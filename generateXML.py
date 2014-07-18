#!/usr/bin/python

from lxml import etree
import sys

topicNodesArray = {}
root = etree.Element('videoSearchResults')

runRoot = etree.SubElement(root, 'videoSearchRunResult', pType='F', pid='TelecomItalia', priority='1', condition='NO', exampleSet='D', desc='This is a text description')

# Open files with retrieval times
with open('../results/'+sys.argv[1]+'/'+ sys.argv[1]+'_poly/CDVS-client.time') as tPoly:
    contentPoly = tPoly.read().splitlines()
tPoly.close()

with open('../results/'+sys.argv[1]+'/'+ sys.argv[1]+'_full/CDVS-client.time') as tFull:
    contentFull = tFull.read().splitlines()
tFull.close()

for t in range(0, 30):
	topicTime = int(contentPoly[t*4]) + int(contentPoly[t*4+1]) + int(contentPoly[t*4+2]) + int(contentPoly[t*4+3]) + int(contentFull[t*4]) + int(contentFull[t*4+1]) + int(contentFull[t*4+2]) + int(contentFull[t*4+3])
	node = etree.SubElement(runRoot, 'videoSearchTopicResult',  tNum="%s" % (t+9069), elapsedTime="%.1f" % (float(topicTime)/1000), searcherId='X')
	topicNodesArray[t+9069]  = node

# Read the treceval compatible file per line and generate XML nodes
with open('../results/'+sys.argv[1]+'/all.res') as f:
    content = f.read().splitlines()
f.close()

for line in content:
	if len(line)>1:
		lineS = line.split()
		topic = lineS[0]
		shotId = lineS[2]
		seqNum = lineS[3]
		etree.SubElement(topicNodesArray[int(topic)], 'item', seqNum="%s" % (seqNum), shotId="%s" % (shotId))

print "<!DOCTYPE videoSearchResults SYSTEM \"http://www-nlpir.nist.gov/projects/tv2014/dtds/videoSearchResults.dtd\">"
print(etree.tostring(root, pretty_print=True))
