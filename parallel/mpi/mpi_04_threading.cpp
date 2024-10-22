//! mpirun_option --map-by socket:PE4
//! mpirun_option --bind-to core

#include <stdio.h>
#include <stdlib.h>
#include <chrono>
#include <thread>

#include <mpi.h>
#include <omp.h>

#define ARRAY_SIZE 1 << 10

// sudo mpicxx --std=c++17 -fopenmp -o prog ./mpi_04_threading.cpp

// export OMP_DISPLAY_ENV=true
// export OMP_DISPLAY_AFFINITY=true
// OMP_DISPLAY_ENV=true OMP_DISPLAY_AFFINITY=true OMP_PLACES=cores OMP_PROC_BIND=true mpirun --report-bindings --map-by slot:PE=4 --bind-to core -np 4 prog
// -> ensures threads are binded to 1 socket (avoids numa)

int main(int argc, char **argv)
{
    int rank, size, col, row;
    MPI_Comm row_comm, col_comm;
    int value[ARRAY_SIZE];

    // multithreaded but only master thread makes mpi calls
    int required = MPI_THREAD_FUNNELED;
    int provided;

    MPI_Init_thread(&argc, &argv, required, &provided);

    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);

    printf("Threads required %d, threads given %d \n", required, provided);

    if (required != provided)
    {
        MPI_Abort(MPI_COMM_WORLD, EXIT_FAILURE);
    }

    // Print the number of processes and the rank of each process
    // threads are bound on the same socket as "master", "close" to master, "spread" across sockets, "default", "primary"
    #pragma omp parallel proc_bind(close)
    {
        int thread_id = omp_get_thread_num();
        int num_threads = omp_get_num_threads();
        #pragma omp critical
        {
            std::cout << "Process " << rank << " out of " << size << " processes, "
                      << "Thread " << thread_id << " out of " << num_threads << " threads" << std::endl;
        }
    }

    // synchronize and complete all processes
    MPI_Finalize();
}