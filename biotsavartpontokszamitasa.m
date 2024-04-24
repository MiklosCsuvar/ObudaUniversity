function biotsavartpontokszamitasa()
%--------------------------------------------------------------------------
% Verzi�: 1.0
% A f�ggv�ny c�lja:
% Az egyenes szakaszokhoz tartoz� - a g�rbevonalak t�rtvonalas k�zel�t�s�t
% ide nem sz�molva - pontok elhagy�s�val el��ll�tani azt a ponthalmazt,
% ami alapj�n a k�bel m�gneses indukci�s nyomvonala - kevesebb pontb�l - 
% gyorsabban kisz�molhat�.
%--------------------------------------------------------------------------
global path cableroute
global width_cableroute width_path gorbeseg
global biotsavartpontokindexei biotsavartpontok
%--------------------------------------------------------------------------
tmp = 0;
for i = 1:width_cableroute
    if (gorbeseg(i) == 1)
        tmp = tmp + 1;
    end
end
uzenet = ['G�rbevonali pontok [db]: ', num2str(tmp)];
disp(uzenet);
if (tmp > 1) % Ha 1-n�l t�bb g�rb�leti pont van, akkor:
    biotsavartpontokindexei = zeros(1,tmp,'int32'); % a Bios-Savart k�plethez helyet foglal nekik,
    j = 1; % be�ll az 1. t�mbelemre.
    for i = 1:width_cableroute % v�gigvizsg�lja az �sszes nyomvonali pontot, �s
        if (gorbeseg(i) == 1) % ha a pont kanyarhoz tartozik, akkor
            biotsavartpontokindexei(1,j) = i; % az index�t elmenti a t�mbbe, �s
            j = j + 1; % a k�vetkez� t�mbbelemre �ll.
        end
    end    
%     vektoregyenloseg1 = (path(1:3,1) == path(1:3,width_path)); % Meg�llap�tja
%     vektoregyenloseg2 = min(vektoregyenloseg1); %  a g�rbe 1. �s utols� pontj�nak egyez�s�t.
% %     if(vektoregyenloseg2 == 1) % Ha a pontok egyeznek (azaz z�rt g�rb�r�l van sz�), akkor:
% %         biotsavartpontokindexei = horzcat(biotsavartpontokindexei,biotsavartpontokindexei(1,1)); % Ti. ezzel lesznek a Biot-Savart-j�rul�ksz�m�t�s
% %         % szempontj�b�l z�rt hurok elemei a r�gz�tett g�rbeszakasz pontok
% %         % is, ha az 1. g�rbeszakasz el�tt vagy az utols� ut�n egyenesszakasz j�nne.
% %         % Ha v�letlen�l ugyanaz a pont lenne, mint a megel�z�, akkor a j�rul�ka am�gy is 0.
% %         disp('IF �gat v�geztem.');
% %     else % K�l�nben (amikor a pontok nem egyeznek (azaz ny�lt g�rb�r�l van sz�)) a kanyarpontok:
% %         biotsavartpontokindexei = horzcat(1,biotsavartpontokindexei); % el� besz�rja az 1. egyenesszakasz 1. pontj�t, �s
% %         biotsavartpontokindexei = horzcat(biotsavartpontokindexei,width_cableroute); % m�g� besz�rja a k�bel nyomvonal�nak
% %         % utols� pontj�t, ami elvileg az utols� egyenesszakasz utols� pontja.
% %         disp('ELSE �gat v�geztem.');        
% %     end
%     if(vektoregyenloseg2 == 0) % Ha a pontok nem egyeznek (azaz ny�lt g�rb�r�l van sz�), akkor:
    if(min(path(1:3,1) == path(1:3,width_path))) % Ha a pontok nem egyeznek (azaz ny�lt g�rb�r�l van sz�), akkor:
        biotsavartpontokindexei = horzcat(1,biotsavartpontokindexei); % el� besz�rja az 1. egyenesszakasz 1. pontj�t, �s
        biotsavartpontokindexei = horzcat(biotsavartpontokindexei,width_cableroute); % m�g� besz�rja a k�bel nyomvonal�nak
        % utols� pontj�t, ami elvileg az utols� egyenesszakasz utols� pontja.
    end        
else %k�l�nben (amikor nincsenek kanyarok, csak egyenes szakaszok),
    biotsavartpontokindexei = zeros(1,width_path,'int32'); % helyet foglal nekik,
    for i = 1:width_path % vizsg�latot ind�t a teljes tervezett nyomvonalra,
        for j = 1:width_cableroute % �s annak minden val�s pontj�ra,
            tmp1 = (cableroute(1:3,j) == path(1:3,i)); % �s ahol a kett� egyezik,
            tmp2 = min(tmp1);
            if(tmp2 == 1)
                biotsavartpontokindexei(1,i) = j; % annak index�t elmenti a t�mbbe.
            end
        end
    end
end
dim = size(biotsavartpontokindexei);
width_biotsavartpontok = dim(2);
biotsavartpontok = zeros(3,width_biotsavartpontok,'double');
for i = 1:width_biotsavartpontok
    uzenet = ['biotsavartpontokindexei(1,i)'];
    disp(uzenet);
    uzenet = [biotsavartpontokindexei(1,i)];
    disp(uzenet);
    biotsavartpontok(1:3,i) = cableroute(1:3,biotsavartpontokindexei(1,i));
end
end