function make_cvlib()
%  make_cvlib -- Make the cvlib_mex in windows. It probably will
%  work as well in Linux/Mac with only minor changes
%
%  Author:	Joaquim Luis
%  Date:	07-Sept-2006


% Adjust for your own path
INCLUDE_CV = '''/Users/Bart/opencv/include/opencv''';
% INCLUDE_CXCORE = '''C:\Program Files\OpenCV\cxcore\include''';
LIB_CV = '''/Users/Bart/opencv/lib/libcv.dylib''';
LIB_CXCORE = '''/Users/Bart/opencv/lib/libcxcore.dylib''';

% -------------------------- Stop editing ---------------------------
include_cv = ['-I' INCLUDE_CV];% ' -I' INCLUDE_CXCORE];
library_cv = [LIB_CV ' ' LIB_CXCORE];

if (ispc)
    opt_cv = '-O -DWIN32 -DDLL_CV100 -DDLL_CXCORE100';
else
    opt_cv = '-O';
end
       
cmd = 'mex cvlib_mex.c -I/usr/local/include/opencv -L/usr/local/lib -lcxcore -lcv -lcvaux -lhighgui -lml'

% cmd = ['mex cvlib_mex.c' ' ' include_cv ' ' library_cv ' ' opt_cv];        
eval(cmd)
    
