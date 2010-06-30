package Views;
import Databases.DBFeatures;
import Databases.DBPerformance;
import processing.core.PApplet;


/**
 * Parent class for all views
 * @author Nick
 *
 */
public class View extends PApplet {

	private static final long serialVersionUID = 1L;
	
	
	public void run(DBFeatures DB) { }
	public void run(DBPerformance DB) { }
	public void redraw() { }
}