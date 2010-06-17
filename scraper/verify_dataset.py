import sys
import os

import xml.dom.minidom

total = 0
missing = []
missingbig = []
missingsmall = []

def verifyDeviant(folder_name, deviant):
	global total, missing, missingbig, missingsmall
	print('Verifying deviant %s' % (deviant))
	deviant_folder = os.path.join(folder_name, deviant)
	image_folder = os.path.join(deviant_folder, 'full')
	thumbbig_folder = os.path.join(deviant_folder, 'thumbbig')
	thumbsmall_folder = os.path.join(deviant_folder, 'thumbsmall')
	for filename in os.listdir(deviant_folder):
		fullpath = os.path.join(deviant_folder, filename)
		if os.path.isdir(fullpath):
			continue
		dom = xml.dom.minidom.parse(fullpath)
		filename = dom.getElementsByTagName("filename")
		total += 1

		if len(filename) != 1:
			print('%s has no filename or too many filenames' % (fullpath))
			continue
		assert( len(filename[0].childNodes) == 1 )
		image_filename = filename[0].childNodes[0].data
		if os.path.exists(os.path.join(image_folder, image_filename) ) == False:
			missing.append(image_filename)
		if os.path.exists(os.path.join(thumbbig_folder, image_filename) ) == False:
			missingbig.append(image_filename)
		if os.path.exists(os.path.join(thumbsmall_folder, image_filename) ) == False:
			missingsmall.append(image_filename)

def main():
	global total, missing, missingbig, missingsmall
	if len(sys.argv) < 2:
		print('Usage: ./verify_dataset folder_name')
		sys.exit(0)

	folder_name = sys.argv[1]
	
	for name in os.listdir(folder_name):
		verifyDeviant(folder_name, name)

	print('Full images missing list: ')
	for m in missing:
		print '\t%s' % (m)
	print('Thumbbig images missing list: ')
	for m in missingbig:
		print '\t%s' % (m)
	print('Thumbsmall images missing list: ')
	for m in missingsmall:
		print '\t%s' % (m)

	print('%d total images' % (total))
	print('%d full images missing' % (len(missing)))
	print('%d thumb big images missing' % (len(missingbig)))
	print('%d thumb small images missing' % (len(missingsmall)))

if __name__ == '__main__':
	main()

