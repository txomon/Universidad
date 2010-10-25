function [k,bc,ac,bnc,anc] = specfact(b,a)
%SPECFACT Factor complex spectrum.
%	[K,BC,AC,BNC,ANC] = SPECFAC(B,A) factors
%	the complex spectrum given by the equation
%
%			B(z)
%		S(z) = ------
%			A(z)
%
%	returning the innovations representation
%
%			  
%		S(z) = K Hca(z) H*ca(1/z*)
%
%	where K is the normalizing constant, and 
%
%			  Bc(z)
%		Hca(z) = -------
%			  Ac(z)
%
%			      Bac(z)    B*c(1/z*)
%		H*ca(1/z*) = ------- = -----------
%			      Aac(z)    A*c(1/z*)
%
%

% gain
k = b(1)/a(1);

% compute roots of polynomials
br = roots(b);
ar = roots(a);

% compute non-causal polynomial
tol = 10000;
bnc = round( tol * poly(br(find(abs(br) < 1)))) / tol;
anc = round( tol * poly(ar(find(abs(ar) < 1)))) / tol;

% compute causal polynomials
bc = fliplr(round( tol * poly(br(find(abs(br) > 1)))) / tol);
ac = fliplr(round( tol * poly(ar(find(abs(ar) > 1)))) / tol);
k = k * bc(1) / ac(1);
bc = bc / bc(1);
ac = ac / ac(1);

