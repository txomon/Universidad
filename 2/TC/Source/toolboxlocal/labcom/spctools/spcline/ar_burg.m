function [a,b,S,gamma,sigma] = ar_burg(x,P)
%AR_BURG  Burg Auto-Regressive (AR) model.
%       [A,B0,S,GAMMA,SIGMA] = AR_BURG(X,P) computes the
%       coefficients of an order P Auto-Regressive (AR) mode
%       of the data given in vector X via the Burg method.
%
%       The output is specified by:
%       	a = AR model polynomial coefficients
%       	b0 = gain
%       	S = prediction error variance
%           gamma = reflection coefficients
%           sigma = sum-of-squared errors
%
%       See also AR_CORR AR_COVAR AR_DRBIN AR_LEVIN AR_MDCOV
%           AR_PRONY AR_SHANK

%       LT Dennis W. Brown 7-11-93
%       Naval Postgraduate School, Monterey, CA
%       May be freely distributed.
%       Not for use in commercial products.

%       Ref: Therrien, Discrete Random Signals and Statistical
%       Signal Processing, 1992, ss 9.4.4, pp 545-548.

% default returns
a=[];b=[];gamma=[];sigma=[];

% figure out if we have a vector
if min(size(x)) ~= 1,
	error('ar_burg: Input arg "x" must be a 1xN or Nx1 vector.');
end;

% work with Nx1 vectors
x = x(:);

% compute power in data
pd = sum(x .* x);
len = length(x);

% initialize algorithm
N = length(x);          % number of samples
ef = x(2:N);            % forward prediction error
eb = x(1:N-1);          % backward prediction error
L = length(ef);         % an index
a = 1;                  % first coefficient
sigma = zeros(1,P+1);     % prediction error variance estimate
gamma = zeros(1,P);     % reflection coefficients
sigma(1)=(x(:)'*x(:))/N;    % this is actually sigma(0).

% perform the burg algorithm
for p=1:P;
    gamma(p) = (2 * ef' * eb)/(ef' * ef + eb' * eb);
    sigma(p+1) = (1-abs(gamma(p))^2)*sigma(p);
    a = [a;0] - conj(gamma(p)) * [0;flipud(a)];
    if p < P
        tmp1 = ef - conj(gamma(p)) * eb;
        tmp2 = eb - gamma(p) * ef;
        ef = tmp1(2:L);
        eb = tmp2(1:L-1);
    end;
    L = L - 1;
end;

% sum of square errors equals last sigma
S = sigma(P+1);

% generate a model, compute power
model = filter(1,a,[1;zeros(len-1,1)]);
pm = sum(model .* model);

% compute gain (b0 in ar model)
b = sqrt(pd / pm);

% return as a row vector
a = reshape(a,1,length(a));
b = reshape(b,1,length(b));

