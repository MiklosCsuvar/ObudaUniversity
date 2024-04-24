function agvmoving()
%--------------------------------------------------------------------------
% Verzió: 9.0.0
% A függvény célja:
% 1. Elfordulni, ha a kábelnyomvonal nem egyenes, és a középpontot
% az érzékelök között tudni tartani.
% 2. Olyan közel vinni az AGV-t a kábelhez, hogy az érzékelök jelének
% különbsége a lehetö legkisebb legyen.
% Emígyen a kábel az érzékelök között a lehetö legjobban középre esik.
%--------------------------------------------------------------------------
global path cableroute pos_det pos_agv phi_agv pos_end phi_elf
global szimhossz_tervezett
global d_agv2endpos dist_agvendpos haladasiirany
global AGVpolygon time plotting kilepes kepkockaotaido keppermp
global l_agv siker tavolsag_agv kozelipont_agv
%--------------------------------------------------------------------------
disp('agvmoving starts.');
% AGV kezdöpozícióba állítása (x,y,phi).
% pos_agv = (cableroute(1:3,1)+cableroute(1:3,2))/2;
pos_agv = (path(1:3,1)+path(1:3,2))/2;
AGVpolygon = agvcalc();% Az AGV paraméterei alapján kiszámolja az AGV körvonalait. AGV plottolásához szükséges pontok.
pos_det = detcalc();
disp('Detektorok helye:');
disp(pos_det);
phi_path = atan2(path(2,2)-path(2,1),path(1,2)-path(1,1));% A pálya irányszöge.
phi_elf = (phi_path - phi_agv) + (-1+haladasiirany)*pi/2;% Az elforgatás szöge.
AGVpolygon = polygonrot(AGVpolygon,phi_elf,pos_agv); % AGV pontjainak az elsö nyomvonalszakasz irányába fordítása.
pos_det = polygonrot(pos_det,phi_elf,pos_agv); % Érzékelök pontjainak az elsö nyomvonalszakasz irányába fordítása.
disp('Detektorok helye:');
disp(pos_det);
phi_agv = phi_agv+phi_elf; % AGV szögpozíció számítása.
% Kábel, AGV, érzékelök ábrázolása:
if (plotting == 1)
    plot(cableroute(1,:),cableroute(2,:),AGVpolygon(1,:),AGVpolygon(2,:),pos_det(1,:),pos_det(2,:));
end
%--------------------------------------------------------------------------
time = 0; % A szimuláció kezdete óta eltelt idö.
nemertcelba = 1;
megvanido = 1;
kilepes = 0;
disp('**************************************************************');
uzenet = ['ido[s] = ', num2str(time)];
disp(uzenet);
movementcalculation();
movementdatasaving();
movementdoing();
while(nemertcelba == 1 && megvanido == 1 && kilepes == 0)
    %----------------------------------------------------------------------
    % 1. szakasz:
    disp('**************************************************************');
    uzenet = ['ido[s] = ', num2str(time)];
    disp(uzenet);
    movementcalculation();
    movementdatasaving();
    if(kepkockaotaido>=(1/keppermp))
        filmezes();
        kepkockaotaido = 0;
    end
    movementdoing();
    %----------------------------------------------------------------------
    if(dist_agvendpos <= d_agv2endpos)
        uzenet = ['Siker: dist_agvendpos = ', num2str(dist_agvendpos), 'm <= d_agv2endpos = ', num2str(d_agv2endpos), ' m.'];
        disp(uzenet);
        disp('pos_end pos_agv');
        disp([pos_end,pos_agv]);
        nemertcelba = 0;
        siker = 1;
    end
    if(time > szimhossz_tervezett)
        uzenet = ['Lejárt az idö: time >= szimhossz_tervezett: ' num2str(time), ' >= ', num2str(szimhossz_tervezett), '.'];
        disp(uzenet);
        megvanido = 0;
    end
    if(nemertcelba == 1 && megvanido == 1 && tavolsag_agv > l_agv)
        msgbox('A szimulació kisiklott.');
        disp('Error in agvmoving.m: Kisiklás.')
        disp('kozelipont_agv, pos_agv:');
        disp([kozelipont_agv,pos_agv]);
        uzenet = ['Az AGV-pálya távolság nagyobb mint az AGV hossza: ', num2str(tavolsag_agv), ' > ', num2str(l_agv), '.'];
        disp(uzenet);
        kilepes = 1;
        %break;% Ha az AGV kimegy a képernyö szélére vagy azon túl, akkor a szimulációnak vége.
    end
end
%--------------------------------------------------------------------------
disp('agvmoving.m stops.');
end