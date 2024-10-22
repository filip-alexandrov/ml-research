#include <iostream>
#include <math.h>
#include <cuda_runtime.h>
#include <random>
#include <cassert>
#include <cuda_profiler_api.h>

// cuda kernel
__global__ void vectorAdd(int *a, int *b, int *c, int n)
{
    // calculate global thread id
    int tid = blockIdx.x * blockDim.x + threadIdx.x;

    // vector boundry guard, there will be masked off thread runs at the end (32 min resolution)
    if (tid < n)
    {
        // each thread adds a single element
        c[tid] = a[tid] + b[tid];
    }
}

void error_check(int *a, int *b, int *c, int n)
{
    for (int i = 0; i < n; i++)
    {

        if (c[i] != a[i] + b[i])
        {
            // std::cout << "Error: " << a[i] << " " << b[i] << " " << c[i] << std::endl;
            throw("Error, not matching");
        }
        else
        {
            // std::cout << "Success" << std::endl;
        }
    }
}

void matrix_init(int *vect, int n)
{
    for (int i = 0; i < n; i++)
    {
        vect[i] = rand() % 100;
    }
}

int main(void)
{
    cudaProfilerStart();

    srand(10);

    // vector size of 2^16;
    int n = 1 << 16;

    // host vector pointers
    int *h_a, *h_b, *h_c;

    // device vector pointers
    int *d_a, *d_b, *d_c;

    // allocation size for all vectors
    size_t bytes = sizeof(int) * n;

    // allocate host memory
    h_a = (int *)malloc(bytes);
    h_b = (int *)malloc(bytes);
    h_c = (int *)malloc(bytes);

    // allocate device memory
    cudaMalloc(&d_a, bytes);
    cudaMalloc(&d_b, bytes);
    cudaMalloc(&d_c, bytes);

    // initialize vecots a and b with random values between 0 and 99
    matrix_init(h_a, n);
    matrix_init(h_b, n);

    // copy from cpu to gpu
    cudaMemcpy(d_a, h_a, bytes, cudaMemcpyHostToDevice);
    cudaMemcpy(d_b, h_b, bytes, cudaMemcpyHostToDevice);

    // threadblock size, there are max threads per block, look up
    // warps are size of 32 threads, should be multiple of 32
    int NUM_THREADS = 256;

    // grid size, there are max grid sizes
    // each thread calculates 1 addition
    int NUM_BLOCKS = (int)ceil(n / NUM_THREADS);

    // 1D only in x-direction
    vectorAdd<<<NUM_BLOCKS, NUM_THREADS>>>(d_a, d_b, d_c, n);

    // copy sum vect from device to host
    cudaMemcpy(h_c, d_c, bytes, cudaMemcpyDeviceToHost);

    // check result for errors
    error_check(h_a, h_b, h_c, n);

    printf("completed successfully\n");

    return 0;
}
