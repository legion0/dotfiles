#!/usr/bin/env python

from subprocess import Popen, PIPE
import sys, os
from re import finditer
from json import dumps

################################################################################
########## Config ##############################################################
################################################################################

symbols = {'ahead of': 'A', 'behind': 'B', 'prehash':':'}

################################################################################
########## End - Config ########################################################
################################################################################

NOT_IN_REPO_STR = 'fatal: Not a git repository'
CWD = os.getcwd()

def _die(msg = None, returncode = -1):
	if msg is not None:
		stream = sys.stdout if returncode == 0 else sys.stderr
		print >> stream, msg
	exit(returncode)
def dump(o):
	print dumps(o, indent=4)

p = Popen(['git', 'symbolic-ref', 'HEAD'], stdout=PIPE, stderr=PIPE)
stdoutdata, stderrdata = p.communicate()
if NOT_IN_REPO_STR in stderrdata:
	_die(None, 0)
#branch = stdoutdata[11:].strip()
branch = stdoutdata[11:-1]

stdoutdata, stderrdata = Popen(['git', 'rev-parse',  '--show-toplevel'], stdout=PIPE, stderr=PIPE).communicate()
if stderrdata != "":
	_die("BAD -2", -2)
gitRoot = stdoutdata.strip()

stdoutdata, stderrdata = Popen(['git','status','--porcelain'], stdout=PIPE, stderr=PIPE).communicate()
if 'fatal' in stderrdata:
	_die("BAD -1", -1)
#print repr(stdoutdata)
data = [x.groupdict() for x in finditer(r"(?P<mode>(?P<m1>.)(?P<m2>.)) (?P<path>.+?)(?: -> (?P<otherpath>.+))?\n", stdoutdata)]
#dump(data)
staged = 0
untracked = 0
modefied = 0
dirty = 0
other = 0
for item in data:
	pathInDir = not os.path.relpath(os.path.join(gitRoot, item["path"]), CWD).startswith("..")
	otherpathInDir = False
	if item["otherpath"] is not None:
		otherpathInDir = not os.path.relpath(os.path.join(gitRoot, item["otherpath"]), CWD).startswith("..")
#	print pathInDir, otherpathInDir
	if item["mode"] == "??":
		if pathInDir:
			untracked += 1
	elif item["m1"] in "MADRC" and item["m2"] in " MD":
		staged += 1
	elif item["m1"] in " MARC" and item["m2"] in "MD":
		if pathInDir:
			modefied += 1
	elif item["m1"] in "DAU" and item["m2"] in "DAU":
		if pathInDir or otherpathInDir:
			dirty += 1
	else:
		other += 1
#print "U%d S%d M%d D%d O%d" % (untracked, staged, modefied, dirty, other)

clean = str(int(untracked + staged + modefied + dirty + other == 0))

remote = ''

if not branch: # not on any branch
	branch = symbols['prehash']+ Popen(['git','rev-parse','--short','HEAD'], stdout=PIPE).communicate()[0][:-1]
else:
	remote_name = Popen(['git','config','branch.%s.remote' % branch], stdout=PIPE).communicate()[0].strip()
	if remote_name:
		merge_name = Popen(['git','config','branch.%s.merge' % branch], stdout=PIPE).communicate()[0].strip()
	else:
		remote_name = "origin"
		merge_name = "refs/heads/%s" % branch

	if remote_name == '.': # local
		remote_ref = merge_name
	else:
		remote_ref = 'refs/remotes/%s/%s' % (remote_name, merge_name[11:])
	revgit = Popen(['git', 'rev-list', '--left-right', '%s...HEAD' % remote_ref],stdout=PIPE, stderr=PIPE)
	revlist = revgit.communicate()[0]
	if revgit.poll(): # fallback to local
		revlist = Popen(['git', 'rev-list', '--left-right', '%s...HEAD' % merge_name],stdout=PIPE, stderr=PIPE).communicate()[0]
	behead = revlist.splitlines()
	ahead = len([x for x in behead if x[0]=='>'])
	behind = len(behead) - ahead
	if behind:
		remote += '%s%s' % (symbols['behind'], behind)
	if ahead:
		remote += '%s%s' % (symbols['ahead of'], ahead)

if remote == "":
	remote = '.'

out = '\n'.join([
	str(branch),
	str(remote),
	str(staged),
	str(dirty),
	str(modefied),
	str(untracked),
	str(other),
	clean])
print(out)
