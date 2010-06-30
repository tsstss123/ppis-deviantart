Makes use of : Complex Networks Package for MatLab
http://www.levmuchnik.net/Content/Networks/ComplexNetworksPackage.html
Though most of that package was later deemed to be unstable when modifying networks, because
mexGraphSqueeze can make Matlab crash

Functions:
LOADNETWORK loads a network (.arcs .vert)as obtained from scraper_network.py
example (win) loadNetwork('deviant_99')

FINDCORE finds the core of a network as described in report
example G = findCore('all', 185, Graph)
 
DIRECTIONALCC calculates the directional clustering coefficients of nodes in a graph
example cc = directionalCC(Graph) 

Scripts:
SCRIPT_TUTORIAL  Script as provided on the Complex Networks Package for MatLab website
SCRIPT_COREPLOTS Find cores and make degree plots
SCRIPT_CORESTATS Find cores, calculate and show statistics on cores

Notes:A graph variable G should have been assigned before running these scripts.
Some variables are hardcoded in the scripts tailored to this project