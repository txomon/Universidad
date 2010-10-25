function z=rec_fm (y,t,B)
% function z=rec_fm (y,t,B)
% Receptor de FM
z=derivar (y);
z=abs(z);
z=filtropb(z,t,B,8,60);
z=z-sum(z)/length(z);
