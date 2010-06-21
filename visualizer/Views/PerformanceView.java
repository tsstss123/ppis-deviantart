package Views;

import Databases.DBPerformance;

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