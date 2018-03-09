# -*- coding: utf-8 -*-

import string
import re

file=open('hwk1_p4.txt','r')
newfile=open('hwk1_p4_result.txt','w')
teststr=file.read()		
'''teststr='"aaa.a. a." 2.2 "ab" aaa.'
print teststr'''

def punc_split(punc_t,teststring):
	
	spacetype=' '
	strlen=len(teststring)
	
	i=-1
	while teststring.find(punc_t,i+1)!=-1:
		dotpos=teststring.find(punc_t,i+1)
		
		targstr=teststring[max((dotpos-1),0):(dotpos+2)]
		'''print targstr'''
		
		if re.search(('[rf]'+punc_t+'\s'),targstr) and (re.search(r'.*(Dr)|(Prof)$',teststring[(dotpos-4):dotpos])):
			pass
			
		elif (re.search(r'^([\s]?[\'\"]\w)',targstr)):
		    teststring=teststring[:dotpos+1]+spacetype+teststring[dotpos+1:]
			
		elif re.search(('\w'+punc_t+'[\W]?$'),targstr) or re.search('[\.\,\?\!\:\'\"a-zA-Z][\'\"][\sa-zA-Z\Z]',targstr):
			teststring=teststring[:dotpos]+spacetype+teststring[dotpos:]
			dotpos=dotpos+1
		
		else:
			pass
		
		i=dotpos
		
	return teststring

punclist=',.?!:"\''
for p in punclist:
	teststr=punc_split(p,teststr)

'''print teststr'''

newfile.write(teststr)
file.close()
newfile.close()
