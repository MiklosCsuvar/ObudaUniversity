% configuration
%--------------------------------------------------------------------------
% Verzió: 2.0
% Ezeket a paramétereket a felhasználónak kell beállítania.
% Kivéve:
% 1. A nyomvonal (path), ami itt is beállítható, vagy
% kiválasztható egy nyomvonal a 'pathsfortesting' fájlból.
% 2. Vannak kézzel nem módosítandó paraméterek vagy változók.
% Értéküket a program módosítja. Csak azért szerepelnek itt, hogy
% a Workspace-ben megjelenjenek. Megjelenítésük:
    %----------------------------------------------------------------------
    % Értékeadás az automatedinitialisation.m-ben vagy más függvényben.
    % TILOS KÉZZEL ÁLLÍTANI! ->
    
    % <- TILOS KÉZZEL ÁLLÍTANI!
%--------------------------------------------------------------------------
% 1. szakasz: % A kábelnyomvonalak adatai
% 2. szakasz: Az AGV geometriája
% 3. szakasz: Az indukciós érzékelök paraméterei
% 4. szakasz: Az áramjárta vezetö
% 5. szakasz: A feszültségerösítés és az A/D átalakító paraméterei
% 6. szakasz: Az AGV mozgásának alapparaméterei
% 7. szakasz: A mozgás közbeni számítások
% 8. szakasz: A szimuláció idöparaméterei és eredményeinek lementése:
% 9. szakasz: Egyéb paraméterek
%--------------------------------------------------------------------------
% 1. szakasz :A kábelnyomvonalak adatai:
% Sokszög körvonal - akármilyen -  koordináták és érzékelö pozíciók.
global path R nyomvonalfelbontas
global cableroute gorbeseg width_cableroute palyakanyarokcentruma palyakanyaroksugara
global tavolsag_agv  idxcur_agv kozelipont_agv phi_agv2cableroute
global gorbuletisugar_max gorbuletisugar_min
global kanyarpontokindexei biotsavartpontokindexei vizsgalandoindexek vizsgalandopontindexe
pathsfortesting;% A lehetséges nyomvonalakat tartalmazó fájl.
path = path15;% A nyomvonal sorszáma pl. 1, 2, ..., 9, ..., 19. Csak a 'pathfortesting.m'-ben megadott számok megengedettek.
R = 0.20; % Kábel görbületi sugara [m]. A 0 tilos!
nyomvonalfelbontas = 0.001; % A kábel nyomvonalának kiszámítási pontossága [m].
    %----------------------------------------------------------------------
    % Értékeadás az automatedinitialisation.m-ben vagy más függvényben.
    % TILOS KÉZZEL ÁLLÍTANI! ->
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
    % <- TILOS KÉZZEL ÁLLÍTANI!
%--------------------------------------------------------------------------
% 2. szakasz: Az AGV geometriája
global D d_kerekek d_det l_agv height_det AGVverzio pos_agv pos_end phi_agv
global phi_elf
D = 0.066; % A kormányzott kerekek átméröje [m].
d_kerekek = 0.195; % A kormányzott kerekek távolsága [m].
d_det = 0.20;% Az érzékelök távolsága [m].
l_agv  = 0.115; % AGV hossza (tkp. tengelytávolsága) [m].
height_det = 0.02;%0.04; % Érzékelök középsíkjának magassága a pálya síkja felett [m].
AGVverzio = 0;% Ha értéke 0/1, a bolygókerék elöl/hátul van.
    %----------------------------------------------------------------------
    % Értékeadás az automatedinitialisation.m-ben vagy más függvényben.
    % TILOS KÉZZEL ÁLLÍTANI! ->    
    pos_agv = [0;0;0]; % AGV pozíciója (x,y). Forgáscentrum.
    pos_end = [0;0;0];% AGV célpozíció (x,y).
    phi_agv = pi/2;% AGV kezdeti szöghelyzete.
    phi_elf = 0;
    % <- TILOS KÉZZEL ÁLLÍTANI!
