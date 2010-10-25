function [h,a] = minvarsp(rx,N,arg3,arg4)
%MINVARSP  Minimum variance spectrum estimation.
%	[H,A]=MINVARSP(RX,N) computes the power spectral density
%	estimate of the signal whose correlation matrix is given 
%	in Rx.  Rx must be a square matrix. Returns n points in
%	the psd curve. The return argument A is the transfer
%	function denominator polynomial of degree 2*N-1.
%
%       [H,A]=MINVARSP(X,P,N) computes the power spectral density
%	estimate of the signal X.  The function computes a PxP
%	correlation matrix using the 'rxxcovar' function.
%
%       [H,A]=MINVARSP(X,P,n,'rxxmethod') computes the PxP 
%       correlation matrix using the method prescribed by 
%       'RXXMETHOD'.  Valid options are:
%           'rxxcorr'  - AR auto-correllation estimate method.
%           'rxxcovar' - AR covariance estimate method.
%           'rxxmdcov' - AR modified-covariance estimate method.
%       The 'rxxcovar' option is the default if no method is 
%       given.
%
%       See also RXXCORR, RXXCOVAR, RXXMDCOV

%       Dennis W. Brown 5-8-94
%       Naval Postgraduate School, Monterey, CA
%       May be freely distributed.
%       Not for use in commercial products.

% check args
if nargin < 3 | nargin > 4,
    error('minvarsp: Invalid number of input arguments...');
end;

% if input is a vector, estimate the correlation matrix.
if min(size(rx)) == 1,

	% remember, rx is a vector

	% work with Nx1 vectors
	rx = rx(:);

	% got to have at least 3 args for this use
	if nargin < 3,
		error('minvarsp: Invalid number of input arguments.');
	end;

	% second arg is size of correlation matrix
	m = N;

	% third arg is number of points to calculate
	n = arg3;

	% fourth arg method if  given
	method = 'rxxcovar';
	if nargin == 4,
		if ~isstr(arg4),
		error('minvarsp: Correlation matrix method not specified.');
		else,
			method = arg4;
		end;
	end;
	
	% estimate correlation matrix
	if strcmp(method,'rxxcorr'),
		rx = rxxcorr(rx,m);
	elseif strcmp(method,'rxxcovar'),
		rx = rxxcovar(rx,m);
	elseif strcmp(method,'rxxmdcov'),
		rx = rxxmdcov(rx,m);
	else,
		error('minvarsp: Invalid correlation estimation method specified.');
	end;

else,

	% more arg checking
	[m,n] = size(rx);
	if m ~= n,
		error('minvarsp: Rx must be a square matrix...');
	end;

	% second arg is number of points to calculate
	if nargin == 2,
		n = N;
	else
		error('minvarsp: Invalid number of input arguments.');
	end;

end;

% find inverse of correlation matrix
rxi = pinv(rx);

[h,a] = freqeig(rxi,n);

