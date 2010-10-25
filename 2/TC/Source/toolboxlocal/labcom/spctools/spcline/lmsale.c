/*
%LMSALE	Adaptive least-mean square line enhancer.
%	[W,Y,E] = LMSALE(X,M,STEP,DELAY) implements
%	an adaptive line enhancer using the least-mean
%	squares approach where X is the input signal,
%	M is the number of filter weights, STEP is
%	the percentage of the maximum step size to use
%	in computing the next set of filter weights and
%	DELAY is the number samples to delay X before
%	computing the new weights.  The final filter
%	weights are returned in W, the estimated signal
%	in Y and the error signal in E.
%
%	The maximum step size is computed as
%
%		maxstep = 2/(M * var(x));
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
*/
#include <math.h>
#include <stdio.h>

#include "mex.h"

/* Input Arguments */
#define X_IN    	prhs[0]
#define W0_IN		prhs[1]
#define MUP_IN		prhs[2]
#define D_IN		prhs[3]

/* Output Arguments */
#define	W_OUT		plhs[0]
#define Y_OUT		plhs[1]
#define E_OUT		plhs[2]

#define pi		3.14159265
#define ISSCALAR(x)	(max(mxGetM(x),mxGetN(x)) == 1)
#define ISVECTOR(x)	(min(mxGetM(x),mxGetN(x)) == 1)
#define VECT_LENGTH(x)	(max(mxGetM((x)),mxGetN((x))))

#ifdef __UNIX__
#define	max(A, B)	((A) > (B) ? (A) : (B))
#define	min(A, B)	((A) < (B) ? (A) : (B))
#endif

#define sgn(A)      ((A) > 0.0 ? 1 : -1)

#ifdef __STDC__
double variance(double *array, int size)
#else
double variance(array, size)
double *array;
int     size;
#endif
{
	/* compute the variance of the values in array */

	double	ave;
	double	sum = 0.0;
	double	sum2 = 0.0;
	int	i;

	for (i = 0; i < size; i++)
	{
		sum += array[i];
		sum2 = sum2 + array[i] * array[i];
	}

	ave = sum / size;

	return ((sum2 - sum * ave) / (size - 1.0));
}



#ifdef __STDC__
void lmsale(double *x_in, double *w0_in, double *y_out, double *e_out,
	double *w_out, int Ns, int M, double offset, double mup,
	int d)
#else
void lmsale(x_in,w0_in,y_out,e_out,w_out,Ns,M,offset,mup,d)
double *x_in,*w0_in,*y_out,*e_out,*w_out;
double offset,mup;
int Ns,M,d;
#endif
{
	int     m,n;
	double	t;
	double	mu;
	double 	var;

	var = variance(x_in,Ns);

	/* maximum step size */
	mu = mup / 50.0 / M / var;

	/* initial condition set to zero */
	for (n=d-1; n < M+d-1; n++)
	{
		/* init */
		y_out[n] = 0.0;

		/* computer filter output */
		for (m=0; m < M; m++)
			if (n-m-d >= 0)	
				y_out[n] += w_out[m] * x_in[n-m-d];
			else
				y_out[n] += w_out[m] * 0.0;

		/* compute error */
		e_out[n] = x_in[n] - y_out[n];

		/* compute new weights */
		t = mu * e_out[n];
		for (m=0; m < M; m++)
			if (n-m-d >= 0)	
				w_out[m] = w_out[m] + t * x_in[n-m-d];
	}

	/* rest of data */
	for (n=M+d-1; n < Ns; n++)
	{
		/* init */
		y_out[n] = 0.0;

		/* computer filter output */
		for (m=0; m < M; m++)
			y_out[n] += w_out[m] * x_in[n-m-d];

		/* compute error */
		e_out[n] = x_in[n] - y_out[n];

		/* compute new weights */
		t = mu * e_out[n];
		for (m=0; m < M; m++)
			w_out[m] = w_out[m] + t * x_in[n-m-d];
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
	int             Ns,M,t,d;
	double	        *y_out,*e_out,*w_out,*x_in,*w0_in;
	double		offset,mup;
	unsigned int	m,n,k;


	/* Check for proper number of arguments */
	if (nrhs != 4)
		mexErrMsgTxt("lmsale: Invalid number of input arguments.");

	/* Check the dimensions of X_IN. */
	if (!mxIsNumeric(X_IN) || mxIsComplex(X_IN) ||
		!mxIsFull(X_IN)  || !mxIsDouble(X_IN) ||
		!ISVECTOR(X_IN)) {
		mexErrMsgTxt("lmsale: Input argument \"x\" must be a vector.");
	}

	/* get input args */
	x_in	= mxGetPr(X_IN);
	w0_in	= mxGetPr(W0_IN);
	mup	= mxGetScalar(MUP_IN);
	d	= (int)mxGetScalar(D_IN);

	/* get length of data */
	Ns  = max(mxGetM(X_IN),mxGetN(X_IN));

	/*  get filter order */
	if (ISSCALAR(W0_IN))
		M = (int)mxGetScalar(W0_IN);
	else
		/* number of initial weights is it */
		M  = (int)max(mxGetM(W0_IN),mxGetN(W0_IN));

	/* Create matrices for the return arguments */
	Y_OUT = mxCreateFull(Ns, 1, REAL);
	E_OUT = mxCreateFull(Ns, 1, REAL);
	W_OUT = mxCreateFull(M,  1, REAL);

	/* Assign pointers to the output arguments */
	y_out = mxGetPr(Y_OUT);
	e_out = mxGetPr(E_OUT);
	w_out = mxGetPr(W_OUT);


	if (ISSCALAR(W0_IN))

		/* set initial weights to zero if not given */
		for (k=0; k < M; k++)
			w_out[k] = 0.0;
	else
		/* set initial weights to user input */
		for (k=0; k < M; k++)
			w_out[k] = w0_in[k];

	/* Do the actual computations in a subroutine */
	lmsale(x_in,w0_in,y_out,e_out,w_out,Ns,M,offset,mup,d);
}

