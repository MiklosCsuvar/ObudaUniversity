function agvmoving()
%--------------------------------------------------------------------------
% Verzi�: 9.0.0
% A f�ggv�ny c�lja:
% 1. Elfordulni, ha a k�belnyomvonal nem egyenes, �s a k�z�ppontot
% az �rz�kel�k k�z�tt tudni tartani.
% 2. Olyan k�zel vinni az AGV-t a k�belhez, hogy az �rz�kel�k jel�nek
% k�l�nbs�ge a lehet� legkisebb legyen.
% Em�gyen a k�bel az �rz�kel�k k�z�tt a lehet� legjobban k�z�pre esik.
%--------------------------------------------------------------------------
global path cableroute pos_det pos_agv phi_agv pos_end phi_elf
global szimhossz_tervezett
global d_agv2endpos dist_agvendpos haladasiirany
global AGVpolygon time plotting kilepes kepkockaotaido keppermp
global l_agv siker tavolsag_agv kozelipont_agv
%--------------------------------------------------------------------------
disp('agvmoving starts.');
% AGV kezd�poz�ci�ba �ll�t�sa (x,y,phi).
% pos_agv = (cableroute(1:3,1)+cableroute(1:3,2))/2;
pos_agv = (path(1:3,1)+path(1:3,2))/2;
AGVpolygon = agvcalc();% Az AGV param�terei alapj�n kisz�molja az AGV k�rvonalait. AGV plottol�s�hoz sz�ks�ges pontok.
pos_det = detcalc();
disp('Detektorok helye:');
disp(pos_det);
phi_path = atan2(path(2,2)-path(2,1),path(1,2)-path(1,1));% A p�lya ir�nysz�ge.
phi_elf = (phi_path - phi_agv) + (-1+haladasiirany)*pi/2;% Az elforgat�s sz�ge.
AGVpolygon = polygonrot(AGVpolygon,phi_elf,pos_agv); % AGV pontjainak az els� nyomvonalszakasz ir�ny�ba ford�t�sa.
pos_det = polygonrot(pos_det,phi_elf,pos_agv); % �rz�kel�k pontjainak az els� nyomvonalszakasz ir�ny�ba ford�t�sa.
disp('Detektorok helye:');
disp(pos_det);
phi_agv = phi_agv+phi_elf; % AGV sz�gpoz�ci� sz�m�t�sa.
% K�bel, AGV, �rz�kel�k �br�zol�sa:
if (plotting == 1)
    plot(cableroute(1,:),cableroute(2,:),AGVpolygon(1,:),AGVpolygon(2,:),pos_det(1,:),pos_det(2,:));
end
%--------------------------------------------------------------------------
time = 0; % A szimul�ci� kezdete �ta eltelt id�.
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
        uzenet = ['Lej�rt az id�: time >= szimhossz_tervezett: ' num2str(time), ' >= ', num2str(szimhossz_tervezett), '.'];
        disp(uzenet);
        megvanido = 0;
    end
    if(nemertcelba == 1 && megvanido == 1 && tavolsag_agv > l_agv)
        msgbox('A szimulaci� kisiklott.');
        disp('Error in agvmoving.m: Kisikl�s.')
        disp('kozelipont_agv, pos_agv:');
        disp([kozelipont_agv,pos_agv]);
        uzenet = ['Az AGV-p�lya t�vols�g nagyobb mint az AGV hossza: ', num2str(tavolsag_agv), ' > ', num2str(l_agv), '.'];
        disp(uzenet);
        kilepes = 1;
        %break;% Ha az AGV kimegy a k�perny� sz�l�re vagy azon t�l, akkor a szimul�ci�nak v�ge.
    end
end
%--------------------------------------------------------------------------
disp('agvmoving.m stops.');
end