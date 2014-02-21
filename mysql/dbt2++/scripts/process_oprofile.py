#!/usr/bin/env python2.7

import xml.etree.ElementTree as ET
from collections import defaultdict
import sys

def parse_opreport_profile(file):
    tree = ET.parse(file)
    root = tree.getroot()

    symboltable = root.find('symboltable')
    symboltable = {s.attrib['id']: s.attrib for s in symboltable.getchildren()}

    binaries = defaultdict(dict)

    for binary in root.findall('binary'):
        for symbol in binary.findall('symbol'):
            symbolinfo = symboltable[symbol.attrib['idref']]
            symbolinfo['count'] = symbolinfo.get('count', 0) + \
                                    int(symbol.find('count').text.strip())
                                                   
            binaryname = binary.attrib['name']
            if symbolinfo['startingaddr'] not in binaries[binaryname]:
                binaries[binaryname][symbolinfo['startingaddr']] = symbolinfo
        
    return binaries

def combine_binaries_symbol_count(b1_symbols, b2_symbols):
    """ given 2 binaries, combine the counts of the symbols  """
    new_symbols = {}

    for key in set(b1_symbols.keys() + b2_symbols.keys()):
        b1_symbol = b1_symbols.get(key)
        b2_symbol = b2_symbols.get(key)
        
        assert (b1_symbol is None or b2_symbol is None) \
                or (b1_symbol['name'] == b2_symbol['name'])
            
        b2_count = b2_symbol['count'] if b2_symbol is not None else 0
        b1_count = b1_symbol['count'] if b1_symbol is not None else 0
        name = b1_symbol['name'] if b1_symbol is not None else b2_symbol['name']
        
        b1_samples = b1_symbol.get('num_samples', 1) if b1_symbol is not None else 0
        b2_samples = b2_symbol.get('num_samples', 1) if b2_symbol is not None else 0
        
        new_symbol = {'startingaddr': key, 'name': name}
        new_symbol['count'] = b1_count+b2_count
        new_symbol['num_samples'] = b1_samples+b2_samples
        
        new_symbols[key] = new_symbol
        
    return new_symbols
    
def combine_reports(report1, report2):
    """ given 2 reports, combine the counts of each binary in the reports"""
    new_report = {}
    
    for key in set(report1.keys() + report2.keys()):
        r1_binary = report1.get(key)
        r2_binary = report2.get(key)
        
        # get rid of some noise from background processes
        len_b1 = len(r1_binary) if r1_binary is not None else 0
        len_b2 = len(r2_binary) if r2_binary is not None else 0
        if len_b1 + len_b2 < 10:
            continue
        
        if r1_binary is not None and r2_binary is not None:
            new_binary = combine_binaries_symbol_count(r1_binary, r2_binary)
        elif r1_binary is None:
            new_binary = r2_binary
        else:
            new_binary = r1_binary
            
        new_report[key] = new_binary
    return new_report
    
import glob

#base = '/home/pgssi/dbt2results/set2/*/'
#base = '/home/pgssi/dbt2results/2013-06-03_14:34:57/'

#base =  '/home/pgssi/dbt2results/set6/2013*/'

#base = '/home/pgssi/dbt2results/set11/2013*/'

base = sys.argv[1] + '/2013*/'

report_32_4_4 = {}
for file in glob.glob(base + '32_ssi_4,4*/*/*/*/oprofile.xml'):
    r = parse_opreport_profile(file)
    report_32_4_4 = combine_reports(report_32_4_4, r)

report_128_4_4 = {}
for file in glob.glob(base + '128_ssi_4,4*/*/*/*/oprofile.xml'):
    r = parse_opreport_profile(file)
    report_128_4_4 = combine_reports(report_128_4_4, r)

report_32_32_4 = {}
for file in glob.glob(base + '32_ssi_32,4*/*/*/*/oprofile.xml'):
    r = parse_opreport_profile(file)
    report_32_32_4 = combine_reports(report_32_32_4, r)
    
report_128_32_4 = {}
for file in glob.glob(base + '128_ssi_32,4*/*/*/*/oprofile.xml'):
    r = parse_opreport_profile(file)
    report_128_32_4 = combine_reports(report_128_32_4, r)

for r in ['report_32_4_4', 'report_32_32_4', 'report_128_4_4', 'report_128_32_4']:
    print r
    for k, v in eval(r + '.items()'):
        print k, len(v)
    print

