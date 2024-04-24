function array = straightlinemake(v1,v2,step)
%--------------------------------------------------------------------------
% Verzió: 2.1
% A függvény célja:
% 1. Ellenörizni, hogy megfelel?en kicsi-e a lépésköz az egyenesvonal
% megrajzolásához.
% 2. Kiszámítani az egynes szakasz pontjait az [x1;y1] és [x2;y2] bemeneti
% koordináták között, mindegyik pontot egy 'lépésnyire' [x1;y1]-töl [x2;y2] felé. 
% 3. Összefüzni a fenti pontokat.
% Bemenet:
% v1, v2: (2,1) oszlopvektor.
% step: 1 db szám.
%--------------------------------------------------------------------------
% 1. szakasz
length = norm(v2-v1,2); % A vektorok közötti távolság.
if (step > length) % Ha a megadott lépésköz nagyobb a kezdö- és  végpont távolságánál,
    step = step/10; % akkor csökkenteni kell a lépésközt.
    disp('Warning in straightlinemake.m: Az egyenes szakasz felbontása túl nagy. Az eredeti 1/10-ére csökkentettem.');
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