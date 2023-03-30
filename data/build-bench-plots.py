import glob, os
import json
import matplotlib.pyplot as plt

abspath = os.path.abspath(__file__)
dname = os.path.dirname(abspath)
os.chdir(dname)

for filename in glob.iglob('bachelor-thesis-info-mirror/artifacts/benchs/*.json'):
	if not os.path.isfile(filename):
		continue
	print(filename)
	with open(filename) as f:
		data = f.read()
	data = json.loads(data)
	labels = []
	totals = []
	times = []
	for k, v in sorted(data.items(), key=lambda x: x[0]):
		labels.append(k)
		totals.append(v['total'])
		times.append(v['times'])

	figsize = [12, 6]

	plt.figure(figsize=figsize)
	#ax = plt.axes()
	#ax.set_facecolor('none')
	plt.yscale('log')
	plt.ylabel('ms (log scale)')
	bp = plt.boxplot(times, labels=labels, whis=(0,100), showmeans=True, meanline=True)
	#plt.gca().set_position([0, 0, 1, 1])
	# plt.show()
	base = os.path.basename(filename).replace('.json', '')
	plt.savefig(f'build/{base}.svg', format='svg')

	plt.figure(figsize=figsize)
	plt.bar(labels, totals, tick_label=labels)
	# plt.show()
	plt.savefig(f'build/{base}.total.svg', format='svg')

