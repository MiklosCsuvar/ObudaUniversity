function movementdoing()
%--------------------------------------------------------------------------
% Verzió: 1.0
% A függvény célja:
% Léptetni az AGV-t, az idöt.
%--------------------------------------------------------------------------
global pos_agv phi_elf lepeskoz time delta_t kepkockaotaido
global phi_agv2cableroute osszes_megtett_ut
%--------------------------------------------------------------------------
% Léptetés:
agvrotationtranslation(lepeskoz,phi_elf);
time = time + delta_t;% Az eltelt idö léptetése.
kepkockaotaido = kepkockaotaido + delta_t;
%--------------------------------------------------------------------------
% Eredménykiírás parancssorba:
disp('agvrotationtranslation utan:');
uzenet = ['ido[s] = ', num2str(time)];
disp(uzenet);
uzenet = ['osszes_megtett_ut [m] = ', num2str(osszes_megtett_ut)];
disp(uzenet);
uzenet = ['Leptetes utáni AGV helyzet: x = ',num2str(pos_agv(1,1)),', y = ',num2str(pos_agv(2,1)),', phi(AGV2cable) = ',num2str(phi_agv2cableroute)];
disp(uzenet);
end