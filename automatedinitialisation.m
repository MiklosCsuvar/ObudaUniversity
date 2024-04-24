function automatedinitialisation()
%--------------------------------------------------------------------------
% Verzió: 5.0
% 0. szakasz: A globális változók beolvasása
% 1. szakasz: A tervezett pálya nyomvonalának megadása.
% 2. szakasz: A sebességek alapértékei.
% 3. szakasz: A kanyarok sugarainak kiszámítása
% 4. szakasz: Az ábrázolás határainak kiszámítása.
% 5. szakasz: Filmkészítés, kimenetmentés inicializálása, konfigurációmentés.
% 6. szakasz: A mágneses indukciós tér betöltése vagy kiszámítása.
% 7. szakasz: Elektromágneses alapértékek.
%--------------------------------------------------------------------------
% 0. szakasz: A globális változók beolvasása
global delta lepeskoz I mu0 amplitude
global N frekvencia Rtek tekercskeresztmetszet amplitude_U
global indukciostenyezo feszerosites
global x_min x_max y_min y_max
global delta_absU_max delta_absU_max_position U_max U_max_position
global szimhossz_tervezett path
global pos_end 
global R
global ADfelbontas vmax vmin
global d_agv2endpos width_path
global filelocation filename fileID keppermp parametermentesfajlba
global writerObj szimulaciokonyvtarhelye film_profil
global plotting filmmaking palyakanyaroksugara
global AvagyD ADClimit signal_max vtomb vtomb_meret deltavbalvjobboszlop deltavbalvjobboszlopsorszam
global deltavbalvjobbtomb nyomvonalfelbontas
global cableroute aramirany vektorvagyskalar width_cableroute gorbeseg
global BSmag detektorszam korabban_szamitott_indukcio
%--------------------------------------------------------------------------
%-------Automatikus paraméterszámítás a kézi beállítások alapján.----------
% 1. szakasz: A tervezett pálya nyomvonalának megadása.
width_path = size(path,2); % Az oszlopok száma (a nyomvonal pontjainak száma).
%--------------------------------------------------------------------------
% 2. szakasz: A sebességek alapértékei.
vtomb_meret = max(size(vtomb,1),size(vtomb,2));
vmax = max(vtomb); % Az AGV maximális sbessége [m/s].
vmin = min(vtomb); % Az AGV minimális sbessége [m/s].
%
deltavbalvjobbtomb = zeros(vtomb_meret,vtomb_meret,'double');
for i = 1:vtomb_meret
    for j = 1:vtomb_meret
        deltavbalvjobbtomb(i,j) = vtomb(i,1) - vtomb(j,1);
    end
end
%
tmp = zeros(vtomb_meret^2,1,'double');
for i = 1:vtomb_meret
    tmp((i-1)*vtomb_meret+1:i*vtomb_meret,1) = deltavbalvjobbtomb(:,i);
end
deltavbalvjobboszlop = unique(tmp);
deltavbalvjobboszlop = sort(deltavbalvjobboszlop,'descend');
deltavbalvjobboszlopsorszam = size(deltavbalvjobboszlop,1);
%--------------------------------------------------------------------------
% 3. szakasz: A kanyarok sugarainak kiszámítása
palyakanyaroksugara = zeros(1,width_path,'double');
if(path(1:3,1) == path(1:3,width_path))
    palyakanyaroksugara(1,1) = R;
    palyakanyaroksugara(1,width_path) = R;
else
    palyakanyaroksugara(1) = 0;
    palyakanyaroksugara(1, width_path) = 0;
end
for i = 2:width_path-1
    palyakanyaroksugara(1,i) = R;
end
%--------------------------------------------------------------------------
% 4. szakasz: Az ábrázolás határainak kiszámítása. A kábel nyomvonalának
% kiszámítása.
agvpoints = agvcalc(); % Az AGV pontjai. Az origo az AGV forgásközéppontja egyben az érzékelök közötti szakasz felezöpontja.
[x_min,x_max,y_min,y_max] = fv_axissetting(agvpoints,path); % A nyomvonalat befoglaló téglalapot határoló egyenesek koordinátái.
if (path(1:3,1) == path(1:3,width_path))% Ha a kábelnyomvonal zárt hurok,
    pos_end = [x_max+2*d_agv2endpos;y_max+2*d_agv2endpos;0];% akkor a cél egy a nyomvonal végéhez közeli pont,
else
    phipath = atan2(path(2,width_path)-path(2,width_path-1),path(1,width_path)-path(1,width_path-1));
    delta_end = [d_agv2endpos*cos(phipath);d_agv2endpos*sin(phipath);0];
    pos_end = path(:,width_path)+delta_end;% különben az utolsó nyomvonalpont.
end
lepeskoz = 0.01;% A pozícióváltozási vektor egységének hossza [m].
delta = nyomvonalfelbontas;
cableroutecalc(); % Kábelnyomvonal-számítás
biotsavartpontokszamitasa(); % Pontok a Biot-Savart törvény számításához
deltaumaxvizsgalatipontok(); % pontok a szükséges erösítés számításához.
%--------------------------------------------------------------------------
% 5. szakasz: Filmkészítés, kimenetmentés inicializálása, konfigurációmentés.
if (plotting == 0) % Ha nincs ábra,
    filmmaking = 0; %akkor a film elmentése is felesleges.
