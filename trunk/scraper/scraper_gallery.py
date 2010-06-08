import urllib
from sgmllib import SGMLParser
from xml.sax import make_parser, handler

from datetime import datetime
import os

image_folder = 'images'

class BackEndUrlRetriever(SGMLParser):
	""" Retrieves the backend url from a deviant's gallery page (http://$deviant$.deviantart.com/gallery)"""
	def start_link(self, attrs):
		href = [v for k, v in attrs if k=='href'] 
		rel = [v for k, v in attrs if k=='rel'] 
		if rel[0] == 'alternate':
			assert(self.backend == None)
			self.backend = href[0]
	backend = None
	
class BackEndParser(handler.ContentHandler):
	def __init__(self, image_folder):
		self.image_folder = image_folder
		self.itemstarted = False
		self.count = 0
		self.stack = []

	def startElement(self, name, attrs):
		self.stack.append(name)
		if name == 'item':
			self.itemstarted = True
			self.count += 1
		elif name == 'media:content':
			doctype = attrs.getValue('medium')
			if doctype != 'image':
				return
			
			url_name = attrs.getValue('url')
			path = os.path.basename(url_name)
			
			url = urllib.urlopen(url_name)

			f = open(os.path.join(self.image_folder, path), 'wb')
			f.write(url.read())
			f.close()
			
	def endElement(self, name):
		self.stack.pop()
		if name == 'item':
			self.itemstarted = False
			
	def characters(self, content):
		if len(self.stack) == 0:
			return
		tag = self.stack[len(self.stack)-1]
	
	def endDocument(self):
		pass


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
	deviant_folder = os.path.join(image_folder, deviant)
	if not os.path.exists(deviant_folder):
		os.mkdir(deviant_folder)
	
	# First retrieve the backend url
	print('[%s] Retrieving backend url from gallery...' % (datetime.now() - starttime))
	url = urllib.urlopen('%sgallery' % (page))
	parser = BackEndUrlRetriever()
	parser.feed(url.read())
	backendurl = parser.backend
	
	# Parse all backend pages
	backendurl = backendurl.rstrip('0')
	print('[%s] Parsing backend pages...' % (datetime.now() - starttime))
	count = 0
	offset = 0
	while offset == 0 or count > 0:
		print '[%s] %s%d' % (datetime.now() - starttime, backendurl, offset)
		url = urllib.urlopen('%s%d' % (backendurl, offset))
		
		parser = make_parser()
		handler = BackEndParser(deviant_folder)
		parser.setContentHandler(handler)
		parser.parse(url)
		
		count = handler.count
		offset += count
	print('Downloaded %d images' % (offset))

if __name__ == '__main__':
	starttime = datetime.now()
	
	parseDeviant('omega300m')
	
	print('[%s] Done!' % (datetime.now() - starttime))
	