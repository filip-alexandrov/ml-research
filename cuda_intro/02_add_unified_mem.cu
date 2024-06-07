#include <iostream>
#include <math.h>
#include <cuda_runtime.h>
#include <random>
#include <cassert>
#include <exception>
#include <string>

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
        assert(c[i] == a[i] + b[i]);
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
    srand(10);

    // get device id
    int id = cudaGetDevice(&id);

    // vector size of 2^16;
    int n = 1 << 16;

    // single set of pointers, cuda manages automatically memory movement to and from host
    int *a, *b, *c;

    // allocation size for all vectors
    size_t bytes = sizeof(int) * n;

    // allocate device memory
    cudaMallocManaged(&a, bytes);
    cudaMallocManaged(&b, bytes);
    cudaMallocManaged(&c, bytes);

    // initialize vecots a and b with random values between 0 and 99
    matrix_init(a, n);
    matrix_init(b, n);

    // threadblock size, there are max threads per block, look up
    // warps are size of 32 threads, should be multiple of 32
    int NUM_THREADS = 256;

    // grid size, there are max grid sizes
    // each thread calculates 1 addition
    int NUM_BLOCKS = (int)ceil(n / NUM_THREADS);

    // start transferting data to device, while doing other things
    cudaMemPrefetchAsync(a, bytes, id);
    cudaMemPrefetchAsync(b, bytes, id);

    // 1D only in x-direction
    vectorAdd<<<NUM_BLOCKS, NUM_THREADS>>>(a, b, c, n);

    // block thread until the gpu finishes, when not calling memcpy explicitly
    cudaDeviceSynchronize();

    // start prefetching back from device
    cudaMemPrefetchAsync(c, bytes, cudaCpuDeviceId);

    // check result for errors
    error_check(a, b, c, n);

    printf("completed successfully\n");

    return 0;
}
