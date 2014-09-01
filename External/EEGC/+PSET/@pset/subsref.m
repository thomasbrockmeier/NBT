function y = subsref(obj, s)
% SUBSREF Subscripted reference for pset objects
%
%   A(I) is an array formed from the elements of pset object A specified by
%   the  subscript vector I. The resulting array is the same size as I.
%
%   A(I,J) is an array formed from the points specified by index J and from
%   the dimensions specified by the index I. If the Transposed property of
%   object A is set to true, then I identifies point indices while J
%   identifies dimension indices.
%
% See also: PSET/SUBSASGN

import PSET.find_pattern;

if isempty(obj),
    error('PSET:pset:subsref:invalidIndex', ...
        'Index exceeds the dimensions of the pset object.');
end

switch s(1).type
    case '()'
        for i = 1:(length(s(1).subs)-2),
            if any(s(1).subs{i+2}~=1),
                error('PSET:pset:subsref:invalidIndex', ...
                    'A pset object has only two dimensions.');
            end
        end
        
        % Has the pset been transposed?
        if obj.Transposed
            p_order = 1;
            d_order = 2;
        else
            p_order = 2;
            d_order = 1;
        end
        
        
        if length(s(1).subs) > 1
            % a(I,J)
            % Determine point indices
            if ischar(s(1).subs{p_order}) && strcmp(s(1).subs{p_order},':'),
                p_indices = 1:obj.NbPoints;
            elseif isnumeric(s(1).subs{p_order}),
                p_indices = s(1).subs{p_order};
            else
                error('PSET:pset:subsref:invalidIndex', ...
                    'Index must be an scalar array or the string '':''');
            end
            if any(p_indices<0 | p_indices > obj.NbPoints),
                error('PSET:pset:subsref:invalidIndex', ...
                    'Index exceeds the dimensions of the pset object.');
            end
            % Determine dimension indices
            if ischar(s(1).subs{d_order}) && strcmp(s(1).subs{d_order},':'),
                d_indices = 1:obj.NbDims;
            elseif isnumeric(s(1).subs{d_order}),
                d_indices = s(1).subs{d_order};
            else
                error('PSET:pset:subsref:invalidIndex', ...
                    'Index must be an scalar array or the string '':''');
            end
            if any(d_indices<0 | d_indices > obj.NbDims),
                error('PSET:pset:subsref:invalidIndex', ...
                    'Index exceeds the dimensions of the pset object.');
            end
            
            % Initialize output data
            if obj.Transposed
                y = nan(length(p_indices), length(d_indices));
            else
                y = nan(length(d_indices), length(p_indices));
            end
            
            % Sort point indices
            [p_indices, p_indices_unsort] = sort(p_indices, 'ascend');
            
            % Retrive the desired points from the correct filemap
            [m_indices, p_indices] = get_map_index(obj, p_indices);
            u_m_indices = unique(m_indices);
            if obj.Transposed,
                for i = 1:length(u_m_indices)
                    this_map_subset = (m_indices==u_m_indices(i));
                    y(this_map_subset, :) = ...
                        obj.MemoryMap{u_m_indices(i)}.Data.Data(d_indices, ...
                        p_indices(this_map_subset))';
                end                
            else
                for i = 1:length(u_m_indices)
                    this_map_subset = (m_indices==u_m_indices(i));
                    y(:, this_map_subset) = ...
                        obj.MemoryMap{u_m_indices(i)}.Data.Data(d_indices, ...
                        p_indices(this_map_subset));
                end
            end
            
            % Undo the sorting  
            if obj.Transposed,
                y(p_indices_unsort,:) = y;
            else
                y(:,p_indices_unsort) = y;
            end
            
        else
            % a(I)
            
            if ischar(s(1).subs{1}) && strcmp(s(1).subs{1},':'),
                indices = (1:(obj.NbDims*obj.NbPoints))';
            elseif isnumeric(s(1).subs{1}),
                indices = s(1).subs{1};
            else
                error('PSET:pset:subsref:invalidIndex', ...
                    'Index must be an scalar array or the string '':''');
            end
            y = nan(size(indices));
            if obj.Transposed
                col_indices = ceil(indices/obj.NbPoints);
                row_indices = mod(indices-1,obj.NbPoints)+1;                
               
                if length(indices) == obj.NbDims*obj.NbPoints, 
                    this_s.type = '()';
                    this_s.subs = {1:obj.NbPoints, 1:obj.NbDims};
                    y = subsref(obj, this_s);   
                    y = reshape(y, size(indices));
                else
                    % Worst case: very slow -> think of something smarter?
                    for i = 1:length(indices)
                        this_s.type = '()';
                        this_s.subs = {row_indices(i), col_indices(i)};
                        y(i) = subsref(obj, this_s);
                    end
                end
                
            else
                col_indices = ceil(indices/obj.NbDims);
                row_indices = mod(indices-1,obj.NbDims)+1;
                
                pos = find_pattern(row_indices,1:obj.NbDims);
                if length(pos) == ceil(length(indices)/obj.NbDims)
                    % All dimensions are selected for all points
                    this_s.type = '()';
                    this_s.subs = {':',unique(col_indices)};
                    y = subsref(obj, this_s);
                    y = reshape(y, size(indices));
                elseif all(diff(indices)==1) && ~isempty(pos)
                    % At most the first and last point are "cut"
                    for i = 1:(pos(1)-1)
                        this_s.type = '()';
                        this_s.subs = {row_indices(i),col_indices(i)};
                        y(i) = subsref(obj,this_s);
                    end
                    this_s.type = '()';
                    this_s.subs = {1:obj.NbDims,...
                        unique(col_indices(i+1:(pos(end)+obj.NbDims-1)))};
                    y((i+1):(pos(end)+obj.NbDims-1))= ...
                        subsref(obj, this_s);
                    for i = (pos(end)+obj.NbDims):length(indices)
                        this_s.type = '()';
                        this_s.subs = {row_indices(i),col_indices(i)};
                        y(i) = subsref(obj, this_s);
                    end
                else
                    % Worst case: very slow -> think of something smarter?
                    for i = 1:length(indices)
                        this_s.type = '()';
                        this_s.subs = {row_indices(i),col_indices(i)};
                        y(i) = subsref(obj, this_s);
                    end
                end
            end      
        end     
        
    case '.'
        if length(s) < 2,
            y = obj.(s(1).subs);
        else
            y = subsref(obj.(s(1).subs),s(2:end));
        end
        
    otherwise
        error('PSET:pset:subsref:invalidIndexingType',...
            'Indexing of type %s is not allowed for pset objects.', s(1).type);
end