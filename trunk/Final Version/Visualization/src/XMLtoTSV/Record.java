package XMLtoTSV;

import java.util.Hashtable;

public class Record {

	public String filename	= "";
	public String name		= "";
	public Hashtable<String,String> featureValues = new Hashtable<String,String>();
	
	public Record(String filename, String name) {
		this.filename	= filename;
		this.name		= name;
	}
	
}
