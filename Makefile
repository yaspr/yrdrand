CC=gcc
CFLAGS=-Wall -Wextra
OFLAGS=-Ofast

all: test_yrdrand

test_yrdrand: test_yrdrand.c
	$(CC) $(CFLAGS) $(OFLAGS) $< yrdrand.S -o $@

clean:
	rm -Rf test_yrdrand 
