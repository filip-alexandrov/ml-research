#include <stdio.h>

int main()
{
    float num1, num2, result;

    // shift by the size of the mantissa
    num1 = 1 << 24; // 127 + 24 = 151 exponent, mantissa is 23 x 0
    num2 = 1.1;     // 127 exponent, mantissa is 23 x 0

    printf("num1: %.9f\n", num1);
    printf("num2: %.9f\n", num2);

    // 1 located at place 0 and place 24 (25 total numbers)
    // 23 bit mantissa => 1 omitted (implicit), 23 x 0 taken, 24th 1 cut off
    result = num1 + num2;

    printf("result: %.9f\n", result);
}