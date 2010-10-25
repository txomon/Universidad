function [w,y,e]=lmsale(x,M,mup,delay)
%LMSALE	Adaptive least-mean square line enhancer.
%	[W,Y,E] = LMSALE(X,M,STEP,DELAY) implements
%	an adaptive line enhancer using the least-mean
%	squares approach where X is the input signal,
%	M is the number of filter weights, STEP is
%	the percentage of the maximum step size to use
%	in computing the next set of filter weights and
%	DELAY is the number samples to delay X in
%	computing the new weights.  The final filter
%	weights are returned in W, the estimated signal
%	in Y and the error signal in E.
%
%	The maximum step size is computed as
%
%		maxstep = 2/(M * std(x)^2);
%
%
%	[W,Y,E] = LMSALE(X,WIN,STEP,DELAY) uses the 
%	vector WIN as the initial guess at the weights.
%	The number of weights is equal to the length
%	of WIN.

%       LT Dennis W. Brown 3-10-93
%       Naval Postgraduate School, Monterey, CA
%       May be freely distributed.
%       Not for use in commercial products.

% default returns
y=[];w=[];e=[];

% check number of input args
if nargin ~= 4
    error('lmsale: Invalid number of input arguments...');
end

% figure out if we have a vector
if min(size(x)) ~= 1,
	error('lmsale: Input arg "x" must be a 1xN or Nx1 vector.');
end;

% work with Nx1 vectors
x = x(:);

% initial weights
w0 = zeros(M,1);

if nargin < 5
	pl = 0;
end;

% some parameters

Ns=length(x);
runs = std(x)^2;

% compute maximum step size
mumax = 2/(M * runs);

% make mu less than 2/lamdamax using percentage
mu = mup/100 * mumax;

% start with initial guess for weights equal to the null vector
w = w0;

% recursively compute the weights to three significant figures
y=zeros(Ns,1);			% space for filtered signal
e=zeros(Ns,1);			% space for error signal
xi = [zeros(M-1,1) ; x(1:M+delay,1)];

% initial conditions set to zero
for k=delay+1:M+delay-1

	b = flipud(xi((k-M+1:k)-delay+M-1));

	% compute filter output
	y(k) = w' * b;

	% compute error
	e(k) = x(k) - y(k);

	% compute new weights
	w = w + mu * b * e(k);

end

% rest of data
for k=M+delay:Ns

	b = flipud(x((k-M+1:k)-delay));

	% compute filter output
	y(k) = w' * b;

	% compute error
	e(k) = x(k) - y(k);

	% compute new weights
	w = w + mu * b * e(k);

end


