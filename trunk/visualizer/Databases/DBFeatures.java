package Databases;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;

import Models.DataClass;
import Models.DataCol;
import Models.DataImage;

public class DBFeatures extends DB {

	public ArrayList<DataClass>	DataClasses			= new ArrayList<DataClass>();
	public ArrayList<DataCol> 	DataCols			= new ArrayList<DataCol>();
	public ArrayList<DataCol>	DataVisibleCols		= new ArrayList<DataCol>();
	public ArrayList<DataImage> DataItems			= new ArrayList<DataImage>();

	public DataImage highlightNode					= null;
	public DataClass highlightClass					= null;

	
	public DBFeatures(File file) {
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
		String[] pieces = line.split("\t");
		DataImage image;

		if (firstLine) {
			handleLineHeaders(pieces);
			firstLine = false;
			return;
		}

		image			= new DataImage(pieces[0]);
		image.dataClass	= findClass(pieces[1]);
		image.dataClass.itemCount++;
		image.colData	= new float[DataCols.size()];

		// col min & max
		float val;
		DataCol col;

		for(int i=2; i<pieces.length; i++) {
			val = Float.valueOf(pieces[i]).floatValue();
			col = DataCols.get(i-2);
			
			// min & max
			if (val < col.ominValue) col.ominValue = val;
			if (val > col.omaxValue) col.omaxValue = val;
			
			// sum
			col.sumValue += val;

			image.colData[i-2] = val;
		}
		
		DataItems.add(image);
	}

	private void handleLineHeaders(String[] pieces) {
		DataCol col;

		for(int i=2; i<pieces.length; i++) {
			col = new DataCol(pieces[i]);
			col.index = i-2;
			DataCols.add(col);
		}
	}

	private DataClass findClass(String name) {
		DataClass dataClass = null;
		
		for (DataClass cl : DataClasses) {
			if (cl.name.equals(name)) {
				dataClass = cl;
				break;
			}
		}

		if (dataClass == null) {
			dataClass = new DataClass(name);
			DataClasses.add(dataClass);
		}

		return dataClass;
	}	

}
