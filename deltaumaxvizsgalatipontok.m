function deltaumaxvizsgalatipontok()
%--------------------------------------------------------------------------
% Verzi�: 1.0
% A f�ggv�ny c�lja:
% Kisz�molni azokat a pontokat, amik �rdekesek lehetnek a fesz�lts�ger�s�t�s szempontj�b�l.
% Ezek azok a pontok, ahol nagyon nagy vagy nagyon kicsi fesz�lts�g
% induk�l�dik.
% Ilyen hely az egynes szakaszok felez�pontja, de k�l�n�sen a kanyarok
% bels� �s k�ls� �ve.
%--------------------------------------------------------------------------
% Inicializ�l�s
global path cableroute
global x_min x_max y_min y_max
global width_cableroute width_path
global vizsgalandoindexek tmptavuj tmptavmax
%--------------------------------------------------------------------------
disp('A deltaumax.m-hez sz�ks�ges pontok keres�se indul.');
tmp = (path(1:3,1) == path(1:3,width_path));
zartgorbe = min(tmp);
width_vizsgalandoindexek = 2*(width_path-1);
if (zartgorbe == 0)
    width_vizsgalandoindexek = width_vizsgalandoindexek + 1;
end
vizsgalandoindexek = zeros(1,width_vizsgalandoindexek,'int32');
tmptavmax = sqrt((x_max-x_min)^2+(y_max-y_min)^2);
% Megkeresi a path nyomvonalv�ltoz� elemeinek megfelel� nyomvonalelemeket a cableroutecalc-b�l.
% Ezek a 'vizsgalandoindexek' p�ratlan indexet elfoglal� elemei.
felsokorlat = width_path-1;
if (zartgorbe == 0)
    felsokorlat = width_path;
end
for i = 1:felsokorlat
    tmptavregi = tmptavmax;
    tmppath = path(1:3,i);
    for j = 1:width_cableroute
        tmp = tmppath-cableroute(1:3,j);
        tmptavuj = norm(tmp,2);
        if(tmptavuj <= tmptavregi)
            tmptavregi = tmptavuj;
            vizsgalandoindexek(1,2*(i-1)+1) = j;
        end
    end
%     uzenet = ['index(1,',num2str(2*(i-1)+1),') = ',num2str(vizsgalandoindexek(1,2*(i-1)+1))];
%     disp(uzenet);
end
disp('A path v�ltoz�nak megfelel� pontokat megtal�ltam.');
%
% Megkeresi a path nyomvonalv�ltoz� elemei k�z�tt f�l�ton lev� nyomvonalelemeket a cableroutecalc-b�l.
% Ezek a 'vizsgalandoindexek' p�ros indexet elfoglal� elemei.
felsokorlat = width_path-1;
for i = 1:felsokorlat
    tmptavregi = tmptavmax;
    tmppath = (path(1:3,i)+path(1:3,i+1))/2;
    for j = 1:width_cableroute
        tmp = tmppath-cableroute(1:3,j);
        tmptavuj = norm(tmp,2);
        if(tmptavuj <= tmptavregi)
            tmptavregi = tmptavuj;
            vizsgalandoindexek(1,2*i) = j;
        end
    end
%     uzenet = ['index(1,',num2str(2*i),') = ',num2str(vizsgalandoindexek(1,2*(i-1)+1))];
%     disp(uzenet);
end
%
disp('A path v�ltoz� elemei k�z�tti pontoknak megfelel� pontokat megtal�ltam.');
%
end