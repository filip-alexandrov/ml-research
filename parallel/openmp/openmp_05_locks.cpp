#include <iostream>
#include <omp.h>

// sudo g++ -fopenmp -O3 -o prog openmp_05_locks.cpp
// OMP_NUM_THREADS=4 ./prog

int main()
{
    int id;

    omp_lock_t lock;
    omp_init_lock(&lock);

    #pragma omp parallel shared(lock) private(id)
    {
        id = omp_get_thread_num();
        omp_set_lock(&lock); // single thread writes
        printf("My thread num is %d\n", id);
        omp_unset_lock(&lock);

        while (!omp_test_lock(&lock))
        {
            std::cout << "Other work id: " << id << std::endl;
        }

        std::cout << "Lock obtained id: " << id << std::endl;
        omp_unset_lock(&lock);
    }

    omp_destroy_lock(&lock);

    return 0;
}
