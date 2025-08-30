

OBJECTS		= sem_all_deall.o sem_init.o sem_pv.o
LIBRARIES	=
PROGRAMS	= dup2 mmap-read mmap-write pipe popen shm \
		  socket-client socket-inet socket-server

.PHONY:         all clean


all:            $(OBJECTS) $(LIBRARIES) $(PROGRAMS)


clean:
	rm -f *.o *.a $(PROGRAMS)