#binary_names =  ['/home/pgssi/install/pgsql/bin/postgres', '/usr/lib/debug/lib/modules/2.6.35.14-106.fc14.x86_64/vmlinux']

binary_names = ['/usr/lib/debug/lib/modules/2.6.35.14-106.fc14.x86_64/vmlinux']

for binary in report_32_4_4.keys():
	if binary.endswith('postgres'):
		binary_names.append(binary)
 
binaries = {}

for binary_key in binary_names:
    binary_32_4_4 = report_32_4_4.get(binary_key)
    binary_128_4_4 = report_128_4_4.get(binary_key)
    binary_32_32_4 = report_32_32_4.get(binary_key)
    binary_128_32_4 = report_128_32_4.get(binary_key)
    
    symbols = {}
    
    for symbol_key in set(binary_32_4_4.keys() + binary_128_4_4.keys() + binary_32_32_4.keys() + binary_128_32_4.keys()):
        symbol_32_4_4 = binary_32_4_4.get(symbol_key)
        symbol_128_4_4 = binary_128_4_4.get(symbol_key)
        symbol_32_32_4 = binary_32_32_4.get(symbol_key)
        symbol_128_32_4 = binary_128_32_4.get(symbol_key)
        
        valid_symbols = [s for s in [symbol_32_4_4, symbol_128_4_4, symbol_32_32_4, symbol_128_32_4] if s is not None]
        
        symbol_name = valid_symbols[0]['name']
        assert all([s['name'] == symbol_name for s in valid_symbols])
    
        symbol = symbols.get(symbol_name, {'name': symbol_name, 'starting_addrs': [], 'count_128_32_4': 0.0, 'count_128_4_4': 0.0, 'count_32_32_4': 0.0, 'count_32_4_4': 0.0})
        symbol['starting_addrs'].append(symbol_key)
        
        symbol['count_32_4_4'] += float(symbol_32_4_4.get('count'))/symbol_32_4_4.get('num_samples', 1) if symbol_32_4_4 is not None else 0.0
        symbol['count_128_4_4'] += float(symbol_128_4_4.get('count'))/symbol_128_4_4.get('num_samples', 1) if symbol_128_4_4 is not None else 0.0
        symbol['count_32_32_4'] += float(symbol_32_32_4.get('count'))/symbol_32_32_4.get('num_samples', 1) if symbol_32_32_4 is not None else 0.0
        symbol['count_128_32_4'] += float(symbol_128_32_4.get('count'))/symbol_128_32_4.get('num_samples', 1) if symbol_128_32_4 is not None else 0.0
    
        # default counts to one... this slightly skews the data, but simplifies ratio stats
        symbol['4_4_ratio'] = (symbol['count_128_4_4'] if symbol['count_128_4_4'] <> 0.0 else None or 1.)/(symbol['count_32_4_4'] if symbol['count_32_4_4'] <> 0.0 else None or 1.)
        symbol['32_4_ratio'] = (symbol['count_128_32_4'] if symbol['count_128_32_4'] <> 0.0 else None or 1.)/(symbol['count_32_32_4'] if symbol['count_32_32_4'] <> 0.0 else None or 1.)
        
        symbol['delta'] = symbol['32_4_ratio']-symbol['4_4_ratio']
        symbol['ratio'] = symbol['32_4_ratio']/symbol['4_4_ratio']
        
        symbols[symbol_name] = symbol
        
    binaries[binary_key] = symbols
        
for k, binary in binaries.items():
    print k
    for symbol in sorted(binary.values(), key=lambda x: x['ratio']): 
        if symbol['ratio'] > 1.5 or True: #or symbol['ratio'] < 0.6:
            print ','.join(map(str, [symbol['name'], symbol['count_32_4_4'], symbol['count_128_4_4'], symbol['count_32_32_4'], symbol['count_128_32_4'], symbol['4_4_ratio'], symbol['32_4_ratio'], symbol['ratio'], symbol['delta']]))
          #   print '{0:<50} ||  {1:13}  {2:13}  |  {3:13}  {4:13cd dbt2    
          #}  |  {5:.2f}  {6:.2f}  {7:.2f}  {8:.2f}'.format (symbol['name'], 
#                                                                                                                  symbol['count_32_4_4'], symbol['count_128_4_4'], 
#                                                                                                                  symbol['count_32_32_4'], symbol['count_128_32_4'], 
#                                                                                                                  symbol['4_4_ratio'], symbol['32_4_ratio'], symbol['ratio'], symbol['delta'])
#     print
#     
#     
### old ###    


