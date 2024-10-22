#include <iostream>
#include <vector>
#include <numeric> 
#include <omp.h>



// sudo g++ -fopenmp -O3 -o prog openmp_02_sections.cpp
// ./prog


int main() {
    // Initialize the array
    int array_size = 1 << 30;
    std::vector<int> array(array_size, 0); 
    for(int i = 0; i < array_size / 2; i++) { 
        array[i] = 1;
        array[i + array_size / 2] = 3; 
    }
    std::cout << "Array size: " << array_size << std::endl; 
    
    thread_local long local_sum = 0; 

    // Record the start time
    double start_time = omp_get_wtime();

    // Compute the total sum using OpenMP
    long total_sum = 0;

    // parallel region, shorthand #pragma omp parallel sections + #pragma omp section
    #pragma omp parallel
    {
        // 2 threads
        #pragma omp sections
        {
            // 1st thread in parallel
            #pragma omp section
            {
                for(int i = 0; i < array_size / 2; i++){ 
                    local_sum += array[i]; 
                }

                #pragma omp critical
                total_sum += local_sum; 
            }

            // 2nd thread in parallel
            #pragma omp section
            {
                // second part of the array
                for(int i = array_size / 2; i < array_size; i++){ 
                    local_sum += array[i]; 
                }

                #pragma omp critical
                total_sum += local_sum; 
            }
        }
    }
    

    // Record the end time
    double end_time = omp_get_wtime();

    // Print the result and the time taken
    std::cout << "The sum of the array is (on avg. 2x original): " << total_sum << std::endl;
    std::cout << "Time taken: " << (end_time - start_time) << " seconds" << std::endl;

    return 0;
}
