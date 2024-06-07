#include <stdio.h>
#include <stdlib.h>
#include <math.h>

void change_ptr(int **ptr)
{
    // change the value of the pointer to another address
    *ptr = (int *)malloc(sizeof(int));
    **ptr = 999;
}

int main()
{
    int val = 5;
    printf("Value: %d\n", val);             // 5
    printf("Address of value: %p\n", &val); // 0x address

    int *ptr = &val;                      // *ptr / ptr =  0x address, ptr = &val not allowed
    printf("Value of ptr: %p\n", ptr);    // auto dereference
    printf("Value of *ptr: %d\n", *ptr);  // explicit dereference
    printf("Address of ptr: %p\n", &ptr); // address of the pointer (*ptr)

    int **ptr_ptr = &ptr;                          // ptr_ptr = address of ptr, but itself has another address
    printf("Value of ptr_ptr: %p\n", ptr_ptr);     // address of ptr (auto deref)
    printf("Value of *ptr_ptr: %p\n", *ptr_ptr);   // address of ptr (explicit deref deref)
    printf("Value of **ptr_ptr: %d\n", **ptr_ptr); // &ptr_ptr ( *ptr_ptr ) -> &ptr ( *ptr ) -> &val (val)
    printf("Address of ptr_ptr: %p\n", &ptr_ptr);  // address of the pointer ptr_ptr

    change_ptr(&ptr);
    printf("Value of ptr: %p\n", ptr);   // auto dereference
    printf("Value of *ptr: %d\n", *ptr); // explicit dereference
}