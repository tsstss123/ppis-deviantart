package Databases;

import java.io.File;

public class DB {

	public File file;
	public boolean initialized		= false;
	public boolean firstLine		= true;
	
	
	public DB(File file) {
		this.file = file;		
	}
	
}
