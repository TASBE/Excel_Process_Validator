% in a 1D vector of booleans, find the longest continuous stretch of trues
% return a boolean vector that is true precisely in the longest stretch.
% In the case of a tie, return the first
function selected = longest_true_stretch(booleans)

% initialize to blank
selected = false(size(booleans));

% find all transitions
ups = find(~booleans(1:end-1) & booleans(2:end));
downs = find(booleans(1:end-1) & ~booleans(2:end));

% if no transitions were found, then it's either all true or all false
if isempty(ups) && isempty(downs)
    if booleans(1), selected = true(size(booleans)); end;
    return;
end

% pad front and back if necessary, so all are matched and up(i)<down(i)
if isempty(ups) || (~isempty(downs) && ups(1)>downs(1)), ups = [0 ups]; end;
if isempty(downs) || ups(end)>downs(end), downs = [downs numel(booleans)]; end;

% find the longest interval and set it to true
lengths = downs-ups;
longest = find(lengths==max(lengths),1);

selected(ups(longest)+1:downs(longest)) = true;
