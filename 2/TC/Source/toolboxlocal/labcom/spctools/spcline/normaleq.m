function [e,a] = normaleq(R)
%NORMALEQ Solve normal equations.
%       [E,A] = NORMALEQ(R) solves a system of normal equations.
%       Coefficient a0 is assumed to equal 1.  R is the 
%       correlation matrix of rank P+1 where P is the order of
%       the system to be solved.  Returns the prediction error
%       variance in E and a 1xP vector of coefficients a1 
%       through aP in A.
%
%       Example for P=2:
%           [R(0)  R(1)  R(2)] [1 ] = [e]
%           [R(-1) R(0)  R(1)] [a1] = [0]
%           [R(-2) R(-1) R(0)] [a2] = [0]

%       LT Dennis W. Brown 7-11-93
%       Naval Postgraduate School, Monterey, CA
%       May be freely distributed.
%       Not for use in commercial products.

%       Ref: Therrien, Discrete Random Signals and Statistical 
%       Signal Processing, 1992, eq 7.23, ss 7.2.1, pp 345.

% default returns
a=[];e=[];

% must be square
[m,n]=size(R);
if (m ~= n)
	error(['normaleq: Correlation matrix is not square!']);
end

% reverse correlation matrix
% R = flipud(fliplr(R));

% solve for the a's
b = R(2:m,2:n);
c = -(R(2:m,1));
a = pinv(b) * c;

% solve for the variance
e = R(1,1) + sum(a.' .* R(1,2:n));

