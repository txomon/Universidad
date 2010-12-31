function [a,b,S,s] = ar_corr(x,P)
%AR_CORR   AR modeling using Autocorrelation method.
%       [A,B,S,PEV] = AR_CORR(X,P) computes the coefficients of a
%       P order Auto-Regressive (AR) model of the data given in
%       vector X via the autocorrelation method. The output is
%       specified by:
%
%           A = AR model coefficients
%           B = gain
%           S = minimum sum of squares
%           PEV = estimate for prediction error variance
%
%       Ref: Therrien, Discrete Random Signals and Statistical
%       Signal Processing, 1992, s 9.4.1, pp 535-541.
%
%       See also AR_COVAR, AR_MDCOV, AR_BURG, AR_PRONY,
%           AR_DURBN, AR_SHANK, NORMALEQ

%       Dennis W. Brown 7-11-93, DWB 9-14-93
%       Naval Postgraduate School, Monterey, CA
%       May be freely distributed.
%       Not for use in commercial products.

% default returns
a=[];S=[];s=[];R=[];X=[];

% figure out if we have a vector
if min(size(x)) ~= 1,
	error('ar_corr: Input arg "x" must be a 1xN or Nx1 vector.');
end;

% work with Nx1 vectors
x = x(:);

% pad the x vector out
x = [x ;zeros(P,1)];

% form the X data matrix
X = zeros(length(x),P+1);
t = length(x);
for k=1:P+1
	X(:,k) = x;
	x = [x(t:t); x(1:t-1)];
end

% form estimate of correlation matrix
R = X' * X;

% solve using normal equations
[S,a]=normaleq(R);

% add in a0=1
a = [1;a];

% estimate the prediction error variance
s = S/length(x);        % length includes padded zeros

% compute the gain
b = sqrt(S);

% return as a row vector
a = reshape(a,1,length(a));
b = reshape(b,1,length(b));