end
if (szimhossz_tervezett < 0) % Ha a megadott idökeret nem pozitív,
    szimhossz_tervezett = 600; % akkor egy kellöen hosszú idöt adunk meg.
end
%
tmpfilelocation = filenaming(filelocation,filename);
if (filmmaking==1)
    %Filminicializálás.
    if (strcmp(film_profil,'Uncompressed AVI'))
        filmpath = strcat(tmpfilelocation,'.avi');
    else
        filmpath = strcat(tmpfilelocation,'.mp4');
    end
    writerObj = VideoWriter(filmpath,film_profil);
    writerObj.FrameRate = keppermp;
    open(writerObj);
    %Konfigurációmentés.
    configurationpath = strcat(szimulaciokonyvtarhelye, 'configuration.m');
    fileID1 = fopen(configurationpath, 'r');
    configurationdata = fread(fileID1);
    newcfgpath = strcat(tmpfilelocation,'.cfg');
    fileID2 = fopen(newcfgpath, 'w');
    fprintf(fileID2, '%c', configurationdata);
    fclose(fileID2);
    fclose(fileID1);
    newcfgpath = strcat(tmpfilelocation,'.cbl');
    fileID3 = fopen(newcfgpath, 'w');
    for i = 1:width_cableroute
        fprintf(fileID3, '%f;%f;%f;%f;%f\n', i,gorbeseg(i),cableroute(1,i),cableroute(2,i),cableroute(3,i));
    end
    fclose(fileID3);
end
%
if (parametermentesfajlba == 1)
    kimenet = strcat(tmpfilelocation,'.txt');
    fileID = fopen(kimenet,'w');
    str = 'time;osszes_megtett_ut;signal;vbal;vjobb; phi_agv2cableroute';
    strtmp = ';tavolsag_agv;pos_agv(1,1);pos_agv(2,1);pos_agv(3,1);kozelipont_agv(1,1);kozelipont_agv(2,1);kozelipont_agv(3,1);palyagorbeseg(idxcur_agv);idxcur_agv';
    str = strcat(str,strtmp);
    for i = 1:detektorszam
        strtmp = strcat(';tavolsag_det(',num2str(i),');pos_det(1,',num2str(i),');pos_det(2,',num2str(i),');pos_det(3,',num2str(i),');kozelipont_det(1,',num2str(i),');kozelipont_det(2,',num2str(i),');kozelipont_det(3,',num2str(i),');palyagorbeseg(idxcur_det(',num2str(i),'));idxcur_det(',num2str(i),'); U_analog_erositetlen(',num2str(i),'); U_dig(',num2str(i),')');
        str = strcat(str,strtmp);
    end
    str = strcat(str,'\n');
fprintf(fileID,str);
%
axis([x_min x_max y_min y_max]);% Ábra tengelyének beállítási paraméterei.
if (exist('vec_aspect') == 1) % Képméretarány beállítása, E==1.
    if (size(vec_aspect,2) == 3)
        daspect(vec_aspect);
    end    
end
%--------------------------------------------------------------------------
% 6. szakasz: A mágneses indukciós tér betöltése vagy kiszámítása.
if (strcmp(vektorvagyskalar,'BSmag'))
    if (strcmp(korabban_szamitott_indukcio,''))
        BSmag = BSmag_init();
        Gamma = cableroute';
        dGamma = nyomvonalfelbontas;
        [BSmag] = BSmag_add_filament(BSmag,Gamma,I*aramirany,dGamma);
    else
        load(korabban_szamitott_indukcio,'X_M','Y_M','Z_M','BX','BY','BZ');
    end
end
%--------------------------------------------------------------------------
% 7. szakasz: Elektromágneses alapértékek kiszámítása.
amplitude = mu0*I/(2*pi); % Az érzékelö jelének amplitúdója: I/2pi, ahol I a kábel áramerössége [Vs/m]
tekercskeresztmetszet = (Rtek^2)*pi; % [m2]
indukciostenyezo = tekercskeresztmetszet*2*pi*frekvencia*N;  % [m2/s]
amplitude_U = amplitude*indukciostenyezo; % [Vm]
signal_max = ADatalakito(ADClimit, ADfelbontas, ADClimit, AvagyD);
if (feszerosites == 0)
    [delta_absU_max, delta_absU_max_position, U_max, U_max_position] = deltaumax();
    uzenet = ['delta(abs(U))_max = ',num2str(delta_absU_max),' V'];
    disp(uzenet);
    uzenet = ['abs(U)_max = ',num2str(U_max),' V'];
    disp(uzenet);
    uzenet = ['ADClimit = ',num2str(ADClimit)];
    disp(uzenet);
    tmpfesz = max(abs(delta_absU_max),abs(U_max));
    feszerosites = ADClimit/tmpfesz; % Így a felerösített indukált feszültsdég kitölti a teljes tartományt.
    signal_max = ADatalakito(tmpfesz*feszerosites, ADfelbontas, ADClimit, AvagyD);
end
uzenet = ['A feszültségerösítés: ', num2str(feszerosites)];
disp(uzenet);
%--------------------------------------------------------------------------
end