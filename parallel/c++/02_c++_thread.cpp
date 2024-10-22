#include <iostream>
#include <vector>
#include <thread>
#include <mutex>
#include <numeric> // for std::accumulate

// sudo g++ -std=c++11 -o prog 02_c++_thread.cpp
// ./prog

const int NUM_THREADS = 4;
std::vector<int> array;
std::vector<int> partial_sum(NUM_THREADS, 0);
std::mutex mtx;
thread_local int local_sum = 0; 

void compute_sum(int thread_id, int start, int end)
{
    for (int i = start; i < end; ++i)
    {
        local_sum += array[i]; 
    }

        std::lock_guard<std::mutex> lock(mtx);
        partial_sum[thread_id] += local_sum; 
}

int main()
{
    int array_size = 100;
    for (int i = 1; i <= array_size; ++i)
    {
        array.push_back(i); // 1 - 100
    }

    // create threads
    std::vector<std::thread> threads;
    int chunk_size = array_size / NUM_THREADS;

    for (int i = 0; i < NUM_THREADS; ++i)
    {
        int start = i * chunk_size;
        int end = (i == NUM_THREADS - 1) ? array_size : (i + 1) * chunk_size;
        threads.emplace_back(compute_sum, i, start, end);
    }

    // join threads
    for (auto &th : threads)
    {
        th.join();
    }

    // compute total sum
    int total_sum = std::accumulate(partial_sum.begin(), partial_sum.end(), 0);

    std::cout << "The sum of the array is : " << total_sum << std::endl;

    return 0;
}
