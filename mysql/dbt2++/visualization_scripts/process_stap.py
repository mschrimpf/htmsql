#!/usr/bin/env python2.7

import sys, csv, glob
import scipy as sp
import numpy as np
from scipy import stats

lock_name_lookup = {
 0: 'BufFreelistLock',
 1: 'ShmemIndexLock',
 2: 'OidGenLock',
 3: 'XidGenLock',
 4: 'ProcArrayLock',
 5: 'SInvalReadLock',
 6: 'SInvalWriteLock',
 7: 'WALInsertLock',
 8: 'WALWriteLock',
 9: 'ControlFileLock',
 10: 'CheckpointLock',
 11: 'CLogControlLock',
 12: 'SubtransControlLock',
 13: 'MultiXactGenLock',
 14: 'MultiXactOffsetControlLock',
 15: 'MultiXactMemberControlLock',
 16: 'RelCacheInitLock',
 17: 'CheckpointerCommLock',
 18: 'TwoPhaseStateLock',
 19: 'TablespaceCreateLock',
 20: 'BtreeVacuumLock',
 21: 'AddinShmemInitLock',
 22: 'AutovacuumLock',
 23: 'AutovacuumScheduleLock',
 24: 'SyncScanLock',
 25: 'RelationMappingLock',
 26: 'AsyncCtlLock',
 27: 'AsyncQueueLock',
 28: 'SerializableXactHashLock',
 29: 'SerializableFinishedListLock',
 30: 'SerializablePredicateLockListLock',
 31: 'OldSerXidLock',
 32: 'SyncRepLock',
 33: 'BufMappingLock0',
 34: 'BufMappingLock1',
 35: 'BufMappingLock2',
 36: 'BufMappingLock3',
 37: 'BufMappingLock4',
 38: 'BufMappingLock5',
 39: 'BufMappingLock6',
 40: 'BufMappingLock7',
 41: 'BufMappingLock8',
 42: 'BufMappingLock9',
 43: 'BufMappingLock10',
 44: 'BufMappingLock11',
 45: 'BufMappingLock12',
 46: 'BufMappingLock13',
 47: 'BufMappingLock14',
 48: 'BufMappingLock15',
 49: 'LockMgrLock0',
 50: 'LockMgrLock1',
 51: 'LockMgrLock2',
 52: 'LockMgrLock3',
 53: 'LockMgrLock4',
 54: 'LockMgrLock5',
 55: 'LockMgrLock6',
 56: 'LockMgrLock7',
 57: 'LockMgrLock8',
 58: 'LockMgrLock9',
 59: 'LockMgrLock10',
 60: 'LockMgrLock11',
 61: 'LockMgrLock12',
 62: 'LockMgrLock13',
 63: 'LockMgrLock14',
 64: 'LockMgrLock15',
 65: 'PredicateLockMgrLock0',
 66: 'PredicateLockMgrLock1',
 67: 'PredicateLockMgrLock2',
 68: 'PredicateLockMgrLock3',
 69: 'PredicateLockMgrLock4',
 70: 'PredicateLockMgrLock5',
 71: 'PredicateLockMgrLock6',
 72: 'PredicateLockMgrLock7',
 73: 'PredicateLockMgrLock8',
 74: 'PredicateLockMgrLock9',
 75: 'PredicateLockMgrLock10',
 76: 'PredicateLockMgrLock11',
 77: 'PredicateLockMgrLock12',
 78: 'PredicateLockMgrLock13',
 79: 'PredicateLockMgrLock14',
 80: 'PredicateLockMgrLock15'}

lock_type_lookup = {
 0: 'LW_EXCLUSIVE',
 1: 'LW_SHARED',
 2: 'LW_WAIT_UNTIL_FREE'
}

from collections import defaultdict

d = defaultdict(list)

N, SUM, MEAN, MIN, MAX = range(5)

def parse_printlwlock(file):
    with open(file, 'r') as f:
        c = csv.reader(f, delimiter=";")
        for l in c:
            (pid, lockname, locktype, waittime) = l 
	    lockname = lockname.strip()
            locktype = locktype.strip()
           # dodgy output? not sure...
            if lockname == 'x41':
                lockname = '0x41'
            if lockname == '043':
                lockname = '0x43'
            d[(lockname,locktype)].append((waittime, pid))
            
        ret = {}
        
        for (k, v) in d.iteritems():
            times = np.array([int(x[0]) for x in v])
            #processes = [int(x[1]) for x in v]
            n, min_max, mean, var, skew, kurt = stats.describe(times)
            ret[k] = (n, sum(times), mean, min_max[0], min_max[1])
            
        return ret
        

#base = '/home/pgssi/dbt2results/2013-06-04_21:23:45/'
#base = '/home/pgssi/dbt2results/set9/2013-06-07_11:19:31/'
base = '/home/pgssi/dbt2results/set5/2013-06-08_09:49:06/'

lwlocks_32_4_4 = parse_printlwlock(glob.glob(base + '32_ssi_4,4*/postgresql-printlwlock.stp.out')[0])
lwlocks_32_32_4 = parse_printlwlock(glob.glob(base + '32_ssi_32,4*/postgresql-printlwlock.stp.out')[0])
lwlocks_128_4_4 = parse_printlwlock(glob.glob(base + '128_ssi_4,4*/postgresql-printlwlock.stp.out')[0])
lwlocks_128_32_4 = parse_printlwlock(glob.glob(base + '128_ssi_4,4*/postgresql-printlwlock.stp.out')[0])

configs = ['32_4_4', '32_32_4', '128_4_4', '128_32_4'] 
config_headers = ['count', 'totalwait', 'avgwait', 'minwait', 'maxwait']

print "lockid,lockid,lockname,locktype," + ','.join([x + '_' + y for x in configs for y in config_headers]) + ",ratio_4_4,ratio_32_4,ratio"

column_headers = ['count', 'totalwait', 'avgwait', 'minwait', 'maxwait']

for lockname, locktype in sorted(set(lwlocks_32_4_4.keys() + lwlocks_32_32_4.keys() + lwlocks_128_4_4.keys() + lwlocks_128_32_4.keys()), key=lambda x: int(x[0], 16)):
    lwlock_32_4_4 = lwlocks_32_4_4.get((lockname, locktype), (None, None, None, None, None))
    lwlock_32_32_4 = lwlocks_32_32_4.get((lockname, locktype), (None, None, None, None, None))
    lwlock_128_4_4 = lwlocks_128_4_4.get((lockname, locktype), (None, None, None, None, None))
    lwlock_128_32_4 = lwlocks_128_32_4.get((lockname, locktype), (None, None, None, None, None))
    
    lockname_int = int(lockname, 16)
    strlockname = lock_name_lookup.get(lockname_int)

    strlocktype = lock_type_lookup.get(int(locktype, 16))    

    ratio_4_4 = (lwlock_128_4_4[MEAN] or 1.)/float(lwlock_32_4_4[MEAN] or 1.)
    ratio_32_4 = (lwlock_128_32_4[MEAN] or 1.)/float(lwlock_32_32_4[MEAN] or 1.)
    ratio = ratio_32_4/ratio_4_4
    
    out = [lockname, lockname_int, strlockname, strlocktype]
    
    for lock in ['lwlock_' + x for x in configs]:
        out.extend(eval(lock))
        
    out.extend([ratio_4_4, ratio_32_4, ratio])
        
    print ','.join(map(str, out))
