function [h,e] = showeig(x,P,arg3)
%SHOWEIG	Plot eigenvalues
%	[H,E] = SHOWEIG(X,P) creates a stem plot of the
%	eigenvalues computed from the PxP correlation matrix
%	of the signal X.  The correlation matrix is computed
%	using the covariance method.  The return H is a handle
%	to the figure window the eigenvalues were displayed in.
%	A vector of eigenvalues is returned in E.
%
%	[H,E] = SHOWEIG(X,P,'METHOD') used the specified 'METHOD'
%	in computing the estimation of the correlation matrix.
%	Valid methods are 'rxxcorr', 'rxxcovar', or 'rxxmdcov'.
%
%	[H,E] = SHOWEIG(RX) computes and displays the eigenvalues
%	of the correlation matrix RX.
%
%	See also RXXCORR, RXXCOVAR, RXXMDCOV

%       Dennis W. Brown 4-27-94, DWB 5-12-94
%       Naval Postgraduate School, Monterey, CA
%       May be freely distributed.
%       Not for use in commercial products.

% defaults
method = 'rxxcovar';

% check args
if nargin < 1 | nargin > 3,
    error('showeig: Invalid number of input arguments...');
end;

if nargin == 1,
	rx = x;
	[P,n] = size(rx);
	if P ~= n,
		error('showeig: Correlation matrix must be square.');
	end;
	method = 'unknown';
else,
	if min(size(x)) ~= 1,
		error('showeig: Input arg "x" must be a 1xN or Nx1 vector.');
	end;
	if max(size(P)) ~= 1,
		error('showeig: Correlation matrix size must be scalar');
	end;
	P = fix(P);

	if nargin == 3,
		method = arg3;
	end;

	% estimate correlation matrix
		if strcmp(method,'rxxcorr'),
		rx = rxxcorr(x,P);
	elseif strcmp(method,'rxxcovar'),
		rx = rxxcovar(x,P);
	elseif strcmp(method,'rxxmdcov'),
		rx = rxxmdcov(x,P);
	else,
	  error('showeig: Invalid correlation estimation method specified...');
	end;
end;

% compute eigenvalues and vectors and sort in descending order
[u,s,v] = svd(rx);
e = diag(s);

% open figure
hh = figure('Name','Eigenvalues of Correlation Matrix');

% do plot
stem(e);
set(gca,'Xlim',[0 length(e)+1],'YLim',[0-0.05*e(1) e(1)*1.05]);
xlabel('Eigen number');
ylabel('Eigenvalue');
if method(1) == 'r',
	title(['Rxx computed using ' method ' method.']);
end;

if nargout == 1,
	h = hh;
end;

