package XMLtoTSV;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Hashtable;
import java.util.Vector;

import java.util.Iterator;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;

import org.w3c.dom.Document;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;

public class XMLtoTSV {
	
	public final String spacer				= "\t";

	public String dir;
	public String classNode;
	public boolean firstFile				= true;
	public File sourceDir;
	public File outputFile;
	public BufferedWriter out;

	public Document dom;
	
	public Hashtable<String,Integer> features	= new Hashtable<String,Integer>();
	public Vector<String> sortedFeatures;
	public ArrayList<Record> records			= new ArrayList<Record>();


	public XMLtoTSV(String dir, String classNode) {
		this.dir		= dir;
		this.classNode	= classNode;
		
		// source dir
		sourceDir	= new File(dir + "features/");
		outputFile	= new File(dir + "features.tsv");


		// output file
		try {
		    FileWriter fstream = new FileWriter(outputFile);
		    out = new BufferedWriter(fstream);
		    
			listAllFiles();
			
			// sort
			sortedFeatures = new Vector<String>(features.keySet());
		    Collections.sort(sortedFeatures);

			writeHeader();
			writeRecords();
			out.close();

		} catch (Exception e) {
			System.err.println("Error: " + e.getMessage());
		}

		System.out.println("Completed all XML files from " + dir + "xml/");
	}
	
	private void listAllFiles() {
	    File[] listOfFiles = sourceDir.listFiles();
	    String filename;
	    int dotPos;

	    for (int i = 0; i < listOfFiles.length; i++) {
	    	if (!listOfFiles[i].isFile())
	    		continue;

	    	filename = listOfFiles[i].getName();
    		dotPos = filename.lastIndexOf(".");
            String extension = filename.substring(dotPos+1);

            if (extension.equals("xml"))
            	parseXMLFile(listOfFiles[i]);
	    }
	}

	private void parseXMLFile(File file) {
		DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();

		try {
			DocumentBuilder db = dbf.newDocumentBuilder();
			
			try {
				dom = db.parse(file);
				parseDocument();
			} catch (SAXException e) {
				e.printStackTrace();
			} catch (IOException e) {
				e.printStackTrace();
			}
			
		} catch (ParserConfigurationException e) {
			e.printStackTrace();
		}

	}
	
	private void parseDocument() {	
		NodeList list;
		NodeList features;
		Node feature;

		String filename;
		String classname;
		String artist;
		String category;


		// filename
		list = dom.getElementsByTagName("filename");
		if (list.getLength() < 1) System.err.println("Filename is missing!");		
		filename = list.item(0).getFirstChild().getNodeValue();
		
		// category
		list = dom.getElementsByTagName("category");
		if (list.getLength() < 1) System.err.println("Category is missing!");
		category = list.item(0).getFirstChild().getNodeValue();
		
		
		// artist
		list = dom.getElementsByTagName("artist");
		if (list.getLength() < 1) System.err.println("Artist is missing!");
		artist = list.item(0).getFirstChild().getNodeValue();
		

		// classname
		if (classNode.equals("artist"))
			classname = artist;
		else
			classname = category;

		
		Record r = new Record(filename, classname);
		records.add(r);

		// features
		list = dom.getElementsByTagName("features");
		if (list.getLength() < 1) System.err.println("Features are missing!");

		features = list.item(0).getChildNodes();

		for (int i=0; i<features.getLength(); i++) {
			feature = features.item(i);
			
			if (feature.getNodeType() == Node.ELEMENT_NODE)
				parseFeature(r, feature);
		}
	}

	private void writeHeader() {
		String featureName;
		String featureString = "";
		int featureCount;
		int recordCount = records.size();
		
		Iterator<String> it = sortedFeatures.iterator();
	    while (it.hasNext()) {		
			featureName = (String)it.next();
			featureCount = features.get(featureName);

			if (featureCount < recordCount) {
				System.err.println("Removing feature " + featureName);
				it.remove();
				continue;
			}

			featureString += spacer + featureName;
		}

		try {
			out.write("img_src" + spacer + "class" + featureString);
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	
	private void writeRecords() {
		String featureString	= "";
		String key				= "";
		String value			= "";
		Iterator<String> it;

		for (Record r : records) {
			featureString = "";
			
			it = sortedFeatures.iterator();
		    while (it.hasNext()) {		
		    	key		= (String)it.next();
				value	= (String) r.featureValues.get(key);
				
				if (value == null) {
					System.err.println("Feature " + key + " is missing for picture " + r.filename);
					System.exit(0);
				}
				
				featureString += spacer + value;					
			}

			try {
				out.write("\n" + r.filename + spacer + r.name + featureString);
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
	}

	private void parseFeature(Record r, Node feature) {
		String name 	= "";
		String fullName	= "";
		String val;
		
		name = feature.getNodeName();
		NodeList featureList = feature.getChildNodes();

		for (int i=0; i<featureList.getLength(); i++) {
		
			// skip wrong XML nodes
			if (featureList.item(i).getNodeType() != Node.ELEMENT_NODE)
				continue;

			val = featureList.item(i).getTextContent();
			String[] tmp = val.split(" ");
				
			for (int j=0; j<tmp.length; j++) {

				if (tmp.length > 1)
					fullName = name + Integer.toString(j);
				else
					fullName = name;

				// add features
				Integer count = (Integer) features.get(fullName);

				if (count == null)
					features.put(fullName, 1);
				else
					features.put(fullName, count + 1);

				r.featureValues.put(fullName, tmp[j]);
			}
		}
	}

	static public void main(String[] args) {
		String dir			= "./data/default/";
		String classNode	= "artist";

		if (args.length >= 1)
			dir = args[0];
		
		if (args.length >= 2)
			classNode = args[1];

		new XMLtoTSV(dir, classNode);
	}
	
}
