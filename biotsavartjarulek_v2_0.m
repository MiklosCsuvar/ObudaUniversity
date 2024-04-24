function indukciotomb_B = biotsavartjarulek_v2_0(aramvezeto,pos_det,amplitudo)
%--------------------------------------------------------------------------
% Verzi�: 2.0
% A f�ggv�ny c�lja:
% Kisz�m�tani az
% 'aramvezeto' t�mb oszlopaiban r�gz�tett vektorokkal megadott �ramj�rta vezet�szakasz
% indukci�s j�rul�k�t
% a 'pos_det' t�mb oszlopaiban r�gz�tett vektorokkal megadott pontokra vonatkoz�an.
% Az 'amplitudo'-val a v�g�n be kell szorozni az eredm�nyt.
%--------------------------------------------------------------------------
r = zeros(3,2,'double');
cosphi = zeros(1,2,'double');
detektorszam = size(pos_det,2);
width_aramvezeto = size(aramvezeto,2);
dB = zeros(3,1,'double');
indukciotomb_B = zeros(3,detektorszam,'double');
%--------------------------------------------------------------------------
% A m�gneses indukci� kisz�m�t�sa.
for i = 1:detektorszam
%     uzenet = [num2str(i),'/',num2str(detektorszam),' poz�ci� feldolgoz�sa'];
%     disp(uzenet);
    for j = 1:width_aramvezeto-1
        for k = 1:2
            r(1:3,k) = aramvezeto(1:3,j+k-1);
        end
        if (min(r(1:3,1) == r(1:3,2)) == 1) % Ha a vektorok azonosak,
            dB = 0*dB; % akkor a m�gneses indukci�-j�rul�k [0;0;0].
        else
            tmp = cross(r(1:3,2)-r(1:3,1),pos_det(1:3,i)-r(1:3,1));
            egysegvektor_dB = tmp/norm(tmp,2); % Az �ramj�rta vezet� szakasza j�rul�k�nak ir�nya.
            tmp = r(1:3,2)-r(1:3,1); % A teljes vezet�szakasz vektora.
            egysegvektor_r1_r2 = tmp/norm(tmp,2); % A vezet�szakasz ir�nya.
            tmp = pos_det(1:3,i)-r(1:3,1); % A pillanatnyi vezet�szaklasz-�rz�kel� helyvektor.
            tmp = tmp-(tmp'*egysegvektor_r1_r2)*egysegvektor_r1_r2; % A vezet�r�l az �rz�kel�re bocs�jtott mer�leges.
            d = norm(tmp,2); % A vezet� �s az �rz�kel� t�vols�ga.
            for k = 1:2
                tmp = pos_det(1:3,i)-r(1:3,k); % A pillanatnyi vezet�szaklasz-�rz�kel� helyvektor.
                cosphi(1,k) = (tmp'*egysegvektor_r1_r2)/norm(tmp,2); % A vezet� �s a helyvektor �ltal bez�rt sz�g koszinusza.
            end
            dB(1:3,1) = (1/d)*abs(cosphi(1,2)-cosphi(1,1))*egysegvektor_dB; %  A vezet�szakasz m�gneses indukci� j�rul�ka
            % a det sorsz�m� �rz�kel�re.
        end
        indukciotomb_B(1:3,i) = indukciotomb_B(1:3,i) + dB(1:3,1);        
    end
end
indukciotomb_B = amplitudo*indukciotomb_B;
%--------------------------------------------------------------------------
% Az erem�ny kijelz�se parancssorba:
% uzenet = ['indukciotomb_B ='];
% disp(uzenet);
% uzenet = [indukciotomb_B];
% disp(uzenet);
end