#include <iostream>
#include <omp.h>
#include <vector>

#define NUM_THREADS 16

// sudo g++ -fopenmp -O3 -o prog openmp_06_ordering.cpp
// OMP_NUM_THREADS=16 ./prog

int main()
{
    std::vector<int> invocation_sequence(NUM_THREADS, -1); 
    int idx = 0; 

    #pragma omp parallel for ordered
    for(int i = 0; i < 1 << 9; i++)
    {
        int iam = omp_get_thread_num();

        #pragma omp ordered
        {
            invocation_sequence[iam] = idx; 
            idx = iam + 1; 
        }
    }

    for(int i = 0; i < NUM_THREADS; i++){ 
        std::cout << invocation_sequence[i] << " "; 
    }

    std::cout << std::endl; 

    return 0;
}
