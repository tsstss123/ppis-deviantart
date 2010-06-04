import urllib

from sgmllib import SGMLParser
from HTMLParser  import HTMLParser

from datetime import datetime

deviants = set()
todolist = set()

class URLLister(SGMLParser):
    def __init__(self):
        SGMLParser.__init__(self)

        self.friends = []
        
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
        self.a_started = True
        href = [v for k, v in attrs if k=='href']  
        if not href:
            return
        self.lasthref = href
        if not self.specialmember:
            return

        # Get deviant and add to friends list for the deviant we are parsing
        # Add to 'todo' list in case this deviant friend is not parsed yet
        deviant = getDeviantForPage(href[0])
        self.friends.append(deviant)
        if deviant not in deviants:
            todolist.add(deviant)
            
        self.specialmember = False
                
    def end_a(self):
        self.a_started  = False
        
    def handle_data(self, text):
        # What we do in handle data depends on inside which tag we are
        if self.li_started > 0:
            self.li_started += 1
            if self.li_started == 3:
                if text != '~':
                    self.specialmember = True   
        elif self.a_started:
            if text == 'Next Page':
                self.nextpage = self.lasthref[0] 
                        
                
def parseFriends(deviant_page):
    print('[%s] Parsing %s (%d deviants so far, %d in the todo list)....' % (datetime.now()-starttime, deviant_page, len(deviants), len(todolist)))
    page_number = 1
    while deviant_page:
        print( '[%s] Parsing friends page %d...' % (datetime.now()-starttime, page_number) )
        url = urllib.urlopen('%sfriends' % (deviant_page) )
              
        parser = URLLister()
        parser.feed(url.read())
        
        deviant_page = parser.nextpage
        page_number += 1
        parser.reset()

def getPageForDeviant(deviant):
    return 'http://%s.deviantart.com/' % (deviant)
    
def getDeviantForPage(page):
    return page.strip('http://').split('.')[0]
    
if __name__ == '__main__':
    starttime = datetime.now()
    
    # Starting todo list
    # Keep parsing until there are no deviants left.
    todolist = set(['omega300m', 'aru01'])
    
    while len(todolist) > 0:
        deviant = todolist.pop()
        deviants.add(deviant)
        parseFriends(getPageForDeviant(deviant))  

    # Do something cools
    print('%d deviants' % (len(deviants)))


