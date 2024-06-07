#include <cuda_runtime.h>
#include <device_launch_parameters.h>
#include <cublas_v2.h>
#include <curand.h>
#include <iostream>
#include <stdlib.h>
#include <math.h>
#include <assert.h>

// cublas assumes column major order (cpu/numpy is row major)
// modifies the indices
void verify_solution(float *a, float *b, float *c, float n)
{
    float temp;
    float epsilon = 0.001;
    for (int i = 0; i < n; i++)
    {
        for (int j = 0; j < n; j++)
        {
            temp = 0;
            for (int k = 0; k < n; k++)
            {
                temp += a[k * n + i] * b[j * n + k];
            }
            assert(fabs(c[j * n + i] - temp) < epsilon);
        }
    }
}

int main()
{
    // problem size
    int n = 1 << 10;
    size_t bytes = n * n * sizeof(float);

    // declare pinters to matrices on device and host
    float *h_a, *h_b, *h_c;
    float *d_a, *d_b, *d_c;

    // allocate memory on host
    h_a = (float *)malloc(bytes);
    h_b = (float *)malloc(bytes);
    h_c = (float *)malloc(bytes);
    cudaMalloc(&d_a, bytes);
    cudaMalloc(&d_b, bytes);
    cudaMalloc(&d_c, bytes);

    // pseudo random number generator
    curandGenerator_t prng;
    curandCreateGenerator(&prng, CURAND_RNG_PSEUDO_DEFAULT);

    // set seed, use the system clock
    curandSetPseudoRandomGeneratorSeed(prng, (unsigned long long)clock());

    // fill the matrix with random numbers
    // gets seed, pointer to memory, number of elements to fill
    // init directly on the device
    curandGenerateUniform(prng, d_a, n * n);
    curandGenerateUniform(prng, d_b, n * n);

    // cublas handle
    cublasHandle_t handle;
    cublasCreate(&handle);

    // scaling factors
    float alpha = 1.0f;
    float beta = 0.0f;

    // calculate c = (alpha * a) * b + (beta * c)
    // (m x n) (n x k) = (m x k)
    // cublas assumes column major order
    // CUBLAS_OP_N = normal matrix, CUBLAS_OP_T = transpose, CUBLAS_OP_C = conjugate transpose
    // m, n, k dimensions of the matrices (here all n's)
    // alpha by reference, device pinter of a, n = leading dimension of a
    // device pointer of b, n = leading dimension of b
    // beta by reference, device pointer of c, n = leading dimension of c
    cublasSegmm(handle, CUBLAS_OP_N, CUBLAS_OP_N, n, n, n, &alpha, d_a, n, d_b, n, &beta, d_c, n);

    // copy back
    cudaMemcpy(h_a, d_a, bytes, cudaMemcpyDeviceToHost);
    cudaMemcpy(h_b, d_b, bytes, cudaMemcpyDeviceToHost);
    cudaMemcpy(h_c, d_c, bytes, cudaMemcpyDeviceToHost);

    // verify solution, column major order
    verify_solution(h_a, h_b, h_c, n);

    printf("COMPLETED SUCCESSFULLY\n");

    // free memory
    free(h_a);
    free(h_b);
    free(h_c);
    cudaFree(d_a);
    cudaFree(d_b);
    cudaFree(d_c);

    // destroy the handle
    cublasDestroy(handle);

    return 0;
}