#!/usr/bin/python

from lxml import etree

topicNodesArray = {}
root = etree.Element('videoSearchResults')

runRoot = etree.SubElement(root, 'videoSearchRunResult', pType='F', pid='TelecomItalia', priority='1', condition='NO', exampleSet='D', desc='This is a text description')

for t in range(9069, 9099):
	# TODO: complete with elapsedTime	
	node = etree.SubElement(runRoot, 'videoSearchTopicResult',  tNum="%s" % (t), elapsedTime='0', searcherId='X')
	topicNodesArray[t]  = node

# Read the treceval compatible file per line and generate XML nodes
with open('../results/07_11_RVD_global/all.res') as f:
    content = f.read().splitlines()

for line in content:
	if len(line)>1:
		lineS = line.split()
		topic = lineS[0]
		shotId = lineS[2]
		seqNum = lineS[3]
		etree.SubElement(topicNodesArray[int(topic)], 'item', seqNum="%s" % (seqNum), shotId="%s" % (shotId))

print "<!DOCTYPE videoSearchResults SYSTEM \"http://www-nlpir.nist.gov/projects/tv2014/dtds/videoSearchResults.dtd\">"
print(etree.tostring(root, pretty_print=True))
