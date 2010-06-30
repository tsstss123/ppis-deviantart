package deviantART;
import java.awt.Color;
import java.awt.Dimension;
import java.awt.FlowLayout;
import java.awt.Graphics;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.util.ArrayList;

import javax.imageio.ImageIO;
import javax.swing.*;

import Helpers.ImageTools;
import Models.DataImage;

/**
 * Footer component of the application.
 * Used to display images and control buttons.
 * @author Nick
 *
 */
public class Footer extends JPanel {
	
	private static final long serialVersionUID = 1L;

	private int offsetX		= 8;
	private int offsetY		= 18;
	private int imgSpacing	= 5;
	
	BufferedImage bg;
	private ArrayList<DataImage> 	Images		= new ArrayList<DataImage>();
	private JPanel ImagesBox;
	private JPanel ButtonsBox;


	public Footer() {
		super();
		setAlignmentX(LEFT_ALIGNMENT);
		setLayout(new FlowLayout(FlowLayout.LEFT, offsetX, offsetY));
		setPreferredSize(new Dimension(1000,136));

		initLayout();
	}
	
	private void initLayout() {
		try {
			bg = ImageIO.read(new File("images/footer.png"));
		} catch (IOException e) {
			e.printStackTrace();			
		}
		
		repaint();
		
		// ImagesBox
		ImagesBox = new JPanel();
		ImagesBox.setAlignmentX(JComponent.LEFT_ALIGNMENT);
		ImagesBox.setLayout(new FlowLayout(FlowLayout.LEFT, imgSpacing, imgSpacing));
		ImagesBox.setBackground(new Color(0,0,0,0));
		ImagesBox.setPreferredSize(new Dimension(870 - 2*offsetX, 112));
		add(ImagesBox);
		
		// ImagesBox
		ButtonsBox = new JPanel();
		ButtonsBox.setAlignmentX(JComponent.LEFT_ALIGNMENT);
		ButtonsBox.setLayout(new BoxLayout(ButtonsBox, BoxLayout.Y_AXIS));
		ButtonsBox.setBackground(new Color(0,0,0,0));
		ButtonsBox.setPreferredSize(new Dimension(130, 112));
		add(ButtonsBox);
		
		ImageIcon ii	= new ImageIcon("images/buttons/features.png");
		JLabel label	= new JLabel(ii);
		label.setPreferredSize(new Dimension(112, 31));
		label.setCursor(deviantART.hander);
		label.addMouseListener(new FooterMouseListener(FooterMouseListener.featuresPressed));
		ButtonsBox.add(label);
		
		ii	= new ImageIcon("images/buttons/class_labels.png");
		label	= new JLabel(ii);
		label.setPreferredSize(new Dimension(112, 31));
		label.setCursor(deviantART.hander);
		label.addMouseListener(new FooterMouseListener(FooterMouseListener.classLabelsPressed));
		ButtonsBox.add(label);
	}
	
	public void addImage(DataImage im) {
		Images.add(im);
		paintImages();
	}
	
	/**
	 * Clear all images from the footer
	 */
	public void resetAll() {
		resetImages();
	}
	
	/**
	 * Reset all images from the footer and repaint
	 */
	public void resetImages() {
		Images.clear();
		paintImages();
	}
	
	public void paintComponent(Graphics g) {
		g.drawImage(bg, 0, 0, null);
	}
	
	/**
	 * Paint the images to the screen
	 */
	/**
	 * 
	 */
	public void paintImages() {
		ImagesBox.removeAll();
		
		int count		= Images.size();
		if (count == 0) {
			ImagesBox.revalidate();
			repaint();
			return;
		}
		
		ImageIcon ii;
		JLabel label;
		
		int maxDim		= 100;
		int colPerRow	= 100;
		int surfW		= 870 - 2*offsetX;
		int surfH		= 112;

		/* Find optimal image size (max width is 100px) */
		int rows;
		for(int i=100; i>0; i--) {

			colPerRow = (int) Math.floor( (float) surfW / (float) (i + imgSpacing) );
			rows = (int) Math.ceil( (float) count / (float) colPerRow );

			if ((i + imgSpacing) * rows <= surfH) {
				maxDim = i;
				break;
			}
		}

		Dimension labelD = new Dimension(maxDim, maxDim);

		for (DataImage im : Images) {
			if (im.thumb == null)
				loadThumb(im);	

			if (im.thumb == null) {
				System.err.println("Resizing failed (footer): " + im.filenameThumb);
				continue;
			}

			ii		= new ImageIcon(ImageTools.resize(im.thumb, maxDim, maxDim));
			label	= new JLabel(ii);
			label.setPreferredSize(labelD);
			label.setCursor(deviantART.hander);
			label.addMouseListener(new FooterMouseListener(im));
			ImagesBox.add(label);
		}
		
		ImagesBox.revalidate();
		repaint();
	}

	private void loadThumb(DataImage im) {
		try {
			BufferedImage thumb = ImageIO.read(new File(deviantART.imagesDir + im.filenameThumb));
			im.thumb = thumb;
		} catch (IOException e) {
			e.printStackTrace();			
		}		
	}
	
}