%--------------------------------------------------------------------------
% 3. szakasz: Az indukciós érzékelök paraméterei
global N Rtek Htek frekvencia detektorszam nullakorulitures
global signal_det pos_det
global kozelipont_det idxcur_det tavolsag_det induction_det flux_det signal_det_erositetlen
global signal_diff signal_max jelmemoriahossz signal_det_tarolt
N = 400;% A tekercselés menetszáma.
Rtek = 0.01; % A tekercs sugara [m].
Htek = 0.02; % A tekercs magassaga [m].
frekvencia = 100000; % Az áram frekvenciája [Hz].
detektorszam = 3; % [db] FIGYELEM!: A kimeneti txt fájlba íráshoz
% a változókat kézzel kell módosítani: automatedinitialisation.m, agvmoving.m!
nullakorulitures = 0; % Bit.
jelmemoriahossz = 5; % Az eltárolt idöpillanatok száma.
    %----------------------------------------------------------------------
    % Értékeadás az automatedinitialisation.m-ben vagy más függvényben.
    % TILOS KÉZZEL ÁLLÍTANI! ->    
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
    % <- TILOS KÉZZEL ÁLLÍTANI!
%--------------------------------------------------------------------------
% 4. szakasz: Az áramjárta vezetö
global I mu0 aramirany
I = 1; % A kábelben folyó áram amplitúdója [A].
mu0 = 4*pi*10^(-7);
aramirany = +1;% +1: pozitív, -1: negatív forgásirány a pálya mentén.
%--------------------------------------------------------------------------
% 5. szakasz: A feszültségerösítés és az A/D átalakító paraméterei
global feszerosites ADClimit ADfelbontas AvagyD
global indukciostenyezo amplitude_U
global delta_absU_max delta_absU_max_position U_max U_max_position deltaH_max
global deltaumaxkereses
feszerosites = 0;% A feszültségerösítés memóriafoglalása. Értékszámítása az automatedinitialisation.m-ben történik.
ADClimit = 5;% Az A/D átalakító alapfeszültsége [V]: [-ADClimit;+ADClimit].
ADfelbontas = 10;% Az A/D-átalakító finomsága [bit].
AvagyD = 'b';% Ha értéke 'a'/'d'/'b', akkor analóg feszültség/digitális feszültség/bit bemenetet kap a szabályozás.
    %----------------------------------------------------------------------
    % Értékeadás az automatedinitialisation.m-ben vagy más függvényben.
    % TILOS KÉZZEL ÁLLÍTANI! ->    
    indukciostenyezo = 0;% A A tesla->volt konverziós tényezö. Módosítani tilos. Értékadás: automatedinitialisation.m.
    amplitude_U = 0;
    delta_absU_max = 0;
    delta_absU_max_position = 0;
    U_max = 0;
    U_max_position = 0;
    deltaH_max = 0;
    deltaumaxkereses = 0;
    % <- TILOS KÉZZEL ÁLLÍTANI!
%--------------------------------------------------------------------------
% 6. szakasz: Az AGV mozgásának alapparaméterei
global delta_t vmax vmin vbal vjobb d_agv2endpos AGVpolygon delta_r
global vtomb deltavbalvjobbtomb deltavbalvjobboszlop delta_s vtomb_meret
global osszes_megtett_ut
delta_t = 0.1; % Idölépés, idököz [m].
delta_s = 0; % Az idölépés alatt megtett út [m].
d_agv2endpos = 0.05;% A cél minimális megközelítés megálláshoz [m].
% Az AGV lehetséges sebességei [m/s]:
vtomb = [1/2.5,1/3,1/4,0]; % Ez van beprogramozva most az AGV-be.
% felosztas = 8;
% tobbszorozes = 1;
% vtomb = (1/2.5)*tobbszorozes*linspace(1,0,felosztas+1);
vtomb = vtomb';
    %----------------------------------------------------------------------
    % Értékeadás az automatedinitialisation.m-ben vagy más függvényben.
    % TILOS KÉZZEL ÁLLÍTANI! ->    
    vmax = 0; % Az AGV maximális sebessége [m/s].
    vmin = 0; % Az AGV minimális sebessége [m/s].
    vbal = 0;% A bal oldali kerék kerületi sebessége [m/s].
    vjobb = 0;% A jobb oldali kerék kerületi sebessége [m/s].
    AGVpolygon = [0;0];
    delta_r = 0; % Az elemi elmozdulás vektora.
    deltavbalvjobbtomb = 0;
    deltavbalvjobboszlop = 0;
    vtomb_meret = 0;
    osszes_megtett_ut = 0;
    % <- TILOS KÉZZEL ÁLLÍTANI!
