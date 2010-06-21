package Views;

import processing.core.PFont;

import Models.DataConnection;
import Models.DataNode;


public class ViewRadial extends PerformanceView {

	private static final long serialVersionUID = 1L;

	private int radius		= 200;
	private int strokeW 	= 10;
	private int	x			= 0;
	private int y			= 0;
	
	private float minThickness	= 0.5f;
	private float maxThickness	= 2.5f;

	private boolean showPerformanceDetails = false;
	private DataNode highlightCat = null;


	public void setup() {
		size(1000, 500);
		noLoop();
		smooth();
		
		x = width/2;
		y = height/2;
		
		PFont plotFont = createFont("Calibri", 11);
		textFont(plotFont);
	}
	
	public void DBloaded() {
		setClassColors ();

		redraw();
	}
	
	public void draw() {
		colorMode(RGB, 255);
		background(0, 0, 0);
		
		if (DB != null) {
			drawTitles();
			drawConnections();
			drawCircle();
		}

		noLoop();
	}
	
	public void redraw() {
		loop();	
	}
	
	public void keyPressed() {
		if (keyCode == 68) {
			showPerformanceDetails = !showPerformanceDetails;
			redraw();
		}
	}
	
	public void mousePressed() {		
		if (mouseButton == LEFT)
			mousePressedHighlight();
		else if (mouseButton == RIGHT)
			mousePressedReset();
	}

	private void mousePressedReset() {
		highlightCat = null;
		redraw();
	}

	private void mousePressedHighlight() {
		float d;
		float closestDist = Float.MAX_VALUE;
			
		for (DataNode n : DB.DataCategories) {
			if (n.x == -1)
				continue;
			
			d = dist(mouseX,mouseY,n.x, n.y);
			if (d < 40 && d < closestDist) {
				closestDist = d;
				highlightCat = n;
			}
		}
		
		redraw();
	}
	
	private void setClassColors() {
		for (int i=0; i<DB.DataCategories.size(); i++)
			DB.DataCategories.get(i).hue = map(i, 0, DB.DataCategories.size()-1, 40, 300);
	}

	private void drawCircle() {
		colorMode(RGB, 255);
		noFill();
		strokeWeight(strokeW);
		
		int wh = 2*radius + strokeW + 3;
		
		stroke(91, 0, 102);
		arc(x, y, wh, wh, 0.85f*PI, 1.35f*PI);
		
		stroke(126, 89, 0);
		arc(x, y, wh, wh, -0.35f*PI, 0.15f*PI);
		
		stroke(46, 91, 0);
		arc(x, y, wh, wh, 0.38f*PI, 0.62f*PI);
		
		stroke(100);
		strokeWeight(3);
		ellipse(x, y, 2*radius, 2*radius);		
	}

	private void drawTitles() {
		float n;
		int i;

		//text("Press \"d\" key for details", 16, 30);

		n = DB.DataCategories.size() - 1;
		i = 0;
		for (DataNode el : DB.DataCategories) {
			el.a = (0.85f*PI) + (i/n) * (0.5f*PI);
			drawTitle(el, (highlightCat != null && !el.equals(highlightCat)));
			i++;
		}

		n = DB.DataFeatures.size() - 1;
		i = 0;
		for (DataNode el : DB.DataFeatures) {
			el.a = (-0.35f*PI) + (i/n) * (0.5f*PI);
			drawTitle(el);
			i++;
		}

		n = DB.DataClassifiers.size() - 1;
		i = 0;
		for (DataNode el : DB.DataClassifiers) {
			el.a = (0.38f*PI) + (i/n) * (0.24f*PI);
			drawTitle(el);
			i++;
		}
	}
	
	private void drawTitle(DataNode el) {
		drawTitle(el, false);		
	}

	private void drawTitle(DataNode el, boolean dim) {
		String s	= el.name;
		float a		= el.a;

		if (dim)
			fill(100);
		else
			fill(200);
		
		if (showPerformanceDetails)
			s += "\n(" + nf(el.perf, 0, 3) + ")";
		
		if (a >= PI/2 && a < 3*PI/2)
			drawText(s, a, true);
		else
			drawText(s, a, false);
	}
	
	private void drawText(String s, float angle, boolean invert) {
		pushMatrix();
		translate(x, y);
		rotate(angle);
		translate (radius + strokeW + 10, 0);
		if (invert) {
			textAlign(RIGHT, CENTER);
			pushMatrix();
			rotate(PI);
			text(s, 0, 0);
			popMatrix();
		} else {
			textAlign(LEFT, CENTER);
			text(s, 0, 0);
		}
		popMatrix();
	}
	
	private void drawConnections() {
		DataConnection c;
		DataNode from;
		DataNode to;
		float thickness;

		int m = DB.DataConnections.size();
		float a;
		float[] p1, p2, p3, p4;

		//colorMode(HSB, 360, 100, 100);
		noFill();

		for (int i = 0; i < m; i++) {
			c	= DB.DataConnections.get(i);
			from = c.from;
			to	= c.to;
			
			// highlighted
			if (highlightCat != null && c.from != highlightCat)
				continue;
			
			thickness = map(c.thickness, DB.minFeaturePerformance, DB.maxFeaturePerformance, minThickness, maxThickness);
			
			// color
			//stroke(color(c.from.hue, 100, 100));
			if (c.type == DataConnection.FEATURE)
				stroke(255, 180, 0);
			else
				stroke(102, 204, 0);

			a = from.a;
			p1 = angleToPoint(a, radius - 0.5f*thickness);
			p3 = angleToPoint(a, radius * 5);
			
			if (from.x == -1) {
				from.x = (int) p1[0];
				from.y = (int) p1[1];
			}

			a = to.a;
			p2 = angleToPoint(a, radius - 0.5f*thickness);
			p4 = p2;
			p4 = angleToPoint(a, radius * 5);

			if (from.x == -1) {
				from.x = (int) p2[0];
				from.y = (int) p2[1];
			}
			
			strokeWeight(thickness);
			
			curve(p3[0], p3[1], p1[0], p1[1], p2[0], p2[1], p4[0], p4[1]);
		}
	}
	
	private float[] angleToPoint(float a, float radius) {
		float[] pos = new float[2];
		pos[0] = x + cos(a) * radius;
		pos[1] = y + sin(a) * radius;
		return pos;
	}

}