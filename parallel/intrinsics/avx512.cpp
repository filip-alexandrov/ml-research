// sse up to 128bit
// #include "nmmintrin.h"

// avx, avx2, avx512
#include "immintrin.h"

#include <iostream>
#include <chrono>
#include <stdlib.h>
#include <random>
#include <bitset>

using namespace std;

void show_vect(auto _vect, int n)
{
    cout << "Vect values: ";
    for (int i = 0; i < n; i++)
    {
        cout << _vect[i] << " ";
    }

    cout << endl;
}

int main()
{
    // // packed single precision, full of 0s, 16 x <single precision>
    // __m512 _zeroVect512 = _mm512_setzero_ps();
    // show_vect(_zeroVect512, 16);

    // // avx / avx2 compatible, 8 x <single precision>
    // __m256 _zeroVect256 = _mm256_setzero_ps();
    // show_vect(_zeroVect256, 8);

    // // reinterpret as array
    // float *data = (float *)&_zeroVect512;
    // show_vect(_zeroVect256, 8);

    // arithmetics
    float a[16];
    __m512 _onesVect512 = _mm512_set1_ps(1.0f);
    __m512 _twosVect512 = _mm512_set1_ps(2.0f);

    // __m512 _resultAdds = _mm512_add_ps(_onesVect512, _twosVect512);
    // show_vect(_resultAdds, 16); 

    // // multiply 
    // __m512 _resultMultiply = _mm512_mul_ps(_onesVect512, _twosVect512);
    // show_vect(_resultMultiply, 16); 

    // // fma, 1 * 2 + 2
    // __m512 _resultFma = _mm512_fmadd_ps(_onesVect512, _twosVect512, _twosVect512); 
    // show_vect(_resultFma, 16); 

    // // devide
    // __m512 _resultDiv = _mm512_div_ps(_onesVect512, _twosVect512); 
    // show_vect(_resultDiv, 16); 

    // __m256 _onesVect256 = _mm256_set1_ps(1.0f);

    // // store (unaligned)
    // _mm256_storeu_ps(a, _onesVect256); 

    // // allocate aligned, 16 * 4bytes = 512 bits = 64 byte alignment 
    // float* aAligned = (float *) _mm_malloc(sizeof(float) * 16, 64); 

    // // store aligned 
    // _mm256_store_ps(aAligned, _onesVect256); 

    // // free allocated aligned memory
    // _mm_free(aAligned); 

    // ones <= twos for each of them: _CMP_LE_OS, ones >= twos _CMP_GE_OS; signaling raises exception
    __mmask16 mask = _mm512_cmp_ps_mask(_onesVect512, _twosVect512, _CMP_LE_OS); 
    int result = _mm512_mask2int(mask); 
    bitset<8> bits(result);
    cout << bits <<endl; 

    return 0;
}