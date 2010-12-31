function [y]=lrs(r,n,fill,taps)
%LRS      Linear-recursive sequence.
%       [Y] = LRS(R,N) returns a binary linear recursive sequence
%       that is N bits long using an R bit shift register.  Uses
%       a randomly generated fill with randomly generated taps.
%
%       [Y] = LRS(R,N,FILL,TAPS) sets the fill and taps to those
%       specified in the vectors FILL and TAPS.  These vectors
%       may be specified by a vector containing a binary repre-
%       sentation each cell of the register or by a list for the
%       location of each "one" cell.  For example, an initial 
%       fill of [1 0 1 0 1] could also be specified by [1 3 5]
%       and taps of [1 0 0 1 0] could be specified as [1 4].  If
%       a binary representation is specified, it must length R.
%       If a list is specified, it largest element must be less
%       than or equal to R.

%       LT Dennis W. Brown 8-16-93, DWB 8-16-93
%       Naval Postgraduate School, Monterey, CA
%       May be freely distributed.
%       Not for use in commercial products.

% defaults
y = [];

% check arguments
if nargin < 2,
    error('lrs: Length and number of bits arguments required...');
end;

if nargin > 2 & nargin ~= 4,
    error('lrs: Fill and taps argument must both be specified...');
end;

% create fill and taps if not specified, must be nonzero
if nargin == 2,
    fill = 0;
    taps = 0;
    while sum(fill)==0, fill = (randn(1,r) <= 0); end;
    while sum(taps)==0, taps = (randn(1,r) <= 0); end;
else,
    % check args
    if (max(fill) == 1 & length(fill) ~= r) | (max(taps) == 1 & length(taps) ~= r),
        error('lrs: Binary specification must have an element for every cell...');
    elseif max(fill) > r | max(taps) > r,
        error('lrs: Maximum cell number must be less than register length...');
    end;
end;

% create binary rep for list specification
if max(fill) > 1,
    temp = zeros(r,1);
    temp(fill,1) = ones(length(fill),1);
    fill = temp;
end;
if max(taps) > 1,
    temp = zeros(r,1);
    temp(taps,1) = ones(length(taps),1);
    taps = temp;
end;

% there is always a tap off cell one (where we get our output)
taps(1) = 1;

% get indices of taps
ind = find(taps);

% create temp output vector
fill = fill(:);                 % reshape to N x 1
y = [fill ; zeros(n-1,1)];

% create the lrs
for i=1:n-1,
    y(r+i) = rem(sum(y(ind)),2);
    ind = ind + 1;
end;

% trim output vector
y = y(r:n+r-1);

