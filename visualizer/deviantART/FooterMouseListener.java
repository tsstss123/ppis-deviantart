package deviantART;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;

import Models.DataImage;
import Popups.Popups;
 
class FooterMouseListener extends MouseAdapter {

	public final static String featuresPressed		= "featuresPressed";
	public final static String classLabelsPressed	= "classLabelsPressed";

	private String action;
    private DataImage im;
 
    public FooterMouseListener(DataImage im) {
    	this.im = im;
    }

    public FooterMouseListener(String action) {
        this.action	= action;
    }
 
    @Override
    public void mouseClicked(MouseEvent event) {
    	if (this.action == featuresPressed)
    		Popups.showFeatureSelector();
    	else if (this.action == classLabelsPressed)
    		Popups.showClassSelector();
    	else
    		showLargeImage();

        super.mouseClicked(event);
    }
    
	private void showLargeImage() {
		new ImagePopup(im);
	}
}