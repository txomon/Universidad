/*

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include "mex.h"

#define MATLAB

#include "siglib.cpp"

/* Input Arguments */
#define MSG_IN	prhs[0]

/* Output Arguments */
#define	ARG_OUT	plhs[0]

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
	int     i;
	double	*y;		/* pointer to output vector space */
	char    *msg;		/* pointer to message string */
	char	*code;
	char	*bits;
	int     msglen = 0;	/* number of characters in message */
	int	code_length;
	
	/* Check for proper number of arguments */
	if (nrhs != 1)
		mexErrMsgTxt("str2mors: Invalid number of input arguments.");

	/* figure out if we have a string for a message */
	if (mxIsString(MSG_IN))
	{
		msglen = mxGetN(MSG_IN) + 1;
		msg = (double *)mxCalloc(msglen,sizeof(char));
		mxGetString(MSG_IN,msg,msglen);
		
	}
	else
		mexErrMsgTxt("str2mors: Input aug must be a string.");

	/* convert to morse */
	code = ascii_morse_string(msg);
	bits = morse_to_bits(code);
	
	code_length = strlen(bits);
	
	/* Create a matrix for the return argument */
	ARG_OUT = mxCreateFull((int)(code_length), 1, REAL);

	/* Assign pointers to the output arguments */
	y = mxGetPr(ARG_OUT);

	/* convert code to vector */
	for (i=0; i<code_length; i++)
		y[i] = (double)(bits[i] - (int)('0'));

	/* free memory */
	mxFree(msg);
	mxFree(code);
	msFree(bits);
}

