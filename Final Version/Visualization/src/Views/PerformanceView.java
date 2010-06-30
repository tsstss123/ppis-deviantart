package Views;

import Databases.DBPerformance;

/**
 * Parent class for all views that perform a performance based view (radial).
 * @author Nick
 *
 */
public class PerformanceView extends View {

	private static final long serialVersionUID = 1L;

	protected DBPerformance DB;


	public void run(DBPerformance DB) {
		this.DB = DB;

		DB.init();
		DBloaded();
	}

	protected void DBloaded() { }
	
}