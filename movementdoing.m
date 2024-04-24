function movementdoing()
%--------------------------------------------------------------------------
% Verzi�: 1.0
% A f�ggv�ny c�lja:
% L�ptetni az AGV-t, az id�t.
%--------------------------------------------------------------------------
global pos_agv phi_elf lepeskoz time delta_t kepkockaotaido
global phi_agv2cableroute osszes_megtett_ut
%--------------------------------------------------------------------------
% L�ptet�s:
agvrotationtranslation(lepeskoz,phi_elf);
time = time + delta_t;% Az eltelt id� l�ptet�se.
kepkockaotaido = kepkockaotaido + delta_t;
%--------------------------------------------------------------------------
% Eredm�nyki�r�s parancssorba:
disp('agvrotationtranslation utan:');
uzenet = ['ido[s] = ', num2str(time)];
disp(uzenet);
uzenet = ['osszes_megtett_ut [m] = ', num2str(osszes_megtett_ut)];
disp(uzenet);
uzenet = ['Leptetes ut�ni AGV helyzet: x = ',num2str(pos_agv(1,1)),', y = ',num2str(pos_agv(2,1)),', phi(AGV2cable) = ',num2str(phi_agv2cableroute)];
disp(uzenet);
end