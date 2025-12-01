#include <stdio.h>
#include <unistd.h>

int main(int ac, char* av)
{
    int i;
    #pragma omp parallel for
    for(i=0; i<16; i++){
        sleep(1);
    }
    return 0;
}