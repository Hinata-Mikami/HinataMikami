// The start-up code for Tiger

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <stdbool.h>

// Main Tiger function
extern void ti_main(void);

void print_int(int64_t x) {
 printf("%lld", (long long int)x);
}

void print_bool(bool x) {
 printf("%s", x ? "true" : "false");
}

int64_t read_int(void) {
  long long x = 0;
  if( scanf("%lld",&x) != 1 )
    printf("Failed to read the 64-bit integer\n"),
    exit(1);
  return x;
}


int main(int argc, char * []) {

  if (argc != 1)
    printf("No arguments are accepted\n"),
    exit(1);

  ti_main();
  printf("\nDone\n");
  return 0;
}
