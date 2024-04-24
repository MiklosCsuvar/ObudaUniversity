% configuration
%--------------------------------------------------------------------------
% Verzi�: 2.0
% Ezeket a param�tereket a felhaszn�l�nak kell be�ll�tania.
% Kiv�ve:
% 1. A nyomvonal (path), ami itt is be�ll�that�, vagy
% kiv�laszthat� egy nyomvonal a 'pathsfortesting' f�jlb�l.
% 2. Vannak k�zzel nem m�dos�tand� param�terek vagy v�ltoz�k.
% �rt�k�ket a program m�dos�tja. Csak az�rt szerepelnek itt, hogy
% a Workspace-ben megjelenjenek. Megjelen�t�s�k:
    %----------------------------------------------------------------------
    % �rt�kead�s az automatedinitialisation.m-ben vagy m�s f�ggv�nyben.
    % TILOS K�ZZEL �LL�TANI! ->
    
    % <- TILOS K�ZZEL �LL�TANI!
%--------------------------------------------------------------------------
% 1. szakasz: % A k�belnyomvonalak adatai
% 2. szakasz: Az AGV geometri�ja
% 3. szakasz: Az indukci�s �rz�kel�k param�terei
% 4. szakasz: Az �ramj�rta vezet�
% 5. szakasz: A fesz�lts�ger�s�t�s �s az A/D �talak�t� param�terei
% 6. szakasz: Az AGV mozg�s�nak alapparam�terei
% 7. szakasz: A mozg�s k�zbeni sz�m�t�sok
% 8. szakasz: A szimul�ci� id�param�terei �s eredm�nyeinek lement�se:
% 9. szakasz: Egy�b param�terek
%--------------------------------------------------------------------------
% 1. szakasz :A k�belnyomvonalak adatai:
% Soksz�g k�rvonal - ak�rmilyen -  koordin�t�k �s �rz�kel� poz�ci�k.
global path R nyomvonalfelbontas
global cableroute gorbeseg width_cableroute palyakanyarokcentruma palyakanyaroksugara
global tavolsag_agv  idxcur_agv kozelipont_agv phi_agv2cableroute
global gorbuletisugar_max gorbuletisugar_min
global kanyarpontokindexei biotsavartpontokindexei vizsgalandoindexek vizsgalandopontindexe
pathsfortesting;% A lehets�ges nyomvonalakat tartalmaz� f�jl.
path = path15;% A nyomvonal sorsz�ma pl. 1, 2, ..., 9, ..., 19. Csak a 'pathfortesting.m'-ben megadott sz�mok megengedettek.
R = 0.20; % K�bel g�rb�leti sugara [m]. A 0 tilos!
nyomvonalfelbontas = 0.001; % A k�bel nyomvonal�nak kisz�m�t�si pontoss�ga [m].
    %----------------------------------------------------------------------
    % �rt�kead�s az automatedinitialisation.m-ben vagy m�s f�ggv�nyben.
    % TILOS K�ZZEL �LL�TANI! ->
    cableroute;
    gorbeseg;
    width_cableroute = 0;
    palyakanyarokcentruma;
    palyakanyaroksugara;
    tavolsag_agv = zeros(1, 1, 'double');
    idxcur_agv = ones(1, 1, 'int32');
    kozelipont_agv = zeros(1, 2, 'double');
    phi_agv2cableroute = 0;
    gorbuletisugar_max = 0;
    gorbuletisugar_min = 0;
    kanyarpontokindexei = 0;
    biotsavartpontokindexei = 0;
    vizsgalandoindexek = 0;
    vizsgalandopontindexe = 0;
    % <- TILOS K�ZZEL �LL�TANI!
