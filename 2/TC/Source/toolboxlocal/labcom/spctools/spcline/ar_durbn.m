function [a,b] = ar_durbn(x,P,Q,L,ain)
%AR_DURBN  Durbin Moving-Average model.
%       [A,B] = AR_DURBN(X,P,Q,L) computes the coefficients of an
%       order P Auto-Regressive, order Q Moving Average Model of
%       the data given in vector x. The L parameter can be used
%       to set the order of the intermediate AR model used to
%       compute the MA parameters via the Durbin method. If not
%       provided, L defaults to 5*Q or the length(X)-1, which ever
%       is smaller.  The AR polynomial coefficients are returned
%       in output vector A and the MA polynomial coefficients are
%       retuned in output vector B.  The AR covariance method is
%       used to compute the AR parameters and is used as the
%       intermediate AR model during computation of the Durbin MA
%       parameters.
%
%       [A,B] = AR_DURBN(X,P,Q,'ARMETHOD') and
%       [A,B] = AR_DURBN(X,P,Q,L,'ARMETHOD') uses the AR method
%       specified by ARMETHOD to compute the AR parameters and the
%       intermediate AR model during computation of the Durbin MA
%       parameters.  Valid AR methods are 'ar_corr', 'ar_covar',
%       'ar_mdcov' and 'ar_burg'.
%
%       See also AR_BURG AR_CORR AR_COVAR AR_LEVIN AR_MDCOV
%           AR_PRONY AR_SHANK

%       Dennis W. Brown 3-1-93, DWB 1-22-94
%       Naval Postgraduate School, Monterey, CA
%       May be freely distributed.
%       Not for use in commercial products.

%       Ref: Therrien, Discrete Random Signals and Statistical
%       Signal Processing, 1992, ss 9.5.2, pp 558-560

%---------------------------------------------------------------------

% default returns
a=[];b=[];

% check args
if nargin < 3 | nargin > 5,
    error('ar_shank: Invalid number of input arguments');
end;

% save the original length of x
Ns = length(x);

%---------------------------------------------------------------------

% figure out if we have a vector
if min(size(x)) ~= 1,
	error('ar_shank: Input arg "x" must be a 1xN or Nx1 vector.');
end;

% work with Nx1 vectors
x = x(:);

%---------------------------------------------------------------------

if nargin < 4,

    ain = 'ar_covar';
    
elseif nargin == 4,

    if ~isstr(L),
        ain = 'ar_covar';
    else
        ain = L;
        clear L;
    end;
end;

% check AR method
if ~strcmp(ain,'ar_corr') & ~strcmp(ain,'ar_covar') & ...
        ~strcmp(ain,'ar_mdcov') & ~strcmp(ain,'ar_burg'),
        error(['ar_durbn: Invalid AR method specified (' ain ')...']);
    end;

end;

% compute the AR parameters
eval(['a = ' ain '(x,P);']);

% -----------------------------------------------------------
% solve for the MA parameters using Durbin's method

% figure out what L is gonna be
if exist('L') ~= 1,
    L = 5 * Q;
    if L > length(x)-1, L = length(x)-1; end
end

% Find intermediate AR model
eval([ '[a1,S] = ' ain '(x,L);']);

% Find white noise variance
% wv = S / length(x);

% Find MA parameters
eval(['[b,S] = ' ain '(a1,Q);']);

% return as a row vector
a = reshape(a,1,length(a));
b = reshape(b,1,length(b));

