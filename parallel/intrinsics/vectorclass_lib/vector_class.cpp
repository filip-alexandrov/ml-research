#include <stdio.h>
#include "./version2/vectorclass.h"
#include "./version2/vectorfp16.h"

// g++ 

void half_precision(){ 
    Vec16f a, b; 
    Vec32h h; 

    // coonvert from single to half 
    h = Vec32h(to_float16(a), to_float16(b)); 

    // convert back to single
    a = to_float(h.get_low()); 
    b = to_float(h.get_high()); 
}

int main() { 
    Vec4i a(10, 11, 12, 13); 
    Vec4i b(20, 21, 22, 23); 

    Vec4i c = a + b; 

    for(int i = 0; i < c.size(); i++) {
        printf(" %5i", c[i]);
    }

    printf("\n"); 

    return 0; 
}