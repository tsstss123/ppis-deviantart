package Helpers;

import java.awt.Graphics2D;
import java.awt.RenderingHints;
import java.awt.image.BufferedImage;

/**
 * Handy tools for image manipulation
 * @author Nick
 *
 */
public class ImageTools {

	public static BufferedImage resize(BufferedImage img, int newW, int newH) {
		return resize(img, newW, newH, false);
	}
	
	public static BufferedImage resize(BufferedImage img, int newW, int newH, boolean exactSize) {
		int[] size = new int[] {newW, newH};
        int w = img.getWidth();  
        int h = img.getHeight(); 

        if (!exactSize)
        	size = getNewSize(newW, newH, w, h);

        if (size[0] == 1)
    	   return img;
       
        BufferedImage dimg = new BufferedImage(size[1], size[2], BufferedImage.TYPE_INT_ARGB);  
        Graphics2D g = dimg.createGraphics();  
        g.setRenderingHint(RenderingHints.KEY_INTERPOLATION, RenderingHints.VALUE_INTERPOLATION_BILINEAR);  
        g.drawImage(img, 0, 0, size[1], size[2], 0, 0, w, h, null);  
        g.dispose();  
        return dimg;  
    }
	
	/**
	 * Calculate the new size of an image when keeping aspect ratio.
	 * @param newW
	 * @param newH
	 * @param curW
	 * @param curH
	 * @return
	 */
	public static int[] getNewSize(int newW, int newH, int curW, int curH) {
		int[] size = new int[3];
		
		float scale = Math.min((float)newW / (float)curW, (float)newH / (float)curH);
		size[0] = (scale == 1) ? 1 : 0;
		size[1] = (int)((float)curW * scale);
		size[2] = (int)((float)curH * scale);
		
		return size;
	}
	
}
