% BSmag_test()
%--------------------------------------------------------------------------
% Verzi�: 2.0
% A f�ggv�ny c�lja:
% 1. Valamely �ramvezet� indukci�s ter�t kisz�molni.
% 2. A f�ggv�nykiv�laszt�s�val �s futtat�ssal �sszevetni
% a [BSmag,X_M,Y_M,Z_M,BX,BY,BZ] = BSmag_get_B(BSmag,X_M,Y_M,Z_M) f�ggv�ny �s 
% a indukciotomb_B = biotsavartjarulek(aramvezeto,posdet,amplitudo) f�ggv�ny
% sz�m�t�si sebess�g�t �s a sz�m�that� indukci�kat.
%--------------------------------------------------------------------------
% Initialize
close all;% Minden �bra �s plottol�s le�ll�t�sa.
clear all;% Minden adat t�rl�se a mem�ri�b�l.
global cableroute x_min x_max y_min y_max nyomvonalfelbontas height_det
global I aramirany X_M Y_M Z_M BSmag BX BY BZ x_M y_M darab1 darab2 %darab3
global amplitude B_abrazolando
configuration; % A k�zzel szerkesztend� param�terek.
automatedinitialisation(); % Param�terek kezd��rt�k�nek automatikus kisz�m�t�sa a k�zzel
% bevitt param�terek alapj�n.
indfvverz = 'BSmag'; % Indukci�sz�m�t�s: 'BSmag': BSmag csomag, b�rmi m�s: biotsavartjarulek_v2_0.
absbzperbzmax = 'abs'; % 'abs': abs(B_z/max(abs(B_z))) [1], m�s: B_z [T]
allapotkovetes = 1; % Kijelezze az indukci�sz�m�t� f�ggv�ny az el�rehalad�st?
abrazolas = 1; % 0/1: Nincs/van �bra.
%--------------------------------------------------------------------------
% BSmag_test.m miatti inicializ�l�s:
Gamma = cableroute';
dGamma = nyomvonalfelbontas;
darab1 = ceil((x_max-x_min)/nyomvonalfelbontas + 1);
uzenet = ['x: darab1 = ',num2str(darab1)];
disp(uzenet);
darab2 = ceil((y_max-y_min)/nyomvonalfelbontas + 1);
uzenet = ['y darab2 = ',num2str(darab2)];
disp(uzenet);
x_M = linspace(x_min,x_max,darab1);
y_M = linspace(y_min,y_max,darab2);
[X_M,Y_M] = ndgrid(x_M,y_M);
Z_M = height_det*ones(size(X_M,1),size(Y_M,2),'double');
% darab3 = max(size(Z_M,3));
uzenet = ['size(Z_M) = (',num2str(size(Z_M,1)),',',num2str(size(Z_M,2)),',',num2str(size(Z_M,3)),')'];
disp(uzenet);
%--------------------------------------------------------------------------
if (strcmp(indfvverz,'BSmag'))    
    BSmag = BSmag_init();
    [BSmag] = BSmag_add_filament(BSmag,Gamma,I*aramirany,dGamma);
    time1 = cputime;
    [BSmag,X_M,Y_M,Z_M,BX,BY,BZ] = BSmag_get_B(BSmag,X_M,Y_M,Z_M);
    time2 = cputime;
else
    time3 = cputime;
    % A fenti bemen� adatok kipr�b�l�sa a biotsavartjarulek f�ggv�nnyel.
    aramvezeto = Gamma';
    posdet = zeros(3,darab1*darab2,'double');
    for i = 1:darab1
        if (allapotkovetes == 1)
            uzenet = [num2str(i),'/',num2str(size(X_M,1)),' sor�talak�t�s'];
            disp(uzenet);
        end
        for j = 1:darab2
            posdet(1,(i-1)*darab2 + j) = X_M(i,j);
            posdet(2,(i-1)*darab2 + j) = Y_M(i,j);
            posdet(3,(i-1)*darab2 + j) = Z_M(i,j);
        end
    end
    time1 = cputime;
    indukciotomb_B = biotsavartjarulek_v2_0(aramvezeto,posdet,amplitude);
    time2 = cputime;
    for i = 1:darab1
        if (allapotkovetes == 1)
            uzenet = [num2str(i),'/',num2str(size(X_M,1)),' B-�talak�t�s'];
            disp(uzenet);
        end
        for j = 1:darab2
            BX(i,j) = indukciotomb_B(1,(i-1)*darab2 + j);
            BY(i,j) = indukciotomb_B(2,(i-1)*darab2 + j);
            BZ(i,j) = indukciotomb_B(3,(i-1)*darab2 + j);
        end
    end
    time4 = cputime;
end
%--------------------------------------------------------------------------
if (abrazolas == 1)
    BZabs = abs(BZ.*1);
    Bmax = max(max(max(BZabs)));
    if (absbzperbzmax == 1)
        B_abrazolando = abs(BZ.*1)/Bmax;
    else
        B_abrazolando = BZ;
    end
    %----------------------------------------------------------------------
    figure(1);
    box off;
    hold off;
    grid off;
    contourf(X_M,Y_M,B_abrazolando);
    colorbar;
    xlabel ('x [m]');
    ylabel ('y [m]');
    if (strcmp(absbzperbzmax,'abs'))
        title1 = '|B_z|/max(|B_z|) [1]';
    else
        title1 = 'B_z [T]';
    end
    if (strcmp(indfvverz,'BSmag'))
        title2 = 'BSmag';
    else
        title2 = 'biotsavartjarulek.v2.0';
    end
    title3 = [title1,' - ',title2];
    title(title3);
end
%--------------------------------------------------------------------------
tmp = time2-time1;
uzenet = ['Az indukci�sz�m�t�s ideje: ',num2str(tmp),' s'];
disp(uzenet);
if (~strcmp(indfvverz,'BSmag'))
    tmp = time4-time3;
    uzenet = ['A biotsavartjarulek_v2_0 id�ig�nye az X_M, Y_M, Z_M oda-vissza alak�t�ssal egy�tt: ',num2str(tmp),' s'];
    disp(uzenet);
end