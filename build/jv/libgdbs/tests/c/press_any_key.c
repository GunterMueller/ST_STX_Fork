#include <stdio.h>

int main(int argc, char **argv) {
	fprintf(stdout, "Press any key...\n");
	fgetc(stdin);
	fprintf(stdout, "Done.\n");
}