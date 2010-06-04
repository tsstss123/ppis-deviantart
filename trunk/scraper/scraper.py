import urllib

from sgmllib import SGMLParser
from HTMLParser  import HTMLParser

import datetime

deviants = set()
todolist = set()

starttime = datetime.datetime.now()

class URLLister(SGMLParser):
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
        global deviants
        self.a_started = True
        href = [v for k, v in attrs if k=='href']  
        if href:
            self.lasthref = href
            if self.specialmember:
                deviant = href[0].strip('http://').split('.')[0]
                if deviant not in deviants:
                    todolist.add(deviant)
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
                        
                
def parseFriends(deviant_page):
    print('[%s] Parsing %s (%d deviants so far, %d in the todo list)....' % (datetime.datetime.now()-starttime, deviant_page, len(deviants), len(todolist)))
    while deviant_page:
        url = urllib.urlopen('%sfriends' % (deviant_page) )
              
        parser = URLLister()
        parser.feed(url.read())
        
        deviant_page = parser.nextpage
        parser.reset()

def getDeviantPage(deviant):
    return 'http://%s.deviantart.com/' % (deviant)
    
if __name__ == '__main__':
    todolist = set(['omega300m', 'aru01'])
    
    while len(todolist) > 0:
        deviant = todolist.pop()
        deviants.add(deviant)
        parseFriends(getDeviantPage(deviant))  

print('%d deviants' % (len(deviants)))


