""" Simple script do count all categories per user
	Usage: category_analyzer image_folder_path printperuser=True/False printsubcategories=True/False """
import sys
import os

import xml.dom.minidom
from collections import defaultdict
from operator import itemgetter

def createSubCategory(depth=6):
	if depth == 0:
		return [0, None] 
	return defaultdict( lambda : [0, createSubCategory(depth-1)] )

totalcategories = defaultdict( lambda : [0, createSubCategory()] )

printsubcategories = True
printperuser = False

def reportDeviant(folder_name, deviant):
	global totalcategories
	#print('Analyzing deviant %s' % (deviant))
	deviant_folder = os.path.join(folder_name, deviant)
	usercategories = defaultdict( lambda : [0, createSubCategory()] )
	for filename in os.listdir(deviant_folder):
		fullpath = os.path.join(deviant_folder, filename)
		if os.path.isdir(fullpath):
			continue
		dom = xml.dom.minidom.parse(fullpath)
		category = dom.getElementsByTagName("category")[0].childNodes[0].data
		
		addToCategories(totalcategories, category)
		addToCategories(usercategories, category)

	if printperuser:
		print('Analyzing deviant %s' % (deviant))
		printCategories(usercategories, '\t', printsubcategories)
		

def addToCategories(categoriesdict, category):
	category = category.split('/')
	for c in category:
		categoriesdict[c][0] += 1
		categoriesdict = categoriesdict[c][1]

def printCategories(categories, indent='\t', printsub=True):
	if not categories:
		return
	categories = sorted(categories.iteritems(), key=itemgetter(1), reverse=True)
	for k, v in categories:
		print '%s%s: %d' % (indent, k, v[0])
		if printsub:
			printCategories(v[1], indent = '%s\t' % (indent))

def main():
	global totalcategories, printsubcategories, printperuser
	if len(sys.argv) < 2:
		print('Usage: ./category_analyzer folder_name')
		sys.exit(0)

	folder_name = sys.argv[1]
	
	if len(sys.argv) > 2:
		printperuser = eval(sys.argv[2])
	if len(sys.argv) > 3:
		printsubcategories = eval(sys.argv[3])
		
	for name in os.listdir(folder_name):
		reportDeviant(folder_name, name)

	if not printperuser:
		printCategories(totalcategories, '', printsubcategories)

if __name__ == '__main__':
	main()

