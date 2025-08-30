

#include <fcntl.h>
#include <stdlib.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <unistd.h>

char* read_from_file (const char* filename, size_t length)
{
  char* buffer;
  int fd;
  ssize_t bytes_read;


  buffer = (char*) malloc (length);
  if (buffer == NULL)
    return NULL;

  fd = open (filename, O_RDONLY);
  if (fd == -1) {

    free (buffer);
    return NULL;
  }
 
  bytes_read = read (fd, buffer, length);
  if (bytes_read != length) {
  
    free (buffer);
    close (fd);
    return NULL;
  }

  close (fd);
  return buffer;
}
