classdef abstract_selector < pset.selector.selector
   % ABSTRACT_SELECTOR - Common implementation among selector classes
   %
   % See also: selector
   
   
   methods
      
       function y = and(varargin)
          
           y = pset.selector.cascade(varargin{:});
           
       end
       
       function str = struct(obj)
          
          warning('off', 'MATLAB:structOnObject');
          str = builtin('struct', obj);
          warning('on', 'MATLAB:structOnObject');
           
       end
       
       function hashCode = get_hash_code(obj)
           
           import datahash.DataHash;
           
           hashCode = DataHash(struct(obj));
           
       end
       
   end
    
    
    
    
end