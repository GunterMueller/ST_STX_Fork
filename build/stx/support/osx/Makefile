CC=gcc
LIBS=-framework ApplicationServices

all: screenshot

screenshot: screenshot.c
	$(CC) -o screenshot screenshot.c $(LIBS)

clean:
	-rm -f screenshot screenshot.o
