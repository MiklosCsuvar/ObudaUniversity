function [x_min,x_max,y_min,y_max] = fv_axissetting(polygonbase,path)
%--------------------------------------------------------------------------
% A f�ggv�ny c�lja:
% Meghat�rozni a k�bel nyomvonala k�r�li �bra hat�rol� koordin�t�it,
% 1 AGV m�retnyire minden ir�nyban.
%--------------------------------------------------------------------------
length_poly = max(polygonbase(1,:)) - min(polygonbase(1,:));% Length of polygon.
width_poly  = max(polygonbase(2,:)) - min(polygonbase(2,:));% Width of polygon.
sizepoly = max(length_poly,width_poly);% Maximal size of AGV.
x_min = min(path(1,:)) - sizepoly;% A leg BAL  koordin�ta.
x_max = max(path(1,:)) + sizepoly;% A leg JOBB koordin�ta.
y_min = min(path(2,:)) - sizepoly;% A leg LENT koordin�ta.
y_max = max(path(2,:)) + sizepoly;% A leg FENT koordin�ta.
%--------------------------------------------------------------------------
% A nem csak sz�gletes, hanem n�gyzetes �bra koordin�t�inak kisz�m�t�sa.
xsize = x_max - x_min;
ysize = y_max - y_min;
screensize = max(xsize,ysize);
x_max = x_min + screensize;
y_max = y_min + screensize;
end