package Views;

import deviantART.deviantART;
import Databases.DBFeatures;
import Models.DataImage;

/**
 * Parent class for all views that perform a feature based view (scatter, parallel).
 * @author Nick
 *
 */
public class FeatureView extends View {

	private static final long serialVersionUID = 1L;

	protected DBFeatures DB;

	/* paddings */
	protected float plotX1, plotY1, plotX2, plotY2;

	
	public void run(DBFeatures DB) {
		this.DB = DB;

		DB.init();
		DBloaded();
	}

	protected void DBloaded() { }

	protected void updateFooter() {
		deviantART.footer.resetImages();

		// node
		if (DB.highlightNode != null)
			deviantART.footer.addImage(DB.highlightNode);

		// class
		else if (DB.highlightClass != null) {
			for (DataImage im : DB.DataItems) {
				if (im.dataClass.equals(DB.highlightClass))
					deviantART.footer.addImage(im);
			}
		}
	}
	
	protected void setClassColors() {
		for (int i=0; i<DB.DataClasses.size(); i++)
			DB.DataClasses.get(i).hue = map(i, 0, DB.DataClasses.size()-1, 30, 330);
	}

}