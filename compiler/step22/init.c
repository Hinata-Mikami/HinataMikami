// The start-up code for Tiger
// The argument x to the Tiger function is accepted as the command-line
// argument

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <stdbool.h>

// Main Tiger function
extern void ti_main(int64_t x);

void print_int(int64_t x) {
 printf("%lld", (long long int)x);
}

void print_bool(bool x) {
 printf("%s", x ? "true" : "false");
}


int main(int argc, char * argv[]) {

  if (argc != 2)
    printf("One argument is required: a 64-bit integer to pass to Tiger\n"
           "as the variable x\n"),
    exit(1);

  long long x = 0;
  if( sscanf(argv[1],"%lld",&x) != 1 )
    printf("Failed to convert the argument '%s' to 64-bit integer\n",argv[1]),
    exit(1);
    
  ti_main(x);
  printf("\nDone\n");
  return 0;
}
