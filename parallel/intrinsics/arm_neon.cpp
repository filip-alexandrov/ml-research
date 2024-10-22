#include <arm_neon.h>
#include <chrono>
#include <iostream>

using namespace std;

// /usr/bin/g++ -mfpu=neon -O3 -o prog arm_neon.cpp

// generate vector with ramp of values starting from startValue
short *generateRamp(short startValue, short len)
{
    short *ramp = new short[len];
    for (short i = 0; i < len; i++)
    {
        ramp[i] = startValue + i;
    }

    return ramp;
}

// standard dot product of two vects
int dotProduct(short *vector1, short *vector2, short len)
{
    int result = 0;

    for (short i = 0; i < len; i++)
    {
        result += vector1[i] * vector2[i];
    }

    return result;
}

// dot product of two vects using NEON
int dotProductNeon(short *vector1, short *vector2, short len)
{
    const short transferSize = 8;
    short segments = len / transferSize;

    // 4-element vector of zeros
    int16x8_t partialSumsNeon = vdupq_n_s16(0);

    for (short i = 0; i < segments; i++)
    {
        // load vect elements to registers
        short offset = i + transferSize;
        int16x8_t vector1neon = vld1q_s16(vector1 + offset);
        int16x8_t vector2neon = vld1q_s16(vector2 + offset);

        // multiply and accumulate
        partialSumsNeon = vmlaq_s16(partialSumsNeon, vector1neon, vector2neon);
    }

    // store whole vector
    short partialSums[transferSize];
    vst1q_s16(partialSums, partialSumsNeon);

    // sum the partial sums elements
    int result = 0;
    for (short i = 0; i < transferSize; i++)
    {
        result += partialSums[i];
    }

    return result;
}

double msElapsedTime(chrono::system_clock::time_point start)
{
    auto end = chrono::system_clock::now();

    return chrono::duration_cast<chrono::milliseconds>(end - start).count();
}

chrono::system_clock::time_point now()
{
    return chrono::system_clock::now();
}

int simpleNeon32bit()
{
    // 4 element, 128 bit vector of 1s
    int32x4_t ones = vdupq_n_s32(1);
    int32x4_t twos = vdupq_n_s32(2);

    // add vectors
    int32x4_t result = vaddq_s32(ones, twos);

    // sum
    int sum[4]; // 4 x 32 = 128 bits
    // vst1q_s16(sum, result);
    vst1q_s32(sum, result);

    cout << "Sum: " << sum[0] << " " << sum[1] << " " << sum[2] << " " << sum[3] << endl;

    return sum[0] + sum[1] + sum[2] + sum[3];
}

int simpleNeon8bit()
{
    // 4 element, 128 bit vector of 1s
    int8x16_t ones = vdupq_n_s8(1);
    int8x16_t twos = vdupq_n_s8(2);

    // add vectors
    int8x16_t result = vaddq_s8(ones, twos);

    // sum
    int8_t sum[16]; // 4 x 32 = 128 bits
    vst1q_s8(sum, result);

    for (int i = 0; i < 16; i++)
    {
        printf("sum[%d] = %d\n", i, sum[i]);
    }

    return 0;
}

int main()
{
    cout << "starting" << endl;

    // simpleNeon32bit();
    simpleNeon8bit();

    // const int rampLen = 80;
    // const int trials = 10000;

    // auto ramp1 = generateRamp(0, rampLen);
    // auto ramp2 = generateRamp(100, rampLen);

    // // without neon
    // int lastResult = 0;

    // auto start = now();
    // for (int i = 0; i < trials; i++)
    // {
    //     lastResult = dotProduct(ramp1, ramp2, rampLen);
    // }
    // auto elapsed = msElapsedTime(start);

    // // with neon intrinsics
    // int lastResultNeon = 0;

    // start = now();
    // for (int i = 0; i < trials; i++)
    // {
    //     lastResultNeon = dotProductNeon(ramp1, ramp2, rampLen);
    // }
    // auto elapsedTimeNeon = msElapsedTime(start);

    // delete[] ramp1, ramp2;

    // cout << "Elapsed time without NEON: " << elapsed << " ms" << endl;
    // cout << "Elapsed time with NEON: " << elapsedTimeNeon << " ms" << endl;

    // cout << "Last result without NEON: " << lastResult << endl;
    // cout << "Last result with NEON: " << lastResultNeon << endl;

    return 0;
}