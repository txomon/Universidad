function yes = isscalar(x)
%ISSCALAR Tests whether the input is a scalar
%  ISSCALAR(x) returns a 1 if x is a scalar (a 1x1 matrix)
%  or 0 otherwise.

% Jordan Rosenthal, 12/11/97
if (ndims(x) == 2) & all( size(x) == [1 1] )
   yes = 1;
else
   yes = 0;
end
