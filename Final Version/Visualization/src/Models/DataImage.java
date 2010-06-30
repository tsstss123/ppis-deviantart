package Models;

import java.awt.image.BufferedImage;

public class DataImage {

	public String filename		= null;
	public String filenameThumb = null;
	public DataClass dataClass	= null;
	public float[] colData		= null;
	public float stdDev			= 0.0f;

	public BufferedImage thumb;
	public BufferedImage scatterImage;
	public int[] scatterSize	= new int[2];

	public DataImage (String filename) {
		this.filename		= filename;
		this.filenameThumb	= filename.replace("/full/", "/thumbsmall/");
	}

}
