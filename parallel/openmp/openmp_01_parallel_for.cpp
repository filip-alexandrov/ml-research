#include <iostream>
#include <vector>
#include <numeric> 
#include <omp.h>



// sudo g++ -fopenmp -O3 -o prog openmp_01_parallel_for.cpp
// ./prog

std::vector<int> array;

int main() {
    // Initialize the array
    int array_size = 1 << 30;  // Increased size for noticeable timing
    for (int i = 1; i <= array_size; ++i) {
        array.push_back(i);  // Fill the array with values from 1 to array_size
    }
    std::cout << "Array size: " << array_size << std::endl; 

    // Record the start time
    double start_time = omp_get_wtime();

    // Compute the total sum using OpenMP
    int total_sum = 0;

    #pragma omp parallel for reduction(+:total_sum)
    for (int i = 0; i < array_size; ++i) {
        total_sum += array[i];
    }

    // Record the end time
    double end_time = omp_get_wtime();

    // Print the result and the time taken
    std::cout << "The sum of the array is: " << total_sum << std::endl;
    std::cout << "Time taken: " << (end_time - start_time) << " seconds" << std::endl;

    return 0;
}
