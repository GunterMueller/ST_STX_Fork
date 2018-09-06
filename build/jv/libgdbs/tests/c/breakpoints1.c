/*
 * CFLAGS=-ggdb3 -O2 -W -Wall -Wno-unused-parameter -I.
 */
#include <stdio.h>
#include <stdlib.h>

static inline int 
add(int a, int b)  {
    return a + b;
}

int my_rand_1(void) {
    return add(rand(), rand());
}

int my_rand_2(void) {
    int r = my_rand_1();
    return add(r, r);
}

int main (int argc, char **argv)
{
  int i = my_rand_1();
  printf("%d\n", i);
  return 1; /* next-line */
}