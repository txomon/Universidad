function yes = isinteger(x)
%ISINTEGER True for integers
%	ISINTEGER(x) returns 1 if x is an integer and 0 otherwise.
if ~isa(x,'double') | isempty(x)
   yes = 0;
   return;
end
if x == fix(x)
	yes = 1;
else
	yes = 0;
end
	