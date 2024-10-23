// A simple C code to print a 64-bit integer

#include <stdio.h>
#include <stdint.h>

int main(void) {
  int64_t x = -42LL;   // A sample integer
  printf("%lld", (long long int)x);
  printf("\nDone\n");
  return 0;
}
