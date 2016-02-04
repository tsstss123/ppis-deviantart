# Bart's Log #

# We 2-6-2010 #
Discussed some data-structure ideas with Davide <br>
Discussed network links, favorites vs. viewers <br>

<h1>Th 3-6-2010</h1>
Installing work enviroment on my computer, matlab python svn etc.<br>
Researching network links  <br>
trying out scrapy for python,<br>
needs, python2.6, zope.interface, twisted10,  pywin, libxml2, lxml,<br>
<a href='http://users.skynet.be/sbi/libxml-python/'>http://users.skynet.be/sbi/libxml-python/</a><br>

<h1>Fri 4-6-2010</h1>
Group meeting took notes <br>
Made scraper with Sander, does not store correct data bur crawls along the relevant images <br>

<h1>Weekend</h1>
Finished scraper now stores relevant data and stores intermediates these every 5 minutes<br>
Started a run Sunday evening<br>

<h1>Mo 7-6-2010</h1>
Looked at results from 2 hr run in Pajek total nodes about 40.000, maximum in degree 3, about 600 nodes with an out degree of at least one, nodes with out degree of 0 have been visited and have no watchers, or have not been visited. <br>

<h1>Tu 8-6-2010</h1>
Fixed network scraper, made it less disk intensive, now automatically reads in partial results and continues, spend time researching why -az.deviantart.com does not work on unix. this is because it's an illegal url. on windows it does work. <br>
Running scraper again <br>
researched networks <br>
DONE wiki on networks, meeting and goals<br>
<br>
<h1>We 9-6-2010</h1>
Looked at previous mean-shift tracker code, if there is anything useful in there, its colorspaces, histograms and histogram distance. <br>
Refamiliarized with matlab <br>
Made matlab feature extractor and image reader <br>
implemented Weibull <br>
GMailinglist since blackboard takes a day to mail. <br>

<h1>Th 10-06-2010</h1>
Nothing worth noting<br>
<br>
<h1>Fri 11-06-2010</h1>
Meeting + notes in wiki<br>
<br>
<h1>Sat 12-06-2010</h1>
More wiki notes of meeting<br>
<br>
<h1>Sun 13-06-2010</h1>
Network crawling finished<br>
<br>
<h1>Mon 14-06-2010</h1>
Mostly football and some research into networks and weibull<br>
<br>
<h1>Tue 15-06-2010</h1>
Called group meeting to integrate all the islands and discuss experiments<br>
Started network analysis in matlab Pajek cant handle nets this big<br>
Lev Meeting<br>
evening worked on having our files transformed for use with networking toolkit<br>
<br>
<h1>Wed 16-06-2010</h1>
helped think about classifier and integration <br>
more input into networking toolkit <br>
starting analysis in networking toolkit <br>
helped with saliency features <br>

<h1>Thu 17-06-2010</h1>
Code cleanup <br>
weird matlab crash and cmd window: should be fixed with KMP_DUPLICATE_LIB_OK=True as enviroment variable . <br>
more code cleanup <br>
more network analysis <br>
helped with saliency feature extraction integration <br>
helped with classify <br>

looked at this for networks <br>
Self-emergence of knowledge trees: Extraction of the Wikipedia hierarchies <br>

<h1>Fri 18-06-2010</h1>
Helped Quan n Nick, generakl trouble shooting  <br>
Had meeting about report and why we do what experiments <br>
1st version of LDA, PCA code <br>

<h1>Sat 19-06-2010</h1>
improved LDA, PCA code<br>
troubleshooting Weibull, te veel absoluut 0 geeft problemen met NaN, im(im==0)=eps; is de oplossing <br>

<h1>Mon 20-06-2010</h1>
Pca, lda onm big dataset <br>
Meeting <br>
Literature on Networks google search on, "social networks" "online social netwoks" + art + artist + flickr.<br>
<br>
<h1>Tue 21-06-2010</h1>
made slides on network, pca, networks slides.<br>
Literature in Bibtex on Weibull<br>
investigated more into core network<br>
<br>
<h1>Wed 22-06-2010</h1>
Pre-presentation work<br>
Presentation<br>
Debug of network scraper code Oops<br>
<br>
<h1>Thu 23-06-2010</h1>
big report meeting<br>
read literature<br>
wrote average image function to show dataset in report<br>
<br>
<h1>Fri 24-06-2010</h1>
Wrote Weibull, <br>
Wrote Future work <br>
Wrote Previous work, working through network references <br>

<h1>Sat 25-06-2010</h1>
sick<br>
<br>
<h1>Sun 26-06-2010</h1>
Studied & wrote networks section<br>
and Appendix<br>
<br>
<h1>Mon 27-06-2010</h1>
wrote networks experiments<br>
rewrote introduction<br>
<br>
<h1>Tue 28-06-2010</h1>
Edited whole paper together<br>
Wrote conclusion<br>
Started code cleanup<br>
<br>
<br>
<br>
first few pca eigenvalues(out of 156)<br>
<blockquote>0.2581<br>
0.0159<br>
0.0033<br>
0.0014<br>
0.0014<br>
0.0012<br>
0.0008<br>
0.0008<br>
0.0005<br>
0.0003<br>
0.0003<br>
0.0002<br>
0.0002<br>
0.0002<br>
0.0002<br>
0.0002<br>
0.0001<br>
0.0001<br>
0.0001<br>
0.0001<br>
0.0001<br>
0.0001<br>
0.0001<br>
0.0001<br>
0.0001<br>
0.0001<br>
0.0001<br>
0.0000</blockquote>

