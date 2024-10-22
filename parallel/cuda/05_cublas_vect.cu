#include <cuda_runtime.h>
#include <device_launch_parameters.h>
#include <cublas_v2.h>
#include <iostream>
#include <stdlib.h>
#include <math.h>

// link against cublas library:
// nvcc 05_cublas.cu -lcublas -o cublas

// init a vector
void vector_init(float *a, int n)
{
    for (int i = 0; i < n; i++)
    {
        a[i] = (float)(rand() % 100);
    }
}

// verify result
void verify_result(float *a, float *b, float *c, float factor, int n)
{
    for (int i = 0; i < n; i++)
    {
        assert(c[i] == factor * a[i] + b[i]);
    }
}

int main()
{
    // vector size
    int n = 1 << 20;
    size_t bytes = n * sizeof(float);

    // declare vector pointers
    float *h_a, *h_b, *h_c;
    float *d_a, *d_b;

    // allocate memory on the host
    h_a = (float *)malloc(bytes);
    h_b = (float *)malloc(bytes);
    h_c = (float *)malloc(bytes);

    // allocate memory on the device
    cudaMalloc(&d_a, bytes);
    cudaMalloc(&d_b, bytes);

    // initialize vects
    vector_init(h_a, n);
    vector_init(h_b, n);

    // create and initialize a new context
    cublasHandle_t handle;
    cublasCreate_v2(&handle);

    // copy the vects to device (cublas specific without memcpy)
    // also cublasSetMatrix is used for 2D arrays, 1 is step size (every element will be copied)
    cublasSetVector(n, sizeof(float), h_a, d_a, 1);
    cublasSetVector(n, sizeof(float), h_b, d_b, 1);

    // launch simple asxpy kernel (single precision a * x + y)
    // scales x by a, regular vect addition scales by 1
    // scale a, multiply a by x, add y
    const float scale = 2.0f;

    // cublas handle, number of elements, reference to scaling factor, vects have no empty spaces (1)
    cublasSaxpy(handle, n, &scale, d_a, 1, d_b, 1);

    // copy the result vector back out
    // num elements, size of each elem, device / host pointer, step size
    // result is stored in d_b
    cublasGetVector(n, sizeof(float), d_b, 1, h_c, 1);

    // verify the result
    verify_result(h_a, h_b, h_c, scale, n);

    // clean up the context
    cublasDestroy_v2(handle);

    // release allocated memory
    cudaFree(d_a);
    cudaFree(d_b);
    free(h_a);
    free(h_b);
    free(h_c);

    return 0;
}