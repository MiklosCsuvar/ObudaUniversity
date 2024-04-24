function cableroutecalc()
%--------------------------------------------------------------------------
% Verzió: 7.0
% A függvény célja:
% 1. Kábelnyomvonalszámítás
% 1.1. Kiszámolni az egynes szakaszok rövidülését, ha a görbület a
% csatlakozásoknál nem nulla.
% 1.2. Kiszámítani a kábel nyomvonal pontjait a path(i), path(i+1) és
% path(i+1), path(i+2) között a rövidülésket is figyelembe véve.
% 1.3. Kiszámolni az egyenesszakaszok csatlakozásánál lév? körívek pontjait.
% 1.4. szakasz: Az egyenesszakasz végpontjainak kiszámítása és a
% köztük lévö pontok kiszámítása.
% 2. Az utolsó egynesszakasz pontjainak kiszámítása és a tömbbe füzése.
% 3. A pályanyomvonal befoglaló téglalapja paramétereinek
% kiszámítása.
% 4. A Biot-Savart törvény szerinti járulékok számításához
% szükséges pontok egy tömbbe szervezése.
% 5. szakasz: Az erösítés szempontjából fontos pályapontok összegyüjtése.
%--------------------------------------------------------------------------
% Kábelnyomvonal-számítás kezdete
% Inicializálás
global path delta lepeskoz cableroute
global max_x_cable max_y_cable min_x_cable min_y_cable
global width_cableroute width_path palyakanyaroksugara gorbeseg palyakanyarokcentruma
curvepoints = zeros(3,1,'double');
%--------------------------------------------------------------------------
gamma1 = 0;
gamma2 = 0;
gamma3 = 0;
secshortening = 0; % Az 1. szakasz elött nincs másik szakasz, így az elején nincs görbeszakasz.
%--------------------------------------------------------------------------
% 1. szakasz: Kábelnyomvonalszámítás
disp('cableroutecalc.m indul.');
% Számítások
i = 1;
% Zárt görbe esetén ki kell számolni, hogy az 1. egyenesszakasz mennyivel
% kezdödik késöbb, és az utolsó egyenesszakasz mennyivel végzödik korábban.
tmp = (path(1:3,1) == path(1:3,width_path));
if (min(tmp) == 1)% Ha zárt görbéröl van szó,
    tmp = path(:,i) - path(:,width_path-1);
    vecdir1 = tmp/norm(tmp,2); % Az 1. szakasz irányvektora.
    tmp = path(:,i+1) - path(:,i);
    vecdir2 = tmp/norm(tmp,2); % A 2. szakasz irányvektora.
    angle_sec1sec2 = acos(-vecdir1'*vecdir2); % Az 1. és a 2. egyenes vonalszakasz találkozásánál bezárt szög.
    sugar = palyakanyaroksugara(1,i+1);
    forgir = rotationdirection(vecdir1,vecdir2);
    norm1  = polygonrot(vecdir1,forgir*pi/2,0*vecdir1);% Az 1. szakasz normálvektora.
    norm2  = polygonrot(vecdir2,forgir*pi/2,0*vecdir2);% A  2. szakasz normálvektora.
    centerdistance = sugar/sin(abs(angle_sec1sec2/2));% Az 1. és 2. szakaszok közötti görbeszakasz középpontja.
    vector = norm1+norm2;
    unitvec_r2center = vector/norm(vector,2); % Unit vector from junction to circle center
    center = path(1:3,i) + centerdistance*unitvec_r2center; % Középpontszámítás.
    secshortening = sugar/tan(abs(angle_sec1sec2/2)); % Cut off from section
    gamma2 = atan2(path(2,i)-center(2,1),path(1,i)-center(1,1));
    gamma1 = gamma2 - forgir*((pi-angle_sec1sec2)/2);
    disp('center gamma3 elott:');
    disp(center);
    gamma3 = gamma2 + forgir*((pi-angle_sec1sec2)/2);
    disp('center gamma3 után:');
    disp(center);
    curvepoints = circlecurve(center,sugar,gamma1,gamma3,delta);
    dim_tmp = size(curvepoints);
    gorbesegtmp = ones(1,dim_tmp(2),'uint32');
    palyakanyarokcentrumatmp = ones(3,dim_tmp(2),'double');
    for centrumidx = 1:3
        palyakanyarokcentrumatmp(centrumidx,:) = palyakanyarokcentrumatmp(centrumidx,:)*center(centrumidx,1);
    end
    for j = 1:dim_tmp(2)
        gorbesegtmp(1,j) = 1;%A kábelnyomvonal adott pontja görbeszakaszhoz tartozik.
    end
    cableroute = horzcat(cableroute,curvepoints);
    gorbeseg = horzcat(gorbeseg,gorbesegtmp);
    palyakanyarokcentruma = horzcat(palyakanyarokcentruma,palyakanyarokcentrumatmp);
    utolso_secshortening = secshortening;
end
%
while(i <= width_path-2)
    % Kábelnyomvonal-számítás.
    tmp = path(:,i+1) - path(:,i);
    vecdir1 = tmp/norm(tmp,2); % Az 1. szakasz irányvektora.
    tmp = path(:,i+2) - path(:,i+1);
    vecdir2 = tmp/norm(tmp,2); % A 2. szakasz irányvektora.
    sec1 = path(:,i) + secshortening*vecdir1; % Az egyenes vonalszakasz 1. határpontja.
    sec2 = path(:,i+1); % Az egyenes vonalszakasz 2. határpontja.
    angle_sec1sec2 = acos(-vecdir1'*vecdir2); % Az 1. és a 2. egyenes vonalszakasz találkozásánál bezárt szög.
    sugar = palyakanyaroksugara(1,i+1);
    if (sugar > 0 && angle_sec1sec2 ~= 0)        
        %------------------------------------------------------------------
        % 1.1. szakasz: Az egyenes szakszok rövidüléséhez és
        % az egyenes szakaszok elötti görbék kiszámításához szükséges
        % paraméterek kiszámítása.
        forgir = rotationdirection(vecdir1,vecdir2);
        norm1  = polygonrot(vecdir1,forgir*pi/2,0*vecdir1);% Az 1. szakasz normálvektora.
        norm2  = polygonrot(vecdir2,forgir*pi/2,0*vecdir2);% A  2. szakasz normálvektora.
        centerdistance = sugar/sin(abs(angle_sec1sec2/2));% Az 1. és 2. szakaszok közötti görbeszakasz középpontja.
        vector = norm1+norm2;
        unitvec_r2center = vector/norm(vector,2); % Unit vector from junction to circle center
        center = path(1:3,i+1) + centerdistance*unitvec_r2center; % Középpontszámítás.
        secshortening = sugar/tan(abs(angle_sec1sec2/2)); % Cut off from section
        sec2 = sec2 - secshortening*vecdir1; % End of straight line section.
        %------------------------------------------------------------------
        % 1.2. szakasz: Az  [x1;y1] és [x2;y2] közötti egyenesszakasz pontjainak
        % kiszámítása és összefüzése.
        tmp = sec2-sec1;
        unit_sec1sec2 = tmp/norm(tmp,2);
        sdirection = vecdir1'*unit_sec1sec2;
        if (sdirection ~= -1)
            xy = straightlinemake(sec1(:,1),sec2(:,1),delta);
            dim_tmp = size(xy);
            gorbesegtmp = zeros(1,dim_tmp(2),'uint32');
            for j = 1:dim_tmp(2)
                gorbesegtmp(1,j) = 0;%A kábelnyomvonal adott pontja egyenesszakaszhoz tartozik.
            end
            palyakanyarokcentrumatmp = zeros(3,dim_tmp(2),'double');
            cableroute = [cableroute,xy];% A 0 mutatja, hogy ez egy egyenesszakasz része.
            gorbeseg = horzcat(gorbeseg,gorbesegtmp);
            palyakanyarokcentruma = horzcat(palyakanyarokcentruma,palyakanyarokcentrumatmp);
        else
            disp('Error [cableroutecalc]: Az egyenes szakasz hossza negatív lett, miután az elején és a végén a körívek létrejöttek.')
        end
        %------------------------------------------------------------------
        % 1.3. szakasz: Az egyenes szakaszt követö görbeszakasz pontjainak
        % kiszámítása és összefüzése.
        gamma2 = atan2(path(2,i+1)-center(2,1),path(1,i+1)-center(1,1));
        gamma1 = gamma2 - forgir*((pi-angle_sec1sec2)/2);
        disp('center gamma3 elott:');
        disp(center);
        gamma3 = gamma2 + forgir*((pi-angle_sec1sec2)/2);
        disp('center gamma3 után:');
        disp(center);
        curvepoints = circlecurve(center,sugar,gamma1,gamma3,delta);
        dim_tmp = size(curvepoints);
        gorbesegtmp = ones(1,dim_tmp(2),'uint32');
        palyakanyarokcentrumatmp = ones(3,dim_tmp(2),'double');
        for centrumidx = 1:3
            palyakanyarokcentrumatmp(centrumidx,:) = palyakanyarokcentrumatmp(centrumidx,:)*center(centrumidx,1);
        end
        for j = 1:dim_tmp(2)
            gorbesegtmp(1,j) = 1;%A kábelnyomvonal adott pontja görbeszakaszhoz tartozik.
        end
        cableroute = horzcat(cableroute,curvepoints);
        gorbeseg = horzcat(gorbeseg,gorbesegtmp);
        palyakanyarokcentruma = horzcat(palyakanyarokcentruma,palyakanyarokcentrumatmp);
    else
        %------------------------------------------------------------------
        % 1.4. szakasz: Az egyenesszakasz végpontjainak kiszámítása és a
        % köztük lévö pontok kiszámítása.
        secshortening = 0;
        sec1 = path(:,i);
        sec2 = path(:,i+1);
        xy = straightlinemake(sec1(:,1),sec2(:,1),delta);
        dim_tmp = size(xy);
        gorbesegtmp = zeros(1,dim_tmp(2),'uint32');
        palyakanyarokcentrumatmp = zeros(3,dim_tmp(2),'uint32');
        % 4. szakasz
        cableroute = horzcat(cableroute,xy);
        gorbeseg = horzcat(gorbeseg,gorbesegtmp);
        palyakanyarokcentruma = horzcat(palyakanyarokcentruma,palyakanyarokcentrumatmp);
    end
    i = i+1;
end
%--------------------------------------------------------------------------
% 2. szakasz: Az utolsó egynesszakasz pontjainak kiszámítása, és a tömbbe
% füzése.
sugar = palyakanyaroksugara(1,i);
if (sugar > 0)
    % Görbületi pontok készítése az egyenesszakasz elején és az azokkkal való összefüzés.
    % Az utolsó egyeneskészítés elökészítése.
    tmp = path(:,i+1)-path(:,i);
    vecdir1 = tmp/norm(tmp,2); % Az 1. szakasz irányvektora.
        
    sec1 = path(:,i) + secshortening*vecdir1; % Az egyenesszakasz 1. határpontja.
    
    tmp = (path(1:3,1) == path(1:3,width_path));
    if (min(tmp) == 1)% Ha zárt görbéröl van szó,
         secshortening = utolso_secshortening;
    end
    
    sec2 = path(:,i+1) - secshortening*vecdir1; % Az egyenesszakasz 2. határpontja.
else
    sec1 = path(:,i);
    sec2 = path(:,i+1);
end
% Az [x1;y1] és [x2;y2] közötti egynes pontjai:
% A pontok képzése és összefüzése az elöbbiek között.
xy = straightlinemake(sec1(:,1),sec2(:,1),lepeskoz);
dim_tmp = size(xy);
gorbesegtmp = zeros(1,dim_tmp(2),'uint32');
for j = 1:dim_tmp(2)
    gorbesegtmp(1,j) = 0;% A kábelnyomvonal adott pontja egyenesszakaszhoz tartozik.
end
cableroute = horzcat(cableroute,xy);
gorbeseg = horzcat(gorbeseg,gorbesegtmp);
% tmp = (path(1:3,1) == path(1:3,width_path)); % Ha zárt görbéröl van szó,
% tmp = min(tmp);
% if (tmp == 1)
%     cableroute = horzcat(cableroute,cableroute(1:3,1)); % akkor a végére füzi a legelsö pontot.
% end
%--------------------------------------------------------------------------
% 3. szakasz: A pályanyomvonal befoglaló téglalapja paramétereinek
% kiszámítása.
% Cable route calculation end
max_x_cable = max(cableroute(1,:));% A kábel x koordinátáinak MAX értéke.
max_y_cable = max(cableroute(2,:));% A kábel y koordinátáinak MAX értéke.
min_x_cable = min(cableroute(1,:));% A kábel x koordinátáinak MIN értéke.
min_y_cable = min(cableroute(2,:));% A kábel y koordinátáinak MIN értéke.
dim_cableroute = size(cableroute);
width_cableroute = dim_cableroute(2);
%--------------------------------------------------------------------------
end