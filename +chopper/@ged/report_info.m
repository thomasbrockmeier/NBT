function [pName, pValue, pDescr]   = report_info(obj)

pName = {...
    'NbEig', ...
    'WindowLength', ...
    'WindowOverlap', ...
    'EmbedDim', ...
    'EmbedDelay', ...
    'MinChunkLength', ...
    'MaxNbChunks', ...
    'PreFilter', ...
    'PostFilter', ...
    'InitDelta' ...
    };
    
pDescr = {...
    'Number of Eigenvalues to retain', ...
    'Analysis window length (samples)', ...
    'Analysis window overlap (%)', ...
    'Embedding dimension', ...
    'Embedding delay (samples)', ...
    'Minimum chunk length (samples)', ...
    'Maximum number of chunks', ...
    'Pre-processing filter', ...
    'Post-processing filter', ...
    'Initial Delta value' ...
    };

pValue = cellfun(@(x) obj.(x), pName, 'UniformOutput', false);
