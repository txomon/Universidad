function [h,S,Px] = ls_whopf(d,x,P)
%LS_WHOPF Least-squares, optimal filter, Wiener-Hopf method.
%       [H,S,PX] = LS_WHOPF(D,X,P) given the observed data
%       sequence X, compute the filter coefficients for a
%       least-squares optimal filter of order P, that will
%       produce the desired data sequence D from the observed
%       data sequence. Output arguments are:
%
%            h = filter coefficients
%            S = sum of squared errors
%           Px = the projection matrix
%
%       See also LS_SVD

%       LT Dennis W. Brown 2-28-93, DWB 1-24-94
%       Naval Postgraduate School, Monterey, CA
%       May be freely distributed.
%       Not for use in commercial products.

%       Ref: Therrien, Discrete Random Signals and Statistical
%       Signal Processing, 1992, ss 9.3, pp 518-528.

% default returns
h=0;S=0;X=0;Xp=0;Px=0;

% figure out if we have a vector
if min(size(d)) ~= 1,
	error('ls_whopf: Input arg "d" must be a 1xN or Nx1 vector.');
end;

% work with Nx1 vectors
d = d(:);

% figure out if we have a vector
if min(size(x)) ~= 1,
	error('ls_whopf: Input arg "x" must be a 1xN or Nx1 vector.');
end;

% work with Nx1 vectors
x = x(:);

% check validity of arguments
if (length(d) ~= length(x))
	error('ls_whopf: Length of x must be equal to length of d');
end;

if length(x) <= P
    error('ls_whopf: Order P must be less than length of observation vector');
end

% form X
K = length(x);
X = zeros(K-P+1,P);
for k=1:P
    X(:,k) = x(k:K-P+k);
end
X = fliplr(X);

% compute pseudoinverse
Xp = pinv(X' * X) * X';

% compute the filter coefficients
d1 = d(P:length(d));
h = Xp * d1;

if nargout >= 2,
    % compute the minimum sum of squared errors
    S = d1' * d1 - d1' * X * h;
end

if nargout >= 3,
    % compute the projection matrix
    Px = X * pinv(X' * X) * X';
end

