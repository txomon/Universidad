function [h,a] = musicsp(rx,N,arg3,arg4,arg5)
%MUSICSP MUltiple SIgnal Classification spectrum estimation.
%	[H,A]=MUSICSP(Rx,N) computes the MUSIC 
%	psuedo-spectral estimate of the signal whose 
%	correlation matrix is given in the variable Rx, 
%	returning the n-point magnitude of the 
%	psuedo-spectral estimate in H. The correlation 
%	matrix, Rx, must be a square matrix. This form of the 
%	function assumes the number of complex sinusoids 
%	contained in the signal is one less than the rank of 
%	correlation matrix Rx.  Return argument A is the 
%	"root" MUSIC polynomial.
%
%	Note: A real sinusoid contains two complex sinusoids.
%
%	[H,A]=MUSICSP(RX,Q,N) forces the algorithm to assume 
%	there are Q complex sinusoidal signals. The variable 
%	Q must be at least one less than the rank correlation 
%	matrix Rx.
%
%	[H,A]=MUSICSP(X,P,Q,N) computes the MUSIC 
%	psuedo-spectral estimate of the signal X.  The 
%	function computes a P x P correlation matrix using 
%	the 'rxxcovar' function and assumes P-1 complex 
%	sinusoids.
%
%	[H,A]=MUSICSP(X,P,Q,N,'rxxmethod') computes the P x P 
%	correlation matrix using the method prescribed by 
%	'rxxmethod'.  Valid options are:
%
%	'rxxcorr' - AR auto-correlation estimate method.
%	'rxxcovar' - AR covariance estimate method.
%	'rxxmdcov' - AR modified-covariance estimate method.
%
%	The 'rxxcovar' option is the default if no method is 
%	given.
%
%	Note: Setting the rank of the projection matrix, Q, to one 
%	less than number of complex sinusoids, P, computes a 
%	spectral estimate based on the Pisarenko harmonic 
%	decomposition.
%
%	The MUSICSPW function takes the same forms as MUSICSP 
%	and computes the weighted MUSIC psuedo-spectrum 
%	(eigenvectors used are weighted by 1/eigenvalue).
%
%       See also RXXCORR, RXXCOVAR, RXXMDCOV

%       Dennis W. Brown 4-27-94, DWB 4-4-95
%       Naval Postgraduate School, Monterey, CA
%       May be freely distributed.
%       Not for use in commercial products.

% check args
if nargin < 1 | nargin > 5,
    error('musicsp: Invalid number of input arguments...');
end;

% if input is a vector, estimate the correlation matrix.
if min(size(rx)) == 1,

	if nargin < 3,
		error('musicsp: Invalid number of input arguments...');
	end;

	% work with Nx1 vectors
	rx = rx(:);
	method = 'rxxcovar';

	% got to have at least 3 args for this use
	if nargin == 3,
		n = arg3;
		P = N;
		N = P-1;
	elseif nargin == 4 | nargin == 5,
		P = N;
		N = arg3;
		n = arg4;
	else
		error('musicsp: Invalid number of input arguments.')
	end;

	if nargin == 5,
		if ~isstr(arg5),
			error('musicsp: Correlation method must be a string...');
		else,
			method = arg5;
		end;
	end;

	% estimate correlation matrix
	if strcmp(method,'rxxcorr'),
		rx = rxxcorr(rx,P);
	elseif strcmp(method,'rxxcovar'),
		rx = rxxcovar(rx,P);
	elseif strcmp(method,'rxxmdcov'),
		rx = rxxmdcov(rx,P);
	else,
		error('musicsp: Invalid correlation estimation method specified...');
	end;

else,

	% more arg checking
	[P,m] = size(rx);
	if P ~= m,
		error('musicsp: Rx must be a square matrix...');
	end;
	
	if nargin == 2, 
		n = N;
		N = P - 1;
	elseif nargin == 3,
		n = arg3;
	else
		error('musicsp: Invalid number of input arguments for Rx form.');
	end;

	% m equals rank of Rx (Rx assumed to be singular)

	if nargin == 2,
		if N > m-1,
			error('musicsp: N must be less the rank of Rx...');
		end;
	end;
end;

% compute eigenvalues and vectors and sort in descending order
[u,s,v] = svd(rx);

% noise subspace
E = v(:,N+1:P);

% form projection matrix
p = E * E';


[h,a] = freqeig(p,n);
