package deviantART;
import java.awt.Dimension;
import java.awt.FlowLayout;
import java.awt.Graphics;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.util.ArrayList;

import javax.imageio.ImageIO;
import javax.swing.*;

import Models.HeaderViewButton;

public class Header extends JPanel {
	
	private static final long serialVersionUID = 1L;

	private deviantART mainApp;
	private BufferedImage img;
	private ArrayList<HeaderViewButton> viewButtons	= new ArrayList<HeaderViewButton>();


	public Header(deviantART mainApp) {
		super();
		
		this.mainApp = mainApp;
		
		setAlignmentX(LEFT_ALIGNMENT);
		setLayout(new FlowLayout(FlowLayout.RIGHT, 0, 0));
		setPreferredSize(new Dimension(1000,56));
		
		initLayout();
	}
	
	private void initLayout() {
		try {
			img = ImageIO.read(new File("images/header2.png"));
		} catch (IOException e) {
			e.printStackTrace();			
		}
		
		repaint();
		addButtons();
	}
	
	public void paintComponent(Graphics g) {
		g.drawImage(img, 0, 0, null);
	}

	private void addButtons() {
		JLabel label;
		HeaderViewButton button;

		// open
		label			= createButton("open.png", 35, 47);
		label.addMouseListener(new HeaderMouseListener(this, HeaderMouseListener.OPEN));
		add(label);

		// export
		label			= createButton("export.png", 36, 47);
		add(label);

		// parallel
		button			= new HeaderViewButton(deviantART.VIEW_PARALLEL, "view_parallel.png", "view_parallel_a.png");
		viewButtons.add(button);
		label			= button.label;
		label.addMouseListener(new HeaderMouseListener(this, deviantART.VIEW_PARALLEL));
		add(label);

		// spacer
		label			= new JLabel();
		label.setPreferredSize(new Dimension(1, 47));
		add(label);

		// scatter
		button			= new HeaderViewButton(deviantART.VIEW_SCATTER, "view_scatter.png", "view_scatter_a.png");
		viewButtons.add(button);
		label			= button.label;
		label.addMouseListener(new HeaderMouseListener(this, deviantART.VIEW_SCATTER));
		add(label);
		
		// spacer
		label			= new JLabel();
		label.setPreferredSize(new Dimension(1, 47));
		add(label);
		
		// scatter
		button			= new HeaderViewButton(deviantART.VIEW_RADIAL, "view_radial.png", "view_radial_a.png");
		viewButtons.add(button);
		label			= button.label;
		label.addMouseListener(new HeaderMouseListener(this, deviantART.VIEW_RADIAL));
		add(label);

		// uva
		label			= createButton("uva.png", 48, 47);
		label.addMouseListener(new HeaderMouseListener(this, HeaderMouseListener.UVA));
		add(label);

		updateButtons(deviantART.activeView);
	}
	
	public JLabel createButton(String filename, int w, int h) {
		ImageIcon ii	= new ImageIcon("images/buttons/" + filename);
		JLabel label	= new JLabel(ii);
		label.setPreferredSize(new Dimension(w, h));
		label.setCursor (deviantART.hander);
		return label;
	}

	public void setView(String view) {
		updateButtons(view);
		mainApp.addView(view);
	}
	
	public void updateButtons(String view) {
		for (HeaderViewButton b : viewButtons) {
			if (!b.active && b.name.equals(view))
				b.setActive();
			else if (b.active && !b.name.equals(view))
				b.setInactive();	
		}
	}
	
	public void open() {
		mainApp.selectFile();
	}
	
}
