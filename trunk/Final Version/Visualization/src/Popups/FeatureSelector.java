package Popups;
import java.awt.Color;
import java.awt.Dimension;
import java.awt.Toolkit;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.ItemEvent;
import java.awt.event.ItemListener;
import java.awt.event.WindowEvent;
import java.awt.event.WindowListener;
import java.util.ArrayList;

import javax.swing.BoxLayout;
import javax.swing.JButton;
import javax.swing.JCheckBox;
import javax.swing.JFrame;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.ScrollPaneConstants;

import deviantART.deviantART;

import Models.DataCol;

/**
 * Popup to select the active features
 * @author Nick
 *
 */
public class FeatureSelector extends JFrame implements ItemListener, ActionListener  {

	private static final long serialVersionUID = 1L;
	private JPanel checkboxesHolder				= new JPanel();
	private ArrayList<JCheckBox> checkboxes		= new ArrayList<JCheckBox>();
	
	public FeatureSelector() {		
		super("Feature selector");
		
		WindowListener wl = new WindowListener() {
			@Override
			public void windowActivated(WindowEvent e) {
				// TODO Auto-generated method stub
				
			}

			@Override
			public void windowClosed(WindowEvent e) {
				// TODO Auto-generated method stub
				
			}

			@Override
			public void windowClosing(WindowEvent e) {
				Popups.featureSelector = null;				
			}

			@Override
			public void windowDeactivated(WindowEvent e) {
				// TODO Auto-generated method stub
				
			}

			@Override
			public void windowDeiconified(WindowEvent e) {
				// TODO Auto-generated method stub
				
			}

			@Override
			public void windowIconified(WindowEvent e) {
				// TODO Auto-generated method stub
				
			}

			@Override
			public void windowOpened(WindowEvent e) {
				// TODO Auto-generated method stub
				
			}
		};

		addWindowListener(wl);

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
		setLocation(screenW - (225), 10);
		pack();
		setVisible(true);
	}

	public void init() {		
		JCheckBox check;

		for (DataCol c : deviantART.DBFeatures.DataCols) {
			check = new JCheckBox(c.name, c.visible);
			check.setForeground(Color.white);
			check.setBackground(Color.black);
			check.addItemListener(this);

			checkboxes.add(check);
			checkboxesHolder.add(check);
		}
		
		JButton btn;

		btn = new JButton("Select None");
		btn.addActionListener(this);
		checkboxesHolder.add(btn);
	}
	
	public void actionPerformed(ActionEvent e) {	
		selectAll(false);
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
		DataCol c;
		
		for (int i=0; i<deviantART.DBFeatures.DataCols.size(); i++) {
			check	= checkboxes.get(i);
			c		= deviantART.DBFeatures.DataCols.get(i);

			if (source == check) {
				c.visible = checked;

				if (c.visible)
					deviantART.DBFeatures.DataVisibleCols.add(c);
				else
					deviantART.DBFeatures.DataVisibleCols.remove(c);
			}
		}

		deviantART.viewObject.redraw();
	}
	
	public void update() {
		JCheckBox check;
		DataCol c;
		
		for (int i=0; i<deviantART.DBFeatures.DataCols.size(); i++) {
			check	= checkboxes.get(i);
			c		= deviantART.DBFeatures.DataCols.get(i);

			if (c.visible != check.isSelected())
				check.setSelected(c.visible);			
		}
	}
	
}
