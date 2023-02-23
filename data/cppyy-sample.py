import timeit
import cppyy

cppyy.cppdef("""
	int id(int a) { return a; }
""")

N = 10**7

def doj(f):
	sum = 0
	for i in range(N):
		sum += f(i)
	return sum

def id(x):
	return x

print('py   ', timeit.timeit(lambda: doj(id), number=10))
print('cppyy', timeit.timeit(lambda: doj(cppyy.gbl.id), number=10))
"""
py    8.905031344000236
cppyy 12.404995038001289
"""
