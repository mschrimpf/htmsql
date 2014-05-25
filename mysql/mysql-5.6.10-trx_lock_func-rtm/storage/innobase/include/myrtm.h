#ifndef _MYRTM_H
#define _MYRTM_H 1

void rtm_lock(ib_mutex_t* mutex, const char* file_name, ulint line);
void rtm_unlock(ib_mutex_t* mutex);

#endif /* _MYRTM_H */
