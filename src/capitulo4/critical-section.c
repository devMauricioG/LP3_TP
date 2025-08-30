

#include <pthread.h>
#include <stdio.h>
#include <string.h>

float* account_balances;



int process_transaction (int from_acct, int to_acct, float dollars)
{
  int old_cancel_state;

  if (account_balances[from_acct] < dollars)
    return 1;


  pthread_setcancelstate (PTHREAD_CANCEL_DISABLE, &old_cancel_state);
  
  account_balances[to_acct] += dollars;
  account_balances[from_acct] -= dollars;
  pthread_setcancelstate (old_cancel_state, NULL);

  return 0;
}
