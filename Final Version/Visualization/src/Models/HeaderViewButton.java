package Models;

import java.awt.Cursor;
import java.awt.Dimension;

import javax.swing.ImageIcon;
import javax.swing.JLabel;

public class HeaderViewButton {
	
	public String name;
	public String filename;
	public String filenameActive;
	public ImageIcon icon;
	public ImageIcon iconActive;
	
	public JLabel label;
	private Cursor hander		= new Cursor (Cursor.HAND_CURSOR);
	
	public boolean active		= false;

	public HeaderViewButton(String name, String filename, String filenameActive) {
		this.name			= name;
		this.filename		= filename;
		this.filenameActive	= filenameActive;
		
		icon		= new ImageIcon("images/buttons/" + filename);
		iconActive	= new ImageIcon("images/buttons/" + filenameActive);
		
		label		= new JLabel(icon);
		label.setPreferredSize(new Dimension(160, 47));
		label.setCursor (hander);
	}
	
	public void setActive() {
		active = true;
		label.setIcon(iconActive);
	}
	
	public void setInactive() {
		active = false;
		label.setIcon(icon);
	}
	
}