%--------------------------------------------------------------------------
% 2. szakasz: Az AGV geometri�ja
global D d_kerekek d_det l_agv height_det AGVverzio pos_agv pos_end phi_agv
global phi_elf
D = 0.066; % A korm�nyzott kerekek �tm�r�je [m].
d_kerekek = 0.195; % A korm�nyzott kerekek t�vols�ga [m].
d_det = 0.20;% Az �rz�kel�k t�vols�ga [m].
l_agv  = 0.115; % AGV hossza (tkp. tengelyt�vols�ga) [m].
height_det = 0.02;%0.04; % �rz�kel�k k�z�ps�kj�nak magass�ga a p�lya s�kja felett [m].
AGVverzio = 0;% Ha �rt�ke 0/1, a bolyg�ker�k el�l/h�tul van.
    %----------------------------------------------------------------------
    % �rt�kead�s az automatedinitialisation.m-ben vagy m�s f�ggv�nyben.
    % TILOS K�ZZEL �LL�TANI! ->    
    pos_agv = [0;0;0]; % AGV poz�ci�ja (x,y). Forg�scentrum.
    pos_end = [0;0;0];% AGV c�lpoz�ci� (x,y).
    phi_agv = pi/2;% AGV kezdeti sz�ghelyzete.
    phi_elf = 0;
    % <- TILOS K�ZZEL �LL�TANI!
%--------------------------------------------------------------------------
% 3. szakasz: Az indukci�s �rz�kel�k param�terei
global N Rtek Htek frekvencia detektorszam nullakorulitures
global signal_det pos_det
global kozelipont_det idxcur_det tavolsag_det induction_det flux_det signal_det_erositetlen
global signal_diff signal_max jelmemoriahossz signal_det_tarolt
N = 400;% A tekercsel�s menetsz�ma.
Rtek = 0.01; % A tekercs sugara [m].
Htek = 0.02; % A tekercs magassaga [m].
frekvencia = 100000; % Az �ram frekvenci�ja [Hz].
detektorszam = 3; % [db] FIGYELEM!: A kimeneti txt f�jlba �r�shoz
% a v�ltoz�kat k�zzel kell m�dos�tani: automatedinitialisation.m, agvmoving.m!
nullakorulitures = 0; % Bit.
jelmemoriahossz = 5; % Az elt�rolt id�pillanatok sz�ma.
    %----------------------------------------------------------------------
    % �rt�kead�s az automatedinitialisation.m-ben vagy m�s f�ggv�nyben.
    % TILOS K�ZZEL �LL�TANI! ->    
    pos_det = zeros(3, detektorszam, 'double');
    tavolsag_det = zeros(1, detektorszam, 'double');
    idxcur_det = ones(1, detektorszam, 'int32');
    induction_det = zeros(3, detektorszam, 'double');
    flux_det = zeros(1, detektorszam, 'double');
    signal_det_erositetlen = zeros(1, detektorszam, 'double');
    signal_det = zeros(1, detektorszam, 'double');
    kozelipont_det =  zeros(3, detektorszam, 'double');
    signal_diff = 0;
    signal_max = 0;
    signal_det_tarolt = zeros(jelmemoriahossz, detektorszam, 'double');
    % <- TILOS K�ZZEL �LL�TANI!
%--------------------------------------------------------------------------
% 4. szakasz: Az �ramj�rta vezet�
global I mu0 aramirany
I = 1; % A k�belben foly� �ram amplit�d�ja [A].
mu0 = 4*pi*10^(-7);
aramirany = +1;% +1: pozit�v, -1: negat�v forg�sir�ny a p�lya ment�n.
%--------------------------------------------------------------------------
% 5. szakasz: A fesz�lts�ger�s�t�s �s az A/D �talak�t� param�terei
global feszerosites ADClimit ADfelbontas AvagyD
global indukciostenyezo amplitude_U
global delta_absU_max delta_absU_max_position U_max U_max_position deltaH_max
global deltaumaxkereses
feszerosites = 0;% A fesz�lts�ger�s�t�s mem�riafoglal�sa. �rt�ksz�m�t�sa az automatedinitialisation.m-ben t�rt�nik.
ADClimit = 5;% Az A/D �talak�t� alapfesz�lts�ge [V]: [-ADClimit;+ADClimit].
ADfelbontas = 10;% Az A/D-�talak�t� finoms�ga [bit].
AvagyD = 'b';% Ha �rt�ke 'a'/'d'/'b', akkor anal�g fesz�lts�g/digit�lis fesz�lts�g/bit bemenetet kap a szab�lyoz�s.
    %----------------------------------------------------------------------
    % �rt�kead�s az automatedinitialisation.m-ben vagy m�s f�ggv�nyben.
    % TILOS K�ZZEL �LL�TANI! ->    
    indukciostenyezo = 0;% A A tesla->volt konverzi�s t�nyez�. M�dos�tani tilos. �rt�kad�s: automatedinitialisation.m.
    amplitude_U = 0;
    delta_absU_max = 0;
    delta_absU_max_position = 0;
    U_max = 0;
    U_max_position = 0;
    deltaH_max = 0;
    deltaumaxkereses = 0;
    % <- TILOS K�ZZEL �LL�TANI!
