package Views;

import processing.core.PFont;

import Models.DataCol;
import Models.DataImage;
import Popups.Popups;

import Helpers.DistancePointSegment;

public class ViewParallel extends FeatureView {

	private static final long serialVersionUID = 1L;
	
	/* std. dev */
	private float maxStdDev					= 0.0f;
	private float minStdDev					= Float.MAX_VALUE;
	
	/* mouse click */
	private float closestDist;
	
	/* clickable col names */
	float colnamesTop, colnamesBottom;
	
	float lineAlpha							= 100.0f;


	public void setup() {
		size(1000, 500);
		noLoop();
		smooth();
		
		/* paddings */
		plotX1 = 40;
		plotX2 = width - plotX1;
		plotY1 = 45;
		plotY2 = height - 34;
		
		/* col names region */
		colnamesTop		= plotY2 + 18;
		colnamesBottom	= plotY2 + 38;
	}

	public void DBloaded() {
		maxStdDev	= 0.0f;
		minStdDev	= Float.MAX_VALUE;
		
		updateFooter();

		setColAvg();
		setClassColors ();
		setItemDeviations();

		redraw();
	}
	
	public void draw() {	
		colorMode(RGB, 255);
		background(0, 0, 0);

		if (DB != null && DB.DataVisibleCols.size() > 1) {
			drawCols();
			drawDataLines();
		}

		noLoop();
	}
	
	public void redraw() {
		loop();
	}
	
	public void mousePressed() {		
		if (mouseButton == LEFT && mouseY > colnamesTop && mouseY < colnamesBottom)
			mousePressedCol();
		else if (mouseButton == RIGHT)
			mousePressedReset();
		else if (mouseButton == LEFT || mouseButton == CENTER)
			mousePressedHighlight();
	}
	
	private void mousePressedCol() {		
		float x;
		float d;
		int colCount = DB.DataVisibleCols.size()-1;
		
		if (colCount <= 1)
			return;
		
		float closestDist	= Float.MAX_VALUE;
		int closest			= 0;

		for (int i=0; i<colCount; i++) {
			x = map(i, 0, colCount, plotX1, plotX2);
			d = dist(x, colnamesTop, mouseX, mouseY);
			
			if (d < closestDist) {
				closestDist	= d;
				closest		= i;	
			}
		}
		
		DB.DataVisibleCols.get(closest).visible = false;
		DB.DataVisibleCols.remove(closest);
		redraw();
		updateFooter();

		Popups.updateFeatureSelector();
	}

	private void mousePressedReset() {
		DB.highlightNode	= null;
		DB.highlightClass	= null;
		redraw();
		updateFooter();
	}

	private void mousePressedHighlight() {
		float[] pos;
		float d;
		closestDist = Float.MAX_VALUE;
		
		DB.highlightNode	= null;
		DB.highlightClass	= null;
		
		boolean useClass = (mouseButton == CENTER || (keyPressed && mouseButton == LEFT && (keyCode == 157 || keyCode == CONTROL)));

		for (DataImage im : DB.DataItems)	{
			
			// hide invisible classes
			if (!im.dataClass.visible)
				continue;

			for (int i=0; i<DB.DataVisibleCols.size()-1; i++) {
				pos = getImagePositions(im, i);
				d = new Float(DistancePointSegment.distanceToSegment(mouseX,mouseY,pos[0],pos[1],pos[2],pos[3]));
				if (d < closestDist) {
					closestDist = d;
					if (useClass)
						DB.highlightClass = im.dataClass;
					else
						DB.highlightNode = im;
				}
			}
		}
		redraw();
		updateFooter();
	}

	private void setColAvg() {
		int lineCount = DB.DataItems.size();
		DataCol col;

		for (int i=0; i<DB.DataCols.size(); i++) {
			col = DB.DataCols.get(i);
			col.avgValue = col.sumValue / lineCount;
		}
	}
	
