import re

testlist = raw_input()
num = re.split(r'\s*',testlist.strip())
num = map(int,num)
while num:
	
	numstr = min(num)
	times = num.count(numstr)
	
	print numstr, times
	
	while numstr in num: num.remove(numstr)