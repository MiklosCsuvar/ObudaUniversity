function movementcalculation()
%--------------------------------------------------------------------------
% Verzió: 1.0
% A függvény célja:
% Kiszámolni a pozíciókat, az elmozdulásszámításhoz szükséges és
% az elmozdulási értékeket.
%--------------------------------------------------------------------------
global pos_agv pos_end phi_elf lepeskoz dist_agvendpos signal_diff
global idxcur_agv tavolsag_agv kozelipont_agv osszes_megtett_ut delta_s
%--------------------------------------------------------------------------
% Pozíció- és léptetésszámítás:
osszes_megtett_ut = osszes_megtett_ut + delta_s;
[tavolsag_agv,kozelipont_agv,idxcur_agv] = position2cabledistance(pos_agv,idxcur_agv);
phiagv2cableroute();
dist_agvendpos = norm(pos_end(:,1)-pos_agv(:,1),2);% A végpozíció távolsága [m].
uzenet = ['Az AGV-pálya távolság: ', num2str(tavolsag_agv), '. A közelipont indexe: ', num2str(idxcur_agv)];
disp(uzenet);
detsignal(); % Kiszámolja a detektorok feszültségét.
uzenet = ['abs(U1)-abs(U2) = ', num2str(signal_diff)];
disp(uzenet);
signal2vbalvjobb();
[lepeskoz, phi_elf] = vbalvjobb2lepeskozphielf();
end