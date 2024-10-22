#include <stdio.h>
#include <stdlib.h>
#include <chrono>
#include <thread>

#include <mpi.h>

#define NUM_PROCS 2

int main(int argc, char **argv)
{
    int rank, size, col, row;
    MPI_Comm row_comm, col_comm;
    int *matrix = (int *)malloc(sizeof(int) * NUM_PROCS);

    MPI_Init(&argc, &argv);

    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);

    // this will block and wait indefinetely
    MPI_Recv(matrix, NUM_PROCS, MPI_INT, 0, 0, MPI_COMM_WORLD, nullptr);

    // send here is nonblocking but it can block in other implementations
    int error = MPI_Send(matrix, NUM_PROCS, MPI_INT, 1, 0, MPI_COMM_WORLD);
    printf("Error code %d \n", error);

    // synchronize and complete all processes
    MPI_Finalize();
}