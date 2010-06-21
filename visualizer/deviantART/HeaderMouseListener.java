package deviantART;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;
import java.io.IOException;
import java.net.URI;
import java.net.URISyntaxException;
 
class HeaderMouseListener extends MouseAdapter {

	public final static String UVA			= "UVA";
	public final static String OPEN			= "OPEN";
	    
	private String action;
	private Header header;
	    
	public HeaderMouseListener(Header header, String action) {
		this.header		= header;
		this.action		= action;
	}
	 
	@Override
	public void mouseClicked(MouseEvent event) {
		if (action == UVA)
			UVA();
		else if (action == OPEN)
			open();
		else if (action == deviantART.VIEW_SCATTER || action == deviantART.VIEW_PARALLEL || action == deviantART.VIEW_RADIAL)
			setView(action);

		super.mouseClicked(event);
	}
	
	private void setView(String view) {
		header.setView(view);		
	}
		
	private void UVA() {
    	try {
			java.awt.Desktop.getDesktop().browse(new URI("http://www.uva.nl"));
		} catch (IOException e) {
			e.printStackTrace();
		} catch (URISyntaxException e) {
			e.printStackTrace();
		}
	}
	
	private void open() {
		header.open();
	}
}