rotatie matrix<br>
<blockquote>0.0064    0.0998<br>
0.0086    0.1114<br>
0.0066    0.0986<br>
0.0065    0.1094<br>
0.0072    0.0923<br>
0.0042    0.0674<br>
0.0045    0.0940<br>
0.0085    0.1127<br>
0.0058    0.1006<br>
0.0058    0.1112<br>
0.0063    0.0994<br>
0.0085    0.1110<br>
0.0066    0.0979<br>
0.0064    0.1096<br>
0.0070    0.0917<br>
0.0043    0.0663<br>
0.0044    0.0940<br>
0.0083    0.1123<br>
0.0057    0.1001<br>
0.0056    0.1117<br>
0.0000    0.0033<br>
</blockquote><blockquote>-0.0002    0.0032<br>
<blockquote>0.0002    0.0025<br>
</blockquote>-0.0003    0.0027<br>
<blockquote>0.0001    0.0042<br>
0.0005    0.0042<br>
0.0001    0.0036<br>
</blockquote>-0.0001    0.0032<br>
<blockquote>0.0002    0.0027<br>
</blockquote>-0.0003    0.0029<br>
<blockquote>0.0064    0.0997<br>
0.0085    0.1110<br>
0.0066    0.0979<br>
0.0063    0.1097<br>
0.0071    0.0921<br>
0.0045    0.0674<br>
0.0045    0.0944<br>
0.0083    0.1124<br>
0.0058    0.1001<br>
0.0055    0.1120<br>
0.0063    0.0984<br>
0.0084    0.1094<br>
0.0066    0.0970<br>
0.0064    0.1083<br>
0.0070    0.0905<br>
0.0045    0.0666<br>
0.0046    0.0931<br>
0.0083    0.1106<br>
0.0058    0.0990<br>
0.0056    0.1104<br>
</blockquote>-0.0006   -0.0298<br>
-0.0010   -0.0322<br>
-0.0003   -0.0309<br>
-0.0007   -0.0323<br>
-0.0007   -0.0270<br>
-0.0000   -0.0222<br>
-0.0002   -0.0286<br>
-0.0012   -0.0312<br>
-0.0006   -0.0313<br>
-0.0007   -0.0320<br>
<blockquote>0.0000    0.0000<br>
0.0028    0.0092<br>
0.0018    0.0131<br>
0.0024    0.0057<br>
0.0036    0.0125<br>
0.0023    0.0212<br>
0.0029    0.0091<br>
0.0028    0.0116<br>
0.0024    0.0163<br>
0.0024    0.0099<br>
0.0000    0.0000<br>
0.0000    0.0000<br>
0.0000    0.0000<br>
0.0000    0.0000<br>
0.0000    0.0000<br>
0.0000    0.0000<br>
0.0000    0.0000<br>
0.0000    0.0000<br>
0.0000    0.0000<br>
0.0000    0.0000<br>
0.0000   -0.0006<br>
0.9980   -0.0616<br>
0.0098    0.1288<br>
0.0075    0.1194<br>
0.0067    0.1280<br>
0.0079    0.1127<br>
0.0049    0.0822<br>
0.0044    0.1127<br>
0.0091    0.1291<br>
0.0062    0.1210<br>
0.0057    0.1290<br>
0.0099    0.1281<br>
0.0078    0.1193<br>
0.0068    0.1288<br>
0.0079    0.1131<br>
0.0053    0.0823<br>
0.0047    0.1136<br>
0.0090    0.1287<br>
0.0064    0.1207<br>
0.0057    0.1299<br>
</blockquote>-0.0005    0.0018<br>
-0.0002    0.0002<br>
-0.0006    0.0017<br>
-0.0003    0.0016<br>
<blockquote>0.0001    0.0026<br>
</blockquote>-0.0005    0.0013<br>
-0.0005    0.0017<br>
-0.0002    0.0006<br>
-0.0007    0.0021<br>
<blockquote>0.0101    0.1272<br>
0.0083    0.1181<br>
0.0069    0.1276<br>
0.0087    0.1127<br>
0.0062    0.0834<br>
0.0052    0.1132<br>
0.0093    0.1279<br>
0.0069    0.1192<br>
0.0058    0.1294<br>
0.0098    0.1263<br>
0.0081    0.1180<br>
0.0069    0.1268<br>
0.0083    0.1118<br>
0.0061    0.0832<br>
0.0050    0.1127<br>
0.0091    0.1264<br>
0.0067    0.1189<br>
0.0058    0.1280<br>
</blockquote>-0.0020   -0.0368<br>
-0.0013   -0.0366<br>
-0.0015   -0.0362<br>
-0.0015   -0.0317<br>
-0.0009   -0.0249<br>
-0.0010   -0.0332<br>
-0.0019   -0.0348<br>
-0.0015   -0.0363<br>
-0.0015   -0.0356<br>
<blockquote>0.0072    0.1303<br>
0.0074    0.1305<br>
</blockquote>-0.0007    0.0002<br>
<blockquote>0.0083    0.1284<br>
0.0079    0.1282<br>
</blockquote>-0.0022   -0.0372<br>
<blockquote>0.0000   -0.0000<br>
</blockquote>-0.0000    0.0000<br>
<blockquote>0.0000   -0.0000<br>
0.0000    0.0008<br>
</blockquote>-0.0004   -0.0003<br>
-0.0000    0.0001<br>
-0.0002   -0.0001<br>
<blockquote>0.0000    0.0000<br>
0.0000   -0.0000<br>
</blockquote>-0.0000    0.0000<br>
<blockquote>0.0000   -0.0000<br>
0.0000   -0.0000<br>
</blockquote>-0.0000   -0.0000<br>
<blockquote>0.0000   -0.0001</blockquote></blockquote>

<h1>todo</h1>
better understand  & Networks