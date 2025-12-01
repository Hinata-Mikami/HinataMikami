#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <omp.h>

int main(int ac, char* av)
{
    int i, j;
    int N = 1000;
    long long x = 0;
    #pragma omp parallel for reduction(+:x), private(j)
    for(i = 0; i < N; i++) {
        for(j = 0; j < N; j++) {
            x += j;
    }}

    printf("x = %lld\n", x);

    return 0;
}