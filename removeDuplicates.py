#!/usr/bin/python

import sys

# Remove duplicates given by sub-frames. e.g: v000.7 and v000.8 belongs both to v000

f = open(sys.argv[1],'r')
keyframes = dict()

for line in f.readlines():
	line_a = line.split()
	k = line_a[0].split('.')
	if keyframes.has_key(k[0]) == 0:
		keyframes[k[0]] = 1
		print k[0]+' '+line_a[1]+' '+line_a[2] 

f.close()

