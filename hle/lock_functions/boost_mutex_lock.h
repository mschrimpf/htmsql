#ifndef BOOST_MUTEX_LOCK_H_
#define BOOST_MUTEX_LOCK_H_

#include <boost/thread.hpp>

void boost_mutex_lock(boost::mutex *lock);
void boost_mutex_unlock(boost::mutex *lock);

#endif /* BOOST_MUTEX_LOCK_H_ */
