### Parallel programming concepts
Different parallel programming concepts implemeted using OpenMP, Intrinsics, Threads

* check for avx, avx2, avx512 support: `grep avx /proc/cpuinfo`
* check for NUMA: `dmesg | grep -i numa`
* cpu info, compiler flags: `cat /proc/cpuinfo`
* check for NUMA: `nproc --all`
* arm intrin reference: `https://developer.arm.com/architectures/instruction-sets/intrinsics`
* intel intrin reference: `https://www.intel.com/content/www/us/en/docs/intrinsics-guide/index.html`