#include <iostream>
#include <pthread.h>
#include <vector>

// sudo g++ -pthread -o prog 01_posix_thread.cpp
// ./prog


const int NUM_THREADS = 4; 

std::vector<int> array; // array to be summed
int partial_sum[NUM_THREADS] = {0}; // store partial per thread sums
pthread_mutex_t mutex; // protect shared data

// thread func
void* compute_sum(void* thread_id) { 
    int tid = *(int*) thread_id; 
    int start = tid * (array.size() / NUM_THREADS); 
    int end = (tid + 1) * (array.size() / NUM_THREADS); 

    for(int i = start; i < end; ++i){ 
        pthread_mutex_lock(&mutex); 
        partial_sum[tid] += array[i]; 
        pthread_mutex_unlock(&mutex); 
    }

    pthread_exit(nullptr); 
}

int main() { 
    // init 
    int array_size = 100; 
    for(int i = 0; i < array_size; ++i) { 
        array.push_back(i + 1); 
    }

    // initialize the mutex 
    pthread_mutex_init(&mutex, nullptr); 

    // create thread ids
    pthread_t threads[NUM_THREADS]; 
    int thread_ids[NUM_THREADS]; 

    // create the threads 
    for(int i = 0; i < NUM_THREADS; ++i) { 
        thread_ids[i] = i; 
        int rc = pthread_create(&threads[i], nullptr, compute_sum, (void*)&thread_ids[i]); 

        if(rc) { 
            std::cerr << "Error: Unable to create thread, " << rc << std::endl; 
            exit(-1); 
        }
    }

    // join the threads 
    for(int i = 0; i < NUM_THREADS; ++i) { 
        pthread_join(threads[i], nullptr); 
    }

    // compute the total sum from the partial sums 
    int total_sum = 0; 
    for(int i = 0; i < NUM_THREADS; ++i){ 
        total_sum += partial_sum[i]; 
    }

    std::cout << "the sum of the array is: " << total_sum << std::endl; 

    // destroy the mutex 
    pthread_mutex_destroy(&mutex); 

    pthread_exit(nullptr); 
    return 0; 
}