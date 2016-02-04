#Info about networks

# Introduction #

there are multiple network models, from the paper references given I looked into:<br>
<br><a href='http://en.wikipedia.org/wiki/Erd%C5%91s%E2%80%93R%C3%A9nyi_model'>Erdős–Rényi model</a><br>
- This does not seem to fit because of "random network connections", the clustering for these networks will probably be low<br>
<br><a href='http://en.wikipedia.org/wiki/Barab%C3%A1si%E2%80%93Albert_model><br'>
- Barabási–Albert model</a> This is a generative scale-free model, which might fit if our network is scale free, which we can discover by looking if the degree distribution follows the power law<br>
<br><a href='http://en.wikipedia.org/wiki/Watts_and_Strogatz_model'>Watts and Strogatz model</a><br>
- Also Small world network, has both local clustering as well as short characteristic paths<br>
<br>
<br>
Conclusion once we have the network we should look at: <br>
- the degree distribution,<br>
- the cluster coefficients and<br>
- the average path length. <br>
these should be possible to cumpute using Pajek<br>
<br>
Then we can decide which model fits and hopefully draw conclusions from that<br>
<br>
<h1>Our DA network</h1>
results <br>
Some basic statistics:<br>
Number of Nodes: 103663 <br>
Number of Links: 4483023 <br>
Average Node Degree: 43.25 <br>
Fraction of reciprocal links: 17.65% <br>
Average Clustering Coefficient: 0.087% <br>

max recursive out degree 44, 1471 nodes <br>
Number of unreachable pairs: 8820<br>
Average distance among reachable pairs: 2.27161<br>
max recursive in degree 43, 1701 nodes <br>
Number of unreachable pairs: 360400 <br>
Average distance among reachable pairs: 2.15401 <br>
max recursive all degree 185, 1099 nodes <br>
Number of unreachable pairs: 97299 <br>
Average distance among reachable pairs: 2.13630 <br>
CoOccurences in in,out, all core <br>
<ol><li>01         541          54<br>
<blockquote>541        1471         286<br>
54         286        1099<br>
Occurence in all 3:<br>
14<br>
</blockquote></li></ol><blockquote>'blackwhiters'<br>
'swmmp'<br>
'armaina'<br>
'vsconcepts'<br>
'norke'<br>
'stelthman'<br>
'clintonkun'<br>
'duhcoolies'<br>
'cheeks-74'<br>
'moonbeam13'<br>
'artisticaunjuli'<br>
'elicoronel16'<br>
'ctjemm'<br>
'cocodrillo'