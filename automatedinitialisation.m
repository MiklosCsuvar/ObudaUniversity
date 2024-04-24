function automatedinitialisation()
%--------------------------------------------------------------------------
% Verzi�: 5.0
% 0. szakasz: A glob�lis v�ltoz�k beolvas�sa
% 1. szakasz: A tervezett p�lya nyomvonal�nak megad�sa.
% 2. szakasz: A sebess�gek alap�rt�kei.
% 3. szakasz: A kanyarok sugarainak kisz�m�t�sa
% 4. szakasz: Az �br�zol�s hat�rainak kisz�m�t�sa.
% 5. szakasz: Filmk�sz�t�s, kimenetment�s inicializ�l�sa, konfigur�ci�ment�s.
% 6. szakasz: A m�gneses indukci�s t�r bet�lt�se vagy kisz�m�t�sa.
% 7. szakasz: Elektrom�gneses alap�rt�kek.
%--------------------------------------------------------------------------
% 0. szakasz: A glob�lis v�ltoz�k beolvas�sa
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
%-------Automatikus param�tersz�m�t�s a k�zi be�ll�t�sok alapj�n.----------
% 1. szakasz: A tervezett p�lya nyomvonal�nak megad�sa.
width_path = size(path,2); % Az oszlopok sz�ma (a nyomvonal pontjainak sz�ma).
%--------------------------------------------------------------------------
% 2. szakasz: A sebess�gek alap�rt�kei.
vtomb_meret = max(size(vtomb,1),size(vtomb,2));
vmax = max(vtomb); % Az AGV maxim�lis sbess�ge [m/s].
vmin = min(vtomb); % Az AGV minim�lis sbess�ge [m/s].
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
% 3. szakasz: A kanyarok sugarainak kisz�m�t�sa
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
% 4. szakasz: Az �br�zol�s hat�rainak kisz�m�t�sa. A k�bel nyomvonal�nak
% kisz�m�t�sa.
agvpoints = agvcalc(); % Az AGV pontjai. Az origo az AGV forg�sk�z�ppontja egyben az �rz�kel�k k�z�tti szakasz felez�pontja.
[x_min,x_max,y_min,y_max] = fv_axissetting(agvpoints,path); % A nyomvonalat befoglal� t�glalapot hat�rol� egyenesek koordin�t�i.
if (path(1:3,1) == path(1:3,width_path))% Ha a k�belnyomvonal z�rt hurok,
    pos_end = [x_max+2*d_agv2endpos;y_max+2*d_agv2endpos;0];% akkor a c�l egy a nyomvonal v�g�hez k�zeli pont,
else
    phipath = atan2(path(2,width_path)-path(2,width_path-1),path(1,width_path)-path(1,width_path-1));
    delta_end = [d_agv2endpos*cos(phipath);d_agv2endpos*sin(phipath);0];
    pos_end = path(:,width_path)+delta_end;% k�l�nben az utols� nyomvonalpont.
end
lepeskoz = 0.01;% A poz�ci�v�ltoz�si vektor egys�g�nek hossza [m].
delta = nyomvonalfelbontas;
cableroutecalc(); % K�belnyomvonal-sz�m�t�s
biotsavartpontokszamitasa(); % Pontok a Biot-Savart t�rv�ny sz�m�t�s�hoz
deltaumaxvizsgalatipontok(); % pontok a sz�ks�ges er�s�t�s sz�m�t�s�hoz.
%--------------------------------------------------------------------------
% 5. szakasz: Filmk�sz�t�s, kimenetment�s inicializ�l�sa, konfigur�ci�ment�s.
if (plotting == 0) % Ha nincs �bra,
    filmmaking = 0; %akkor a film elment�se is felesleges.
end
if (szimhossz_tervezett < 0) % Ha a megadott id�keret nem pozit�v,
    szimhossz_tervezett = 600; % akkor egy kell�en hossz� id�t adunk meg.
end
%
tmpfilelocation = filenaming(filelocation,filename);
if (filmmaking==1)
    %Filminicializ�l�s.
    if (strcmp(film_profil,'Uncompressed AVI'))
        filmpath = strcat(tmpfilelocation,'.avi');
    else
        filmpath = strcat(tmpfilelocation,'.mp4');
    end
    writerObj = VideoWriter(filmpath,film_profil);
    writerObj.FrameRate = keppermp;
    open(writerObj);
    %Konfigur�ci�ment�s.
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
axis([x_min x_max y_min y_max]);% �bra tengely�nek be�ll�t�si param�terei.
if (exist('vec_aspect') == 1) % K�pm�retar�ny be�ll�t�sa, E==1.
    if (size(vec_aspect,2) == 3)
        daspect(vec_aspect);
    end    
end
%--------------------------------------------------------------------------
% 6. szakasz: A m�gneses indukci�s t�r bet�lt�se vagy kisz�m�t�sa.
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
% 7. szakasz: Elektrom�gneses alap�rt�kek kisz�m�t�sa.
amplitude = mu0*I/(2*pi); % Az �rz�kel� jel�nek amplit�d�ja: I/2pi, ahol I a k�bel �ramer�ss�ge [Vs/m]
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
    feszerosites = ADClimit/tmpfesz; % �gy a feler�s�tett induk�lt fesz�ltsd�g kit�lti a teljes tartom�nyt.
    signal_max = ADatalakito(tmpfesz*feszerosites, ADfelbontas, ADClimit, AvagyD);
end
uzenet = ['A fesz�lts�ger�s�t�s: ', num2str(feszerosites)];
disp(uzenet);
%--------------------------------------------------------------------------
end