#include <stdio.h>
#include <stdlib.h>
#include <chrono>
#include <thread>

#include <mpi.h>

#define NUM_PROCS 32
#define ARRAY_SIZE 1024

#define INSPECT(dt) {MPI_Type_get_extent(dt, &lb, &ex); printf("%li \n", etx);}

// sudo mpicxx --std=c++17 -o prog ./mpi_07_datatypes.cpp
// mpirun -np 32 --oversubscribe prog

int main(int argc, char **argv)
{
    int rank, size, col, row;
    MPI_Comm row_comm, col_comm;
    int value[ARRAY_SIZE];

    MPI_Init(&argc, &argv);

    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);

    MPI_Datatype new_type; 
    MPI_Type_contiguous(ARRAY_SIZE, MPI_INT, &new_type); 
    MPI_Type_commit(&new_type); 

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

    MPI_Bcast(&value, 1, new_type, 0, MPI_COMM_WORLD);

    // check array contents
    int sum = 0;
    for (int i = 0; i < ARRAY_SIZE; i++)
    {
        sum += value[i];
    }
    printf("Process %d has summed to: %d \n", rank, sum);
    

    // synchronize and complete all processes
    MPI_Finalize();
}