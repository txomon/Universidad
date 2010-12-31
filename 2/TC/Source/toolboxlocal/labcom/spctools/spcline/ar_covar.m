function [a,b,S,s] = ar_covar(x,P)
%AR_COVAR  AR modeling using covariance method.
%       [A,B,S,PEV] = AR_COVAR(X,P) computes the coefficients of a
%       P order Auto-Regressive (AR) model of the data given in
%       vector X via the covariance method. The output is
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
%       See also AR_CORR, AR_MDCOV, AR_BURG, AR_PRONY,
%           AR_DURBN, AR_SHANK, NORMALEQ

%       Dennis W. Brown 7-11-93, DWB 9-14-93
%       Naval Postgraduate School, Monterey, CA
%       May be freely distributed.
%       Not for use in commercial products.


% default returns
a=[];S=[];s=[];R=[];X=[];

% figure out if we have a vector
if min(size(x)) ~= 1,
	error('ar_covar: Input arg "x" must be a 1xN or Nx1 vector.');
end;

% work with Nx1 vectors
x = x(:);

% compute power in data
pd = sum(x .* x);
len = length(x);

% pad the x vector out
x = [x ;zeros(P,1)];

% form the X data matrix
X = zeros(length(x),P+1);
t = length(x);
for k=1:P+1
	X(:,k) = x;
	x = [x(t:t); x(1:t-1)];
end

% chop X to get rid of any zero padded values
X = X(P+1:length(x)-P,:);

% form estimate of correlation matrix
R = X' * X;

% solve using normal equations
[S,a]=normaleq(R);

% estimate prediction error variance
s = S/len;

% add in a0=1
a = [1;a];

% generate a model, compute power
model = filter(1,a,[1;zeros(len-1,1)]);
pm = sum(model .* model);

% compute gain (b0 in ar model)     Note: THIS IS A FUDGE!
b = sqrt(pd / pm);

% return as a row vector
a = reshape(a,1,length(a));
b = reshape(b,1,length(b));

