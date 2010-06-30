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

/**
 * Main application to visualize a deviantART dataset.
 * Combines three different visualization techniques into
 * one application.
 * @author Nick
 */
/**
 * @author Nick
 *
 */
/**
 * @author Nick
 *
 */
public class deviantART extends JFrame {
	
	private static final long serialVersionUID	= 1L;
		
	/* view */
	public final static String VIEW_SCATTER		= "VIEW_SCATTER";
	public final static String VIEW_PARALLEL	= "VIEW_PARALLEL";
	public final static String VIEW_RADIAL		= "VIEW_RADIAL";
	public static String activeView				= VIEW_PARALLEL;

	
	/**
	 * Box that holds the active visualization object.
	 */
	public Box viewHolder;
	/**
	 * Active visualization object
	 */
	public static View viewObject;
	
	/* layout */
	public static Header header;
	public static Footer footer;

	/* dataset */
	/**
	 * Directory containing the dataset (images, XML)
	 */
	public static File datasetDir;
	/**
	 * Directory containing the images of the dataset
	 */
	public static String imagesDir;
	/**
	 * Database used to store the loaded dataset (scatter/parallel)
	 */
	public static DBFeatures DBFeatures;
	/**
	 * Database used to store the loaded dataset (radial)
	 */
	public static DBPerformance DBPerformance;

	public static Cursor hander					= new Cursor (Cursor.HAND_CURSOR);


	/**
	 * Default constructor
	 */
	public deviantART() {
		initLayout();

		// file chooser
		//selectFile();

		// auto select file
		setDatasetDir(new File("./data/default/"));
		runView();

		/* java layout */
		pack();
		setVisible(true);
	}

	/**
	 * Initialize application layout.
	 * Add header, view and footer.
	 */
	private void initLayout() {
		setTitle("deviantART Divider");
		setBackground(Color.black);

		getContentPane().setLayout(new BoxLayout(getContentPane(), BoxLayout.Y_AXIS));

		addHeader();
		addViewHolder();
		addView(activeView);
		addFooter();
	}
	
	/**
	 * Activates a visualization view
	 * @param Name of the view to active
	 */
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
	
	/**
	 * Add header to the application
	 */
	private void addHeader() {
		header = new Header(this);
		add(header);
	}
	
	/**
	 * Add the view holder to the application
	 */
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

	/**
	 * Lets the user select a dataset directory
	 */
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

	/**
	 * Set the directory of the dataset
	 * @param Directory containing the dataset
	 */
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

	/**
	 * Run the active view
	 */
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