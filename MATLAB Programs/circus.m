function [xp yp varargout] = circus(r,varargin)

ang=0:0.01:2*pi; 

if nargin == 1
	xc=0; yc=0;
	xp = r*cos(ang) + xc;
	yp = r*sin(ang) + yc;
elseif nargin == 2
	xc=varargin{1}; yc=0;
	xp = r*cos(ang) + xc;
	yp = r*sin(ang) + yc;
elseif nargin == 3
	xc=varargin{1}; yc=varargin{2};
	xp = r*cos(ang) + xc;
	yp = r*sin(ang) + yc;
elseif nargin == 4
	xc=varargin{1}; yc=varargin{2}; zc=varargin{3};
	xp = r*cos(ang) + xc;
	yp = r*sin(ang) + yc;
	zp = zeros(numel(xp)) + zc;
	varargout = {zp};
else
	disp('bad job');
end

end