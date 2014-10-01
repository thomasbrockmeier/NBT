function y = unique(ev)


if isnumeric(ev(1).Type),
    y = nan(numel(ev),1);
    count = 1;
    for i = 1:numel(ev)
        if ~ismember(ev(i).Type, y),
            y(count) = ev(i).Type;
            count = count + 1;
        end
    end
else
    y = cell(numel(ev),1);
    count = 1;
    for i = 1:numel(ev)
        if ~ismember(ev(i).Type, y),
            y{count} = ev(i).Type;
            count = count + 1;
        end
    end
end
y(count:end) = [];
