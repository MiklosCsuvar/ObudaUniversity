function detindukcio2detflux()
%--------------------------------------------------------------------------
% Verzi�: 1.0
% A f�ggv�ny c�lja:
% Az �rz�kel� poz�ci�j�ban m�rt m�gneses indukci�b�l kisz�molni az
% �rz�kel�re jut� m�gneses fluxust.
%--------------------------------------------------------------------------
global detektorszam induction_det flux_det Rtek height_det tavolsag_det vektorvagyskalar
%--------------------------------------------------------------------------
if (vektorvagyskalar == 's')
    % Fluxussz�m�t�s skal�rk�nt t�rolt m�gneses indukci�b�l.
    for i = 1:detektorszam
    flux_det(1,i) = induction_det(3,i)*Rtek^2*pi*tavolsag_det(1,i)/sqrt(height_det^2+tavolsag_det(1,i)^2);
    end
else
    % Fluxussz�m�t�s vektork�nt t�rolt m�gneses indukci�b�l.
    feluletvektor = Rtek^2*pi*[0;0;1];
    for i = 1:detektorszam
        flux_det(1,i) = induction_det(1:3,i)'*feluletvektor;
    end
end
%--------------------------------------------------------------------------
% Az erem�ny kijelz�se parancssorba:
% uzenet = ['Fluxus [Vs]:       F(1) = ', num2str(flux_det(1,1)), '; F(2) = ', num2str(flux_det(1, detektorszam))];
% disp(uzenet);
end