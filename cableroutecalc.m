function cableroutecalc()
%--------------------------------------------------------------------------
% Verzi�: 7.0
% A f�ggv�ny c�lja:
% 1. K�belnyomvonalsz�m�t�s
% 1.1. Kisz�molni az egynes szakaszok r�vid�l�s�t, ha a g�rb�let a
% csatlakoz�sokn�l nem nulla.
% 1.2. Kisz�m�tani a k�bel nyomvonal pontjait a path(i), path(i+1) �s
% path(i+1), path(i+2) k�z�tt a r�vid�l�sket is figyelembe v�ve.
% 1.3. Kisz�molni az egyenesszakaszok csatlakoz�s�n�l l�v? k�r�vek pontjait.
% 1.4. szakasz: Az egyenesszakasz v�gpontjainak kisz�m�t�sa �s a
% k�zt�k l�v� pontok kisz�m�t�sa.
% 2. Az utols� egynesszakasz pontjainak kisz�m�t�sa �s a t�mbbe f�z�se.
% 3. A p�lyanyomvonal befoglal� t�glalapja param�tereinek
% kisz�m�t�sa.
% 4. A Biot-Savart t�rv�ny szerinti j�rul�kok sz�m�t�s�hoz
% sz�ks�ges pontok egy t�mbbe szervez�se.
% 5. szakasz: Az er�s�t�s szempontj�b�l fontos p�lyapontok �sszegy�jt�se.
%--------------------------------------------------------------------------
% K�belnyomvonal-sz�m�t�s kezdete
% Inicializ�l�s
global path delta lepeskoz cableroute
global max_x_cable max_y_cable min_x_cable min_y_cable
global width_cableroute width_path palyakanyaroksugara gorbeseg palyakanyarokcentruma
curvepoints = zeros(3,1,'double');
%--------------------------------------------------------------------------
gamma1 = 0;
gamma2 = 0;
gamma3 = 0;
secshortening = 0; % Az 1. szakasz el�tt nincs m�sik szakasz, �gy az elej�n nincs g�rbeszakasz.
%--------------------------------------------------------------------------
% 1. szakasz: K�belnyomvonalsz�m�t�s
disp('cableroutecalc.m indul.');
% Sz�m�t�sok
i = 1;
% Z�rt g�rbe eset�n ki kell sz�molni, hogy az 1. egyenesszakasz mennyivel
% kezd�dik k�s�bb, �s az utols� egyenesszakasz mennyivel v�gz�dik kor�bban.
tmp = (path(1:3,1) == path(1:3,width_path));
if (min(tmp) == 1)% Ha z�rt g�rb�r�l van sz�,
    tmp = path(:,i) - path(:,width_path-1);
    vecdir1 = tmp/norm(tmp,2); % Az 1. szakasz ir�nyvektora.
    tmp = path(:,i+1) - path(:,i);
    vecdir2 = tmp/norm(tmp,2); % A 2. szakasz ir�nyvektora.
    angle_sec1sec2 = acos(-vecdir1'*vecdir2); % Az 1. �s a 2. egyenes vonalszakasz tal�lkoz�s�n�l bez�rt sz�g.
    sugar = palyakanyaroksugara(1,i+1);
    forgir = rotationdirection(vecdir1,vecdir2);
    norm1  = polygonrot(vecdir1,forgir*pi/2,0*vecdir1);% Az 1. szakasz norm�lvektora.
    norm2  = polygonrot(vecdir2,forgir*pi/2,0*vecdir2);% A  2. szakasz norm�lvektora.
    centerdistance = sugar/sin(abs(angle_sec1sec2/2));% Az 1. �s 2. szakaszok k�z�tti g�rbeszakasz k�z�ppontja.
    vector = norm1+norm2;
    unitvec_r2center = vector/norm(vector,2); % Unit vector from junction to circle center
    center = path(1:3,i) + centerdistance*unitvec_r2center; % K�z�ppontsz�m�t�s.
    secshortening = sugar/tan(abs(angle_sec1sec2/2)); % Cut off from section
    gamma2 = atan2(path(2,i)-center(2,1),path(1,i)-center(1,1));
    gamma1 = gamma2 - forgir*((pi-angle_sec1sec2)/2);
    disp('center gamma3 elott:');
    disp(center);
    gamma3 = gamma2 + forgir*((pi-angle_sec1sec2)/2);
    disp('center gamma3 ut�n:');
    disp(center);
    curvepoints = circlecurve(center,sugar,gamma1,gamma3,delta);
    dim_tmp = size(curvepoints);
    gorbesegtmp = ones(1,dim_tmp(2),'uint32');
    palyakanyarokcentrumatmp = ones(3,dim_tmp(2),'double');
    for centrumidx = 1:3
        palyakanyarokcentrumatmp(centrumidx,:) = palyakanyarokcentrumatmp(centrumidx,:)*center(centrumidx,1);
    end
    for j = 1:dim_tmp(2)
        gorbesegtmp(1,j) = 1;%A k�belnyomvonal adott pontja g�rbeszakaszhoz tartozik.
    end
    cableroute = horzcat(cableroute,curvepoints);
    gorbeseg = horzcat(gorbeseg,gorbesegtmp);
    palyakanyarokcentruma = horzcat(palyakanyarokcentruma,palyakanyarokcentrumatmp);
    utolso_secshortening = secshortening;
end
%
while(i <= width_path-2)
    % K�belnyomvonal-sz�m�t�s.
    tmp = path(:,i+1) - path(:,i);
    vecdir1 = tmp/norm(tmp,2); % Az 1. szakasz ir�nyvektora.
    tmp = path(:,i+2) - path(:,i+1);
    vecdir2 = tmp/norm(tmp,2); % A 2. szakasz ir�nyvektora.
    sec1 = path(:,i) + secshortening*vecdir1; % Az egyenes vonalszakasz 1. hat�rpontja.
    sec2 = path(:,i+1); % Az egyenes vonalszakasz 2. hat�rpontja.
    angle_sec1sec2 = acos(-vecdir1'*vecdir2); % Az 1. �s a 2. egyenes vonalszakasz tal�lkoz�s�n�l bez�rt sz�g.
    sugar = palyakanyaroksugara(1,i+1);
    if (sugar > 0 && angle_sec1sec2 ~= 0)        
        %------------------------------------------------------------------
        % 1.1. szakasz: Az egyenes szakszok r�vid�l�s�hez �s
        % az egyenes szakaszok el�tti g�rb�k kisz�m�t�s�hoz sz�ks�ges
        % param�terek kisz�m�t�sa.
        forgir = rotationdirection(vecdir1,vecdir2);
        norm1  = polygonrot(vecdir1,forgir*pi/2,0*vecdir1);% Az 1. szakasz norm�lvektora.
        norm2  = polygonrot(vecdir2,forgir*pi/2,0*vecdir2);% A  2. szakasz norm�lvektora.
        centerdistance = sugar/sin(abs(angle_sec1sec2/2));% Az 1. �s 2. szakaszok k�z�tti g�rbeszakasz k�z�ppontja.
        vector = norm1+norm2;
        unitvec_r2center = vector/norm(vector,2); % Unit vector from junction to circle center
        center = path(1:3,i+1) + centerdistance*unitvec_r2center; % K�z�ppontsz�m�t�s.
        secshortening = sugar/tan(abs(angle_sec1sec2/2)); % Cut off from section
        sec2 = sec2 - secshortening*vecdir1; % End of straight line section.
        %------------------------------------------------------------------
        % 1.2. szakasz: Az  [x1;y1] �s [x2;y2] k�z�tti egyenesszakasz pontjainak
        % kisz�m�t�sa �s �sszef�z�se.
        tmp = sec2-sec1;
        unit_sec1sec2 = tmp/norm(tmp,2);
        sdirection = vecdir1'*unit_sec1sec2;
        if (sdirection ~= -1)
            xy = straightlinemake(sec1(:,1),sec2(:,1),delta);
            dim_tmp = size(xy);
            gorbesegtmp = zeros(1,dim_tmp(2),'uint32');
            for j = 1:dim_tmp(2)
                gorbesegtmp(1,j) = 0;%A k�belnyomvonal adott pontja egyenesszakaszhoz tartozik.
            end
            palyakanyarokcentrumatmp = zeros(3,dim_tmp(2),'double');
            cableroute = [cableroute,xy];% A 0 mutatja, hogy ez egy egyenesszakasz r�sze.
            gorbeseg = horzcat(gorbeseg,gorbesegtmp);
            palyakanyarokcentruma = horzcat(palyakanyarokcentruma,palyakanyarokcentrumatmp);
        else
            disp('Error [cableroutecalc]: Az egyenes szakasz hossza negat�v lett, miut�n az elej�n �s a v�g�n a k�r�vek l�trej�ttek.')
        end
        %------------------------------------------------------------------
        % 1.3. szakasz: Az egyenes szakaszt k�vet� g�rbeszakasz pontjainak
        % kisz�m�t�sa �s �sszef�z�se.
        gamma2 = atan2(path(2,i+1)-center(2,1),path(1,i+1)-center(1,1));
        gamma1 = gamma2 - forgir*((pi-angle_sec1sec2)/2);
        disp('center gamma3 elott:');
        disp(center);
        gamma3 = gamma2 + forgir*((pi-angle_sec1sec2)/2);
        disp('center gamma3 ut�n:');
        disp(center);
        curvepoints = circlecurve(center,sugar,gamma1,gamma3,delta);
        dim_tmp = size(curvepoints);
        gorbesegtmp = ones(1,dim_tmp(2),'uint32');
        palyakanyarokcentrumatmp = ones(3,dim_tmp(2),'double');
        for centrumidx = 1:3
            palyakanyarokcentrumatmp(centrumidx,:) = palyakanyarokcentrumatmp(centrumidx,:)*center(centrumidx,1);
        end
        for j = 1:dim_tmp(2)
            gorbesegtmp(1,j) = 1;%A k�belnyomvonal adott pontja g�rbeszakaszhoz tartozik.
        end
        cableroute = horzcat(cableroute,curvepoints);
        gorbeseg = horzcat(gorbeseg,gorbesegtmp);
        palyakanyarokcentruma = horzcat(palyakanyarokcentruma,palyakanyarokcentrumatmp);
    else
        %------------------------------------------------------------------
        % 1.4. szakasz: Az egyenesszakasz v�gpontjainak kisz�m�t�sa �s a
        % k�zt�k l�v� pontok kisz�m�t�sa.
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
% 2. szakasz: Az utols� egynesszakasz pontjainak kisz�m�t�sa, �s a t�mbbe
% f�z�se.
sugar = palyakanyaroksugara(1,i);
if (sugar > 0)
    % G�rb�leti pontok k�sz�t�se az egyenesszakasz elej�n �s az azokkkal val� �sszef�z�s.
    % Az utols� egyenesk�sz�t�s el�k�sz�t�se.
    tmp = path(:,i+1)-path(:,i);
    vecdir1 = tmp/norm(tmp,2); % Az 1. szakasz ir�nyvektora.
        
    sec1 = path(:,i) + secshortening*vecdir1; % Az egyenesszakasz 1. hat�rpontja.
    
    tmp = (path(1:3,1) == path(1:3,width_path));
    if (min(tmp) == 1)% Ha z�rt g�rb�r�l van sz�,
         secshortening = utolso_secshortening;
    end
    
    sec2 = path(:,i+1) - secshortening*vecdir1; % Az egyenesszakasz 2. hat�rpontja.
else
    sec1 = path(:,i);
    sec2 = path(:,i+1);
end
% Az [x1;y1] �s [x2;y2] k�z�tti egynes pontjai:
% A pontok k�pz�se �s �sszef�z�se az el�bbiek k�z�tt.
xy = straightlinemake(sec1(:,1),sec2(:,1),lepeskoz);
dim_tmp = size(xy);
gorbesegtmp = zeros(1,dim_tmp(2),'uint32');
for j = 1:dim_tmp(2)
    gorbesegtmp(1,j) = 0;% A k�belnyomvonal adott pontja egyenesszakaszhoz tartozik.
end
cableroute = horzcat(cableroute,xy);
gorbeseg = horzcat(gorbeseg,gorbesegtmp);
% tmp = (path(1:3,1) == path(1:3,width_path)); % Ha z�rt g�rb�r�l van sz�,
% tmp = min(tmp);
% if (tmp == 1)
%     cableroute = horzcat(cableroute,cableroute(1:3,1)); % akkor a v�g�re f�zi a legels� pontot.
% end
%--------------------------------------------------------------------------
% 3. szakasz: A p�lyanyomvonal befoglal� t�glalapja param�tereinek
% kisz�m�t�sa.
% Cable route calculation end
max_x_cable = max(cableroute(1,:));% A k�bel x koordin�t�inak MAX �rt�ke.
max_y_cable = max(cableroute(2,:));% A k�bel y koordin�t�inak MAX �rt�ke.
min_x_cable = min(cableroute(1,:));% A k�bel x koordin�t�inak MIN �rt�ke.
min_y_cable = min(cableroute(2,:));% A k�bel y koordin�t�inak MIN �rt�ke.
dim_cableroute = size(cableroute);
width_cableroute = dim_cableroute(2);
%--------------------------------------------------------------------------
end