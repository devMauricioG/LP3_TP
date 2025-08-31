#include <pthread.h>
#include <stdio.h>
#include <stdint.h> // para intptr_t

void* compute_prime(void* arg) {
    int candidate = 2;
    int n = *((int*) arg);

    while (1) {
        int factor;
        int is_prime = 1;

        for (factor = 2; factor < candidate; ++factor)
            if (candidate % factor == 0) {
                is_prime = 0;
                break;
            }

        if (is_prime) {
            if (--n == 0)
                return (void*)(intptr_t) candidate;
        }
        ++candidate;
    }
    return NULL;
}

int main() {
    pthread_t thread;
    int which_prime = 5000;
    void* ret_val;

    pthread_create(&thread, NULL, &compute_prime, &which_prime);

    pthread_join(thread, &ret_val);
    int prime = (int)(intptr_t) ret_val;

    printf("The %dth prime number is %d.\n", which_prime, prime);
    return 0;
}
