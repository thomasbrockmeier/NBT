function y = copy(obj, varargin)
% copy() - Copies a pset object
%
% Usage:
%   >> Y = copy(X)
%   >> Y = copy(X, PNAME1, PVAL1, ..., PNAMEn, PVALn) 
%
% Input:
%   X   - A PSET.pset object
%
% Output:
%   Y   - A PSET.pset object which is a copy of X
%
% Note:
%   The optional (pname,pvalue) pairs can be used to modify the properties
%   of the cloned pset object. For instance, the command:
%
%   >> Y = copy(X, 'Temporary', false)
%
%   will enforce that Y is not temporary, regardless whether X was or was
%   not temporary. Method copy() accepts the same (pname, pvalue) pairs as
%   the constructor PSET.pset.
%
%
% See also: PSET.pset

import PSET.globals;
import PSET.pset;
import MISC.process_varargin;

DATA_EXT = globals.evaluate.DataFileExt;

THIS_OPTIONS = {'datafile'};

datafile = [];

eval(process_varargin(THIS_OPTIONS, varargin));

if isempty(datafile),
    datafile = session.getInstance.tmpFileName;
end

% Create a copy of the data file
[pathstr, new_name] = fileparts(datafile);
if isempty(pathstr),
    try
        new_name = [session.getInstance.Folder filesep new_name DATA_EXT]; 
    catch  %#ok<CTCH>
        new_name = [pwd filesep new_name DATA_EXT];    
    end
else
    new_name = [pathstr filesep new_name DATA_EXT];
end
copyfile(obj.DataFile, new_name);

% Create a pset object associated to the new files
y = pset(new_name, obj.NbDims, varargin{:});

end