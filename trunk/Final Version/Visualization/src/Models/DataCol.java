package Models;
/**
 * Represents a column of the parallel coordinates plot
 * @author Nick
 *
 */
public class DataCol {

	public String name		= null;
	public int index		= 0;
	
	/* from source */
	/**
	 * Original max value
	 */
	public float omaxValue	= 0.0f;
	/**
	 * Original min value
	 */
	public float ominValue	= Float.MAX_VALUE;
	
	/* used for display */
	/**
	 * Modified (rounded) max value, used for display
	 */
	public float maxValue	= 0.0f;
	/**
	 * Modified (rounded) min value, used for display
	 */
	public float minValue	= Float.MAX_VALUE;

	public float avgValue	= 0.0f;
	public float sumValue	= 0.0f;
	public boolean visible	= false;

	public DataCol (String name) {
		this.name	= name;
	}

}
