function [h,S,Px] = ls_svd(d,x,P)
%LS_SVD    Least-squares optimal filter, SVD method.
%       [H,S,PX] = LS_SVD(D,X,P) given the observed data
%       sequence X, compute the filter coefficients for a
%       least-squares optimal filter of order P, that will
%       produce the desired data sequence D from the observed
%       data sequence. Output arguments are:
%
%            H = filter coefficients
%            S = sum of squared errors
%           PX = the projection matrix
%
%       See also LS_WHOPF

%       LT Dennis W. Brown 2-28-93, DWB 1-24-94
%       Naval Postgraduate School, Monterey, CA
%       May be freely distributed.
%       Not for use in commercial products.

%       Ref: Therrien, Discrete Random Signals and Statistical
%       Signal Processing, 1992, ss 9.3.4, pp 528-533.

% default returns
h=0;S=0;X=0;Xp=0;Px=0;s=0;v=0;u=0;

% figure out if we have a vector
if min(size(d)) ~= 1,
	error('ls_svd: Input arg "d" must be a 1xN or Nx1 vector.');
end;

% work with Nx1 vectors
d = d(:);

% figure out if we have a vector
if min(size(x)) ~= 1,
	error('ls_svd: Input arg "x" must be a 1xN or Nx1 vector.');
end;

% work with Nx1 vectors
x = x(:);

% check validity of arguments
if (length(d) ~= length(x))
	error('ls_svd: Length of x must be equal to length of d');
end;

% compute X
K = length(x);
X = zeros(K-P+1,P);
for k=1:P
    X(:,k) = x(k:K-P+k);
end
X = fliplr(X);

% take the SVD
[u,s,v] = svd(X);

% compute s plus
[m,n] = size(s);
sp=zeros(m,n);
for j=1:m
    for k=1:n
        if abs(s(j,k)) > .10*eps
            sp(j,k) = 1/s(j,k);
        end
    end
end

% compute the pseudoinverse
Xp = v * sp' * u';

if nargout >= 3,
    % compute the projection matrix
    Px = X * Xp;
end

% compute the filter coefficients
h = zeros(P,1);
for k=1:P
    h = h + 1/s(k,k) * u(:,k)' * d(P:K) * v(:,k);
end

if nargout >= 2,
    % compute the minimum sum of squared errors
    d1 = d(P:length(d));
    S = d1' * d1 - d1' * X * h;
end

