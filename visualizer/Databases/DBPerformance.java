package Databases;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;

import Models.DataConnection;
import Models.DataNode;

public class DBPerformance extends DB {

	public ArrayList<DataNode> 	DataCategories		= new ArrayList<DataNode>();
	public ArrayList<DataNode> 	DataFeatures		= new ArrayList<DataNode>();
	public ArrayList<DataNode> DataClassifiers		= new ArrayList<DataNode>();
	public ArrayList<DataConnection> DataConnections	= new ArrayList<DataConnection>();
	
	public float minFeaturePerformance				= Float.MAX_VALUE;
	public float maxFeaturePerformance				= 0.0f;
	
	public float minClassifierPerformance			= Float.MAX_VALUE;
	public float maxClassifierPerformance			= 0.0f;
	

	public DBPerformance(File file) {
		super(file);
	}

	public void init() {
		if (initialized) return;
		
		try {
			BufferedReader reader = new BufferedReader(new FileReader(file));
			String line = null;

			while ((line = reader.readLine()) != null)
				handleLine(line);			

		} catch (IOException e) {
			e.printStackTrace();
		}
		
		initialized = true;
	}
	
	private void handleLine(String line) {
		if (firstLine) {
			firstLine = false;
			return;
		}
		
		String[] pieces = line.split("\t");
		String[] features	= new String[pieces.length-3];
		System.arraycopy(pieces, 3, features, 0, pieces.length-3);

		DataNode	cat		= findCategory(pieces[0]);
		DataNode	cl		= findClassifier(pieces[1]);
		DataNode	f		= findFeature(features);
		float		perf	= new Float(pieces[2]);

		DataConnection c;
		
		// connect cat to feature
		c = new DataConnection(DataConnection.FEATURE, cat, f, perf);
		DataConnections.add(c);

		// connect cat to classifier
		c = findConnection(cat, cl);
		if (c != null && c.thickness < perf) {
			c.thickness = perf;
		} else {
			c = new DataConnection(DataConnection.CLASSIFIER, cat, cl, perf);
			DataConnections.add(c);
		}
		
		// feature min & max
		if (perf < minFeaturePerformance) minFeaturePerformance = perf;
		if (perf > maxFeaturePerformance) maxFeaturePerformance = perf;

		if (perf > cat.perf)	cat.perf = perf;
		if (perf > f.perf)		f.perf = perf;
		if (perf > cl.perf)		cl.perf = perf;
	}

	public DataNode findCategory(String name) {
		DataNode res = null;

		for (DataNode el : DataCategories) {
			if (el.name.equals(name)) {
				res = el;
				break;
			}
		}
		
		if (res == null) {
			res = new DataNode(name);
			DataCategories.add(res);
		}

		return res;
	}

	public DataNode findClassifier(String name) {
		DataNode res = null;

		for (DataNode el : DataClassifiers) {
			if (el.name.equals(name)) {
				res = el;
				break;
			}
		}

		if (res == null) {
			res = new DataNode(name);
			DataClassifiers.add(res);
		}

		return res;
	}

	public DataNode findFeature(String[] features) {
		DataNode res = null;
		int found;

		for (DataNode el : DataFeatures) {		
			// skip unequal lengths
			if (features.length != el.features.length)
				continue;
			
			found = 0;

			for (int i=0; i<features.length; i++) {
				for (int j=0; j<el.features.length; j++) {
					if (features[i].equals(el.features[j]))
						found++;
				}
			}

			if (found == features.length) {
				res = el;
				break;
			}
		}
		
		if (res == null) {
			res = new DataNode(features);
			DataFeatures.add(res);
		}

		return res;
	}
	
	public DataConnection findConnection(DataNode from, DataNode to) {
		DataConnection res = null;
		
		for (DataConnection c : DataConnections) {
			if (c.from == from && c.to == to) {
				res = c;
				break;
			}
		}
		
		return res;
	}
	
}
