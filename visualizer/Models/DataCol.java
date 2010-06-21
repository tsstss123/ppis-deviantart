package Models;
public class DataCol {

	public String name		= null;
	public int index		= 0;
	
	/* from source */
	public float omaxValue	= 0.0f;
	public float ominValue	= Float.MAX_VALUE;
	
	/* used for display */
	public float maxValue	= 0.0f;
	public float minValue	= Float.MAX_VALUE;

	public float avgValue	= 0.0f;
	public float sumValue	= 0.0f;
	//public boolean visible	= true;
	public boolean visible	= false;

	public DataCol (String name) {
		this.name	= name;
	}

}
