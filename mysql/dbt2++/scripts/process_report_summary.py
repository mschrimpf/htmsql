#!/usr/bin/env python2.7

import csv, sys, math
from collections import defaultdict
import scipy as sp
import numpy as np
from scipy import stats

report_summary = sys.argv[1]
output_dir = sys.argv[2]

data = defaultdict(lambda: defaultdict(lambda: np.array([])))
count = defaultdict(int)

MPL, ISOLATION, CPU, ITERATION, DATE, TIME = range(6)
TOTALTRANS, TOTALROLLBACK, TOTALSERRETRIES, TOTALAVGRESTIME, TTPM, ERRORS, DURATION = range(7)
TOTALTRANS, TOTALROLLBACK, TOTALSERRETRIES, TOTALAVGRESTIME, TRANSPERMIN, ABORTRATE = range(6)
VAL, ERROR = range(2)

with open(report_summary, 'rU') as f:
    c = csv.reader(f, delimiter=';')
    header=c.next() #discard header
    assert header == ['run','totaltrans','totalrollback','totalserretries','totalavgrestime','ttpm','errors','duration']
    for row in c:
        key = row[0].split('_')
        value = row[1:]
        totaltrans = int(value[TOTALTRANS])
        totalrollback = int(value[TOTALROLLBACK])
        totalserretries = int(value[TOTALSERRETRIES])
        totalavgrestime = float(value[TOTALAVGRESTIME])
        ttpm = float(value[TTPM])
        errors = int(value[ERRORS])
        duration = float(value[DURATION])
    
        assert duration == 5.0
        assert errors == 0
        
        # average over ITERATION, DATE, TIME
        key = (int(key[MPL]), key[ISOLATION], key[CPU])
        
        transpermin = totaltrans / duration
        abortrate = totalrollback/float(totaltrans)*100
        
        if abortrate > 1:
            print "error? (abortrate > 1%%): %s" % str(row)
        
        values = [totaltrans, totalrollback, totalserretries, totalavgrestime, transpermin, abortrate]
       
        for var in ['totaltrans', 'totalrollback', 'totalserretries', 'totalavgrestime', 'transpermin', 'abortrate']:
            data[key][var] = np.append(data[key][var], eval(var))

#average data and calc 95% confidence interval assuming normal dist
new_data = {}   
for runk, runv in data.items():
    new_vals = {}
    for k, v in runv.items():
        n, min_max, mean, var, skew, kurt = stats.describe(v)
        std = math.sqrt(var)
        err = std * stats.norm._ppf((1+0.95)/float(2))
        new_vals[k] = (mean, err)
    new_data[runk] = new_vals
data = new_data
              
              
# plot data exports

for cpu in ["1,1", "4,4", "8,1", "16,4", "32,4"]:
    #fix CPU
    #vary MPL and ISOLATION
    # measure transpermin
    with open(output_dir + '/%s_v_%s_%s.data' % ('MPL', 'TPM', 'CPU'+str(cpu)), 'w') as f:
        f.write('MPL SI SI-err SSI SSI-err\n')
        for k, v in sorted(data.items()):
            if k[CPU] == cpu:
                if k[ISOLATION] == 'si':
                    f.write('{} {} {} '.format(k[MPL], *v['transpermin']))
                else:
                    assert k[ISOLATION]  == 'ssi'
                    f.write('{} {}\n'.format(*v['transpermin']))

    # measure abortrate
    with open(output_dir + '/%s_v_%s_%s.data' % ('MPL', 'ABORT', 'CPU'+str(cpu)), 'w') as f:
        f.write('MPL SI SI-err SSI SSI-err\n')
        for k, v in sorted(data.items()):
            if k[CPU] == cpu:
                if k[ISOLATION] == 'si':
                    f.write('{} {} {} '.format(k[MPL], *v['abortrate']))
                else:
                    assert k[ISOLATION]  == 'ssi'
                    f.write('{} {}\n'.format(*v['abortrate']))
                    
    # measure serialization retries
    with open(output_dir + '/%s_v_%s_%s.data' % ('MPL', 'SERRET', 'CPU'+str(cpu)), 'w') as f:
        f.write('MPL SI SI-err SSI SSI-err\n')
        for k, v in sorted(data.items()):
            if k[CPU] == cpu:
                if k[ISOLATION] == 'si':
                    f.write('{} {} {} '.format(k[MPL], *v['totalserretries']))
                else:
                    assert k[ISOLATION]  == 'ssi'
                    f.write('{} {}\n'.format(*v['totalserretries']))

def cpu_key(t):
    k, v = t
    core, die = k[CPU].split(',')
    return (int(core) + int(die),  k[ISOLATION])
    
for mpl in [1, 8, 16, 32, 64, 128]:
    with open(output_dir + '/%s_v_%s_%s.data' % ('CPU', 'TPM', 'MPL'+str(mpl)), 'w') as f:
        f.write('CPU SI SI-err SSI SSI-err\n')
        for k, v in sorted(data.items(), key=cpu_key):
            if k[MPL] == mpl:
                if k[ISOLATION] == 'si':
                    f.write('{} {} {} '.format(k[CPU], *v['transpermin']))
                else:
                    assert k[ISOLATION]  == 'ssi'
                    f.write('{} {}\n'.format(*v['transpermin']))

    # measure abortrate
    with open(output_dir + '/%s_v_%s_%s.data' % ('CPU', 'ABORT', 'MPL'+str(mpl)), 'w') as f:
        f.write('CPU SI SI-err SSI SSI-err\n')
        for k, v in sorted(data.items(), key=cpu_key):
            if k[MPL] == mpl:
                if k[ISOLATION] == 'si':
                    f.write('{} {} {} '.format(k[CPU], *v['abortrate']))
                else:
                    assert k[ISOLATION]  == 'ssi'
                    f.write('{} {}\n'.format(*v['abortrate']))
                    
    # measure serialization retries
    with open(output_dir + '/%s_v_%s_%s.data' % ('CPU', 'SERRET', 'MPL'+str(mpl)), 'w') as f:
        f.write('CPU SI SI-err SSI SSI-err\n')
        for k, v in sorted(data.items(), key=cpu_key):
            if k[MPL] == mpl:
                if k[ISOLATION] == 'si':
                    f.write('{} {} {} '.format(k[CPU], *v['totalserretries']))
                else:
                    assert k[ISOLATION]  == 'ssi'
                    f.write('{} {}\n'.format(*v['totalserretries']))
                    