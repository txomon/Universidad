function y = sgn(x)

% function y = sgn(x)
%
% Returns the signum function.
%
%         { 1    x >= 0
%    y = {
%         {-1    x < 0
%
% by Dennis W. Brown, Last modified: 7/11/93
% Naval Postgraduate School, Monterey, CA

y = sign(x);

y = (y >= 0) + (-1) * (y == -1);


