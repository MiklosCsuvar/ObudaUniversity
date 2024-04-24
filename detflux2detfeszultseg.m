function detflux2detfeszultseg()
%--------------------------------------------------------------------------
% Verzi�: 1.0
% A f�ggv�ny c�lja:
% Az �rz�kel� poz�ci�j�ban m�rt m�gneses fluxusb�l fesz�lts�get
% el��ll�tani.
%--------------------------------------------------------------------------
global detektorszam flux_det signal_det_erositetlen frekvencia N
%--------------------------------------------------------------------------
for i = 1:detektorszam
    signal_det_erositetlen(1,i) = flux_det(1,i)*2*pi*frekvencia*N;
end
%--------------------------------------------------------------------------
% Az erem�ny kijelz�se parancssorba:
% uzenet = ['Induk�lva [V]:     U(1) = ', num2str(signal_det_erositetlen(1,1)), ' V; U(2) = ', num2str(signal_det_erositetlen(1, detektorszam)), ' V'];
% disp(uzenet);
end