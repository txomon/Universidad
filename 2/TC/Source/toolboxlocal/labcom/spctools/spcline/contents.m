% Signal Processing and Communications Toolbox
% Linear system/spectrum estimation functions.
% Version 3.00, 4/3/95
% LT Dennis W. Brown
% Naval Postgraduate School
% Monterey, CA
%
% AR/MA/ARMA Modeling.
%   AR_CORR     AR modeling using Autocorrelation method.
%   AR_COVAR    AR modeling using covariance method.
%   AR_DURBN    Durbin Moving-Average model.
%   AR_LEVIN    Levinson recursion auto-regressive (AR) model.
%   AR_MDCOV    AR modeling using modified covariance method.
%   AR_PRONY    Prony Moving-Average model.
%   AR_SHANK    Shank Moving-Average model.
%   AR_BURG     Burg Auto-Regressive (AR) model.
%
% Least-squares Modeling.
%   LS_SVD      Least-squares optimal filter, SVD method.
%   LS_WHOPF    Least-squares, optimal filter, Wiener-Hopf method.
%
% Correlation Matrices.
%   RXXCORR     Estimate correlation matrix (auto-correlation
%                 method).
%   RXXCOVAR    Estimate correlation matrix (covariance method).
%   RXXMDCOV    Estimate correlation matrix (modified covariance
%                 method).
%
% Spectrum estimation.
%   AVGPERGM    Daniell periodogram.
%   BLACKTUK    Blackman-Tukey spectral estimation.
%   DANIELL     Daniell periodogram.
%   FREQEIG     Evaluate eigen-based spectral estimate.
%   MINVARSP    Minimum variance spectrum estimation.
%   MUSICSP     MUltiple SIgnal Classification spectrum estimation.
%   MUSICSPW    Weighted MUSIC.
%
% Adaptive Filtering.
%   LMSALE      Adaptive least-mean square line enhancer.
%
% Misc
%   NORMALEQ    Solve normal equations.
%   MAXPHASE    Maximum phase polynomial.
%   MINPHASE    Minimum phase polynomial.
%   SPECFACT    Spectral factorization.
%   SHOWEIG     Plot eigenvalues
