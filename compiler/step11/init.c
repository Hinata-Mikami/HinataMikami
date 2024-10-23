// The start-up code for Tiger

#include <stdio.h>
#include <stdint.h>

// Main Tiger function
extern void ti_main(void);

void print_int(int64_t x) {
  printf("%lld", (long long int)x);
}


int main(void) {
  ti_main();
  printf("\nDone\n");
  return 0;
}