# def calc_ratio_report(report1, report2):
#     """ given 2 reports, for each symbol of each binary calculate the ratio of fn calls report1:report2 """
# 
#     new_report = {}
#     
#     for bin_key in ['/home/pgssi/install/pgsql/bin/postgres',
#  '/usr/lib/debug/lib/modules/2.6.35.14-106.fc14.x86_64/vmlinux']:
#  #in set(report1.keys() + report2.keys()):
#         r1_binary = report1.get(bin_key)
#         r2_binary = report2.get(bin_key)
#         
#         new_binary = {}
#         
#         for sym_key in set(r1_binary.keys() + r2_binary.keys()):
#             b1_symbol = r1_binary.get(sym_key)
#             b2_symbol = r2_binary.get(sym_key)
#         
#             assert (b1_symbol is None or b2_symbol is None) \
#                     or (b1_symbol['name'] == b2_symbol['name'])
#             
#             b2_count = b2_symbol['count'] if b2_symbol is not None else 0
#             b1_count = b1_symbol['count'] if b1_symbol is not None else 0
#             name = b1_symbol['name'] if b1_symbol is not None else b2_symbol['name']
#         
#             b1_samples = b1_symbol.get('num_samples', 1) if b1_symbol is not None else 0
#             b2_samples = b2_symbol.get('num_samples', 1) if b2_symbol is not None else 0
#             
#             b1_average = b1_count/float(b1_samples) if b1_samples <> 0 else 0.000000001
#             b2_average = b2_count/float(b2_samples) if b2_samples <> 0 else 0.000000001
#         
#             new_symbol = {'startingaddr': sym_key, 'name': name}
#             new_symbol['ratio'] = b1_average/b2_average
#     
#             new_binary[sym_key] = new_symbol
#         
#         new_report[bin_key] = new_binary
#     
#     return new_report
# 
# def compare_ratio_reports(ratioreport1, ratioreport2):
#     """ given  2 ratio reports, compare the ratios of each function call """
#     
#     new_report = {}
#     
#     for bin_key in ['/home/pgssi/install/pgsql/bin/postgres',
#  '/usr/lib/debug/lib/modules/2.6.35.14-106.fc14.x86_64/vmlinux']:
#  #in set(report1.keys() + report2.keys()):
#         r1_binary = ratioreport1.get(bin_key)
#         r2_binary = ratioreport2.get(bin_key)
#         
#         new_binary = {}
#         
#         for sym_key in set(r1_binary.keys() + r2_binary.keys()):
#             b1_symbol = r1_binary.get(sym_key)
#             b2_symbol = r2_binary.get(sym_key)
#         
#             assert (b1_symbol is None or b2_symbol is None) \
#                     or (b1_symbol['name'] == b2_symbol['name'])
#             
#             name = b1_symbol['name'] if b1_symbol is not None else b2_symbol['name']
#         
#             b1_ratio = b1_symbol.get('ratio') if b1_symbol is not None else 0.000000001
#             b2_ratio = b2_symbol.get('ratio') if b2_symbol is not None else 0.000000001
#             
#             new_symbol = {'startingaddr': sym_key, 'name': name}
#             new_symbol['4,4_ratio'] = b1_symbol.get('ratio') if b1_symbol is not None else None
#             new_symbol['32,4_ratio'] = b2_symbol.get('ratio') if b2_symbol is not None else None
#             new_symbol['ratio'] = b1_ratio/b2_ratio
#     
#             new_binary[sym_key] = new_symbol
#         
#         new_report[bin_key] = new_binary
#     
#     return new_report
#     
# import glob
# 
# report_32_4_4 = {}
# for file in glob.glob('/mnt/data1/pgssi/db16/dbt2results/set2/*/32_ssi_4,4*/*/*/*/oprofile.xml'):
#     r = parse_opreport_profile(file)
#     report_32_4_4 = combine_reports(report_32_4_4, r)
# 
# report_128_4_4 = {}
# for file in glob.glob('/mnt/data1/pgssi/db16/dbt2results/set2/*/128_ssi_4,4*/*/*/*/oprofile.xml'):
#     r = parse_opreport_profile(file)
#     report_128_4_4 = combine_reports(report_128_4_4, r)
# 
# report_32_32_4 = {}
# for file in glob.glob('/mnt/data1/pgssi/db16/dbt2results/set2/*/32_ssi_32,4*/*/*/*/oprofile.xml'):
#     r = parse_opreport_profile(file)
#     report_32_32_4 = combine_reports(report_32_32_4, r)
#     
# report_128_32_4 = {}
# for file in glob.glob('/mnt/data1/pgssi/db16/dbt2results/set2/*/128_ssi_32,4*/*/*/*/oprofile.xml'):
#     r = parse_opreport_profile(file)
#     report_128_32_4 = combine_reports(report_128_32_4, r)
# 
# for r in ['report_32_4_4', 'report_32_32_4', 'report_128_4_4', 'report_128_32_4']:
#     print r
#     for k, v in eval(r + '.items()'):
#         print k, len(v)
#     print
# 
# ratio_report_4_4 = calc_ratio_report(report_32_4_4, report_128_4_4)
# 
# ratio_report_32_4 = calc_ratio_report(report_32_32_4, report_128_32_4)
# 
# comp = compare_ratio_reports(ratio_report_4_4, ratio_report_32_4)
# 
# for k, v in comp['/home/pgssi/install/pgsql/bin/postgres'].items():
#     print "%s\t%s\t%s\t%s" % (str(v['name']), v['ratio'], v['b1_ratio'], v['b2_ratio'])

 
# def calc_profile_count_diff(si_symbols, ssi_symbols):
#     #ssi_symbols - si_symbols
#     diff_symbols = {}
# 
#     for key in set(si_symbols.keys() + ssi_symbols.keys()):
#         si_symbol = si_symbols.get(key)
#         ssi_symbol = ssi_symbols.get(key)
#     
#         assert (si_symbol is None or ssi_symbol is None) \
#                 or (si_symbol['name'] == ssi_symbol['name'])
#     
#         ssi_count = ssi_symbol['count'] if ssi_symbol is not None else 0
#         si_count = si_symbol['count'] if si_symbol is not None else 0
#         name = si_symbol['name'] if si_symbol is not None else ssi_symbol['name']
#     
#         diff = {'startingaddr': key, 'name': name, 'ssi_count': ssi_count, 'si_count': si_count}
#         diff['diff_count'] = ssi_count - si_count
#         diff['percent_increase'] = (ssi_count - si_count)/float(max(si_count, sys.float_info.epsilon))
#     
#         diff_symbols[key] = diff
#     
#     return diff_symbols
# 
# si = parse_opreport_profile("/Users/brent/Desktop/2013-05-19_12:20:23/128_si_32,4_1_2013-05-19_12:20:23/db/oprofile/xml/oprofile.xml")
#     
# ssi = parse_opreport_profile("/Users/brent/Desktop/2013-05-19_12:20:23/128_ssi_32,4_1_2013-05-19_12:33:08/db/oprofile/xml/oprofile.xml")
# 
# 
# si_pg = si['/home/pgssi/install/pgsql/bin/postgres']
# ssi_pg = ssi['/home/pgssi/install/pgsql/bin/postgres']
# 
# diff_pg = calc_count_diff(si_pg, ssi_pg)
# 
# 
# sorted(diff_pg.values(), key = lambda v: v['diff_count'])

# 
# #########
# 
# def parse_opreport_callgraph(file):
# 
# tree = ET.parse(file)
# root = tree.getroot()
# 
# symboltable = root.find('symboltable')
# symboltable = {s.attrib['id']: s.attrib for s in symboltable.getchildren()}
# 
# binaries = {}
# 
# for binary in root.findall('binary'):
#     for symbol in binary.findall('symbol'):
#         
#         for caller_symbol in symbol.find('callers'):
#             symbolinfo = symboltable[caller_symbol.attrib['idref']]
#             symbolinfo['count'] = symbolinfo.get('count', 0) + \
#                                 int(caller_symbol.find('count').text.strip())
#             
#         for callee in symbol.find('callees'):
#         
#         
#         symbolinfo = symboltable[symbol.attrib['idref']]
#         symbolinfo['count'] = symbolinfo.get('count', 0) + \
#                                 int(symbol.find('count').text.strip())
#                                                
#         binaryname = binary.attrib['name']
#         if symbolinfo['startingaddr'] not in binaries[binaryname]:
#             binaries[binaryname][symbolinfo['startingaddr']] = symbolinfo
#     
# return binaries
# 
