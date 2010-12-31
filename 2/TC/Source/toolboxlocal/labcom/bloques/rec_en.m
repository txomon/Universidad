function z=rec_en (y,t,B)
% function z=rec_fm (y,t,B)
% Receptor de envolvente
z=abs(y);
z=filtropb(z,t,B,8,60);
z=z-sum(z)/length(z);
