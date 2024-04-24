function movementcalculation()
%--------------------------------------------------------------------------
% Verzi�: 1.0
% A f�ggv�ny c�lja:
% Kisz�molni a poz�ci�kat, az elmozdul�ssz�m�t�shoz sz�ks�ges �s
% az elmozdul�si �rt�keket.
%--------------------------------------------------------------------------
global pos_agv pos_end phi_elf lepeskoz dist_agvendpos signal_diff
global idxcur_agv tavolsag_agv kozelipont_agv osszes_megtett_ut delta_s
%--------------------------------------------------------------------------
% Poz�ci�- �s l�ptet�ssz�m�t�s:
osszes_megtett_ut = osszes_megtett_ut + delta_s;
[tavolsag_agv,kozelipont_agv,idxcur_agv] = position2cabledistance(pos_agv,idxcur_agv);
phiagv2cableroute();
dist_agvendpos = norm(pos_end(:,1)-pos_agv(:,1),2);% A v�gpoz�ci� t�vols�ga [m].
uzenet = ['Az AGV-p�lya t�vols�g: ', num2str(tavolsag_agv), '. A k�zelipont indexe: ', num2str(idxcur_agv)];
disp(uzenet);
detsignal(); % Kisz�molja a detektorok fesz�lts�g�t.
uzenet = ['abs(U1)-abs(U2) = ', num2str(signal_diff)];
disp(uzenet);
signal2vbalvjobb();
[lepeskoz, phi_elf] = vbalvjobb2lepeskozphielf();
end