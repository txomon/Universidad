function [rxx] = rxxcorr(x,P)
%RXXCORR  Estimate correlation matrix (auto-correlation method).
%       [RXX] = RXXCORR(X,P) estimates a PxP auto-correlation 
%       matrix for the data in X using the method of estimating 
%       the auto-correlation matrix used in the auto-correlation
%       method of AR modeling.  The resulting auto-correlation 
%       matrix will be positive semidefinite and Toeplitz.
%
%       See also RXXTRUE, RXXCOVAR, RXXMDCOV

%       Dennis W. Brown 12-14-93
%       May be freely distributed.

% figure out if we have a vector
if min(size(x)) ~= 1,
	error('rxxcorr: Input arg "x" must be a 1xN or Nx1 vector.');
end;

% work with Nx1 vectors
x = x(:);

% pad the x vector out
x = [x ;zeros(P-1,1)];

% form the X data matrix
X = zeros(length(x),P);
t = length(x);
for k=1:P
	X(:,k) = x;
	x = [x(t:t); x(1:t-1)];
end

% form estimate of correlation matrix
rxx = X' * X;

