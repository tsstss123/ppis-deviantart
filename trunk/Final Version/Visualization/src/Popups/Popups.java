package Popups;

public class Popups {

	public static FeatureSelector featureSelector;
	public static ClassSelector classLabels;
	
	
	public Popups() { }
	
	public static void showFeatureSelector() {
		if (featureSelector != null) return;

		featureSelector = new FeatureSelector();		
	}

	public static void updateFeatureSelector() {
		if (featureSelector != null)
			featureSelector.update();
	}
	
	public static void showClassSelector() {
		if (classLabels != null) return;

		classLabels = new ClassSelector();		
	}
}
