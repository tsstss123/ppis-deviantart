package XMLtoTSV;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;

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
	public ArrayList<String> featureNames	= new ArrayList<String>();
	public File sourceDir;
	public File outputFile;
	public BufferedWriter out;

	public Document dom;
	
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
	    	if (listOfFiles[i].isFile()) {
	    		
	    		filename = listOfFiles[i].getName();

	    		dotPos = filename.lastIndexOf(".");
	            String extension = filename.substring(dotPos+1);

	            if (extension.equals("xml"))
	            	parseXMLFile(listOfFiles[i]);
	    	}
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
		
		String featuresString = "";

		
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

		
		// features
		list = dom.getElementsByTagName("features");
		if (list.getLength() < 1) System.err.println("Features are missing!");

		features = list.item(0).getChildNodes();

		for (int i=0; i<features.getLength(); i++) {
			feature = features.item(i);
			
			if (feature.getNodeType() == Node.ELEMENT_NODE)
				featuresString += parseFeature(feature);
		}

		
		// header
		if (firstFile)
			writeHeader();


		// content
		try {
			out.write("\n" + filename + spacer + classname + featuresString);
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	
	private void writeHeader() {
		if (!firstFile) return;
		
		try {
			out.write("img_src" + spacer + "class" + spacer + featureNamesToString());
		} catch (IOException e) {
			e.printStackTrace();
		}

		firstFile = false;
	}

	private String parseFeature(Node feature) {
		String res = "";
		String name;
		String val;
		
		name = feature.getNodeName();

		NodeList featureList = feature.getChildNodes();

		for (int i=0; i<featureList.getLength(); i++) {
		
			if (featureList.item(i).getNodeType() == Node.ELEMENT_NODE) {

				val = featureList.item(i).getTextContent();
				String[] tmp = val.split(" ");
				
				for (int j=0; j<tmp.length; j++) {
					if (firstFile) {
						if (tmp.length == 1)
							featureNames.add(name);
						else
							featureNames.add(name + Integer.toString(j));
					}

					res += spacer + tmp[j];
				}
			}
		}

		return res;
	}

	private String featureNamesToString() {
		String res = "";

		for (int i=0; i<featureNames.size(); i++) {
			if (i > 0) res += spacer;
			
			res += featureNames.get(i);
		}	

		return res;
	}

	


	static public void main(String[] args) {
		String dir			= "./data/albert/";
		String classNode	= "artist";

		if (args.length >= 1)
			dir = args[0];
		
		if (args.length >= 2)
			classNode = args[1];

		new XMLtoTSV(dir, classNode);
	}
	
}
