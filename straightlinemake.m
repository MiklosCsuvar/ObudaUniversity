function array = straightlinemake(v1,v2,step)
%--------------------------------------------------------------------------
% Verzi�: 2.1
% A f�ggv�ny c�lja:
% 1. Ellen�rizni, hogy megfelel?en kicsi-e a l�p�sk�z az egyenesvonal
% megrajzol�s�hoz.
% 2. Kisz�m�tani az egynes szakasz pontjait az [x1;y1] �s [x2;y2] bemeneti
% koordin�t�k k�z�tt, mindegyik pontot egy 'l�p�snyire' [x1;y1]-t�l [x2;y2] fel�. 
% 3. �sszef�zni a fenti pontokat.
% Bemenet:
% v1, v2: (2,1) oszlopvektor.
% step: 1 db sz�m.
%--------------------------------------------------------------------------
% 1. szakasz
length = norm(v2-v1,2); % A vektorok k�z�tti t�vols�g.
if (step > length) % Ha a megadott l�p�sk�z nagyobb a kezd�- �s  v�gpont t�vols�g�n�l,
    step = step/10; % akkor cs�kkenteni kell a l�p�sk�zt.
    disp('Warning in straightlinemake.m: Az egyenes szakasz felbont�sa t�l nagy. Az eredeti 1/10-�re cs�kkentettem.');
end
%--------------------------------------------------------------------------
% 2-3. szakasz
array = [v1];
if (v1(1,1) ~= v2(1,1) || v1(2,1) ~= v2(2,1) || v1(3,1) ~= v2(3,1))
    tmp = length;
    egysegvektor = (v2-v1)/norm(v2-v1,2);
    tmpvec = v1;
    while (tmp > 0)
        tmpvec = tmpvec+(step*egysegvektor);
        array = [array, tmpvec];
        tmp = tmp - step;
    end
    array = [array, v2];
end
%--------------------------------------------------------------------------
end