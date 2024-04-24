function [x_min,x_max,y_min,y_max] = fv_axissetting(polygonbase,path)
%--------------------------------------------------------------------------
% A függvény célja:
% Meghatározni a kábel nyomvonala körüli ábra határoló koordinátáit,
% 1 AGV méretnyire minden irányban.
%--------------------------------------------------------------------------
length_poly = max(polygonbase(1,:)) - min(polygonbase(1,:));% Length of polygon.
width_poly  = max(polygonbase(2,:)) - min(polygonbase(2,:));% Width of polygon.
sizepoly = max(length_poly,width_poly);% Maximal size of AGV.
x_min = min(path(1,:)) - sizepoly;% A leg BAL  koordináta.
x_max = max(path(1,:)) + sizepoly;% A leg JOBB koordináta.
y_min = min(path(2,:)) - sizepoly;% A leg LENT koordináta.
y_max = max(path(2,:)) + sizepoly;% A leg FENT koordináta.
%--------------------------------------------------------------------------
% A nem csak szögletes, hanem négyzetes ábra koordinátáinak kiszámítása.
xsize = x_max - x_min;
ysize = y_max - y_min;
screensize = max(xsize,ysize);
x_max = x_min + screensize;
y_max = y_min + screensize;
end