// The start-up code for Tiger and the standard library

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <math.h>
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

bool read_bool(void) {
  /* try to read one symbol more than the longer `false', to make
     sure it is indeed delimited by white space or EOF
  */
  char buf[7];
  if( scanf(" %6s",buf) != 1 )
    goto exit;
  if (strcmp(buf,"true") == 0)
    return true;
  if (strcmp(buf,"false") == 0)
    return false;
  exit:
    printf("Failed to read the boolean\n"),
    exit(1);
}

void print_line(void) {
  putchar('\n');
}

int64_t ti_random(const int64_t a, const int64_t b) {
  if(!(a < b)) 
    printf("bad invocation of random with arguments %lld and %lld\n",
           (long long)a, (long long)b),
    exit(1);
  return (int64_t)(__builtin_trunc((double)(b-a) * drand48())) + a;
}

void seed(const int64_t seed) {
  srand48(seed);
}

typedef struct tistring_s {
  uint32_t size;
  char body [255];
} * tistring;

// int compare_tistrings(const struct tistring_s* a, const struct tistring_s* b) {
//     uint32_t min_size = (a->size < b->size) ? a->size : b->size;
    
//     for (uint32_t i = 0; i < min_size; i++) {
//         if (a->body[i] != b->body[i]) {
//             return (a->body[i] < b->body[i]) ? -1 : 1;
//         }
//     }

//     if (a->size < b->size) return -1;  
//     if (a->size > b->size) return 1;  

//     return 0;
// }

bool eq_str(tistring s1, tistring s2){
  return strcmp(s1->body, s2->body) == 0;
}

bool neq_str(tistring s1, tistring s2){
  return strcmp(s1->body, s2->body) != 0;
}

bool lt_str(tistring s1, tistring s2){
  return strcmp(s1->body, s2->body) < 0;
}

bool leq_str(tistring s1, tistring s2){
  return strcmp(s1->body, s2->body) <= 0;
}

bool gt_str(tistring s1, tistring s2){
  return strcmp(s1->body, s2->body) > 0;
}

bool geq_str(tistring s1, tistring s2){
  return strcmp(s1->body, s2->body) >= 0;
}


void print(tistring s) {
  if( fwrite(s->body, s->size, 1, stdout) != 1)
    perror("fwrite error"), exit(10);
}

int main(int argc, char * []) {

  if (argc != 1)
    printf("No arguments are accepted\n"),
    exit(1);
  seed(17);

  ti_main();
  printf("\nDone\n");
  return 0;
}
