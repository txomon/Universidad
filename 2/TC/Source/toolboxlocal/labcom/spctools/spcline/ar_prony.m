function [a,b] = ar_prony(x,P,Q,ain)
%AR_PRONY  Prony Moving-Average model.
%       [A,B] = AR_PRONY(X,P,Q) computes the coefficients of an
%       order P Auto-Regressive, order Q Moving Average Model of
%       the data given in vector X. The AR parameters are found
%       using the covariance method.  The AR polynomial coef-
%       ficients are returned in output vector A and the MA
%       polynomial coefficients are retuned in output vector B.
%
%       [A,B] = AR_PRONY(X,P,Q,'ARMETHOD') computes the MA model
%       coefficients via the Prony method based on the AR model
%       coefficients computed by the method specified in ARMETHOD.
%       Valid AR methods are 'ar_corr', 'ar_covar', 'ar_mdcov'
%       and 'ar_burg'.
%
%       Ref: Therrien, Discrete Random Signals and Statistical
%       Signal Processing, 1992, ss 9.5.2, pp 555-558.
%
%       See also AR_BURG AR_CORR AR_COVAR AR_DRBIN AR_LEVIN
%           AR_MDCOV AR_SHANK

%       Dennis W. Brown 7-11-93, DWB 1-22-94
%       Naval Postgraduate School, Monterey, CA
%       May be freely distributed.
%       Not for use in commercial products.
%

%---------------------------------------------------------------------

% default returns
a=[];b=[];

% check args
if nargin < 3 | nargin > 4,
    error('ar_prony: Invalid number of input arguments');
end;

% save the original length of x
Ns = length(x);

%---------------------------------------------------------------------

% figure out if we have a vector
if min(size(x)) ~= 1,
	error('ar_prony: Input arg "x" must be a 1xN or Nx1 vector.');
end;

% work with Nx1 vectors
x = x(:);

%---------------------------------------------------------------------

if nargin < 4,

    % compute the "a" coefficients
    a = ar_covar(x,P);

else,

    if ~strcmp(ain,'ar_corr') & ~strcmp(ain,'ar_covar') & ...
        ~strcmp(ain,'ar_mdcov') & ~strcmp(ain,'ar_burg'),
        error(['ar_prony: Invalid AR method specified (' ain ')...']);
    end;
    eval(['a = ' ain '(x,' int2str(P) ');']);

end;

% form the X matrix
Xb = zeros(Q+1,P+1);
for k=1:P+1
	Xb(:,k) = [zeros(min(k-1,Q+1),1) ; x(1:max(Q-k+2))];
end

% solve for b
b = Xb * a.';

% return as a row vector
a = reshape(a,1,length(a));
b = reshape(b,1,length(b));

