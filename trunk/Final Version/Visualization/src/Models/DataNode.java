package Models;
/**
 * Represents a node on the radial plot
 * @author Nick
 *
 */
public class DataNode {

	public String name			= "";
	/**
	 * List of features used as node
	 */
	public String[] features	= null;
	public float a				= 0;
	public float perf			= 0.0f;
	public float hue			= 0.0f;

	public int x				= -1;
	public int y				= -1;

	public DataNode (String name) {
		this.name = name;
	}

	public DataNode (String[] features) {
		this.features	= features;
		
		for(int i=0; i<features.length; i++) {
			if (!this.name.equals(""))
				this.name += "\n";

			this.name += features[i];
		}
	}

}
