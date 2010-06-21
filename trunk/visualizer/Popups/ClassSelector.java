package Popups;
import java.awt.Color;
import java.awt.Dimension;
import java.awt.Toolkit;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.ItemEvent;
import java.awt.event.ItemListener;
import java.util.ArrayList;
import java.util.Random;

import javax.swing.BoxLayout;
import javax.swing.JButton;
import javax.swing.JCheckBox;
import javax.swing.JFrame;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.ScrollPaneConstants;

import deviantART.deviantART;

import Models.DataClass;

public class ClassSelector extends JFrame implements ItemListener, ActionListener  {

	private static final long serialVersionUID = 1L;
	private JPanel checkboxesHolder				= new JPanel();
	private ArrayList<JCheckBox> checkboxes		= new ArrayList<JCheckBox>();

	public ClassSelector() {		
		super("Class labels");

		Toolkit tk = Toolkit.getDefaultToolkit();
		Dimension screenSize = tk.getScreenSize();
		int screenW = screenSize.width;
		
		setLayout(new BoxLayout(getContentPane(), BoxLayout.Y_AXIS));
		
		checkboxesHolder.setLayout(new BoxLayout(checkboxesHolder, BoxLayout.Y_AXIS));
		checkboxesHolder.setBackground(Color.black);

		JScrollPane scrollPane = new JScrollPane(checkboxesHolder,
				ScrollPaneConstants.VERTICAL_SCROLLBAR_AS_NEEDED,
	            ScrollPaneConstants.HORIZONTAL_SCROLLBAR_NEVER);
		scrollPane.setBorder(null);
		add(scrollPane);

		init();
		
		setPreferredSize(new Dimension(200, 600));
		setBackground(Color.black);
		setLocation(screenW - (425), 10);
		pack();
		setVisible(true);
	}

	public void init() {		
		JCheckBox check;

		for (DataClass c : deviantART.DBFeatures.DataClasses) {
			check = new JCheckBox(c.name, c.visible);
			check.setForeground(Color.getHSBColor(c.hue/360,1.0f,1.0f));
			check.setBackground(Color.black);
			check.addItemListener(this);

			checkboxes.add(check);
			checkboxesHolder.add(check);
		}
		
		JButton btn;
		
		btn = new JButton("Select All");
		btn.addActionListener(this);
		checkboxesHolder.add(btn);

		btn = new JButton("Select None");
		btn.addActionListener(this);
		checkboxesHolder.add(btn);
		
		btn = new JButton("Suprise me");
		btn.addActionListener(this);
		checkboxesHolder.add(btn);
		
		btn = new JButton("Invert");
		btn.addActionListener(this);
		checkboxesHolder.add(btn);
	}
	
	public void actionPerformed(ActionEvent e) {
		JButton btn = (JButton) e.getSource();
		String text = btn.getText();
		
		if (text == "Select All")
			selectAll(true);
		else if (text == "Select None")
			selectAll(false);
		else if (text == "Invert")
			invert();
		else if (text == "Suprise me")
			random();
	}
	
	private void random() {
		Random random = new Random(); 
		
		for (JCheckBox c : checkboxes)
			c.setSelected(random.nextBoolean());
		
		deviantART.viewObject.redraw();		
	}
	
	private void invert() {
		for (JCheckBox c : checkboxes)
			c.setSelected(!c.isSelected());
		
		deviantART.viewObject.redraw();	
	}
	
	private void selectAll(boolean state) {
		for (JCheckBox c : checkboxes)
			c.setSelected(state);
		
		deviantART.viewObject.redraw();
	}
	
	public void itemStateChanged(ItemEvent e) {
		Object source = e.getItemSelectable();
		Boolean checked = (e.getStateChange() == ItemEvent.SELECTED);
		
		JCheckBox check;
		DataClass c;
		
		for (int i=0; i<deviantART.DBFeatures.DataClasses.size(); i++) {
			check	= checkboxes.get(i);
			c		= deviantART.DBFeatures.DataClasses.get(i);

			if (source == check)
				c.visible = checked;
		}

		deviantART.viewObject.redraw();
	}
	
}
