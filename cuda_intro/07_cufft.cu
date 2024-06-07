#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <cuda_runtime.h>
#include "cublas_v2.h"

// number of rows
#define M 6

// number of cols
#define N 5
// i = row idx, j = col idx
// ld = leading dimension (stride, num rows)
// converts 2D array indices into 1D index of column major storage
#define IDX2C(i, j, ld) (((j) * (ld)) + (i))

// __inline__ to embed the function where the funciton is called, instead of calling it as separate func -> reduced overhead
// cublasHandle_t handle: A handle to the cuBLAS library context
// float *m: Pointer to the matrix in memory (1D array, located on the device)
// int ldm: Leading dimension of the matrix m
// n : Number of cols
static __inline__ void modify(cublasHandle_t handle, float *m, int ldm, int n, int p, int q, float alpha, float beta)
{
    // scales a vector by scalar
    // scaling starts at element (p, q) and affects n - q elements down the column
    // scaling factor used is alpha / beta
    // stride (incx) is ldm, so we move down the column (jump to next row)
    cublasSscal(handle, n - q, &alpha, &m[IDX2C(p, q, ldm)], ldm);
    cublasSscal(handle, ldm - p, &beta, &m[IDX2C(p, q, ldm)], 1);
}

int main(void)
{
    cudaError_t cudaStat;
    cublasStatus_t stat;
    cublasHandle_t handle;

    // pointers and idx of the current matrix element
    int i, j;
    float *devPtrA;
    float *a = 0;

    // allocate mmeory on the host
    a = (float *)malloc(M * N * sizeof(*a));
    if (!a)
    {
        printf("host memory allocation failed");
        return EXIT_FAILURE;
    }

    // a is col major 1D
    // fill the matrix with numbers (sequential in row major order)
    for (j = 0; j < N; j++)
    {
        for (i = 0; i < M; i++)
        {
            a[IDX2C(i, j, M)] = (float)(i * N + j + 1);
        }
    }

    // allocate memory on the device
    cudaStat = cudaMalloc((void **)&devPtrA, M * N * sizeof(*a));

    // check for errors
    if (cudaStat != cudaSuccess)
    {
        printf("device memory allocation failed");
        free(a);
        return EXIT_FAILURE;
    }

    // create cublas handler (session context)
    stat = cublasCreate(&handle);

    // check for errors
    if (stat != CUBLAS_STATUS_SUCCESS)
    {
        printf("CUBLAS initialization failed\n");
        free(a);
        cudaFree(devPtrA);
        return EXIT_FAILURE;
    }

    // copy the matrix to the device
    stat = cublasSetMatrix(M, N, sizeof(*a), a, M, devPtrA, M);

    if (stat != CUBLAS_STATUS_SUCCESS)
    {
        printf("data download failed");
        free(a);
        cudaFree(devPtrA);
        cublasDestroy(handle);
        return EXIT_FAILURE;
    }

    // modify the matrix using our custom function
    modify(handle, devPtrA, M, N, 1, 2, 16.0f, 12.0f);

    // copy the matrix back to the host
    stat = cublasGetMatrix(M, N, sizeof(*a), devPtrA, M, a, M);

    if (stat != CUBLAS_STATUS_SUCCESS)
    {
        printf("data upload failed");
        free(a);
        cudaFree(devPtrA);
        cublasDestroy(handle);
        return EXIT_FAILURE;
    }

    // free memory and destroy the handler
    cudaFree(devPtrA);
    cublasDestroy(handle);

    // print the matrix
    for (j = 0; j < N; j++)
    {
        for (i = 0; i < M; i++)
        {
            // a is still in col major order, so we the transformation function to index
            printf("%7.0f", a[IDX2C(i, j, M)]);
        }
        printf("\n");
    }

    // free memory on host
    free(a);
    return EXIT_SUCCESS;
}