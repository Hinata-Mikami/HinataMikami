// Main program for the sample_clean

#include <stdio.h>
#include <stdint.h>

int64_t read_int(void) {
  long long a;
  scanf("%lld", &a);
  return a;
}

void print_int(int64_t x) {
  printf("val %lld\n", (long long)x);
}

extern void mymain(void);

int main(void)
{
  mymain();
  return 0;
}
