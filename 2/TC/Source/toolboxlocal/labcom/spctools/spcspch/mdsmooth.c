/*
%MDSMOOTH Median smoothing filter.
%       [y] = MDSMOOTH(X,L) smooths the input vector X using a
%       median filter with a rectangular window of "L" samples.
%
%       See also: SP_STENG, SP_STMAG, SP_STZCR, AVSMOOTH
%
%       MDSMOOTH is implemented as a mex function on some
%       installations.

%       LT Dennis W. Brown 7-11-93, DWB 8-17-93
%       Naval Postgraduate School, Monterey, CA
%       May be freely distributed.
%       Not for use in commercial products.
*/
#include <math.h>
#include <stdlib.h>
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
static int doublecompare(double *i, double *j)
#else
static int doublecompare(i,j)
double *i, *j;
#endif
{
    if (*i < *j) return -1;
    else if (*i > *j) return 1;
    else return 0;
}


#ifdef __STDC__
void mdsmooth(double y_out[], double x[], int Ns, int L)
#else
void mdsmooth(y_out,x,Ns,L)
double x[],y_out[];
int Ns,L;
#endif
{
    int     i,j,k,s = (int)(L/2),odd = (L % 2),middle,middle2;
    double  *buffer;

    /* partial into data */
    for (k = 1; k <= s; k++)
    {
        buffer = (double *)calloc(s+k,sizeof(double));
        if (!buffer)
            mexErrMsgTxt("mdsmooth: Memory allocation error...");

        /* set middle */
        odd = ((s+k) % 2);
        if (odd)
            middle = (s+k)/2;
        else
        {
            middle = (s+k)/2 - 1;
            middle2 = middle+1;
        }

        j = -1;
        for (i = 0; i < s+k; i++) buffer[++j] = x[i];

        qsort(buffer,s+k,sizeof(double),doublecompare);

        if (odd)
            y_out[k-1] = buffer[middle];
        else
            y_out[k-1] = (buffer[middle] + buffer[middle2])/2;

        /* free memory */
        free(buffer);
    }

    buffer = (double *)calloc(L,sizeof(double));
    if (!buffer)
        mexErrMsgTxt("mdsmooth: Memory allocation error...");

    /* set middle */
    odd = (L % 2);
    if (odd)
        middle = L/2;
    else
    {
        middle = L/2 - 1;
        middle2 = middle+1;
    }

    /* fully in data */
    for (k = 0; k < Ns-L+1; k++)
    {
        j = -1;
        for (i = k; i < k+L; i++) buffer[++j] = x[i];

        qsort(buffer,L,sizeof(double),doublecompare);

        if (odd)
            y_out[s++] = buffer[middle];
        else
            y_out[s++] = (buffer[middle] + buffer[middle2])/2;
    }

    /* free memory */
    free(buffer);

    /* coming out of data */
    for (k = Ns-L+1; k < Ns-L/2; k++)
    {
        buffer = (double *)calloc(s+k,sizeof(double));
        if (!buffer)
            mexErrMsgTxt("mdsmooth: Memory allocation error...");

        /* set middle */
        odd = (Ns-k) % 2;
        if (odd)
            middle = (Ns-k)/2;
        else
        {
            middle = (Ns-k)/2 - 1;
            middle2 = middle+1;
        }

        j = -1;
        for (i = k; i < Ns; i++) buffer[++j] = x[i];

        qsort(buffer,Ns-k,sizeof(double),doublecompare);

        if (odd)
            y_out[s++] = buffer[0];
        else
            y_out[s++] = (buffer[middle] + buffer[middle2])/2;

        /* free memory */
        free(buffer);

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
		mexErrMsgTxt("mdsmooth: Invalid number of input arguments.");

	/* Check the dimensions of X_IN. */
	if (!mxIsNumeric(X_IN) || mxIsComplex(X_IN) ||
		!mxIsFull(X_IN)  || !mxIsDouble(X_IN) ||
		!ISVECTOR(X_IN)) {
		mexErrMsgTxt("mdsmooth: Input argument \"x\" must be a vector.");
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
	mdsmooth(y_out,x,Ns,L);
}

