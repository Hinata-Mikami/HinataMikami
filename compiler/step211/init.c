// The start-up code for Tiger
// The argument x to the Tiger function is accepted as the command-line
// argument

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

// Main Tiger function
extern void ti_main(int64_t x);

void print_int(int64_t x) {
 printf("%lld", (long long int)x);
}

// Ex7
void print_bool(int64_t x) {
  if (x == 1){
    printf("true");
  }
  else if (x == 0){
    printf("false");
  }
  else 
    printf("'%lld' cannot be applied to the function 'print_bool'\n", (long long int)x),
    exit(1);
}


int main(int argc, char * argv[]) {
  if (argc != 2) {
    printf("One argument is required: a 64-bit integer to pass to Tiger\n"
           "as the variable x\n");
    exit(1);
  }

  if (strcmp(argv[1], "true") == 0) {
    ti_main(1);
    printf("\nDone\n");
    return 0;
  }
  else if (strcmp(argv[1], "false") == 0) {
    ti_main(0);
    printf("\nDone\n");
    return 0;
  }

  long long x = 0;
  if (sscanf(argv[1], "%lld", &x) != 1) {
    printf("Failed to convert the argument '%s' to 64-bit integer\n", argv[1]);
    exit(1);
  }

  ti_main(x);
  printf("\nDone\n");
  return 0;
}
