#include <stdio.h>
#line 3 "factorial2.c"
#line 4 "factorial2.js"
int factorial(int i) {	
	if (i == 1) {
		return 1;
	} else {
		return i * factorial(i - 1);
	}
}
#line 12 "factorial2.c"

int main(int argc, char **argv) {
	int i = 5;
	int f = factorial(i);
	printf("factorial(%d) = %d\n", i , f);
}