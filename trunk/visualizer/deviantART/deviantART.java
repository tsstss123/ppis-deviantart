package deviantART;
import java.awt.*;
import java.io.File;
import java.io.IOException;

import javax.swing.*;

import Databases.DBFeatures;
import Databases.DBPerformance;
import Views.View;
import Views.ViewParallel;
import Views.ViewRadial;
import Views.ViewScatter;

public class deviantART extends JFrame {
	
	private static final long serialVersionUID	= 1L;
		
	/* view */
	public final static String VIEW_SCATTER		= "VIEW_SCATTER";
	public final static String VIEW_PARALLEL	= "VIEW_PARALLEL";
	public final static String VIEW_RADIAL		= "VIEW_RADIAL";
	public static String activeView				= VIEW_PARALLEL;

	public Box viewHolder;
	public static View viewObject;
	
	/* layout */
	public static Header header;
	public static Footer footer;

	/* dataset */
	public static File datasetDir;
	public static String imagesDir;
	public static DBFeatures DBFeatures;
	public static DBPerformance DBPerformance;

	public static Cursor hander					= new Cursor (Cursor.HAND_CURSOR);


	public deviantART() {
		initLayout();

		// file chooser
		//selectFile();

		// auto select file
		setDatasetDir(new File("./data/albert/"));
		runView();

		/* java layout */
		pack();
		setVisible(true);
	}

	private void initLayout() {
		setTitle("deviantART Divider");
		setBackground(Color.black);

		getContentPane().setLayout(new BoxLayout(getContentPane(), BoxLayout.Y_AXIS));

		addHeader();
		addViewHolder();
		addView(activeView);
		addFooter();
	}
	
	public void addView(String view) {
		if (viewObject != null) {
			if (view.equals(activeView)) return;
			
			if (viewObject != null) {
				viewHolder.removeAll();
				viewObject.destroy();
				viewObject = null;
			}

			footer.resetAll();
		}

		activeView = view;

		if (view == VIEW_SCATTER)
			addViewScatter();
		else if (view == VIEW_RADIAL)
			addViewRadial();
		else
			addViewParallel();
		
		runView();
	}
	
	private void addHeader() {
		header = new Header(this);
		add(header);
	}
	
	private void addViewHolder() {
		viewHolder = Box.createHorizontalBox();
		viewHolder.setAlignmentX(LEFT_ALIGNMENT);
		viewHolder.setPreferredSize(new Dimension(1000,500));
		add(viewHolder);
	}

	private void addViewParallel() {
		viewObject = new ViewParallel();
		viewHolder.add(viewObject);
		viewObject.init(); // Processing
	}

	private void addViewScatter() {
		viewObject = new ViewScatter();
		viewHolder.add(viewObject);
		viewObject.init(); // Processing
	}
	
	private void addViewRadial() {
		viewObject = new ViewRadial();
		viewHolder.add(viewObject);
		viewObject.init(); // Processing
	}
	
	private void addFooter() {
		footer = new Footer();
		add(footer);
	}

	public void selectFile() {
		JFileChooser fc = new JFileChooser();
		fc.setFileSelectionMode(JFileChooser.DIRECTORIES_ONLY);
		fc.setDialogTitle("Choose a dataset directory");

		int returned = fc.showOpenDialog(getParent());
		if (returned == JFileChooser.APPROVE_OPTION) {
			File file = fc.getSelectedFile();
			setDatasetDir(file);
			runView();
		}
	}

	public void setDatasetDir(File file) {
		String path = "./";

		try {
			path = file.getCanonicalPath();
		} catch (IOException e) {
			e.printStackTrace();
		}
		
		File fileFeatures	= new File(path + "/features.tsv");
		File filePerformance	= new File(path + "/performance.tsv");

		if (!fileFeatures.isFile() || !filePerformance.isFile()) {
			System.err.println("Error: features.tsv or performance.tsv is not found!");
			System.exit(0);
		}

		datasetDir = file;
		imagesDir = path + "/dataset/";

		DBFeatures		= new DBFeatures(fileFeatures);
		DBPerformance	= new DBPerformance(filePerformance);
	}

	public void runView() {
		if (datasetDir == null) return;		
		
		String className = viewObject.getClass().getName();
		if (className.equals("Views.ViewRadial"))
			viewObject.run(DBPerformance);
		else
			viewObject.run(DBFeatures);
	}

	static public void main(String[] args) {
		deviantART app = new deviantART();
		app.setDefaultCloseOperation(WindowConstants.EXIT_ON_CLOSE);
	}
}