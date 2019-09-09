#!/usr/bin/python

import os

cpu = 0
mem = 0


try:
    with open('./top.log','r') as file:
        for line in file:
            data = line.strip().split()
            cpu += float(data[8])
            mem += float(data[9])
except FileNotFoundError:
    print 'top.log not found'

# print 'cpu:',cpu
# print 'mem:',mem


max_cpu = 0
max_mem = 0

exists = os.path.isfile('./max_metrics.log')
if exists:
    with open('./max_metrics.log','r') as file:
        lines = file.readlines()
        max_cpu = float(lines[0].strip().split()[1])
        max_mem = float(lines[1].strip().split()[1])


max_cpu = max(max_cpu, cpu)
max_mem = max(max_mem, mem)

try:
    with open('./max_metrics.log','w') as file:
        file.write("cpu: {}\n".format(max_cpu))
        print "max_cpu: {}%".format(max_cpu)
        file.write("mem: {}\n".format(max_mem))
        print "max_mem: {}%".format(max_mem)
except Exception, err:
    print 'Error when writing to max_metrics.log\n',err
