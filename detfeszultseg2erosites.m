function detfeszultseg2erosites()
%--------------------------------------------------------------------------
% Verzió: 1.0
% A függvény célja:
% Az érzékelö feszültségét lineárisan erösíteni.
%--------------------------------------------------------------------------
global signal_det signal_det_erositetlen feszerosites detektorszam
%--------------------------------------------------------------------------
for i = 1:detektorszam
    signal_det(1,i) = signal_det_erositetlen(1,i)*feszerosites; % Erösített jel: U[V].
end
%--------------------------------------------------------------------------
% Az eremény kijelzése parancssorba:
% uzenet = ['Erösítve [V]:      U(1) = ', num2str(signal_det(1,1)), '; U(', num2str(detektorszam),') = ', num2str(signal_det(1, detektorszam))];
% disp(uzenet);
end