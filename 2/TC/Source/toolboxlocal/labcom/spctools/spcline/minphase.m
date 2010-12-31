function [y,gain] = minphase(P,tol)
%MINPHASE  Minimum phase polynomial.
%       [Y] = MINPHASE(P) returns a minimum phase polynomial 
%       for P.  P is returned if P is already minimum phase.
%
%	[Y,G] = MINPHASE(P) returns the polynomial Y such 
%	that the highest order coefficient is equal to one.
%	The gain is then returned in G.
%
%       Algorithm:  Multiply the polynomial by the following 
%       factor for each root that is greater than 1 in magnitude:
%
%                           z Conj[z0] - 1
%               Pmin = P *  ---------------
%                               -z + z0
%
%       This can be done by first convolving the numerator with 
%       P to perform the polynomial multiplication and then 
%       deconvolving P with the denominator to perform the 
%       polynomial division.
%
%	MINPHASE(P,TOL) sets the tolerance used in pairing
%	complex roots using the CPLXPAIR command.  Default
%	tolerance is 0.0001.
%
%       See also MAXPHASE

%       LT Dennis W. Brown 7-11-93, DWB 5-25-94
%       Naval Postgraduate School, Monterey, CA
%       May be freely distributed.
%       Not for use in commercial products.

%       Ref: Therrien, Discrete Random Signals and Statistical 
%           Signal Processing, 1992, ss 5.5.1, pp 250-253.
%       Oppenheim, Schafer, Digital Signal Processing, 1975,
%           ss 7.2, pp 345-353.

% default return
y = [];

% figure out if we have a vector
if min(size(P)) ~= 1,
	error('minphase: Input arg "P" must be a 1xN or Nx1 vector.');
end;
if nargin ~= 2,
	tol = 0.0001;
end;

% work with Nx1 vectors
P = P(:);

% save gain
index = find(P ~= 0);
gain = P(index(1));

% find roots and sort
r = cplxpair(roots(P),0.0001);

% find roots inside & outside & on unit circle
ra = abs(r);
onner = find(ra == 1.0);
inner = find(ra <  1.0);
outer = find(ra >  1.0);


% move root inside
g = [r(onner) ; r(inner) ; (1 ./ conj(r(outer)))];

% find outer complex roots
gain = gain * real(prod(r(outer)));

% the minimum phase polynomial
if nargout <= 1,
	y = gain * real(poly(g));
else,
	y = real(poly(g));
end;
