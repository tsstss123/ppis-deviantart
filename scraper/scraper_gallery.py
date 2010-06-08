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
	def __init__(self, full_folder, thumb150_folder, thumb300W_folder):
		self.full_folder = full_folder
		self.thumb150_folder = thumb150_folder
		self.thumb300W_folder = thumb300W_folder
		self.itemstarted = False
		self.count = 0
		self.stack = []

	def startElement(self, name, attrs):
		self.stack.append(name)
		if name == 'item':
			self.itemstarted = True
			self.count += 1
		elif self.download_full and name == 'media:content':
			doctype = attrs.getValue('medium')
			if doctype != 'image':
				return
			
			self.downloadImageTo(self.full_folder, attrs.getValue('url'))
			
		elif name == 'media:thumbnail':
			if self.download_thumb150 and attrs.getValue('height') == '150':
				self.downloadImageTo(self.thumb150_folder, attrs.getValue('url'))
			elif self.download_thumb300W and attrs.getValue('width') == '300':
				self.downloadImageTo(self.thumb300W_folder, attrs.getValue('url'))
			
	def downloadImageTo(self, folder, url_name):
		filename = os.path.basename(url_name)

		url = urllib.urlopen(url_name)
		f = open(os.path.join(folder, filename), 'wb')
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
		handler = BackEndParser(full_folder, thumb150_folder, thumb300W_folder)
		parser.setContentHandler(handler)
		parser.parse(url)
		
		count = handler.count
		offset += count
	print('Downloaded %d images' % (offset))

if __name__ == '__main__':
	starttime = datetime.now()
	
	parseDeviant('omega300m')
	
	print('[%s] Done!' % (datetime.now() - starttime))
	