import urllib
from sgmllib import SGMLParser
from xml.sax import make_parser, handler

import sys
from datetime import datetime
import os
import getopt

lastfilesize = 0
def progressReporter(count, size, total):
	global lastfilesize
	lastfilesize = total
	
class ErrorHandler:
    def error(self, exception):
        "Handle a recoverable error."
        raise exception

    def fatalError(self, exception):
        "Handle a non-recoverable error."
        #raise exception
        pass

    def warning(self, exception):
        "Handle a warning."
        print exception

class GalleryBackEndParser(handler.ContentHandler):
	""" Downloads images and info from the backend url of deviantART.  
		Set downloadfull to False to not download the full images
		Set downloadthumbs to False to not download the thumbnails (2 for each image) 
		Set removefailed to True in case you want the xml files removed when one of the images
		fails to download."""
	def __init__(self, deviant, imagefolder, downloadfullimages, downloadthumbnails, removefailed):
		self.deviant = deviant
		self.count = 0
		self.totaldownloaded = 0
		self.stack = []

		self.downloadfullimages = downloadfullimages
		self.downloadthumbnails = downloadthumbnails
		self.removefailed = removefailed
			
		# Item info
		self.itemstarted = False
		self.xmlcontent = []
		self.imagefilename = None

		# Create folders for the downloaded images if needed
		deviant_folder = os.path.join(imagefolder, deviant)
		if not os.path.exists(deviant_folder):
			os.mkdir(deviant_folder)
		full_folder = os.path.join(deviant_folder, 'full')
		if not os.path.exists(full_folder):
			os.mkdir(full_folder)
		thumbbig_folder = os.path.join(deviant_folder, 'thumbbig')
		if not os.path.exists(thumbbig_folder):
			os.mkdir(thumbbig_folder)
		thumbsmall_folder = os.path.join(deviant_folder, 'thumbsmall')
		if not os.path.exists(thumbsmall_folder):
			os.mkdir(thumbsmall_folder)
		
		self.deviant_folder = deviant_folder
		self.full_folder = full_folder
		self.thumbbig_folder = thumbbig_folder
		self.thumbsmall_folder = thumbsmall_folder

	def startElement(self, name, attrs):
		self.stack.append(name)
		if name == 'item':
			# Start a new xml file for this image
			self.xmlcontent = []
			self.thumbnails = []

			self.itemstarted = True
			self.skipitem = False
			self.count += 1
		elif name == 'media:content':
			doctype = attrs.getValue('medium')
			if doctype != 'image':
				return

			self.imagefilename = os.path.basename(attrs.getValue('url'))
			self.xmlcontent.append('\t<filename idx="1" type="char" size="1 %s">%s</filename>\n' % (len(self.imagefilename), self.imagefilename))

			if self.downloadfullimages:
				self.downloadImageTo(self.full_folder, attrs.getValue('url'))
		elif name == 'media:thumbnail':
			self.thumbnails.append( (attrs.getValue('url'), int(attrs.getValue('width')), int(attrs.getValue('height'))) )

	def downloadImageTo(self, folder, url_name):
		""" Downloads the image from the url to the specified folder
			Retrieves the image filename from the url """
		filename = os.path.basename(url_name)
		fullpath = os.path.join(folder, filename)
		if os.path.exists(fullpath) == True:
			return
		tries = 2
		while 1:
			try:
				urllib.urlretrieve(url_name, fullpath, progressReporter)
				break
			except urllib.ContentTooShortError:
				print('ContentTooShortError: retrying %s...' % (url_name))
				tries -= 1
				if tries == 0:
					print('Failed to retrieve "%s", removing corrupt image...' % (url_name))
					os.remove(fullpath)
					if self.removefailed:
						self.skipitem = True
					break
		self.totaldownloaded += lastfilesize

	def endElement(self, name):
		self.stack.pop()
		if name == 'item':	
			if self.imagefilename:
				# Download thumbs
				if self.downloadthumbnails:
					if len(self.thumbnails) == 1:
							self.downloadImageTo(self.thumbbig_folder, self.thumbnails[0][0])
							self.downloadImageTo(self.thumbsmall_folder, self.thumbnails[0][0])
					elif len(self.thumbnails) == 2:
						if self.thumbnails[0][1]*self.thumbnails[0][2] > self.thumbnails[1][1]*self.thumbnails[1][2]:
							self.downloadImageTo(self.thumbbig_folder, self.thumbnails[0][0])
							self.downloadImageTo(self.thumbsmall_folder, self.thumbnails[1][0])
						else:
							self.downloadImageTo(self.thumbbig_folder, self.thumbnails[1][0])
							self.downloadImageTo(self.thumbsmall_folder, self.thumbnails[0][0])
					else:
						assert(0)

				if self.skipitem:
					# Remove unused images. This happens because one of the images failed to download
					# In that case remove all others. Caused by dead links?
					fullpath = os.path.join(self.full_folder, self.imagefilename)
					if os.path.exists(fullpath):
						os.remove(fullpath)
					fullpath = os.path.join(self.thumbbig_folder, self.imagefilename)
					if os.path.exists(fullpath):
						os.remove(fullpath)
					fullpath = os.path.join(self.thumbsmall_folder, self.imagefilename)
					if os.path.exists(fullpath):
						os.remove(fullpath)
				else:
					# Write xml file
					xmlname, ext = os.path.splitext(self.imagefilename)
					xmlname = '%s.xml' % (xmlname)
					fpxml = open(os.path.join(self.deviant_folder, xmlname), 'wb')
					fpxml.write('<?xml version="1.0"?>\n')
					fpxml.write('<!-- Written on %s using Sanders awesome xml thing -->\n' % (datetime.now()) )
					fpxml.write('<root xml_tb_version="3.1" idx="1" type="struct" size="1 1">\n')

					for line in self.xmlcontent:
						fpxml.write( line.encode('UTF-8') )

					fpxml.write('</root>\n')
					fpxml.close()

			self.imagefilename = None
			self.itemstarted = False
			
	def characters(self, content):
		if len(self.stack) == 0:
			return
		tag = self.stack[len(self.stack)-1]
		if tag == 'media:category':
			self.xmlcontent.append('\t<category idx="1" type="char" size="1 %s">%s</category>\n' % (len(content), content))
		elif tag == 'media:title':
			self.xmlcontent.append('\t<title idx="1" type="char" size="1 %s">%s</title>\n' % (len(content), content))
		elif tag == 'guid':
			self.xmlcontent.append('\t<guid idx="1" type="char" size="1 %s">%s</guid>\n' % (len(content), content))

	def endDocument(self):
		pass

