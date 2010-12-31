function [rxx] = rxxmdcov(x,P)
%RXXMDCOV Estimate correlation matrix (modified covariance method).
%       [RXX] = RXXMDCOV(X,P) estimates a PxP auto-correlation 
%       matrix for the data in X using the method of estimating 
%       the auto-correlation matrix used in the modified 
%       covariance method of AR modeling.  The resulting auto- 
%       correlation matrix will not be Toeplitz.
%
%       See also RXXTRUE, RXXCORR, RXXCOVAR

%       Dennis W. Brown 12-14-93
%       May be freely distributed.

% figure out if we have a vector
if min(size(x)) ~= 1,
	error('rxxmdcov: Input arg "x" must be a 1xN or Nx1 vector.');
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

% chop X to get rid of any zero padded values
X = X(P:length(x)-P+1,:);

% form estimate of correlation matrix X' X + rev(x.') rev(x*)
R = X' * X;                     	    % first half
rxx = R + conj(flipud(fliplr(R)));      % second half


