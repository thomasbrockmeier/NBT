function obj = subsasgn(obj, s, b)
% SUBSASGN Subcripted assignment
%
%   PSET(I,J) = B assigns the values of B into the points stored in the pset
%   object PSET.
%
%
% See also: PSET/SUBSREF

if isempty(obj),
    error('PSET:pset:subsasgn:invalidIndex', ...
        'Cannot assign to an empty pset object.');
end

if isempty(b),
    error('PSET:pset:subsasgn:invalidRHS', ...
        'Cannot assign an empty value. The size of a pset object is inmutable.');
end

switch s(1).type
    
    case '()',
        for i = 1:(length(s(1).subs)-2),
            if any(s(1).subs{i+2}~=1),
                error('PSET:pset:subsasgn:invalidIndex', ...
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
           % obj(I,J) = b; 
           % Determine point indices
            if ischar(s(1).subs{p_order}) && strcmp(s(1).subs{p_order},':'),
                p_indices = 1:obj.NbPoints;
            elseif isnumeric(s(1).subs{p_order}),
                p_indices = s(1).subs{p_order};
            else
                error('PSET:pset:subsasgn:invalidIndex', ...
                    'Index must be an scalar array or the string '':''');
            end
            if any(p_indices<0 | p_indices > obj.NbPoints),
                error('PSET:pset:subsasgn:invalidIndex', ...
                    'Index exceeds the dimensions of the pset object.');
            end
            % Determine dimension indices
            if ischar(s(1).subs{d_order}) && strcmp(s(1).subs{d_order},':'),
                d_indices = 1:obj.NbDims;
            elseif isnumeric(s(1).subs{d_order}),
                d_indices = s(1).subs{d_order};
            else
                error('PSET:pset:subsasgn:invalidIndex', ...
                    'Index must be an scalar array or the string '':''');
            end
            if any(d_indices<0 | d_indices > obj.NbDims),
                error('PSET:pset:subsasgn:invalidIndex', ...
                    'Index exceeds the dimensions of the pset object.');
            end
                    
            % Determine the filemaps of each point
            [m_indices, p_indices] = get_map_index(obj, p_indices);
            
            % Write the corresponding points to each filemap
            u_m_indices = unique(m_indices);
            if obj.Transposed,
                for i = 1:length(u_m_indices)
                    this_map_subset = (m_indices==u_m_indices(i));
                    if prod(size(b)) < 2,
                        obj.MemoryMap{u_m_indices(i)}.Data.Data(d_indices, ...
                            p_indices(this_map_subset)) = b;
                    else
                        obj.MemoryMap{u_m_indices(i)}.Data.Data(d_indices, ...
                            p_indices(this_map_subset)) = b(this_map_subset, :).';
                    end
                end
            else
                for i = 1:length(u_m_indices)
                    this_map_subset = (m_indices==u_m_indices(i));
                    if prod(size(b)) < 2, %#ok<*PSIZE>
                        obj.MemoryMap{u_m_indices(i)}.Data.Data(d_indices, ...
                            p_indices(this_map_subset)) = b;
                    else
                        obj.MemoryMap{u_m_indices(i)}.Data.Data(d_indices, ...
                            p_indices(this_map_subset)) = b(:, this_map_subset);
                    end
                end
            end
        else
            % obj(I) = b; 
            error('PSET:pset:subsasgn:invalidIndex', ...
                    'Single index subasgn had not been implemented yet!');
                        
            
        end
        
    
    case '.'
        if length(s) < 2,
           obj.(s(1).subs) = b;
        else
            obj = subsasgn(obj.(s(1).subs),s(2:end),b);
        end
        
    otherwise
        error('PSET:pset:subsasgn:invalidIndexingType',...
            'Indexing of type %s is not allowed for pset objects.', s(1).type);
        
        
end



end

