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


// Ex 24
void print_line() {
  printf("\n");
}

#include <string.h>
bool read_bool(void) {
  char input[6];  // "true" または "false" を格納できるサイズ（+1 の余裕を持つ）

  // 標準入力から文字列を読み取る
  if (scanf("%5s", input) != 1) {  // 最大5文字を読み取る（バッファオーバーフローを防ぐ）
    printf("Failed to read a boolean value\n");
    exit(1);
  }

  // 入力値を検証
  if (strcmp(input, "true") == 0) {
    return true;
  } else if (strcmp(input, "false") == 0) {
    return false;
  } else {
    printf("Invalid boolean value: %s (expected 'true' or 'false')\n", input);
    exit(1);
  }
}


int rnd(int a, int b) {
  if (a >= b) {
    printf("Invalid range: [%d, %d).\n", a, b);
    exit(1);
  }
  return a + rand() % (b - a);
}


void rnd_seed(int x) {
  srand(x);
}


int main(int argc, char * []) {

  if (argc != 1)
    printf("No arguments are accepted\n"),
    exit(1);

  ti_main();
  printf("\nDone\n");
  return 0;
}
