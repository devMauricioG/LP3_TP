

OBJECTS		= readfile.o temp_file.o test.o
LIBRARIES	= libtest.a libtest.so
PROGRAMS	= app arglist client getopt_long print-env tifftest

.PHONY:         all clean


all:            $(OBJECTS) $(LIBRARIES) $(PROGRAMS)

clean:
	rm -f *.o *.a $(PROGRAMS)


main:		reciprocal.o

libtest.a:	test.o
	ar cr $@ $?

libtest.so:	test.c
	$(CC) $(CFLAGS) -fPIC -shared $< -o $@

app:		LDLIBS += -L. -ltest
app:		app.c libtest.a

tifftest:	CFLAGS += -static
tifftest:	LDLIBS += -ltiff -ljpeg -lz -lm
