#include <stdio.h>

int factorial(int i) {
	if (i == 1) {
		return 1;
	} else {
		return i * factorial(i - 1);
	}
}

int main(int argc, char **argv) {
	int i = 5;
	int f = factorial(i);
	printf("factorial(%d) = %d\n", i , f);
}