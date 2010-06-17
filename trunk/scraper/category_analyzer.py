import sys
import os

import xml.dom.minidom
from collections import defaultdict
from operator import itemgetter

def reportDeviant(folder_name, deviant):
	print('Analyzing deviant %s' % (deviant))
	deviant_folder = os.path.join(folder_name, deviant)
	categories = defaultdict( lambda : 0 )
	for filename in os.listdir(deviant_folder):
		fullpath = os.path.join(deviant_folder, filename)
		if os.path.isdir(fullpath):
			continue
		dom = xml.dom.minidom.parse(fullpath)
		category = dom.getElementsByTagName("category")[0].childNodes[0].data
		category = category.split('/')[0]
		categories[category] += 1
	categories = sorted(categories.iteritems(), key=itemgetter(1), reverse=True)
	for v in categories:
		print('\t%s: \t%d' % (v[0], v[1]))

def main():
	if len(sys.argv) < 2:
		print('Usage: ./category_analyzer folder_name')
		sys.exit(0)

	folder_name = sys.argv[1]
	
	for name in os.listdir(folder_name):
		reportDeviant(folder_name, name)


if __name__ == '__main__':
	main()

