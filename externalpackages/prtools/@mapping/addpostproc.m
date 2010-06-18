%ADDPOSTPROC Add mapppings in POSTPROC field of a datafile
%
%   A = ADDPOSTPROC(A,MAPPING)
%   A = ADDPOSTPROC(A)
%
% INPUT
%   A        - Datafile
%   POSTPROC - Postprocessing mapping command
%
% OUTPUT
%   A       - Datafile
%
% DESCRIPTION
% Extends the set of mappings stored in A.POSTPROC.
% Existing mappings are extended sequentially: 
%      A.POSTPROC = A.POSTPROC * MAPPING
%
% Mappings in A.POSTPROC are stored only and executed just 
% after A is converted from a DATAFILE into a DATASET.
% The feature size of the datafile A is reset to the output
% size of MAPIING.
% The POSTPROC field  of A can be reset by SETPOSTPROC.
%
% SEE ALSO
% DATAFILES, SETPREPROC, SETPOSTPROC
