#include <errno.h>
#include <time.h>

#include "../timing.h"

int64_t timing_get_nanos(void) {
  struct timespec tv;

  // CLOCK_MONOTONIC is more portable than CLOCK_REALTIME
  // especially when considering musl libc compatibility
  if (clock_gettime(CLOCK_MONOTONIC, &tv) != 0) {
    // Fall back to CLOCK_REALTIME if MONOTONIC fails
    clock_gettime(CLOCK_REALTIME, &tv);
  }

  return tv.tv_sec * 1000000000LL + tv.tv_nsec;
}

void timing_sleep(int64_t nanos) {
  struct timespec tv = {nanos / 1000000000LL, nanos % 1000000000LL};

  struct timespec rem;
  while (nanosleep(&tv, &rem) == -1) {
    if (errno != EINTR) {
      // If error is not due to interrupted system call, break
      break;
    }
    // Otherwise, continue sleeping for the remaining time
    tv = rem;
  }
}
