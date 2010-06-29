Add python to your path

catagory_analyzer
	Prints catagory or sub-catagory counts, globally or per user
	Usage: python category_analyzer.py [options] folder_name
	Options: -u prints per user, -s prints subcatagories
scraper_network
	Scrapes the premium (none ~) deviantART network, ultimately this is saved in Pajek .net work format, 
	also in .arcs and .vert which can be loaded with the loadNetwork function in the projects Network directory.
	Usage python scraper_network
verify_dataset
	Looks if there exists an image for every xml file. Does not check for corrupted images
	Usage: python verify_dataset.py folder_name
scraper_gallery
	Downloads images, xml and thumbnails for the given users, options can be mixed.
	Usage: %s [options] image_folder_path deviant1 deviant2 deviant3
	Usage: %s [options] -f filename image_folder_path
	Options: -i downloads the fullscale images, -t downloads thumbnails, -r removes xml if images fail 
	Option: -f filename, filename has to be a file with one deviantname per line the deviantname has to be in quotes ""