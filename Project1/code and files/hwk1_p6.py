# -*- coding: utf-8 -*-

import string
import re

file=open('hwk1_p4_result.txt','r')

testlist=file.read()
num=re.split(r'\s*',testlist)

while num:
	
	numstr=min(num)
	times=num.count(numstr)
	
	print numstr,times
	
	while numstr in num: num.remove(numstr)