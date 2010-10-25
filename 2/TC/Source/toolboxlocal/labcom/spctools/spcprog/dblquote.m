function y=dblquote(str)
%DBLQUOTE Double single quote characters.
%	[Y] = DBLQUOTE('STRING') replaces each single 
%	occurance of a single quote in 'STRING' with
%	two singles quotes.

%       Dennis W. Brown 2-5-94
%       Copyright (c) 1994 by Dennis W. Brown
%       May be freely distributed.
%       Not for use in commercial products.

% find single quotes
k = find(str == '''');
kl = length(k);
kk = k + (1:kl);
kd = diff(k);

if isempty(k), y = str; return;	end;	% no quotes

% output variable
y = zeros(1,length(str)+kl);

% first chunk
y(1:k(1)) = str(1:k(1));

% middle chunk
for i = 1:kl-1
	y(kk(i):(kk(i)+kd(i))) = str(k(i):k(i+1));
end;

% last chunk
y(kk(kl):length(y)) = str(k(kl):length(str));


y = setstr(y);
