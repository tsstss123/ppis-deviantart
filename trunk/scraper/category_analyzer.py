""" Simple script do count all categories per user
	Usage: category_analyzer image_folder_path printperuser=True/False printsubcategories=True/False """
import sys
import os

import xml.dom.minidom
from collections import defaultdict
from operator import itemgetter

import getopt

def createSubCategory(depth=6):
	if depth == 0:
		return [0, None] 
	return defaultdict( lambda : [0, createSubCategory(depth-1)] )

totalcategories = defaultdict( lambda : [0, createSubCategory()] )

printsubcategories = False
printperuser = False

def reportDeviant(folder_name, deviant):
	global totalcategories
	deviant_folder = os.path.join(folder_name, deviant)
	usercategories = defaultdict( lambda : [0, createSubCategory()] )
	for filename in os.listdir(deviant_folder):
		fullpath = os.path.join(deviant_folder, filename)
		if os.path.isdir(fullpath):
			continue
		try:
			dom = xml.dom.minidom.parse(fullpath)
		except xml.parsers.expat.ExpatError:
			continue
		
		try:
			category = dom.getElementsByTagName("category")[0].childNodes[0].data
		except:
			continue
	
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

	opt, args = getopt.getopt(sys.argv[1:], 'us')
	
	if len(args) != 1:
		print('Usage: ./category_analyzer [options] folder_name')
		sys.exit(0)

	folder_name = args[0]
	
	for o in opt:
		if o[0] == '-u':
			printperuser = True
		if o[0] == '-s':		
			printsubcategories = True
		
	for name in os.listdir(folder_name):
		reportDeviant(folder_name, name)

	if not printperuser:
		printCategories(totalcategories, '', printsubcategories)

if __name__ == '__main__':
	main()

