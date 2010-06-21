import urllib

def isPremium(deviant):
	content = urllib.urlopen('http://%s.deviantart.com/'%deviant).read()
	if content.find('<strong class="f">Premium Member</strong>') != -1:
		return True
	return False


if __name__ == '__main__':
	deviants = 'omega300m K1lgore Mallimaakari catluvr2 Skarbog erroid iakobos miss-mosh LALAax Craniata stereoflow kamilsmala wirestyle Red-Priest-Usada Swezzels Udodelig Pierrebfoto woekan fediaFedia UdonNodu gsphoto sujawoto sekcyjny Mentosik8 One-Vox zihnisinir Knuxtiger4 Kitsunebaka91 NEDxfullMOon nyctopterus'.split()

	premiummembers = []
	for deviant in deviants:
		print('Is %s a leet premium member?...' % (deviant))
		if isPremium(deviant):
			print('Yep!')
			premiummembers.append(deviant)
		else:
			print('No, loser!')
	print premiummembers
