#include <iostream>
#include <math.h>
#include <cuda_runtime.h>
#include <random>
#include <cassert>

// 16x16 matrix shared memory size
// 16 x 16 threads = 256 threads per block
// size of int is 4
#define SHMEM_SIZE 16 * 16 * 4

__global__ void tiledMatrixMul(int *a, int *b, int *c, int n, int tile_size)
{
    // 2 statically sized pieces of shared memory inside block
    __shared__ int A[SHMEM_SIZE];
    __shared__ int B[SHMEM_SIZE];

    // shorten these parameters for clean re-use
    int tx = threadIdx.x;
    int ty = threadIdx.y;
    int bx = blockIdx.x;
    int by = blockIdx.y;

    // calculate global row and column position for this thread
    int row = by * tile_size + ty;
    int col = bx * tile_size + tx;

    // intermediate sum for element being written
    int temp_val = 0;

    // loop over the current tile only
    for (int i = 0; i < (n / tile_size); i++)
    {
        // load shared memory
        A[ty + tile_size + tx] = a[row * n + i + tile_size + tx];
        B[ty + tile_size + tx] = b[i * tile_size * n + ty * n + col];

        // ensure all threads have loaded their data
        __syncthreads();

        // calculate all temp values for this tile
        for (int j = 0; j < tile_size; j++)
        {
            temp_val += A[ty * tile_size + j] * B[j + tile_size + tx];
        }

        // ensure some thereads don't progress and stomp current shared memory values
        __syncthreads();
    }

    c[row * n + col] = temp_val;
}

__global__ void matrixMul(const int *a, const int *b, int *c, int N)
{
    // compute eahch thread's global row and col index within the result matrix
    int row = blockIdx.y * blockDim.y + threadIdx.y;
    int col = blockIdx.x * blockDim.x + threadIdx.x;

    // iterate over row and down column
    c[row * N + col] = 0;
    for (int k = 0; k < N; k++)
    {
        // Accumulate results for a single element
        c[row * N + col] += a[row * N + k] * b[k * N + col];
    }
}

// Check result on the CPU
void verify_result(const int *a, const int *b, const int *c, int N)
{
    // For every row...
    for (int i = 0; i < N; i++)
    {
        // For every column...
        for (int j = 0; j < N; j++)
        {
            // For every element in the row-column pair
            int tmp = 0;
            for (int k = 0; k < N; k++)
            {
                // Accumulate the partial results
                tmp += a[i * N + k] * b[k * N + j];
            }

            // Check against the CPU result
            assert(tmp == c[i * N + j]);
        }
    }
}

void matrix_init(int *vect, int w, int h)
{
    for (int h_idx = 0; h_idx < h; h_idx++)
    {
        for (int w_idx = 0; w_idx < w; w_idx++)
        {
            vect[h_idx * h + w_idx] = rand() % 100;
        }
    }
}

int main(void)
{
    // matrix size 1024x1024
    int n = 1 << 10;

    // size in bytes of matrix
    size_t bytes = n * n * sizeof(int);

    // host pointers
    int *h_a, *h_b, *h_c;

    // allocate host memory
    h_a = (int *)malloc(bytes);
    h_b = (int *)malloc(bytes);
    h_c = (int *)malloc(bytes);

    int *d_a, *d_b, *d_c;

    // device pointers
    cudaMalloc(&d_a, bytes);
    cudaMalloc(&d_b, bytes);
    cudaMalloc(&d_c, bytes);

    // init matrices
    matrix_init(h_a, n, n);
    matrix_init(h_b, n, n);

    // copy to device
    cudaMemcpy(d_a, h_a, bytes, cudaMemcpyHostToDevice);
    cudaMemcpy(d_b, h_b, bytes, cudaMemcpyHostToDevice);

    // threads per block, 16 * 16 = 256 threads per block in 2D, matches 32 threads per warp
    int BLOCK_SIZE = 16;

    // blocks in each dimension, 2D
    int GRID_SIZE = (int)ceil(n / BLOCK_SIZE);

    // dim3 objects, here we have 2D
    dim3 grid(GRID_SIZE, GRID_SIZE);
    dim3 threads(BLOCK_SIZE, BLOCK_SIZE);

    // launch kernel
    tiledMatrixMul<<<grid, threads>>>(d_a, d_b, d_c, n, BLOCK_SIZE);

    // copy back to host
    cudaMemcpy(h_c, d_c, bytes, cudaMemcpyDeviceToHost);

    // check result
    verify_result(h_a, h_b, h_c, n);

    // free device
    cudaFree(d_a);
    cudaFree(d_b);
    cudaFree(d_c);

    // free hsot
    free(h_a);
    free(h_b);
    free(h_c);

    printf("completed successfully \n");

    return 0;
}
