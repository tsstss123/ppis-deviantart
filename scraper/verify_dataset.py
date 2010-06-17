import sys
import os

import xml.dom.minidom

missing = []
missing300W = []
missing150 = []

def verifyDeviant(folder_name, deviant):
	global missing, missing300W, missing150
	print('Verifying deviant %s' % (deviant))
	deviant_folder = os.path.join(folder_name, deviant)
	image_folder = os.path.join(deviant_folder, 'full')
	thumb300W_folder = os.path.join(deviant_folder, 'thumb300W')
	thumb150_folder = os.path.join(deviant_folder, 'thumb150')
	for filename in os.listdir(deviant_folder):
		fullpath = os.path.join(deviant_folder, filename)
		if os.path.isdir(fullpath):
			continue
		dom = xml.dom.minidom.parse(fullpath)
		filename = dom.getElementsByTagName("filename")
		
		if len(filename) != 1:
			print('%s has no filename or too many filenames' % (fullpath))
			continue
		assert( len(filename[0].childNodes) == 1 )
		image_filename = filename[0].childNodes[0].data
		if os.path.exists(os.path.join(image_folder, image_filename) ) == False:
			missing.append(image_filename)
		if os.path.exists(os.path.join(thumb300W_folder, image_filename) ) == False:
			missing300W.append(image_filename)
		if os.path.exists(os.path.join(thumb150_folder, image_filename) ) == False:
			missing150.append(image_filename)

def main():
	if len(sys.argv) < 2:
		print('Usage: ./verify_dataset folder_name')
		sys.exit(0)

	folder_name = sys.argv[1]
	
	for name in os.listdir(folder_name):
		verifyDeviant(folder_name, name)

	print('Full images missing list: ')
	for m in missing:
		print '\t%s' % (m)
	print('Thumb300W images missing list: ')
	for m in missing300W:
		print '\t%s' % (m)
	print('Thumb150 images missing list: ')
	for m in missing150:
		print '\t%s' % (m)

	print('%d full images missing' % (len(missing)))
	print('%d thumb 300W images missing' % (len(missing300W)))
	print('%d thumb 150 images missing' % (len(missing150)))

if __name__ == '__main__':
	main()

