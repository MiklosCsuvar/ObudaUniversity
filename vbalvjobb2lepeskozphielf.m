function [lepeskoz, phi_elf] = vbalvjobb2lepeskozphielf()
%--------------------------------------------------------------------------
% Verzió: 1.0
% A függvény célja:
% Kiszámolni a kerekek sebességei (vbal, vjobb) alapján
% a léptetés távolságát (lepeskoz [m]) és
% az elforgatás szögét (phi_elf [rad]).
%--------------------------------------------------------------------------
global vbal vjobb delta_t d_kerekek gorbuletisugar delta_s
%--------------------------------------------------------------------------
disp('vbalvjobb2lepeskozphielf.m');
if (vbal == vjobb)
    delta_s = vbal*delta_t;
    % gorbuletisugar = Inf;
    phi_elf = 0;
    lepeskoz = abs(delta_s);
else
    if (sign(vbal) == sign(vjobb))
        delta_s_bal = vbal*delta_t;
        delta_s_jobb = vjobb*delta_t;
        delta_s = (delta_s_bal+delta_s_jobb)/2;
        phi_elf = -(delta_s_bal-delta_s_jobb)/d_kerekek;
        gorbuletisugar = gorbuletisugarfv();
        lepeskoz = 2*gorbuletisugar*sin(phi_elf/2);
    else
        delta_s_bal = vbal*delta_t;
        delta_s_jobb = vjobb*delta_t;
        delta_s = delta_s_bal-delta_s_jobb;
        % phi_elf = -delta_t*(delta_s_bal-delta_s_jobb)/d_kerekek;
        phi_elf = -delta_s/d_kerekek;
        lepeskoz = 0;
    end
end
%osszes_megtett_ut = osszes_megtett_ut + delta_s;
%--------------------------------------------------------------------------
uzenet = ['lepeskoz = ', num2str(lepeskoz),', phi_elf = ', num2str(phi_elf)];
disp(uzenet);
end