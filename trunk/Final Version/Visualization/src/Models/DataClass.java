package Models;
/**
 * Represents a class from the dataset
 * @author Nick
 *
 */
public class DataClass {

	public String name	= null;
	/**
	 * Color of the class
	 */
	public float hue	= 0.0f;
	/**
	 * Number of datapoints belonging to this class
	 */
	public int itemCount = 0;
	
	public float avgX	= 0.0f;
	public float avgY	= 0.0f;
	
	public boolean visible	= true;
	
	public DataClass (String name) {
		this.name	= name;		
	}

}
