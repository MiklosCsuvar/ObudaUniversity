function detflux2detfeszultseg()
%--------------------------------------------------------------------------
% Verzió: 1.0
% A függvény célja:
% Az érzékelö pozíciójában mért mágneses fluxusból feszültséget
% elöállítani.
%--------------------------------------------------------------------------
global detektorszam flux_det signal_det_erositetlen frekvencia N
%--------------------------------------------------------------------------
for i = 1:detektorszam
    signal_det_erositetlen(1,i) = flux_det(1,i)*2*pi*frekvencia*N;
end
%--------------------------------------------------------------------------
% Az eremény kijelzése parancssorba:
% uzenet = ['Indukálva [V]:     U(1) = ', num2str(signal_det_erositetlen(1,1)), ' V; U(2) = ', num2str(signal_det_erositetlen(1, detektorszam)), ' V'];
% disp(uzenet);
end