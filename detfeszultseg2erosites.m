function detfeszultseg2erosites()
%--------------------------------------------------------------------------
% Verzi�: 1.0
% A f�ggv�ny c�lja:
% Az �rz�kel� fesz�lts�g�t line�risan er�s�teni.
%--------------------------------------------------------------------------
global signal_det signal_det_erositetlen feszerosites detektorszam
%--------------------------------------------------------------------------
for i = 1:detektorszam
    signal_det(1,i) = signal_det_erositetlen(1,i)*feszerosites; % Er�s�tett jel: U[V].
end
%--------------------------------------------------------------------------
% Az erem�ny kijelz�se parancssorba:
% uzenet = ['Er�s�tve [V]:      U(1) = ', num2str(signal_det(1,1)), '; U(', num2str(detektorszam),') = ', num2str(signal_det(1, detektorszam))];
% disp(uzenet);
end