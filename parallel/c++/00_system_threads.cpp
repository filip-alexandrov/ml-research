
// expose gnu specific features (including clone)
#define _GNU_SOURCE

#include <iostream>
#include <sched.h>
#include <unistd.h>
#include <sys/wait.h>
#include <cstdlib>

// sudo g++ -std=c++17 -o prog 00_system_threads.cpp
// ./prog

const int STACK_SIZE = 65536; // 64kb stack size for the new thread

// thread speclific id
thread_local int thread_id = 0; 

// executed in the child thread context
int threadFunction(void *arg) { 
    thread_id++; 

    std::cout << "Child thread: " << thread_id << " PID " << getpid() << ", PPID " << getppid() << std::endl; 
    return 0; 
}

int main() { 
    char *stack = new char[STACK_SIZE]; // allocate stack for the child thread

    // pointer to func that will be executed by the new thread, pinter to the top of the stack allocated for the child thread
    // flags specifying the resources to be shared between the parent and child threads
    // nullptr = argument to be passed to "threadFunciton"
    pid_t pid = clone(threadFunction, stack + STACK_SIZE, CLONE_VM | CLONE_FS | CLONE_FILES | CLONE_SIGHAND | CLONE_THREAD, nullptr); 


    if(pid == -1) { 
        std::cerr << "Failed to create new thread using clone." << std::endl; 
        return 1; 
    }

    // Wait for the child thread to terminate before continuing
    waitpid(pid, nullptr, 0); 

    // parent process (main thread)
    std::cout << "Main thread: Finished child thread with PID: " << pid << std::endl; 

    delete[] stack; 

    return 0; 
}