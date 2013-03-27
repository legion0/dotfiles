#!/usr/bin/env python
import sys, os, subprocess, collections

def main(argv):
	p = subprocess.Popen(["df"], stdout=subprocess.PIPE)
	strout, _ = p.communicate()
	data = [line.split() for line in strout.split("\n")[1:-1]]
	data = [(x[0], x[5], long(x[1])) for x in data]
	dfData = data
	with open("/proc/partitions") as f:
		data = f.read()
	data = [line.split() for line in data.split("\n")[2:-1]]
	data = [(x[3], long(x[2])) for x in data]
	procData = data
	data = [("Device", "Letter", "Mount Point", "Distance")]
	deviceSet = set()
	for device, devSize in procData:
		best = None
		bestDistance = 10000 # better not find then lie (10MB diff)
		for letter, mountPoint, driveSize in dfData:
			distance = abs(driveSize - devSize)
			if distance < bestDistance:
				bestDistance = distance
				best = (letter, mountPoint)
		if best is not None and device not in deviceSet and device[:-1] not in deviceSet:
			deviceSet.add(device)
			data.append((device, best[0], best[1], str(bestDistance)))
	data = tuple(data)
	printTable(data, printHeader = True)

def printTable(matrix, printHeader = False, printRowId = False):
	widths = collections.OrderedDict()
	for lineNum in xrange(len(matrix)):
		for colNum in xrange(len(matrix[lineNum])):
			if colNum not in widths:
				widths[colNum] = 0
			widths[colNum] = max(widths[colNum], len(matrix[lineNum][colNum]))
	template = "%%-%ds  " * len(widths)
	template.strip()
	template = template % tuple(widths.values())
	if printHeader:
		print template % matrix[0]
		print "-" * (sum([x+2 for x in widths.itervalues()]) - 2)
		matrix = matrix[1:]
	for line in matrix:
		print template % line

if __name__ == '__main__':
	main(sys.argv[1:])