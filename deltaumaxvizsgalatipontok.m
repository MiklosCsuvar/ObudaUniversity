function deltaumaxvizsgalatipontok()
%--------------------------------------------------------------------------
% Verzió: 1.0
% A függvény célja:
% Kiszámolni azokat a pontokat, amik érdekesek lehetnek a feszültségerösítés szempontjából.
% Ezek azok a pontok, ahol nagyon nagy vagy nagyon kicsi feszültség
% indukálódik.
% Ilyen hely az egynes szakaszok felezöpontja, de különösen a kanyarok
% belsö és külsö íve.
%--------------------------------------------------------------------------
% Inicializálás
global path cableroute
global x_min x_max y_min y_max
global width_cableroute width_path
global vizsgalandoindexek tmptavuj tmptavmax
%--------------------------------------------------------------------------
disp('A deltaumax.m-hez szükséges pontok keresése indul.');
tmp = (path(1:3,1) == path(1:3,width_path));
zartgorbe = min(tmp);
width_vizsgalandoindexek = 2*(width_path-1);
if (zartgorbe == 0)
    width_vizsgalandoindexek = width_vizsgalandoindexek + 1;
end
vizsgalandoindexek = zeros(1,width_vizsgalandoindexek,'int32');
tmptavmax = sqrt((x_max-x_min)^2+(y_max-y_min)^2);
% Megkeresi a path nyomvonalváltozó elemeinek megfelelö nyomvonalelemeket a cableroutecalc-ból.
% Ezek a 'vizsgalandoindexek' páratlan indexet elfoglaló elemei.
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
disp('A path változónak megfelelö pontokat megtaláltam.');
%
% Megkeresi a path nyomvonalváltozó elemei között félúton levö nyomvonalelemeket a cableroutecalc-ból.
% Ezek a 'vizsgalandoindexek' páros indexet elfoglaló elemei.
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
disp('A path változó elemei közötti pontoknak megfelelö pontokat megtaláltam.');
%
end