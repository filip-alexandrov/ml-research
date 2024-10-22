#include <iostream>
#include <vector>
#include <omp.h>

// sudo g++ -fopenmp -O3 -o prog openmp_00_basics.cpp
// ./prog

const int NUM_THREADS = 4;
std::vector<int> array;

int compute_sum()
{
    int total_sum = 0;

    #pragma omp parallel num_threads(NUM_THREADS)
    {
        int local_sum = 0;
        int thread_id = omp_get_thread_num();
        int num_threads = omp_get_num_threads();

        #pragma omp critical
        {
            std::cout << "Thread id " << thread_id << " total num threads: " << num_threads << std::endl; 
        }

        int chunk_size = array.size() / num_threads;
        int start = thread_id * chunk_size;
        int end = (thread_id == num_threads - 1) ? array.size() : (thread_id + 1) * chunk_size;

        for (int i = start; i < end; ++i)
        {
            local_sum += array[i];
        }

        #pragma omp critical
        {
            total_sum += local_sum;
        }
    }

    return total_sum;
}

int main()
{
    int array_size = 100;
    for (int i = 1; i <= array_size; ++i)
    {
        array.push_back(i);
    }

    int total_sum = compute_sum();

    std::cout << "The sum fo the array is " << total_sum << std::endl;
    return 0;
}