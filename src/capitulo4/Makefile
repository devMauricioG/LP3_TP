

OBJECTS		= cleanup.o condvar.o critical-section.o cxx-exit.o \
		  job-queue1.o job-queue2.o job-queue3.o spin-condvar.o
LIBRARIES	=
PROGRAMS	= detached primes thread-create thread-create2 \
		  thread-pid tsd


LDLIBS		+= -lpthread

.PHONY:         all clean


all:            $(OBJECTS) $(LIBRARIES) $(PROGRAMS)


clean:
	rm -f *.o *.a $(PROGRAMS)
