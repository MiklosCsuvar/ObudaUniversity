function detindukcio2detflux()
%--------------------------------------------------------------------------
% Verzió: 1.0
% A függvény célja:
% Az érzékelö pozíciójában mért mágneses indukcióból kiszámolni az
% érzékelöre jutó mágneses fluxust.
%--------------------------------------------------------------------------
global detektorszam induction_det flux_det Rtek height_det tavolsag_det vektorvagyskalar
%--------------------------------------------------------------------------
if (vektorvagyskalar == 's')
    % Fluxusszámítás skalárként tárolt mágneses indukcióból.
    for i = 1:detektorszam
    flux_det(1,i) = induction_det(3,i)*Rtek^2*pi*tavolsag_det(1,i)/sqrt(height_det^2+tavolsag_det(1,i)^2);
    end
else
    % Fluxusszámítás vektorként tárolt mágneses indukcióból.
    feluletvektor = Rtek^2*pi*[0;0;1];
    for i = 1:detektorszam
        flux_det(1,i) = induction_det(1:3,i)'*feluletvektor;
    end
end
%--------------------------------------------------------------------------
% Az eremény kijelzése parancssorba:
% uzenet = ['Fluxus [Vs]:       F(1) = ', num2str(flux_det(1,1)), '; F(2) = ', num2str(flux_det(1, detektorszam))];
% disp(uzenet);
end