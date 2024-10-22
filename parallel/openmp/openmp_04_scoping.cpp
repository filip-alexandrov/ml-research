#include <iostream>
#include <omp.h>

// sudo g++ -fopenmp -O3 -o prog openmp_04_scoping.cpp
// OMP_NUM_THREADS=4 ./prog

int main()
{
    int iam, nthreads;
#pragma omp parallel private(iam, nthreads) 
    {
        // assign values here, no values are assigned
        iam = omp_get_thread_num();
        nthreads = omp_get_num_threads();

        printf("Thread id: %d, out of %d threads \n", iam, nthreads);

        if (iam == 0)
        {
            printf("Here is the master thread\n");
        }
    }

    int i = 3; 
    #pragma omp parallel for firstprivate(i)
    for(int j = 0; j < 4; j++) { 
        i = i + 1; 
        printf("-> i=%d\n", i);         
    }

    printf("final value of i = %d\n", i); 

    i = 3; 
    #pragma omp parallel for lastprivate(i)
    for(int j = 0; j < 4; j++) { 
        i = i + 1; 
        printf("-> i=%d\n", i);         
    }

    printf("final value of i = %d\n", i); 

    i = 3; 
    #pragma omp parallel for firstprivate(i) \
        lastprivate(i)
    for(int j = 0; j < 4; j++) 
    {
        i = i + 1; 
        printf("-> i = %d \n", i); 
    }
    printf("final value of i = %d\n", i); 
    
    return 0;
}
