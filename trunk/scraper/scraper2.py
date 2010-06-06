import urllib

from sgmllib import SGMLParser
from HTMLParser  import HTMLParser

import datetime
import pickle

todolist = set()

starttime = datetime.datetime.now()

class Deviants( dict ):
	def add(self, deviant):
		super(Deviants,self).__setitem__(deviant, [super(Deviants,self).__len__()+1, set()])
	def deviant_id(self, deviant):
		return dict.__getitem__(self, deviant)[0]
	def add_friend(self, deviant, friend):
		item = dict.__getitem__(self, deviant)
		item[1].add(self.deviant_id(friend))
		
class URLLister(SGMLParser):
	def __init__(self, deviantt, deviantss):
		SGMLParser.__init__(self, 0)
		self.deviant = deviantt
		self.deviants = deviantss
		
	def reset(self):                              
		SGMLParser.reset(self)
		
		self.li_started = False
		self.a_started = False
		self.specialmember = False
		self.nextpage = None
		self.lasthref = None

	def start_li(self, attrs):
		self.li_started = 1
		
	def end_li(self):
		self.li_started = 0
		
	def start_a(self, attrs):     
		global todolist
		self.a_started = True
		href = [v for k, v in attrs if k=='href']  
		if href:
			self.lasthref = href
			if self.specialmember:
				newdeviant = href[0].strip('http://').split('.')[0]
				if newdeviant not in self.deviants.keys():
					deviants.add(newdeviant)
					todolist.add(newdeviant)
				deviants.add_friend(deviant, newdeviant)
				self.specialmember = False
				
	def end_a(self):
		self.a_started  = False
		
	def handle_data(self, text):
		if self.li_started > 0:
			self.li_started += 1
			if self.li_started == 3:
				if text != '~':
					self.specialmember = True   
		if self.a_started:
			if text == 'Next Page':
				self.nextpage = self.lasthref[0] 
						
				
def parseFriends(deviant, deviants):
	deviant_page = getDeviantPage(deviant)
	parser = URLLister(deviant, deviants)
	print('[%s] Parsing %s (%d deviants so far, %d in the todo list)....' % (datetime.datetime.now()-starttime, deviant_page, len(deviants), len(todolist)))
	
	while deviant_page:
		url = urllib.urlopen('%sfriends' % (deviant_page) )
		parser.feed(url.read())
		deviant_page = parser.nextpage
		parser.reset()

def getDeviantPage(deviant):
	return 'http://%s.deviantart.com/' % (deviant)

def pajek_writer(deviants):
	out = open('deviants.pickle', 'wb')
	pickle.dump(deviants, out)
	out.close
	f = open('deviants.net', 'w')
	f.write('*Vertices %d\n'  %(len(deviants)))
	for (deviant, value) in deviants.iteritems():
		f.write('%d "%s"\n'%(value[0], deviant))
	f.write('*Edges\n' )
	for value in deviants.itervalues():
		for friend in (value[1]):
			f.write('%d %d 1\n' %(value[0], friend))	
	f.close
	
if __name__ == '__main__':
	todolist = set(['omega300m', 'aru01'])
	deviants = Deviants()
	
	for deviant in todolist:
		deviants.add(deviant)
	print deviants	
	while (len(todolist) > 0) and (len(deviants)<100) :
		deviant = todolist.pop()
		parseFriends(deviant, deviants)
	pajek_writer(deviants)
