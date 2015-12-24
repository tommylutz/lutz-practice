
fNum = 54.1
dNum = 51
strNum = '52X'

print "Added together %s"%str(fNum)+str(dNum)+strNum

print "Added together: %f"%(dNum+fNum)

dNum = float(dNum) / 2
print "Num: %f"%(dNum)
raw_input()

print "Float %06.2f, Int %03d, Int as Hex %03x, Str %s" % (fNum, dNum, dNum, strNum)

if isinstance(strNum,str):
	print "True!"
else:
	print "They don't match"

print "Type of dNum: %s" % (type(dNum))
print "Class type of dnum: {0}".format(dNum.__class__)

list = dir(__builtins__)
print list
for element in list:
	print "Element: {elem}".format(elem=element)
	
print "\n".join(list)

jsonStr = """{"foo": "bar", "uuids": [0,1,2,3,4]}"""

import json

obj = json.loads(jsonStr)
print type(obj)
print "Object foo={arg1}".format(arg1=obj['foo'])

print obj

from sys import argv
print "Argv is type %s" % type(argv)


print "Hello world"
x = None
while not type(x) is int:
	print "Type an integer"
	try:
		x = int(raw_input())
	except Exception as ex:
		print "Exception: %s"%repr(ex)
		print type(ex)
		raise ex



raw_input("Press enter to exit")