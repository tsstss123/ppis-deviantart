import urllib

from sgmllib import SGMLParser
from HTMLParser  import HTMLParser

import datetime
import cPickle
import cProfile 
import pstats
import os

starttime = datetime.datetime.now()

class Deviants( dict ):
	""" dictionary class to store a list of deviants """
	def add(self, deviant):
		super(Deviants,self).__setitem__(deviant, [super(Deviants,self).__len__()+1, set()])
	def deviant_id(self, deviant):
		return dict.__getitem__(self, deviant)[0]
	def add_friend(self, deviant, friend):
		item = dict.__getitem__(self, deviant)
		item[1].add(self.deviant_id(friend))

class FriendListParser(SGMLParser):
	""" main html parser deviants are between <li></li>, filter on ~"""
	def __init__(self, deviant, deviants, todolist):
		SGMLParser.__init__(self, 0)
		self.deviant = deviant
		self.deviants = deviants
		self.todolist = todolist

	def reset(self):                              
		SGMLParser.reset(self)
		
		self.specialmember = False
		self.nextpage = None
		self.lasthref = None
		
		self.stack = []
		
	def handle_starttag(self, tag, method, attributes):
		SGMLParser.handle_starttag(self, tag, method, attributes)
		self.stack.append(tag)
		
	def handle_endtag(self, tag, method):
		SGMLParser.handle_endtag(self, tag, method)
		self.stack.pop()

	# Defining the following methods will make sure 
	# that handle_starttag and endtag gets called.
	def start_li(self, attrs): pass
	def end_li(self): pass
	def start_span(self, attrs): pass
	def end_span(self): pass
		
	def start_a(self, attrs):     
		href = [v for k, v in attrs if k=='href']  
		if href:
			self.lasthref = href
			if self.specialmember:
				newdeviant = getDeviantForPage(href[0])
				if newdeviant not in self.deviants.keys():
					self.deviants.add(newdeviant)
					self.todolist.append(newdeviant)
				self.deviants.add_friend(self.deviant, newdeviant)
				self.specialmember = False
				
	def end_a(self):
		pass
		
	def handle_data(self, text):
		if len(self.stack) == 0:
			return	# No tags we want to catch, so don't care about the data
			
		tag = self.stack[len(self.stack)-1]
		if tag == 'li':
			if text != '~':
				self.specialmember = True 
		elif tag == 'a':
			if text == 'Next Page':
				self.nextpage = self.lasthref[0] 

def parseFriends(deviant, deviants, todolist):
	""" retrieve consecutive friends lists for a deviant and parse"""
	deviant_page = getDeviantPage(deviant)
	parser = FriendListParser(deviant, deviants, todolist)
	print('[%s] %s (%d deviants known, %d todo )....' 
% (datetime.datetime.now()-starttime, deviant, len(deviants), len(todolist)))
	
	while deviant_page:
		url = urllib.urlopen('%sfriends' % (deviant_page) )
		parser.feed(url.read())
		deviant_page = parser.nextpage
		parser.reset()

def getDeviantPage(deviant):
	""" does as the name indicates """
	return 'http://%s.deviantart.com/' % (deviant)
def getDeviantForPage(page):
	""" removes http and deviantart.com"""
	return page.split('http://', 1)[1].split('.')[0]
	
def pickle_writer(deviantsandlist, time):
	""" write a python pickle style file to continue if the scraper encounters problems """
	print 'saving timestamp %d, found errors %s' %(time, deviantsandlist[2])
	delete = time-2
	try :
		os.remove('deviants_%d.pickle' %(delete))
	except Exception as e:
		print('File not found: deviants_%d.pickle' %(delete))
				
	out = open('deviants_%d.pickle' %(time), 'wb')
	cPickle.dump(deviantsandlist, out)
	out.close
	
def pajek_writer(deviants, time):
	""" write a pajek style network file """
	print 'saving for pajek timestamp %d' %(time)
	#open as binary so both in windows and unix we get the windows output
	f = open('deviants_%d.net' %(time), 'wb')
	f.write('*Vertices %d\r\n'  %(len(deviants)))
	for (deviant, value) in deviants.iteritems():
		f.write('%d "%s"\r\n'%(value[0], deviant))
	f.write('*Arcs\r\n' )
	for value in deviants.itervalues():
		for friend in (value[1]):
			f.write('%d %d 1\r\n' %(value[0], friend))	
	f.close
	
def matlab_writer(deviants, time):
	""" write 2 files, *.vert, *.arcs used for loading in matlab with loadNetwork """
	print 'saving for matlab timestamp %d' %(time)
	#open as binary so both in windows and unix we get the windows output
	f = open('deviants_%d.vert' %(time), 'wb')
	for (deviant, value) in deviants.iteritems():
		f.write('%d,%s\r\n'%(value[0], deviant))
	f.close
	#open as binary so both in windows and unix we get the windows output
	f = open('deviants_%d.arcs' %(time), 'wb')
	for value in deviants.itervalues():
		for friend in (value[1]):
			f.write('%d,%d,1\r\n' %(value[0], friend))	
	f.close
	
	
def load_data():
	""" load a python pickle file to recover a session """
	mx = -1
	mxf = ''
	for file in os.listdir('.'):
		end = file.find('.pickle')
		if end > 0:
			start = file[:end].find('_')+1
			if int(file[start:end])> mx:
				mx = int(file[start:end])
				mxf = file
	if mx > 0 : 
		print('Loading pickle from file: %s' %(mxf))
		f = open(mxf, 'rb')
		data = cPickle.load(f)
		f.close()
		return data
	else :
		print('No pickles found, will load default values')
		return defaultvalues()
		
def defaultvalues():
	""" some default values """
	deviants = Deviants()
	todolist = ['omega300m']
	errlist = []
	prevsavetime = 0
	for deviant in todolist:
		deviants.add(deviant)
	return [deviants, todolist, errlist, prevsavetime]
	
def main():
	""" starts the main program, load pickle files if available, ends and writes network files when the network has been scraped"""
	data = load_data()
	deviants = data[0]
	todolist = data[1]
	errlist = data[2]
	prevsavetime = data[3]

	nextsavetime = 1
	saveinterval = 30

	if len(todolist) == 0 and len(errlist) > 0 and os.name == 'nt':
		print 'Redoing errorlist'
		todolist = errlist
		errlist = []

	while (len(todolist) > 0):
		if (datetime.datetime.now()-starttime).seconds > (nextsavetime*saveinterval):
			pickle_writer([deviants, todolist, errlist, prevsavetime+nextsavetime], prevsavetime+nextsavetime)
			nextsavetime += 1
		deviant = todolist.pop(0)
		try:
			parseFriends(deviant, deviants, todolist)
		except Exception as e:
			print('Exception: %s %s, %s' %(deviant, type(e), e))
			errlist.append(deviant)
	pickle_writer([deviants, todolist, errlist, nextsavetime+prevsavetime+1], prevsavetime+nextsavetime)
	pajek_writer(deviants, prevsavetime+nextsavetime)
	matlab_writer(deviants, prevsavetime+nextsavetime)

if __name__ == '__main__':
	main()
#	cProfile.run('main()', 'prof')
#	p = pstats.Stats('prof')
#	p.sort_stats('cumulative').print_stats(25)
