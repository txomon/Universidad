function [q,xk,rk]=q_unif(in,L,arg3,arg4)
%
% >> xq=q_unif(in,L,xmin,xmax)
% Cuantifica in[] en L niveles uniformemente entre xmin y xmax
% 
% >> xq=q_unif(in,L,gamma)
% Cuantifica in[] en L niveles entre mean - gamma*sigma , mean+gamma*sigma 
%
% >> xq=q_unif(in,L) 
% Tomamos Xmin y Xmax el min y max de la entrada.
% 
% >> [q x r]= q_unif(in,L)
% Opcionalmente devuelve los niveles x_k r_k que describen cuantificador.

[sx sy]=size(in); in=reshape(in,1,sx*sy);

if nargin==4,xmin=arg3; xmax=arg4; end 
if nargin==3, m=mean(in); s=std(in); xmin=m-arg3*s; xmax=m+arg3*s; end
if nargin==2, xmin=min(in); xmax=max(in) ; end
 
in(in>=xmax)= xmax;    
in(in<=xmin)= xmin;    

dx=(xmax-xmin)/L;
rk=[xmin+dx/2:dx:xmax];
rk=[rk xmax-dx/2];

in=in-xmin;             % Inicio en 0
q=floor(in/dx)+1;       % Determino indices
q=rk(q);               % devuelvo valores de reconstruccion correspondientes

q=reshape(q,sx,sy);

% Devolvemos x_k y r_k opcionalmente
xk=[xmin:dx:xmax];
rk=rk(1:L);