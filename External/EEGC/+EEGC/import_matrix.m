function eegset_obj = import_matrix(m, varargin)
% import_matrix() - Imports a matrix object
%
% Usage:
%
%   >> EEGSET_OBJ = import_matrix(M, 'opt1', val1, ..., 'optn', valn)
%
% Inputs:
%   M           - A numeric matrix
%   
% Outputs:
%   EEGSET_OBJ  - The generated EEGC.eegset object
%
% 
% Optional option/value pairs: see help EEGC.eegset
%
%
% #-----------------------------------------------------------------------#
% # The EEGC package for MATLAB                                           #
% #-----------------------------------------------------------------------#
% # Author:  German Gomez-Herrero <g.gomez@nin.knaw.nl>                   #
% #          Netherlands Institute for Neuroscience                       #
% #          Amsterdam, The Netherlands                                   #
% #-----------------------------------------------------------------------#
%
% See also: EEGC, EEGC.eegset

import EEGC.eegset;
import PSET.generate_data;
import MISC.ispset;

if ~ispset(m),
    m = generate_data('matrix', size(m,1), size(m,2), 'matrix', m, varargin{:});    
end

eegset_obj = eegset(m.DataFile, m.NbDims, varargin{:});