def getDeviantPage(deviant):
	return 'http://%s.deviantart.com/' % (deviant)
def getDeviantForPage(page):
	return page.split('http://')[1].split('.')[0]
	
def parseDeviant(deviant, imagefolder, downloadfullimages, downloadthumbnails, removefailed):
	print('[%s] Parsing %s...' % (datetime.now() - starttime, deviant))

	# Parse all backend pages
	# Keep increasing the offset until there are no more new items parsed
	backendurl = 'http://backend.deviantart.com/rss.xml?q=gallery:%s&offset=' % (deviant)
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
		handler = GalleryBackEndParser(deviant, imagefolder, 
						downloadfullimages, downloadthumbnails, removefailed)
		parser.setContentHandler(handler)
		parser._err_handler = ErrorHandler()
		parser.parse(url)
		
		count = handler.count
		offset += count
		total += handler.totaldownloaded
	print('\tParsed/Downloaded %d images (%d MB)' % (offset, total / 1048576))

def load_deviants(filename):
	file = open(filename, 'r')
	deviant_list = file.readlines()
	file.close()
	return [deviant.strip('"\n \t\r') for deviant in deviant_list ]

def main():
	downloadfullimages = False
	downloadthumbnails = False
	removefailed = False

	opt, args = getopt.getopt(sys.argv[1:], 'f:itr')

	if len(args) < 1:
		print('Usage: %s [options] image_folder_path deviant1 deviant2 deviant3 ...\n\t or %s [options]-f filename image_folder_path' % (sys.argv[0],sys.argv[0]))
		return
		
	deviants = None

	for o, v in opt:
		if o == '-i':
			downloadfullimages = True
		elif o == '-t':
			downloadthumbnails = True
		elif o == '-r':
			removefailed = True
		elif o == '-f':
			deviants = load_deviants(v)
			removefailed = True
	
	imagefolder = args[0]
	if not deviants:
		deviants = args[1:]
	
	if not os.path.exists(imagefolder):
		os.mkdir(imagefolder)

 	print('Downloading full images: %s' % (downloadfullimages))
	print('Downloading thumbnails: %s' % (downloadthumbnails))

	# Parse all deviants
	for deviant in deviants:
		parseDeviant(deviant, imagefolder, downloadfullimages, downloadthumbnails, removefailed)

	print('[%s] Done!' % (datetime.now() - starttime))

if __name__ == '__main__':
	starttime = datetime.now()
	main()

