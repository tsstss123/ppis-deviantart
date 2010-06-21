package Views;

import java.awt.Graphics2D;
import java.awt.image.BufferedImage;
import java.awt.image.RescaleOp;
import java.io.File;
import java.io.IOException;

import javax.imageio.IIOException;
import javax.imageio.ImageIO;

import deviantART.deviantART;

import processing.core.PFont;
import processing.core.PGraphicsJava2D;

import Models.DataClass;
import Models.DataCol;
import Models.DataImage;

import Helpers.ImageTools;

public class ViewScatter extends FeatureView {

	private static final long serialVersionUID = 1L;

	private int nrXAxisLabels				= 10;
	private int nrYAxisLabels				= 5;
	private int borderSize					= 4;
	private Graphics2D g2;
	
	/* mouse click */
	private float closestDist;
	
	/* clickable col names */
	float colnamesTop, colnamesBottom;

	
	public void setup() {
		size(1000, 500);
		noLoop();
		smooth();
		
		g2 = ((PGraphicsJava2D)g).g2;
		
		/* paddings */
		plotX1 = 53;
		plotX2 = width - plotX1;
		plotY1 = 45;
		plotY2 = height - 34;
	}
	
	public void DBloaded() {
		updateFooter();

		setClassColors ();
	
		redraw();
	}
	
	public void draw() {
		colorMode(RGB, 255);
		background(0, 0, 0);
	
		if (DB.DataVisibleCols.size() == 2) {
			drawCols();
			drawData();
			drawClassCenters();
		}
		
		noLoop();
	}
	
	public void redraw() {
		loop();	
		updateFooter();
	}
	
	public void mousePressed() {		
		if (mouseButton == RIGHT)
			mousePressedReset();
		else if (mouseButton == LEFT || mouseButton == CENTER)
			mousePressedHighlight();
	}

	private void mousePressedReset() {
		DB.highlightNode	= null;
		DB.highlightClass	= null;
		redraw();
	}

	private void mousePressedHighlight() {
		int[] pos;
		float d;
		closestDist = Float.MAX_VALUE;
		
		DB.highlightNode	= null;
		DB.highlightClass	= null;
		
		boolean useClass = (mouseButton == CENTER || (keyPressed && mouseButton == LEFT && (keyCode == 157 || keyCode == CONTROL)));
		
		for (DataImage im : DB.DataItems)	{
			// hide invisible classes
			if (!im.dataClass.visible)
				continue;
			
			pos = getImagePositions(im);
			d = dist(mouseX,mouseY,pos[0],pos[1]);
			if (d < closestDist) {
				closestDist = d;
				if (useClass)
					DB.highlightClass = im.dataClass;
				else
					DB.highlightNode = im;
			}
		}
		redraw();
	}
	
	private void drawCols() {
		colorMode(RGB, 255);
		stroke(70);
		strokeWeight(1);

		PFont plotFont = createFont("Calibri", 12);
		textFont(plotFont);
		fill(150);
		
		drawXCol();
		drawYCol();
	}
	
	private void drawXCol() {
		float x;
		float v;
		DataCol col = DB.DataVisibleCols.get(0);

		line(plotX1, plotY2, plotX2, plotY2);
		textAlign(CENTER, TOP);
		fill(240);
		text(col.name, map(0.5f, 0, 1, plotX1, plotX2), plotY2 + 18);
		fill(150);
		
		float dif = abs(col.omaxValue - col.ominValue);
		col.minValue = col.ominValue - (dif * (32 / (plotX2 - plotX1)));
		col.maxValue = col.omaxValue + (dif * (32 / (plotX2 - plotX1)));
		
		float IntervalMinor = (col.maxValue - col.minValue) / nrXAxisLabels;

		for (int i=0; i<=nrXAxisLabels;i++) {
			v = col.minValue + (i * IntervalMinor);
			x = map(v, col.minValue, col.maxValue, plotX1, plotX2);

			if (v == col.minValue)
				textAlign(LEFT, TOP);
			else if (v == col.maxValue)
				textAlign(RIGHT, TOP);
			else
				textAlign(CENTER, TOP);
			
			text(String.format("%13.2e", v), x, plotY2 + 3);
		}
	}
	
