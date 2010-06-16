import urllib
from sgmllib import SGMLParser
from xml.sax import make_parser, handler

import sys
from datetime import datetime
import os

image_folder = '../images'
	
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
		self.xmlcontent = []
		self.imagefilename = None

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
			# Start a new xml file for this image
			self.xmlcontent = []

			self.itemstarted = True
			self.count += 1

		if name == 'media:content':
			doctype = attrs.getValue('medium')
			if doctype != 'image':
				return

			self.imagefilename = os.path.basename(attrs.getValue('url'))
			self.xmlcontent.append('\t<filename idx="1" type="char" size="1 %s">%s</filename>\n' % (len(self.imagefilename), self.imagefilename))

			if self.download_full:
				self.downloadImageTo(self.full_folder, attrs.getValue('url'))

		elif name == 'media:thumbnail':
			if self.download_thumb150 and attrs.getValue('height') == '150':
				self.downloadImageTo(self.thumb150_folder, attrs.getValue('url'))
			elif self.download_thumb300W and attrs.getValue('width') == '300':
				self.downloadImageTo(self.thumb300W_folder, attrs.getValue('url'))

	def downloadImageTo(self, folder, url_name):
		""" Downloads the image from the url to the specified folder
			Retrieves the image filename from the url """
		if not self.download_images:
			return
		filename = os.path.basename(url_name)
		tries = 3
		while 1:
			try:
				urllib.urlretrieve(url_name, os.path.join(folder, filename), progressReporter)
				break
			except ContentTooShortError:
				tries -= 1
				if tries == 0:
					print('Failed to retrieve "%s"' % (url_name))
					break
		self.totaldownloaded += lastfilesize

	def endElement(self, name):
		self.stack.pop()
		if name == 'item':	
			# Write xml file
			xmlname, ext = os.path.splitext(self.imagefilename)
			xmlname = '%s.xml' % (xmlname)
			fpxml = open(os.path.join(self.deviant_folder, xmlname), 'wb')
			fpxml.write('<?xml version="1.0"?>\n')
			fpxml.write('<!-- Written on %s using Sanders awesome xml thing -->\n' % (datetime.now()) )
			fpxml.write('<root xml_tb_version="3.1" idx="1" type="struct" size="1 1">\n')

			for line in self.xmlcontent:
				fpxml.write( line )

			fpxml.write('</root>\n')
			fpxml.close()

			self.itemstarted = False
			
	def characters(self, content):
		if len(self.stack) == 0:
			return
		tag = self.stack[len(self.stack)-1]
		if tag == 'media:category':
			self.xmlcontent.append('\t<category idx="1" type="char" size="1 %s">%s</category>\n' % (len(content), content))
		elif tag == 'media:title':
			self.xmlcontent.append('\t<title idx="1" type="char" size="1 %s">%s</title>\n' % (len(content), content))

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
	
	# make a folder for our deviant
	if not os.path.exists(image_folder):
		os.mkdir(image_folder)

	# Parse all backend pages
	backendurl = 'http://backend.deviantart.com/rss.xml?q=gallery:%s&offset=' % (deviant)
	print('\t[%s] Parsing backend pages...' % (datetime.now() - starttime))
	count = 0
	offset = 0
	total = 0
	started = False
	while not started or count > 0:
		started = True
		print '\t[%s] offset=%d (%d MB downloaded)' % (datetime.now() - starttime, offset, total / 1048576)
		print '%s%d' % (backendurl, offset)
		url = urllib.urlopen('%s%d' % (backendurl, offset))
		print url
		
		parser = make_parser()
		handler = BackEndParser(deviant)
		parser.setContentHandler(handler)
		parser.parse(url)
		
		count = handler.count
		offset += count
		total += handler.totaldownloaded
	print('\tParsed/Downloaded %d images (%d MB)' % (offset, total / 1048576))
	
def main():
	global image_folder
	if len(sys.argv) < 3:
		print('Usage: %s image_folder deviant1 deviant2 deviant3 ...' % sys.argv[0])
		return
		
        image_folder = sys.argv[1]
	deviants = sys.argv[2:len(sys.argv)]
	for deviant in deviants:
		parseDeviant(deviant)
	
	print('[%s] Done!' % (datetime.now() - starttime))

if __name__ == '__main__':
	starttime = datetime.now()
	main()