	private void setItemDeviations() {
		float stdDev;

		for (DataImage im : DB.DataItems)	{
			stdDev = 0.0f;
			
			for (int i=0; i<im.colData.length-1; i++)
				stdDev += sqrt(pow(im.colData[i] - DB.DataCols.get(i).avgValue, 2));
			
			im.stdDev = stdDev;
			
			// min & max
			if (stdDev < minStdDev) minStdDev = stdDev;
			if (stdDev > maxStdDev) maxStdDev = stdDev;
		}
	}
	
	private void drawCols() {
		int i;
		float x;

		colorMode(RGB, 255);
		stroke(70);
		strokeWeight(1);

		PFont plotFont = createFont("Calibri", 12);
		textFont(plotFont);
		fill(150);
		
		i = 0;
		int colCount = DB.DataVisibleCols.size()-1;

		for (DataCol col : DB.DataVisibleCols) {
			x = map(i, 0, colCount, plotX1, plotX2);
			line(x, plotY1, x, plotY2);
			
			textAlign(CENTER, TOP);

			// name
			fill(240);
			text(col.name, x, plotY2 + 18);
			fill(150);

			col.minValue = col.ominValue;
			col.maxValue = col.omaxValue;
			
			// min
			text(String.format("%13.2e", col.minValue), x, plotY2 + 3);
			
			// max
			textAlign(CENTER, BOTTOM);
			text(String.format("%13.2e", col.maxValue), x, plotY1 - 3);
			
			i++;
		}
	}

	private float[] getImagePositions(DataImage im, int i) {
		float pos[] = new float[4];
		int colsCount = DB.DataVisibleCols.size()-1;

		DataCol col1 = DB.DataVisibleCols.get(i);
		DataCol col2 = DB.DataVisibleCols.get(i+1);

		pos[0] = map(i, 0, colsCount, plotX1, plotX2);
		pos[2] = map(i+1, 0, colsCount, plotX1, plotX2);

		pos[1] = map(im.colData[col1.index], col1.minValue, col1.maxValue, plotY2, plotY1);
		pos[3] = map(im.colData[col2.index], col2.minValue, col2.maxValue, plotY2, plotY1);
		
		return pos;
	}
	
	private void drawDataLines() {
		strokeWeight(1.0f);
		colorMode(HSB, 360, 100, 100, 100);
		
		// alpha
		int countVisibleClasses = 0;
		for (int i=0; i<DB.DataClasses.size(); i++) {
			if (DB.DataClasses.get(i).visible)
				countVisibleClasses++;
		}
		

		// draw only highlighted class
		if (DB.highlightClass != null) {
			lineAlpha = 100.0f;

			for (DataImage im : DB.DataItems)	
				if (im.dataClass.equals(DB.highlightClass))
					drawImageDataLines(im, false, true);

		// draw all lines
		} else {

			lineAlpha = 100.0f - ((float) countVisibleClasses / (float) DB.DataClasses.size()) * 75.0f;		
			Boolean dim = (DB.highlightNode != null);

			// draw all non highlighted items
			for (DataImage im : DB.DataItems)		
				drawImageDataLines(im, dim, false);
	
			// draw single highlighted
			if (DB.highlightNode != null)
				drawImageDataLines(DB.highlightNode, false, true);
		}
	}

	private void drawImageDataLines(DataImage im, Boolean dim, Boolean highlight) {			
		// hide invisible classes
		if (!im.dataClass.visible)
			return;

		float[] pos;
		float brightness;
		
		if (dim)
			brightness = 20;
		else if (highlight)
			brightness = 100;
		else
			brightness = map(im.stdDev, minStdDev, maxStdDev, 30, 100);
		
		stroke(color(im.dataClass.hue, 100, brightness, lineAlpha));

		for (int i=0; i<DB.DataVisibleCols.size()-1; i++) {
			pos = getImagePositions(im, i);
			line(pos[0], pos[1], pos[2], pos[3]);
		}
	}

}