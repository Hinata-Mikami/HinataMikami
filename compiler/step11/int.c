// Sample function to print an int
// gcc -O0 -S -fverbose-asm -fomit-frame-pointer
#include <stdint.h>

extern void print_int(int64_t);

void ti_main(void)
{ print_int(-42LL); }
