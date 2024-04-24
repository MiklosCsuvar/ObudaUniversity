function xy = polygonmove(xy, delta)
%--------------------------------------------------------------------------
% Verzió: 3.0
% A függvény célja:
% - Eltolni az 'xy' bemeneti sokszöget,
% - a 'delta' bementi vektorral,
% - az új (x, y) pozícióba.
% Bemenet:
% xy: a sokszög koordinátáinak (2,n) mátrixa.
% delta: A pozícióváltozás (2,1) vektora.
% Az új koordinátákat a régiekböl pontonként számolja ki.
%--------------------------------------------------------------------------
xy_width = size(xy,2);
xy_length = size(xy,1);
delta_length = size(delta,1);
%
if(xy_length ~= delta_length)
    uzenet = ['Error in polygonmove.m: A tömb sorszáma', num2str(xy_length),' és a delta sorszáma', num2str(delta_length), ' eltér.'];
    disp(uzenet);
end
%
for i = 1:xy_width
    xy(: , i) = xy(: , i) + delta;
end
end