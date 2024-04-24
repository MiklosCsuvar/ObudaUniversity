function [tavolsagok,kozelipontok,idx_uj] = position2cabledistance(poziciok,idx_regi)
%--------------------------------------------------------------------------
% Verzi�: 2.0
% Bemenet:
% poziciok: Azon pontok, amik k�belnyomvonalt�l(val� t�vols�g�t keress�k (3,1)-as vektorainak (3,n)-es t�mbje.
% idx_regi: A fenti vektor(ok)hoz tartoz� el�z� k�belnyomvonal indexek.
% A f�ggv�ny c�lja:
% Kisz�molni egy tetsz�leges pont (x,y,z) �s a k�belnyomvonal (x,y) t�vols�g�t az XY-s�kban!
%--------------------------------------------------------------------------
% V�ltoz�k beolvas�sa vagy defini�l�sa �s alap�rt�kad�sa.
global max_x_cable max_y_cable min_x_cable min_y_cable
global cableroute width_cableroute
global idxenv
%--------------------------------------------------------------------------
% A t�vols�g kiindul�si �rt�ke. Lehetetlen�l nagy.
v1 = [min_x_cable;min_y_cable];
v2 = [max_x_cable;max_y_cable];
tav = norm(v2-v1,2); % Ideiglenes v�ltoz�: t�vols�g.
dim = size(poziciok);
poziciodarabszam = dim(2); % A vizsg�land� helyvektorok darabsz�ma.
tavolsagok = tav*ones(1,dim(2),'double'); % A t�vols�gokat tartalmaz� kimeneti t�mb.
% idx_uj = zeros(1,dim(2),'uint32'); % Az �j k�belnyomvonal indexek t�mbje.
idx_uj = idx_regi; % Az �j k�belnyomvonal indexek t�mbje.
kozelipontok = zeros(3,dim(2),'double'); % Az egyes vizsg�lt helyvektorokhoz tartoz� k�belnyomvonal-pontok t�mbje ()
%palyagorbesegertekek = zeros(1,dim(2),'uint32');
% uzenet = ['poziciodarabszam = ', num2str(dim(2))];
% disp(uzenet);
%--------------------------------------------------------------------------
% A pont �s a k�belnyomvonal k�z�tti t�vols�g kisz�m�t�sa.
for d = 1:poziciodarabszam
    %tavolsagok(1,d) = tav;
    if (idx_regi(1,d) == 1)
        i = idx_regi(1,d);
        while (i < width_cableroute)% A sz�m�t�s elv�gz�se a teljes k�belnyomvonal ment�n.
            % Ez a ciklus g�pid�-ig�nyes. Ha lehet, csak egyszer fusson le.
            i = i+1;
                % A k�bel 'i' index� pontja �s a megadott (x,y) pont k�z��tti
                % t�vols�g kisz�m�t�sa
                tmptavolsag = norm(poziciok(1:3,d)-cableroute(1:3,i),2);
                if (tmptavolsag <= tavolsagok(1,d))
                    tavolsagok(1,d) = tmptavolsag;% Ha az elt�rolt t�vols�g kisebb a sz�m�tottn�l, akkor fel�l�rja,
                    idx_uj(1,d) = i;% �s a tov�bbi t�vols�gkutakod�sok ezen index k�rnyezet�b�l indulnak.
                end
        end
%         uzenet = ['if (idx_regi(1,d) == 1): idx_uj(1,', num2str(d),') = ', num2str(idx_uj(1,d))];
%         disp(uzenet);        
    else
        for l = 0:1
            k = 0;
            % A sz�m�t�s elv�gz�se a legut�bbi legk�zelebbi pont 'idxenv' sugar� k�rnyezet�ben.
%             uzenet = ['else �g: For ciklus. l = ', num2str(l), ' k = ', num2str(k), ' idx_regi(1,',num2str(d),') = i = ', num2str(idx_regi(1,d))];
%             disp(uzenet);
            while (k < idxenv)
                i = mod((width_cableroute+idx_regi(1,d)+(k*((-1)^l))),width_cableroute);
                if (i == 0)
                    i = width_cableroute;
                end
%                 uzenet = ['else �g: k cikluson bel�l. Vizsg�lat: i = ',num2str(i)];
%                 disp(uzenet);
                % A k�bel 'i' index� pontja �s a megadott (x,y) pont k�z��tti
                % t�vols�g kisz�m�t�sa
                tmptavolsag = norm(poziciok(1:3,d)-cableroute(1:3,i),2);
                if (tmptavolsag <= tavolsagok(1,d))
                    tavolsagok(1,d) = tmptavolsag;% Ha az elt�rolt t�vols�g kisebb a sz�m�tottn�l, akkor fel�l�rja,
                    idx_uj(1,d) = i;% �s a tov�bbi t�vols�gkutakod�sok ezen index k�rnyezet�b�l indulnak.
%                          uzenet = ['else �g: �rt�kad�s. l = ', num2str(l), ' k = ', num2str(k), ' idx_uj(1,',num2str(d),') = i = ', num2str(idx_uj(1,d))];
%                          disp(uzenet);
                end
                k = k+1;
            end
%             uzenet = ['else �g k ciklus v�ge ut�n:', 'idx_regi(1,',num2str(d), ') = ', num2str(idx_regi(1,d)), ' l = ', num2str(l), ' k = ', num2str(k), ' idx_uj(1,',num2str(d),') = i = ', num2str(idx_uj(1,d))];
%             disp(uzenet);
        end
%         uzenet = ['else �g l ciklus �s else v�ge:', 'idx_regi(1,',num2str(d), ') = ', num2str(idx_regi(1,d)), ' l = ', num2str(l), ' k = ', num2str(k), ' idx_uj(1,',num2str(d),') = i = ', num2str(idx_uj(1,d))];
%         disp(uzenet);
    end
%     uzenet = ['V�gleges idx_uj(1,',num2str(d),') = ', num2str(idx_uj(1,d))];
%     disp(uzenet);
    kozelipontok(1:3,d) = cableroute(1:3,idx_uj(1,d));
%    palyagorbesegertekek(1,d) = gorbeseg(1,idx_uj(1,d));
end
%--------------------------------------------------------------------------
% Az erem�ny kijelz�se parancssorba:
% if (poziciodarabszam > 1)
%     uzenet = ['Detektor-p�lya t�vols�g (xy-s�k): d(1) = ', num2str(tavolsagok(1,1)), ', d(2) = ', num2str(tavolsagok(1, poziciodarabszam))];
%     disp(uzenet);
% end
end