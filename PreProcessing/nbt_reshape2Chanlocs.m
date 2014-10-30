function NewData=nbt_reshape2Chanlocs(OldData, OldChanloc, NewChanloc)

%Todo
%deal with bad channels

NoMatchList = [];
%First we try to find matching channel locations.
for m=1:length(NewChanloc)
    FoundMatch = 0;
    for i=1:length(OldChanloc)
        if(NewChanloc(m).X == OldChanloc(i).X)
            if(NewChanloc(m).Y == OldChanloc(i).Y)
                if(NewChanloc(m).Z == OldChanloc(i).Z)
                    %The channels match
                    NewData(:,m) = OldData(:,i);
                    FoundMatch = 1;
                end
            end
        end
    end
    if(FoundMatch == 0)
        %No match was found
        NoMatchList = [NoMatchList m];
    end
end

if(~isempty(NoMatchList))
    %Then we interpolate - !nbt_interpolate need Data in ChannelxValues
    %format!!
    InterpolatetData = nbt_interpolate(OldData',OldChanloc, NewChanloc(NoMatchList));
    NewData(:,NoMatchList) = InterpolatetData';
end
end

function InterpolatetData = nbt_interpolate(Data,Chanlocs, ChanlocsToInterpolate)
%% !! note this function needs Data to be in Channels x Values format !!
% get theta, rad of electrodes
% ----------------------------
xelec = [ Chanlocs.X ];
yelec = [ Chanlocs.Y ];
zelec = [ Chanlocs.Z ];
rad = sqrt(xelec.^2+yelec.^2+zelec.^2);
xelec = xelec./rad;
yelec = yelec./rad;
zelec = zelec./rad;

xbad = [ ChanlocsToInterpolate.X ];
ybad = [ ChanlocsToInterpolate.Y ];
zbad = [ ChanlocsToInterpolate.Z ];
rad = sqrt(xbad.^2+ybad.^2+zbad.^2);
xbad = xbad./rad;
ybad = ybad./rad;
zbad = zbad./rad;



[tmp1, tmp2, tmp3, InterpolatetData] = spheric_spline( xelec, yelec, zelec, xbad, ybad, zbad, Data);



function [xbad, ybad, zbad, allres] = spheric_spline( xelec, yelec, zelec, xbad, ybad, zbad, values)
%Function from eeg_interp.m from EEGLAB
newchans = length(xbad);
numpoints = size(values,2);

Gelec = computeg(xelec,yelec,zelec,xelec,yelec,zelec);
Gsph  = computeg(xbad,ybad,zbad,xelec,yelec,zelec);

% compute solution for parameters C
% ---------------------------------
meanvalues = mean(values);
values = values - repmat(meanvalues, [size(values,1) 1]); % make mean zero

values = [values;zeros(1,numpoints)];
C = pinv([Gelec;ones(1,length(Gelec))]) * values;
clear values;
allres = zeros(newchans, numpoints);

% apply results
% -------------
for j = 1:size(Gsph,1)
    allres(j,:) = sum(C .* repmat(Gsph(j,:)', [1 size(C,2)]));
end
allres = allres + repmat(meanvalues, [size(allres,1) 1]);

% compute G function
% ------------------
    function g = computeg(x,y,z,xelec,yelec,zelec)
        
        unitmat = ones(length(x(:)),length(xelec));
        EI = unitmat - sqrt((repmat(x(:),1,length(xelec)) - repmat(xelec,length(x(:)),1)).^2 +...
            (repmat(y(:),1,length(xelec)) - repmat(yelec,length(x(:)),1)).^2 +...
            (repmat(z(:),1,length(xelec)) - repmat(zelec,length(x(:)),1)).^2);
        
        g = zeros(length(x(:)),length(xelec));
        %dsafds
        m = 4; % 3 is linear, 4 is best according to Perrin's curve
        for n = 1:7
            if ismatlab
                L = legendre(n,EI);
            else % Octave legendre function cannot process 2-D matrices
                for icol = 1:size(EI,2)
                    tmpL = legendre(n,EI(:,icol));
                    if icol == 1, L = zeros([ size(tmpL) size(EI,2)]); end;
                    L(:,:,icol) = tmpL;
                end;
            end;
            g = g + ((2*n+1)/(n^m*(n+1)^m))*squeeze(L(1,:,:));
        end
        g = g/(4*pi);
    end
end
end