	private void drawYCol() {
		float y;
		float v;
		DataCol col = DB.DataVisibleCols.get(1);

		line(plotX1, plotY1, plotX1, plotY2);
		textAlign(CENTER, CENTER);
		fill(240);
		text(col.name, plotX1 - 8, plotY1 - 18);
		fill(150);
		
		float dif = abs(col.omaxValue - col.ominValue);
		col.minValue = col.ominValue - (dif * (32 / (plotY2 - plotY1)));
		col.maxValue = col.omaxValue + (dif * (32 / (plotY2 - plotY1)));

		float IntervalMinor = (col.maxValue - col.minValue) / nrYAxisLabels;

		for (int i=0; i<=nrYAxisLabels;i++) {
			v = col.minValue + (i * IntervalMinor);
			y = map(v, col.minValue, col.maxValue, plotY2, plotY1);
			
			if (v == col.minValue)
				textAlign(RIGHT, BOTTOM);
			else if (v == col.maxValue)
				textAlign(RIGHT, TOP);
			else
				textAlign(RIGHT, CENTER);
			
			text(String.format("%13.2e", v), plotX1 - 8, y);
		}
	}
	
	private int[] getImagePositions(DataImage im) {
		int pos[] = new int[2];

		DataCol col1 = DB.DataVisibleCols.get(0);
		DataCol col2 = DB.DataVisibleCols.get(1);

		pos[0] = (int) map(im.colData[col1.index], col1.minValue, col1.maxValue, plotX1, plotX2);
		pos[1] = (int) map(im.colData[col2.index], col2.minValue, col2.maxValue, plotY1, plotY2);

		return pos;
	}
	
	private void drawData() {
		resetClassAvg();
		
		Boolean dim = (DB.highlightClass != null || DB.highlightNode != null);

		colorMode(RGB, 255);
		fill(color(255, 0));
		strokeWeight(borderSize);

		// draw all non highlighted items
		for (DataImage im : DB.DataItems)		
			drawDataImages(im, dim, false);

		// draw single highlighted
		if (DB.highlightNode != null)
			drawDataImages(DB.highlightNode, false, true);

		// draw highlighted class
		if (DB.highlightClass != null) {
			for (DataImage im : DB.DataItems)	
				if (im.dataClass.equals(DB.highlightClass))
					drawDataImages(im, false, true);
		}
	}

	private void drawDataImages(DataImage im, Boolean dim, Boolean highlight) {
		int[] pos;
		int[] size	= new int[2];
		
		colorMode(HSB, 360, 100, 100);
		
		// hide invisible classes
		if (!im.dataClass.visible)
			return;

		if (dim) {
			stroke(color(im.dataClass.hue, 100, 30));
			colorMode(RGB, 255);
			tint(255, 90);
		} else {
			stroke(color(im.dataClass.hue, 100, 100));
			noTint();
		}

		if (im.scatterImage == null) {
			try {
				BufferedImage img = ImageIO.read(new File(deviantART.imagesDir + im.filenameThumb));
				if (img == null) {
					System.err.println("Corrupted? image: " + deviantART.imagesDir + im.filenameThumb);
					return;
				}
				im.scatterSize	= ImageTools.getNewSize(50, 50, img.getWidth(), img.getHeight());
				size			= im.scatterSize;
				im.scatterImage	= ImageTools.resize(img, size[1], size[2]);
			} catch (IIOException e) {
				System.err.println("Image not found: " + deviantART.imagesDir + im.filenameThumb);
				return;
			} catch (IOException e) {
				e.printStackTrace();
				return;
			}
		} else {	
			size = im.scatterSize;
		}

		pos = getImagePositions(im);
		pos[0] = pos[0] - (size[1] / 2);
		pos[1] = pos[1] - (size[2] / 2);
		
		// calc class center
		im.dataClass.avgX += pos[0];
		im.dataClass.avgY += pos[1];
		
		RescaleOp rop = null;
		if (dim) {
			float[] scales = { 1f, 1f, 1f, 0.5f };
			float[] offsets = new float[4];
			rop = new RescaleOp(scales, offsets, null);
		}

		rect(pos[0], pos[1], size[1], size[2]);
		g2.drawImage(im.scatterImage, rop, pos[0], pos[1]);
	}
	
	private void resetClassAvg() {
		for (DataClass c : DB.DataClasses) {
			c.avgX = 0.0f;
			c.avgY = 0.0f;
		}
	}

	private void drawClassCenters() {
		colorMode(HSB, 360, 100, 100);
		strokeWeight(2);
		stroke(color(360, 100, 100));

		for (DataClass c : DB.DataClasses) {
			// hide invisible classes
			if (!c.visible)
				continue;

			fill(color(c.hue, 100, 100));
			ellipse(c.avgX / c.itemCount, c.avgY / c.itemCount, 15, 15);
		}
	}

}