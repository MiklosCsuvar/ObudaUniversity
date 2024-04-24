function xy = polygonmove(xy, delta)
%--------------------------------------------------------------------------
% Verzi�: 3.0
% A f�ggv�ny c�lja:
% - Eltolni az 'xy' bemeneti soksz�get,
% - a 'delta' bementi vektorral,
% - az �j (x, y) poz�ci�ba.
% Bemenet:
% xy: a soksz�g koordin�t�inak (2,n) m�trixa.
% delta: A poz�ci�v�ltoz�s (2,1) vektora.
% Az �j koordin�t�kat a r�giekb�l pontonk�nt sz�molja ki.
%--------------------------------------------------------------------------
xy_width = size(xy,2);
xy_length = size(xy,1);
delta_length = size(delta,1);
%
if(xy_length ~= delta_length)
    uzenet = ['Error in polygonmove.m: A t�mb sorsz�ma', num2str(xy_length),' �s a delta sorsz�ma', num2str(delta_length), ' elt�r.'];
    disp(uzenet);
end
%
for i = 1:xy_width
    xy(: , i) = xy(: , i) + delta;
end
end