

#include <malloc.h>
#include <pthread.h>
#include <semaphore.h>

struct job {

  struct job* next; 


};


struct job* job_queue;

extern void process_job (struct job*);

pthread_mutex_t job_queue_mutex = PTHREAD_MUTEX_INITIALIZER;


sem_t job_queue_count;


void initialize_job_queue ()
{

  job_queue = NULL;

  sem_init (&job_queue_count, 0, 0);
}



void* thread_function (void* arg)
{
  while (1) {
    struct job* next_job;

 
    sem_wait (&job_queue_count);

    
    pthread_mutex_lock (&job_queue_mutex);
    
    next_job = job_queue;
    
    job_queue = job_queue->next;
    
    pthread_mutex_unlock (&job_queue_mutex);

    
    process_job (next_job);
    
    free (next_job);
  }
  return NULL;
}

/* Add a new job to the front of the job queue.  */

void enqueue_job (/* Pass job-specific data here...  */)
{
  struct job* new_job;

  /* Allocate a new job object.  */
  new_job = (struct job*) malloc (sizeof (struct job));
  /* Set the other fields of the job struct here...  */

  /* Lock the mutex on the job queue before accessing it.  */
  pthread_mutex_lock (&job_queue_mutex);
  /* Place the new job at the head of the queue.  */
  new_job->next = job_queue;
  job_queue = new_job;

  /* Post to the semaphore to indicate another job is available.  If
     threads are blocked, waiting on the semaphore, one will become
     unblocked so it can process the job.  */
  sem_post (&job_queue_count);

  /* Unlock the job queue mutex.  */
  pthread_mutex_unlock (&job_queue_mutex);
}
