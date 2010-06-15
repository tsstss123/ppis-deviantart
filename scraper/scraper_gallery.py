import urllib
from sgmllib import SGMLParser
from xml.sax import make_parser, handler

import sys
from datetime import datetime
import os

image_folder = '../images'

class BackEndUrlRetriever(SGMLParser):
	""" Retrieves the backend url from a deviant's gallery page (http://$deviant$.deviantart.com/gallery)"""
	def start_link(self, attrs):
		href = [v for k, v in attrs if k=='href'] 
		rel = [v for k, v in attrs if k=='rel'] 
		if rel[0] == 'alternate':
			assert(self.backend == None)
			self.backend = href[0]
	backend = None
	
lastfilesize = 0
def progressReporter(count, size, total):
	global lastfilesize
	lastfilesize = total
	
class BackEndParser(handler.ContentHandler):
	def __init__(self, deviant):
		global image_folder
		
		self.deviant = deviant
		self.count = 0
		self.totaldownloaded = 0
		self.stack = []
			
		# Item info
		self.itemstarted = False
		self.imagefilename = None
		self.imagecategory = None

		# Create folders for the downloaded images if needed
		deviant_folder = os.path.join(image_folder, deviant)
		if not os.path.exists(deviant_folder):
			os.mkdir(deviant_folder)
		full_folder = os.path.join(deviant_folder, 'full')
		if not os.path.exists(full_folder):
			os.mkdir(full_folder)
		thumb150_folder = os.path.join(deviant_folder, 'thumb150')
		if not os.path.exists(thumb150_folder):
			os.mkdir(thumb150_folder)
		thumb300W_folder = os.path.join(deviant_folder, 'thumb300W')
		if not os.path.exists(thumb300W_folder):
			os.mkdir(thumb300W_folder)
		
		self.deviant_folder = deviant_folder
		self.full_folder = full_folder
		self.thumb150_folder = thumb150_folder
		self.thumb300W_folder = thumb300W_folder

	def startElement(self, name, attrs):
		self.stack.append(name)
		if name == 'item':
			self.itemstarted = True
			self.count += 1

		if self.download_images:
			if self.download_full and name == 'media:content':
				doctype = attrs.getValue('medium')
				if doctype != 'image':
					return

				self.imagefilename = os.path.basename(attrs.getValue('url'))

				self.downloadImageTo(self.full_folder, attrs.getValue('url'))

			elif name == 'media:thumbnail':
				if self.download_thumb150 and attrs.getValue('height') == '150':
					self.downloadImageTo(self.thumb150_folder, attrs.getValue('url'))
				elif self.download_thumb300W and attrs.getValue('width') == '300':
					self.downloadImageTo(self.thumb300W_folder, attrs.getValue('url'))

	def downloadImageTo(self, folder, url_name):
		""" Downloads the image from the url to the specified folder
			Retrieves the image filename from the url """
		filename = os.path.basename(url_name)
		urllib.urlretrieve(url_name, os.path.join(folder, filename), progressReporter)
		self.totaldownloaded += lastfilesize

	def endElement(self, name):
		self.stack.pop()
		if name == 'item':
			# Write away a xml file for this image
			xmlname, ext = os.path.splitext(self.imagefilename)
			xmlname = '%s.xml' % (xmlname)
			fpxml = open(os.path.join(self.deviant_folder, xmlname), 'wb')
			fpxml.write('<?xml version="1.0"?>\n')
			fpxml.write('<!-- Written on %s using Sanders awesome xml thing -->\n' % (datetime.now()) )
			fpxml.write('<root xml_tb_version="3.1" idx="1" type="struct" size="1 1">\n')
			fpxml.write('\t<category idx="1" type="char" size="1 %s">%s</category>\n' % (len(self.imagecategory), self.imagecategory))
			fpxml.write('</root>\n')
			fpxml.close()

			self.itemstarted = False
			
	def characters(self, content):
		if len(self.stack) == 0:
			return
		tag = self.stack[len(self.stack)-1]
		if tag == 'media:category':
			self.imagecategory = content

	def endDocument(self):
		pass

	# Image download settings
	download_images = True
	download_full = True
	download_thumb150 = True
	download_thumb300W = True

def getDeviantPage(deviant):
	return 'http://%s.deviantart.com/' % (deviant)
def getDeviantForPage(page):
	return page.strip('http://').split('.')[0]
	
def parseDeviant(deviant):
	print('[%s] Parsing %s...' % (datetime.now() - starttime, deviant))
	
	# Get page and make a folder for our deviant
	page = getDeviantPage(deviant)
	
	if not os.path.exists(image_folder):
		os.mkdir(image_folder)

	# First retrieve the backend url
	print('\t[%s] Retrieving backend url from gallery...' % (datetime.now() - starttime))
	url = urllib.urlopen('%sgallery' % (page))
	parser = BackEndUrlRetriever()
	parser.feed(url.read())
	backendurl = parser.backend
	
	# Parse all backend pages
	backendurl = backendurl.rstrip('0')
	print('\t[%s] Parsing backend pages...' % (datetime.now() - starttime))
	count = 0
	offset = 0
	total = 0
	started = False
	while not started or count > 0:
		started = True
		print '\t[%s] offset=%d (%d MB downloaded)' % (datetime.now() - starttime, offset, total / 1048576)
		url = urllib.urlopen('%s%d' % (backendurl, offset))
		
		parser = make_parser()
		handler = BackEndParser(deviant)
		parser.setContentHandler(handler)
		parser.parse(url)
		
		count = handler.count
		offset += count
		total += handler.totaldownloaded
	print('\tParsed/Downloaded %d images (%d MB)' % (offset, total / 1048576))
	
def main():
	if len(sys.argv) < 2:
		print('Usage: %s deviant1 deviant2 deviant3 ...' % sys.argv[0])
		return
		
	deviants = sys.argv[1:len(sys.argv)]
	for deviant in deviants:
		parseDeviant(deviant)
	
	print('[%s] Done!' % (datetime.now() - starttime))

if __name__ == '__main__':
	starttime = datetime.now()
	main()
