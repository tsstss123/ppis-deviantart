package deviantART;
import java.awt.Color;
import java.awt.Dimension;
import java.awt.Graphics;
import java.awt.Toolkit;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;

import javax.imageio.ImageIO;
import javax.swing.JFrame;

import Helpers.ImageTools;
import Models.DataImage;

public class ImagePopup extends JFrame {

	private static final long serialVersionUID = 1L;

	private DataImage im;
	private BufferedImage large;
	
	private int screenW;
	private int screenH;

	
	public ImagePopup(DataImage im) {		
		super(im.filename);
		
		this.im = im;

		Toolkit tk = Toolkit.getDefaultToolkit();
		Dimension screenSize = tk.getScreenSize();
		screenW = screenSize.width;
		screenH = screenSize.height;
		
		loadImage();
		
		int w = large.getWidth();
		int h = large.getHeight();
		
		setPreferredSize(new Dimension(w, h));
		setBackground(Color.black);
		setLocation(screenW - (w+25), 10);
		pack();
		setVisible(true);

		repaint();
	}
	
	private void loadImage() {
		try {
			large = ImageIO.read(new File(deviantART.imagesDir + im.filename));

			int w = large.getWidth();
			int h = large.getHeight();
			
			if (w > screenW * 0.8 || h > screenH * 0.8)
				large = ImageTools.resize(large, (int) (screenW * 0.8), (int) (screenH * 0.8));
			
		} catch (IOException e) {
			e.printStackTrace();			
		}
	}
	
	public void paint(Graphics g) {
		g.drawImage(large, 0, 20, null);
	}

}
