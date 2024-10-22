// installs on mac arm64:
// HOMEBREW_NO_INSTALL_UPGRADE=1 brew install riscv-gnu-toolchain
// HOMEBREW_NO_INSTALL_UPGRADE=1 brew install qemu

// 64 BIT SYSTEMS:
// compile assemble and link with debug: riscv64-unknown-elf-gcc -g 07_high_lev.c -o 07_prog
// compile only: riscv64-unknown-elf-gcc -O1 -S 07_high_lev.c -o 07_prog.s
// assemble only (also possible from .s): riscv64-unknown-elf-gcc -O1 -g -c 07_high_lev.c -o 07_prog.o
// riscv64-unknown-elf-gcc -O1 -g -c 07_prog.s -o 07_prog.o
// objdump of .text section: riscv64-unknown-elf-objdump -d 07_prog.o
// objdump of SYMBOLS: riscv64-unknown-elf-objdump -t 07_prog.o
// link only: riscv64-unknown-elf-gcc 07_prog.o -o 07_prog
// disassemble the executable (linked and ready to go): riscv64-unknown-elf-objdump -S -t 07_prog > 07_objdump.txt

// 32 BIT SYSTEMS:

int f, g, y;

int func(int a, int b)
{
    if (b < 0)
        return (a + b);
    else
        return (a + func(a, b - 1));
}

void main()
{
    f = 2;
    g = 3;
    y = func(f, g);

    return;
}