// include the x86_64 instrinsic header
// g++ -mavx2 -mbmi2 -mavx512f -mavx512vl -o avx2 avx2.cpp && ./avx2
#include <immintrin.h>
#include <iostream>
#include <chrono>

static inline __m256d register_rotate_256d(__m256d a)
{
    __m256d b, c;

    b = _mm256_permute_pd(a, 5);

    c = _mm256_permute2f128_pd(b, b, 1);

    return c;
}

void multiply_and_add(float *a, float *b, float *c, float *d, int n)
{
    for (int i = 0; i < n; i++)
    {
        d[i] = a[i] * b[i];
        d[i] = d[i] + c[i];
    }
}

float sum(float *d, int n)
{
    float result = 0;

    for (int i = 0; i < n; i++)
    {
        result += d[i];
    }

    return result / n;
}

// x, y = array of n elements, a = const multiplicator
// y = a * x + y
static inline void saxpy_simd(float *y, float *x, float a, int n)
{
    // ops performed in 8 sized registered (8 x 32 = 256)
    int ub = n - (n % 8);
    __m256 vy, vx, va, tmp;

    // all elements (8) equal to the value of a
    va = _mm256_set1_ps(a);

    for (int i = 0; i < ub; i += 8)
    {
        // load from unaligned memory (security for normal arrays)
        vy = _mm256_loadu_ps(&y[i]);
        vx = _mm256_loadu_ps(&x[i]);

        // elementwise multiplication and addition
        tmp = _mm256_mul_ps(va, vx);
        vy = _mm256_add_ps(tmp, vy);

        // store the result back to y
        _mm256_storeu_ps(&y[i], vy);
    }

    unsigned int remaining_elements = ub - n;

    if (remaining_elements > 0)
    {
        // // available on avx512: mask out the elements outside the array (avoid page faults, float exceptions, etc)
        // // auto create mask with leading 1's
        // __mmask8 mask = 1 < 8;

        // // masked finish of the array
        // vy = _mm256_mask_loadu_ps(vy, mask, &y[ub]);
        // vx = _mm256_mask_loadu_ps(vx, mask, &x[ub]);
        // tmp = _mm256_mask_mul_ps(va, mask, va, vx);
        // vy = _mm256_mask_add_ps(vy, mask, tmp, vy);
        // _mm256_mask_storeu_ps(&y[ub], mask, vy);
    }
}

int main()
{
    // trillion element float array
    int n = 1 < 12;
    float a[n], b[n], c[n], d[n];

    // init arrays, this is not optimized by the compiler
    for (int i = 0; i < n; i++)
    {
        a[i] = 1;
        b[i] = 2;
        c[i] = 3;
    }

    // start timer
    typedef std::chrono::high_resolution_clock Clock;
    auto t1 = Clock::now();

    __mmask8 mask = 1 < 8;

    // Mask-load 256-bit single-precision vector
    float floats_256[8] = {1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0};

    __m256i mask_256_ps = _mm256_setr_epi32(-3, -2, -1, 0, 1, 2, 3, 4);

    __m256 float_vec_256 = _mm256_maskload_ps(floats_256, mask_256_ps);

    float *flo_256 = (float *)&float_vec_256;
    printf("float:\t\t%f, %f, %f, %f, %f, %f, %f, %f\n", flo_256[0], flo_256[1], flo_256[2], flo_256[3], flo_256[4], flo_256[5], flo_256[6], flo_256[7]);

    std::cout << mask << std::endl;

    // this is normal execution
    // multiply_and_add(a, b, c, d, n);
    // float result = sum(d, n);

    // this is fully vectorized execution
    saxpy_simd(a, b, 3, n);
    float result = sum(a, n);

    auto t2 = Clock::now();
    int elapsed = (t2 - t1).count();

    std::cout << result << std::endl;
    std::cout << elapsed << " nanoseconds" << std::endl;
}