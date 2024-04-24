function indukciotomb_B = biotsavartjarulek_v2_0(aramvezeto,pos_det,amplitudo)
%--------------------------------------------------------------------------
% Verzió: 2.0
% A függvény célja:
% Kiszámítani az
% 'aramvezeto' tömb oszlopaiban rögzített vektorokkal megadott áramjárta vezetöszakasz
% indukciós járulékát
% a 'pos_det' tömb oszlopaiban rögzített vektorokkal megadott pontokra vonatkozóan.
% Az 'amplitudo'-val a végén be kell szorozni az eredményt.
%--------------------------------------------------------------------------
r = zeros(3,2,'double');
cosphi = zeros(1,2,'double');
detektorszam = size(pos_det,2);
width_aramvezeto = size(aramvezeto,2);
dB = zeros(3,1,'double');
indukciotomb_B = zeros(3,detektorszam,'double');
%--------------------------------------------------------------------------
% A mágneses indukció kiszámítása.
for i = 1:detektorszam
%     uzenet = [num2str(i),'/',num2str(detektorszam),' pozíció feldolgozása'];
%     disp(uzenet);
    for j = 1:width_aramvezeto-1
        for k = 1:2
            r(1:3,k) = aramvezeto(1:3,j+k-1);
        end
        if (min(r(1:3,1) == r(1:3,2)) == 1) % Ha a vektorok azonosak,
            dB = 0*dB; % akkor a mágneses indukció-járulék [0;0;0].
        else
            tmp = cross(r(1:3,2)-r(1:3,1),pos_det(1:3,i)-r(1:3,1));
            egysegvektor_dB = tmp/norm(tmp,2); % Az áramjárta vezetö szakasza járulékának iránya.
            tmp = r(1:3,2)-r(1:3,1); % A teljes vezetöszakasz vektora.
            egysegvektor_r1_r2 = tmp/norm(tmp,2); % A vezetöszakasz iránya.
            tmp = pos_det(1:3,i)-r(1:3,1); % A pillanatnyi vezetöszaklasz-érzékelö helyvektor.
            tmp = tmp-(tmp'*egysegvektor_r1_r2)*egysegvektor_r1_r2; % A vezetöröl az érzékelöre bocsájtott meröleges.
            d = norm(tmp,2); % A vezetö és az érzékelö távolsága.
            for k = 1:2
                tmp = pos_det(1:3,i)-r(1:3,k); % A pillanatnyi vezetöszaklasz-érzékelö helyvektor.
                cosphi(1,k) = (tmp'*egysegvektor_r1_r2)/norm(tmp,2); % A vezetö és a helyvektor által bezárt szög koszinusza.
            end
            dB(1:3,1) = (1/d)*abs(cosphi(1,2)-cosphi(1,1))*egysegvektor_dB; %  A vezetöszakasz mágneses indukció járuléka
            % a det sorszámú érzékelöre.
        end
        indukciotomb_B(1:3,i) = indukciotomb_B(1:3,i) + dB(1:3,1);        
    end
end
indukciotomb_B = amplitudo*indukciotomb_B;
%--------------------------------------------------------------------------
% Az eremény kijelzése parancssorba:
% uzenet = ['indukciotomb_B ='];
% disp(uzenet);
% uzenet = [indukciotomb_B];
% disp(uzenet);
end