%--------------------------------------------------------------------------
% 6. szakasz: Az AGV mozg�s�nak alapparam�terei
global delta_t vmax vmin vbal vjobb d_agv2endpos AGVpolygon delta_r
global vtomb deltavbalvjobbtomb deltavbalvjobboszlop delta_s vtomb_meret
global osszes_megtett_ut
delta_t = 0.1; % Id�l�p�s, id�k�z [m].
delta_s = 0; % Az id�l�p�s alatt megtett �t [m].
d_agv2endpos = 0.05;% A c�l minim�lis megk�zel�t�s meg�ll�shoz [m].
% Az AGV lehets�ges sebess�gei [m/s]:
vtomb = [1/2.5,1/3,1/4,0]; % Ez van beprogramozva most az AGV-be.
% felosztas = 8;
% tobbszorozes = 1;
% vtomb = (1/2.5)*tobbszorozes*linspace(1,0,felosztas+1);
vtomb = vtomb';
    %----------------------------------------------------------------------
    % �rt�kead�s az automatedinitialisation.m-ben vagy m�s f�ggv�nyben.
    % TILOS K�ZZEL �LL�TANI! ->    
    vmax = 0; % Az AGV maxim�lis sebess�ge [m/s].
    vmin = 0; % Az AGV minim�lis sebess�ge [m/s].
    vbal = 0;% A bal oldali ker�k ker�leti sebess�ge [m/s].
    vjobb = 0;% A jobb oldali ker�k ker�leti sebess�ge [m/s].
    AGVpolygon = [0;0];
    delta_r = 0; % Az elemi elmozdul�s vektora.
    deltavbalvjobbtomb = 0;
    deltavbalvjobboszlop = 0;
    vtomb_meret = 0;
    osszes_megtett_ut = 0;
    % <- TILOS K�ZZEL �LL�TANI!
%--------------------------------------------------------------------------
% 7. szakasz: A mozg�s k�zbeni sz�m�t�sok
global idxcur idxenv dist_agvpath haladasiirany gorbuletisugar vektorvagyskalar
global biotsavartpontok indukcio_finomkozelites_pontossag
global BSmag X_BSmag Y_BSmag Z_BSmag BX_BSmag BY_BSmag BZ_BSmag
global korabban_szamitott_indukcio BX BY BZ X_M Y_M Z_M signal2sebesseg_verzio
idxcur = 0;% Az AGV pillanatnyi poz�ci�j�nak indexe.
idxenv = 100;% A tov�bbhalad�shoz vizsg�lt "idxcur" k�rnyezet sugara.
dist_agvpath = 0; % Az AGV poz�ci�ja �s a k�belnyomvonal k�z�tti t�vols�g.
haladasiirany = +1;% +1: pozit�v, -1: negat�v forg�sir�ny a p�lya ment�n.
gorbuletisugar = 0;% A p�lya g�rb�leti sugara [m].
indukcio_finomkozelites_pontossag = 0.001; % [1]
vektorvagyskalar = 'BSmag'; % s: Skal�r B[T]. v: Vektor B[T] = [Bx;By;Bz]. BSmag: A BSmag_get_B MATLAB csomag haszn�lata.
signal2sebesseg_verzio = '1-2'; %
% Ki kell sz�molni �s �br�zolni a B(x,y,z) [T]-t?: Ha igen, akkor a
korabban_szamitott_indukcio = ''; % k�l�nben a megadott f�jlb�l kell bet�lteni a teret.
% korabban_szamitott_indukcio = 'F:\Kand�\szakdolgozat\jegyz�k�nyvek\absBz_per_Bzmax_path15_0.001m\absBz_per_Bzmax_path15_0.001m.mat';
    %----------------------------------------------------------------------
    % �rt�kead�s az automatedinitialisation.m-ben vagy m�s f�ggv�nyben.
    % TILOS K�ZZEL �LL�TANI! ->    
    biotsavartpontok = 0;
    BSmag = 0;
    X_BSmag = zeros(1,1,1,'double');
    Y_BSmag = zeros(1,1,1,'double');
    Z_BSmag = zeros(1,1,1,'double');
    BX_BSmag = zeros(1,1,1,'double');
    BY_BSmag = zeros(1,1,1,'double');
    BZ_BSmag = zeros(1,1,1,'double');
    BX = 0;
    BY = 0;
    BZ = 0;
    X_M = 0;
    Y_M = 0;
    Z_M = 0;
    % <- TILOS K�ZZEL �LL�TANI!
