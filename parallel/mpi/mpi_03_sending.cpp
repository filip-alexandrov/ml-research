#include <stdio.h>
#include <stdlib.h>
#include <chrono>
#include <thread>

#include <mpi.h>

#define NUM_PROCS 2

// sudo mpicxx --std=c++17 -o prog ./mpi_03_sending.cpp
// mpirun -np 2 --oversubscribe prog

int main(int argc, char **argv)
{
    int rank, size, col, row;
    MPI_Comm row_comm, col_comm;
    int value; 

    MPI_Init(&argc, &argv);

    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);

    // start timer 
    MPI_Wtime(); 

    // this will still work, but is risky
    if (rank == 0)
    {
        // init with value 
        value = 42; 

        // send
        MPI_Send(&value, NUM_PROCS, MPI_INT, 1, 0, MPI_COMM_WORLD);

        printf("Value send at: %f \n", MPI_Wtime()); 

    }
    else
    {
        // sleep for 3 seconds
        std::this_thread::sleep_for(std::chrono::seconds(30));

        printf("Thread reactivated at: %f \n", MPI_Wtime()); 

        // try to receive (val was send in the past)
        MPI_Recv(&value, NUM_PROCS, MPI_INT, MPI_ANY_SOURCE, MPI_ANY_TAG, MPI_COMM_WORLD, nullptr);

        // still receives successfully 
        printf("Process %d recevied %d at %f \n", rank, value, MPI_Wtime()); 
    }

    // synchronize and complete all processes
    MPI_Finalize();
}