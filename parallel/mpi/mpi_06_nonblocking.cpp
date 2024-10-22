#include <stdio.h>
#include <stdlib.h>
#include <chrono>
#include <thread>

#include <mpi.h>

#define NUM_PROCS 32
#define ARRAY_SIZE 1024

// sudo mpicxx --std=c++17 -o prog ./mpi_06_nonblocking.cpp
// mpirun -np 32 --oversubscribe prog

int main(int argc, char **argv)
{
    int rank, size, col, row;
    MPI_Comm row_comm, col_comm;
    int value[ARRAY_SIZE];

    MPI_Init(&argc, &argv);

    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);

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

    // broadcast async, do work during send and wait at the end, buffer not free
    MPI_Request req;
    MPI_Status status;
    MPI_Ibcast(&value, ARRAY_SIZE, MPI_INT, 0, MPI_COMM_WORLD, &req);

    // dont touch buffer here
    if (rank == 0)
        printf("Doing work during the communication \n");

    MPI_Wait(&req, &status);

    // buffer free to be overwritten here

    if (rank == 0)
        printf("Finished : %d \n", status.MPI_ERROR);

    // synchronize and complete all processes
    MPI_Finalize();
}