%--------------------------------------------------------------------------
% 8. szakasz: A szimul�ci� id�param�terei �s eredm�nyeinek lement�se
global plotting szimhossz_tervezett mozgas
global filmmaking filelocation filename keppermp timepassing vec_aspect
global parametermentesfajlba szimulaciokonyvtarhelye
global time kepkockaotaido teljesmozgasido film_profil
mozgas = 1; % Az AGV mozg�s�t szimul�lni kell?
parametermentesfajlba = 1;
szimulaciokonyvtarhelye = 'f:\Kand�\szakdolgozat\szimul�ci�\';
filelocation = 'f:\Kand�\szakdolgozat\film\';% A filmek ment�si k�nyvt�ra.
filename = 'agvmoving_9.0.0_15'; %"agvmoving_verzi�_nyomvonalsz�m"
plotting = 1; % K�sz�l �bra? Igen - 1; Nem - 0.
filmmaking = 1;% K�sz�l film? Igen - 1; Nem - 0.
keppermp = 25; % A k�p/s be�ll�t�sa. Vigy�zat! Ide�lis esetben delta_t*keppermp=1.
vec_aspect = [1 1 1]; % Aspect ratio be�ll�t�s. A m�sik lehet�s�g az 'auto'.
film_profil = 'Uncompressed AVI'; % Az 'Uncompressed AVI': gyorsabb plottol�s. 'MPEG-4': A f�jl r�helyesen kicsi.
timepassing = 2; % Timepassing = 0/1/m�s pozit�v �rt�k: semmi/1/egy�b id�k�z sz�net van a k�perny�k�pek k�z�tt.
% Egyszer�s�tettem vele a programot. Ld. mkpassedtm. �gy legfeljebb a timepassing = 1 s eset kimarad.
szimhossz_tervezett = 5*(4+2*4*R*(pi/4-1))/0.4; % A szimul�ci� teljes hossza [s]. Ha negat�v, akkor az id�keret = 24*3600 s.
% szimhossz_tervezett = 10; % A szimul�ci� teljes hossza [s]. Ha negat�v, akkor az id�keret = 24*3600 s.
    %----------------------------------------------------------------------
    % �rt�kead�s az automatedinitialisation.m-ben vagy m�s f�ggv�nyben.
    % TILOS K�ZZEL �LL�TANI! ->
    time = 0;
    kepkockaotaido = 0;% A legut�bbi plottol�s �s k�pkocka �ta eltelt ido [s].
    teljesmozgasido = 0;% Az adott mozgas ideje [s].
    % <- TILOS K�ZZEL �LL�TANI!
%--------------------------------------------------------------------------
% 9. szakasz: Egy�b param�terek
% TILOS K�ZZEL �LL�TANI! ->
% Ezek k�zzel nem m�dos�tand� param�terek vagy v�ltoz�k.
% �rt�k�ket a program m�dos�tja. Csak az�rt szerepelnek itt, hogy
% a Workspace-ben megjelenjenek.
% �rt�kead�s az automatedinitialisation.m-ben.
global kilepes amplitude eltolas siker tmptavuj tmptavmax
global egysegvektor vizsgalandopont_erinto_vektora vizsgalandopont_normal_vektora
global tovabb_vizsgalandopont_indexe tovabb_vizsgalandopont_tavolsaga
global tovabb_vizsgalando_ertek vizsgalandopont_vektora
kilepes = 0;
amplitude = 0;
eltolas = 0;
siker = 0;
tmptavuj = 0;
tmptavmax = 0;
egysegvektor = 0;
vizsgalandopont_erinto_vektora = 0;
vizsgalandopont_normal_vektora = 0;
tovabb_vizsgalandopont_indexe = 0;
tovabb_vizsgalandopont_tavolsaga = 0;
tovabb_vizsgalando_ertek = 0;
vizsgalandopont_vektora= 0;
% <- TILOS K�ZZEL �LL�TANI!
%--------------------------------------------------------------------------