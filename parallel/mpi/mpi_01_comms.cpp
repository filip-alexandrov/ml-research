#include <stdio.h>
#include <stdlib.h>
#include <chrono>
#include <thread>

#include <mpi.h>

// mpicxx --std=c++17 -o mpi_01_comms mpi_01_comms.cpp
// mpirun -np 32 --oversubscribe mpi_01_comms

#define NUM_PROCS 32

int main(int argc, char **argv)
{
    int rank, size, col, row;
    MPI_Comm row_comm, col_comm;
    int matrix_size = 8 * 4;
    int *matrix = (int *)malloc(sizeof(int) * matrix_size);
    int *result = (int *)malloc(sizeof(int) * matrix_size);

    MPI_Init(&argc, &argv);

    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);

    // 8 x 4 matrix of procs
    row = rank % 4;
    col = rank / 4;

    // split communicator 32 procs -> 4 x 8 based on color
    // color = row (0 - 7), key (order in the comm) = col (0 - 4)
    // all elems in the same row / col will be in one communicator
    MPI_Comm_split(MPI_COMM_WORLD, row, col, &row_comm);
    MPI_Comm_split(MPI_COMM_WORLD, col, row, &col_comm);

    // broadcast data to all other procs
    if (rank == 0)
    {
        for (int i = 0; i < matrix_size; i++)
        {
            matrix[i] = 1;
        }
    }

    // send / rcv syncs, but bcast wont
    // root = process that sends
    MPI_Bcast(matrix, matrix_size, MPI_INT, 0, MPI_COMM_WORLD);

    // sync
    MPI_Barrier(MPI_COMM_WORLD);

    // each process sums elements in matrix
    // only root writes to result
    MPI_Reduce(matrix, result, NUM_PROCS, MPI_INT, MPI_SUM, 0, MPI_COMM_WORLD);

    // every col process now has the same array
    if (rank == 0)
    {
        int final_result = 0; 
        
        // every process delivers 1 value of the reduction
        for (int i = 0; i < NUM_PROCS; i++)
        {
            final_result += result[i]; 
        }

        printf("final result: %d \n", final_result);
    }

    // synchronize and complete all processes
    MPI_Finalize();
}