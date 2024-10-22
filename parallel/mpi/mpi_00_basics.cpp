#include <stdio.h>
#include <stdlib.h>
#include <chrono>
#include <thread>


#include <mpi.h>

// SETUP:
// 1. installation guide: https://webpages.charlotte.edu/abw/coit-grid01.uncc.edu/ParallelProgSoftware/Software/OpenMPIInstall.pdf
// apt-get install openmpi-bin openmpi-doc libopenmpi-dev
// 2. set vscode to use compiler /usr/bin/mpicc
// 3. compile: mpicxx --std=c++17 -o mpi_basics mpi_basics.cpp
// 4. run locally (required NO ROOT): mpirun -np 4 --oversubscribe mpi_basics

int main(int argc, char **argv)
{
    // avoid writing code here => will be executed before all procs have started

    // init the mpi process (implicit barrier)
    MPI_Init(&argc, &argv);

    double value;
    MPI_Status s;

    // find position of the process and total number of processes
    int rank, size;
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);

    // measure time, returns double, initializes here
    value = MPI_Wtime();

    // sleep for 3 seconds 
    std::this_thread::sleep_for(std::chrono::seconds(3));

    // has to be called here too since it initted to 0, is different everywhere
    value = MPI_Wtime();
    printf("MPI Process %d of %d (value = %f)\n", rank, size, value);

    // number of seconds between two successive clock ticks
    double clock_res = MPI_Wtick();

    if(rank == 0) { 
        printf("Clock resolution: %f \n", clock_res); 
    }

    // sync processes
    MPI_Barrier(MPI_COMM_WORLD); 

    // everything but first
    if (rank > 0)
    {
        // buffer where to receive the value (allocated pointer)
        // number of such values to be received
        // datatype (wrapper around standard c datatypes)
        // source (rank of process that has send it within a communicator)
        // message tag???
        // communicator: MPI_COMM_SELF also available by default
        // status

        // matching "source" and "tag" within the same communicator
        // MPI_ANY_SOURCE and MPI_ANY_TAG can be used 
        MPI_Recv(&value, 1, MPI_DOUBLE, rank - 1, 0, MPI_COMM_WORLD, &s);

        // number of elemes actually received
        int count; 
        int error = MPI_Get_count(&s, MPI_DOUBLE, &count); 

        // printf("Process %d has received %d elements.\n", rank, count); 
    }

    // everything but last
    if (rank < size - 1)
    {
        // waits until it has sent, returns error codes
        // send to next process (rank + 1)
        int error = MPI_Send(&value, 1, MPI_DOUBLE, rank + 1, 0, MPI_COMM_WORLD);
    }

    if (rank == size - 1)
    {
        // prints will be returned to the 0 process
        printf("Value from mpi process 0: %f \n", value);
    }

    // synchronize and complete all processes 
    MPI_Finalize();
}