#!/usr/bin/env python2.7

import sys, os 

core_configs = {}

core_configs['1,1' ] = [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
core_configs['4,4' ] = [1,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0]
core_configs['8,1' ] = [1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
core_configs['16,4'] = [1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0]
core_configs['32,4'] = [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]


def set_core(core, val):
    core_file = '/sys/devices/system/cpu/cpu%d/online' % core
    os.system("echo %s > %s 2>/dev/null" % (val, core_file))   

core_config = sys.argv[1]

assert core_config in core_configs.keys()

for core, val in sorted(enumerate(core_configs[core_config]), 
			key = lambda x: str.lower(str(x[0]))):
    if core == 0:
        continue #core 0 must always be on
    set_core(core, val)
