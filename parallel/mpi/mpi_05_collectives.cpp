#include <stdio.h>
#include <stdlib.h>
#include <chrono>
#include <thread>

#include <mpi.h>

#define NUM_PROCS 32
#define ARRAY_SIZE 1024

// sudo mpicxx --std=c++17 -o prog ./mpi_05_collectives.cpp
// mpirun -np 2 --oversubscribe prog  -> to trigger abort
// mpirun -np 32 --oversubscribe prog

int main(int argc, char **argv)
{
    int rank, size, col, row;
    MPI_Comm row_comm, col_comm;
    int value[ARRAY_SIZE];

    MPI_Init(&argc, &argv);

    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);

    // check if enough procs spawned, rank 0 only prints error message
    if (size != NUM_PROCS)
    {
        std::cerr << "Error: Not enough processes started. At least " << NUM_PROCS << " processes are required, but only " << size << " was started." << std::endl;

        MPI_Abort(MPI_COMM_WORLD, EXIT_FAILURE);
    }

    // set array to contain 0s on all procs
    for (int i = 0; i < ARRAY_SIZE; i++)
    {
        value[i] = 0;
    }

    // init only on rank 0
    if (rank == 0)
    {
        // init with value
        for (int i = 0; i < ARRAY_SIZE; i++)
        {
            value[i] = 1;
        }
    }

    // broadcast the value to all processes, synchronizing, buffer can be immediately used
    // MPI_Bcast(&value, ARRAY_SIZE, MPI_INT, 0, MPI_COMM_WORLD);

    // // check array contents
    // int sum = 0;
    // for (int i = 0; i < ARRAY_SIZE; i++)
    // {
    //     sum += value[i];
    // }
    // printf("Process %d has summed to: %d \n", rank, sum);

    // scatter, every proc receives sendcount number of elements
    int sendcount = ARRAY_SIZE / NUM_PROCS; // 32 elems
    int recv_buffer[32];

    MPI_Scatter(&value, sendcount, MPI_INT, &recv_buffer, sendcount, MPI_INT, 0, MPI_COMM_WORLD);

    // // check array contents
    // int sum = 0;
    // for (int i = 0; i < sendcount; i++)
    // {
    //     sum += recv_buffer[i];
    // }
    // printf("Process %d has summed to: %d \n", rank, sum);

    // increment array at every proc
    for (int i = 0; i < sendcount; i++)
    {
        recv_buffer[i]++;
    }

    // every proc send "sendcount" and root receives "sendcount" elements per process
    MPI_Gather(&recv_buffer, sendcount, MPI_INT, &value, sendcount, MPI_INT, 0, MPI_COMM_WORLD);

    // check array contents
    if (rank == 0)
    {
        int sum = 0;
        for (int i = 0; i < ARRAY_SIZE; i++)
        {
            sum += value[i];
        }

        // sums up to double the normal length
        printf("Root process %d has summed to: %d \n", rank, sum);
    }

    // synchronize and complete all processes
    MPI_Finalize();
}