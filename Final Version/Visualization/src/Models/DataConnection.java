package Models;

/**
 * Represents a connection between to nodes (radial plot)
 * @author Nick
 *
 */
public class DataConnection {
	
	public static final int FEATURE		= 0;
	public static final int CLASSIFIER	= 1;
	
	public DataNode from;
	public DataNode to;
	public float thickness;
	public int type;
	
	public DataConnection(int type, DataNode from, DataNode to, float thickness) {
		this.type	= type;
		this.from	= from;
		this.to		= to;
		this.thickness	= thickness;
	}

}