%--------------------------------------------------------------------------
% 7. szakasz: A mozgás közbeni számítások
global idxcur idxenv dist_agvpath haladasiirany gorbuletisugar vektorvagyskalar
global biotsavartpontok indukcio_finomkozelites_pontossag
global BSmag X_BSmag Y_BSmag Z_BSmag BX_BSmag BY_BSmag BZ_BSmag
global korabban_szamitott_indukcio BX BY BZ X_M Y_M Z_M signal2sebesseg_verzio
idxcur = 0;% Az AGV pillanatnyi pozíciójának indexe.
idxenv = 100;% A továbbhaladáshoz vizsgált "idxcur" környezet sugara.
dist_agvpath = 0; % Az AGV pozíciója és a kábelnyomvonal közötti távolság.
haladasiirany = +1;% +1: pozitív, -1: negatív forgásirány a pálya mentén.
gorbuletisugar = 0;% A pálya görbületi sugara [m].
indukcio_finomkozelites_pontossag = 0.001; % [1]
vektorvagyskalar = 'BSmag'; % s: Skalár B[T]. v: Vektor B[T] = [Bx;By;Bz]. BSmag: A BSmag_get_B MATLAB csomag használata.
signal2sebesseg_verzio = '1-2'; %
% Ki kell számolni és ábrázolni a B(x,y,z) [T]-t?: Ha igen, akkor a
korabban_szamitott_indukcio = ''; % különben a megadott fájlból kell betölteni a teret.
% korabban_szamitott_indukcio = 'F:\Kandó\szakdolgozat\jegyzökönyvek\absBz_per_Bzmax_path15_0.001m\absBz_per_Bzmax_path15_0.001m.mat';
    %----------------------------------------------------------------------
    % Értékeadás az automatedinitialisation.m-ben vagy más függvényben.
    % TILOS KÉZZEL ÁLLÍTANI! ->    
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
    % <- TILOS KÉZZEL ÁLLÍTANI!
%--------------------------------------------------------------------------
% 8. szakasz: A szimuláció idöparaméterei és eredményeinek lementése
global plotting szimhossz_tervezett mozgas
global filmmaking filelocation filename keppermp timepassing vec_aspect
global parametermentesfajlba szimulaciokonyvtarhelye
global time kepkockaotaido teljesmozgasido film_profil
mozgas = 1; % Az AGV mozgását szimulálni kell?
parametermentesfajlba = 1;
szimulaciokonyvtarhelye = 'f:\Kandó\szakdolgozat\szimuláció\';
filelocation = 'f:\Kandó\szakdolgozat\film\';% A filmek mentési könyvtára.
filename = 'agvmoving_9.0.0_15'; %"agvmoving_verzió_nyomvonalszám"
plotting = 1; % Készül ábra? Igen - 1; Nem - 0.
filmmaking = 1;% Készül film? Igen - 1; Nem - 0.
keppermp = 25; % A kép/s beállítása. Vigyázat! Ideális esetben delta_t*keppermp=1.
vec_aspect = [1 1 1]; % Aspect ratio beállítás. A másik lehetöség az 'auto'.
film_profil = 'Uncompressed AVI'; % Az 'Uncompressed AVI': gyorsabb plottolás. 'MPEG-4': A fájl röhelyesen kicsi.
timepassing = 2; % Timepassing = 0/1/más pozitív érték: semmi/1/egyéb idököz szünet van a képernyöképek között.
% Egyszerüsítettem vele a programot. Ld. mkpassedtm. Így legfeljebb a timepassing = 1 s eset kimarad.
szimhossz_tervezett = 5*(4+2*4*R*(pi/4-1))/0.4; % A szimuláció teljes hossza [s]. Ha negatív, akkor az idökeret = 24*3600 s.
% szimhossz_tervezett = 10; % A szimuláció teljes hossza [s]. Ha negatív, akkor az idökeret = 24*3600 s.
    %----------------------------------------------------------------------
    % Értékeadás az automatedinitialisation.m-ben vagy más függvényben.
    % TILOS KÉZZEL ÁLLÍTANI! ->
    time = 0;
    kepkockaotaido = 0;% A legutóbbi plottolás és képkocka óta eltelt ido [s].
    teljesmozgasido = 0;% Az adott mozgas ideje [s].
    % <- TILOS KÉZZEL ÁLLÍTANI!
%--------------------------------------------------------------------------
% 9. szakasz: Egyéb paraméterek
% TILOS KÉZZEL ÁLLÍTANI! ->
% Ezek kézzel nem módosítandó paraméterek vagy változók.
% Értéküket a program módosítja. Csak azért szerepelnek itt, hogy
% a Workspace-ben megjelenjenek.
% Értékeadás az automatedinitialisation.m-ben.
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
% <- TILOS KÉZZEL ÁLLÍTANI!
%--------------------------------------------------------------------------