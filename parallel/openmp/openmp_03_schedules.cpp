#include <iostream>
#include <omp.h>

#define S 25

// sudo g++ -fopenmp -O3 -o prog openmp_03_schedules.cpp
// OMP_NUM_THREADS=4 ./prog


int main() {
    int a[S], b[S], c[S]; 

    // Parallel region with different loop schedules
    // parallel region wont execute in parallel
    #pragma omp parallel
    {
        // Default (static) schedule all chunks default to n (round robin)
        #pragma omp for schedule(static)
        for (int i = 0; i < S; i++) {
            a[i] = omp_get_thread_num(); 
        }

        // Dynamic schedule, fixed chunk size, defaults to 1, chunks to free procs at runtimne
        #pragma omp for schedule(dynamic, 4)
        for (int i = 0; i < S; i++) {
            b[i] = omp_get_thread_num(); 
        }

        // Start with large chunks, exponentially decrease size
        #pragma omp for schedule(guided)
         for (int i = 0; i < S; i++) {
            c[i] = omp_get_thread_num(); 
        }
    }

    // static, dynamic, guided schedules
    for(int i = 0; i < S; i++) { 
        printf("Iter %4d: %4d %4d %4d \n", i, a[i], b[i], c[i]); 
    }

    return 0;
}
