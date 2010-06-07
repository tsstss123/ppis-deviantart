import urllib

from sgmllib import SGMLParser
from HTMLParser  import HTMLParser

import datetime
import pickle
import cProfile 
import pstats

starttime = datetime.datetime.now()

class Deviants( dict ):
	def add(self, deviant):
		super(Deviants,self).__setitem__(deviant, [super(Deviants,self).__len__()+1, set()])
	def deviant_id(self, deviant):
		return dict.__getitem__(self, deviant)[0]
	def add_friend(self, deviant, friend):
		item = dict.__getitem__(self, deviant)
		item[1].add(self.deviant_id(friend))
		
class FriendListParser(SGMLParser):
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
					self.todolist.add(newdeviant)
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
	deviant_page = getDeviantPage(deviant)
	parser = FriendListParser(deviant, deviants, todolist)
	print('[%s] Parsing %s (%d deviants know, %d todo )....' 
% (datetime.datetime.now()-starttime, deviant, len(deviants), len(todolist)))
	
	while deviant_page:
		url = urllib.urlopen('%sfriends' % (deviant_page) )
		parser.feed(url.read())
		deviant_page = parser.nextpage
		parser.reset()

def getDeviantPage(deviant):
	return 'http://%s.deviantart.com/' % (deviant)
def getDeviantForPage(page):
    return page.strip('http://').split('.')[0]
    
def pajek_writer(deviantsandlist, time):
	print 'saving timestamp %d errors %s' %(time, deviantsandlist[2])
	out = open('deviants_%d.pickle' %(time), 'wb')
	pickle.dump(deviantsandlist, out)
	out.close
	deviants = deviantsandlist[0]
	f = open('deviants_%d.net' %(time), 'w')
	f.write('*Arcs %d\n'  %(len(deviants)))
	for (deviant, value) in deviants.iteritems():
		f.write('%d "%s"\n'%(value[0], deviant))
	f.write('*Edges\n' )
	for value in deviants.itervalues():
		for friend in (value[1]):
			f.write('%d %d 1\n' %(value[0], friend))	
	f.close

def start():
	todolist = set(['omega300m'])
	errlist = []
	deviants = Deviants()
	nextsavetime = 0
	for deviant in todolist:
		deviants.add(deviant)
	while (len(todolist) > 0):
		if (datetime.datetime.now()-starttime).seconds > (nextsavetime*300):
			pajek_writer([deviants, todolist, errlist], nextsavetime)
			nextsavetime += 1
		deviant = todolist.pop()
        	try:
			parseFriends(deviant, deviants, todolist)
		except Exception as e:
			print('Exception: %s %s, %s' %(deviant, type(e), e))
            		errlist.append(deviant)
	pajek_writer([deviants, todolist, errlist], -1)
	
if __name__ == '__main__':
	start()
#	cProfile.run('start()', 'prof')
#	p = pstats.Stats('prof')
#	p.sort_stats('cumulative').print_stats(25)
