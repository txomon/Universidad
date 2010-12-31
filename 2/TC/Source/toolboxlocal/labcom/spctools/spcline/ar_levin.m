function [a,s]=ar_levin(r,P)
%AR_LEVIN  Levinson recursion auto-regressive (AR) model.
%       [A,PEV] = AR_LEVIN(R,P) computes the coefficients of an 
%       order P auto-regressive model from values of the auto- 
%       correlation vector r = [R(0) R(1) R(2) ... R(P-1)]. The
%       autocorrelation must be symmetric (i.e. R(1) = R(-1), 
%       R(2) = R(-2), etc,.).  The output arguments are:
%
%           a = AR parameters
%           PEV = linear prediction error variance
%
%       Ref: Therrien, Discrete Random Signals and Statistical 
%       Signal Processing, 1992, ss 8.5, pp 422-430
%
%       See also AR_CORR AR_COVAR AR_DRBIN AR_LEVIN AR_MDCOV
%           AR_PRONY AR_SHANK

%       LT Dennis W. Brown 7-11-93, DWB 1-22-94
%       Naval Postgraduate School, Monterey, CA
%       May be freely distributed.
%       Not for use in commercial products.

% default values
a=[]; s=0;

% argument check
if nargin ~= 2
        error(['ar_levin: Invalid number of input arguments...']);
end

% figure out if we have a vector
if min(size(r)) ~= 1,
	error('ar_levin: Input arg "r" must be a 1xN or Nx1 vector.');
end;

% work with Nx1 vectors
r = r(:);

% number of samples in vector
Ns = length(r);

% add an extra 0 for later, won't be used, just to
% prevent a beep
r = [r ; 0];

% set initial conditions
a = 1;
b = 1;
s = r(1);

% do the algorithm
for k = 1:P

    rt = r(2:k+1);

    delta = rt' * flipud(a);     % note r is conjugated

    % reflection coefficients
    gamma = delta / s;

    % AR parameters
    a = [a;0] - gamma * [0;flipud(conj(a))];

    % error variance
    s = (1 - gamma * conj(gamma)) * s;

end

% return as a row vector
a = reshape(a,1,length(a));
b = reshape(b,1,length(b));

