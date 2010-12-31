/*
%AVSMOOTH Median smoothing filter.
%       [y] = AVSMOOTH(X,L) smooths the input vector X using a
%       median filter with a rectangular window of "L" samples.
%
%       See also: SP_STENG, SP_STMAG, SP_STZCR, MDSMOOTH
%
%       AVSMOOTH is implemented as a mex function on some
%       installations.

%       LT Dennis W. Brown 7-11-93, DWB 8-17-93
%       Naval Postgraduate School, Monterey, CA
%       May be freely distributed.
%       Not for use in commercial products.

*/
#include <math.h>
#include <stdio.h>

#ifdef __TURBOC__
#include "e:\matlab\extern\include\mex.h"
#else
#include "mex.h"
#endif

/* Input Arguments */
#define	X_IN        prhs[0]
#define L_IN    prhs[1]

/* Output Arguments */
#define	Y_OUT	plhs[0]

#define pi 3.14159265
#define ISSCALAR(x) 	    (max(mxGetM(x),mxGetN(x)) == 1)
#define ISVECTOR(x)         (min(mxGetM(x),mxGetN(x)) == 1)
#define VECT_LENGTH(x)      (max(mxGetM((x)),mxGetN((x))))

#ifdef __UNIX__
#define	max(A, B)	((A) > (B) ? (A) : (B))
#define	min(A, B)	((A) < (B) ? (A) : (B))
#endif

#define sgn(A)      ((A) > 0.0 ? 1 : -1)

#ifdef __STDC__
void avsmooth(double y_out[], double x[], int Ns, int L)
#else
void avsmooth(y_out,x,Ns,L)
double x[],y_out[];
int Ns,L;
#endif
{
    int     i,k,s = (int)(L/2);

    /* partial into data */
    for (k = 0; k < s; k++)
    {
        for (i=0; i <= s+k; i++)
        {
            y_out[k] += x[i];
        }
        y_out[k] /= i;
    }

    /* fully in data */
    for (k = 0; k < Ns-L+1; k++)
    {
        for (i = k; i < k+L; i++) y_out[s] += x[i];
        y_out[s++] /= L;
    }

    /* coming out of data */
    for (k = Ns-L+1; k < Ns-L/2; k++)
    {
        for (i=k; i < Ns; i++) y_out[s] += x[i];
        y_out[s++] /= Ns-k;
    }

}

#ifdef __STDC__
void mexFunction(
	int		nlhs,
	Matrix	*plhs[],
	int		nrhs,
	Matrix	*prhs[]
	)
#else
mexFunction(nlhs, plhs, nrhs, prhs)
int nlhs, nrhs;
Matrix *plhs[], *prhs[];
#endif
{
    int             Ns,L;
	double	        *y_out,*x;
	unsigned int	m,n;

	/* Check for proper number of arguments */
	if (nrhs != 2)
		mexErrMsgTxt("avsmooth: Invalid number of input arguments.");

	/* Check the dimensions of X_IN. */
	if (!mxIsNumeric(X_IN) || mxIsComplex(X_IN) ||
		!mxIsFull(X_IN)  || !mxIsDouble(X_IN) ||
		!ISVECTOR(X_IN)) {
		mexErrMsgTxt("avsmooth: Input argument \"x\" must be a vector.");
	}

    /* check input args */
    x   = mxGetPr(X_IN);
	Ns  = max(mxGetM(X_IN),mxGetN(X_IN));
    L   = (int)mxGetScalar(L_IN);

	/* Create a matrix for the return arguments */
	Y_OUT = mxCreateFull(Ns, 1, REAL);

	/* Assign pointers to the output arguments */
	y_out = mxGetPr(Y_OUT);

	/* Do the actual computations in a subroutine */
	avsmooth(y_out,x,Ns,L);
}

