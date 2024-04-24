function [tavolsagok,kozelipontok,idx_uj] = position2cabledistance(poziciok,idx_regi)
%--------------------------------------------------------------------------
% Verzió: 2.0
% Bemenet:
% poziciok: Azon pontok, amik kábelnyomvonaltól(való távolságát keressük (3,1)-as vektorainak (3,n)-es tömbje.
% idx_regi: A fenti vektor(ok)hoz tartozó elözö kábelnyomvonal indexek.
% A függvény célja:
% Kiszámolni egy tetszöleges pont (x,y,z) és a kábelnyomvonal (x,y) távolságát az XY-síkban!
%--------------------------------------------------------------------------
% Változók beolvasása vagy definiálása és alapértékadása.
global max_x_cable max_y_cable min_x_cable min_y_cable
global cableroute width_cableroute
global idxenv
%--------------------------------------------------------------------------
% A távolság kiindulási értéke. Lehetetlenül nagy.
v1 = [min_x_cable;min_y_cable];
v2 = [max_x_cable;max_y_cable];
tav = norm(v2-v1,2); % Ideiglenes változó: távolság.
dim = size(poziciok);
poziciodarabszam = dim(2); % A vizsgálandó helyvektorok darabszáma.
tavolsagok = tav*ones(1,dim(2),'double'); % A távolságokat tartalmazó kimeneti tömb.
% idx_uj = zeros(1,dim(2),'uint32'); % Az új kábelnyomvonal indexek tömbje.
idx_uj = idx_regi; % Az új kábelnyomvonal indexek tömbje.
kozelipontok = zeros(3,dim(2),'double'); % Az egyes vizsgált helyvektorokhoz tartozó kábelnyomvonal-pontok tömbje ()
%palyagorbesegertekek = zeros(1,dim(2),'uint32');
% uzenet = ['poziciodarabszam = ', num2str(dim(2))];
% disp(uzenet);
%--------------------------------------------------------------------------
% A pont és a kábelnyomvonal közötti távolság kiszámítása.
for d = 1:poziciodarabszam
    %tavolsagok(1,d) = tav;
    if (idx_regi(1,d) == 1)
        i = idx_regi(1,d);
        while (i < width_cableroute)% A számítás elvégzése a teljes kábelnyomvonal mentén.
            % Ez a ciklus gépidö-igényes. Ha lehet, csak egyszer fusson le.
            i = i+1;
                % A kábel 'i' indexü pontja és a megadott (x,y) pont közüötti
                % távolság kiszámítása
                tmptavolsag = norm(poziciok(1:3,d)-cableroute(1:3,i),2);
                if (tmptavolsag <= tavolsagok(1,d))
                    tavolsagok(1,d) = tmptavolsag;% Ha az eltárolt távolság kisebb a számítottnál, akkor felülírja,
                    idx_uj(1,d) = i;% és a további távolságkutakodások ezen index környezetéböl indulnak.
                end
        end
%         uzenet = ['if (idx_regi(1,d) == 1): idx_uj(1,', num2str(d),') = ', num2str(idx_uj(1,d))];
%         disp(uzenet);        
    else
        for l = 0:1
            k = 0;
            % A számítás elvégzése a legutóbbi legközelebbi pont 'idxenv' sugarú környezetében.
%             uzenet = ['else ág: For ciklus. l = ', num2str(l), ' k = ', num2str(k), ' idx_regi(1,',num2str(d),') = i = ', num2str(idx_regi(1,d))];
%             disp(uzenet);
            while (k < idxenv)
                i = mod((width_cableroute+idx_regi(1,d)+(k*((-1)^l))),width_cableroute);
                if (i == 0)
                    i = width_cableroute;
                end
%                 uzenet = ['else ág: k cikluson belül. Vizsgálat: i = ',num2str(i)];
%                 disp(uzenet);
                % A kábel 'i' indexü pontja és a megadott (x,y) pont közüötti
                % távolság kiszámítása
                tmptavolsag = norm(poziciok(1:3,d)-cableroute(1:3,i),2);
                if (tmptavolsag <= tavolsagok(1,d))
                    tavolsagok(1,d) = tmptavolsag;% Ha az eltárolt távolság kisebb a számítottnál, akkor felülírja,
                    idx_uj(1,d) = i;% és a további távolságkutakodások ezen index környezetéböl indulnak.
%                          uzenet = ['else ág: Értékadás. l = ', num2str(l), ' k = ', num2str(k), ' idx_uj(1,',num2str(d),') = i = ', num2str(idx_uj(1,d))];
%                          disp(uzenet);
                end
                k = k+1;
            end
%             uzenet = ['else ág k ciklus vége után:', 'idx_regi(1,',num2str(d), ') = ', num2str(idx_regi(1,d)), ' l = ', num2str(l), ' k = ', num2str(k), ' idx_uj(1,',num2str(d),') = i = ', num2str(idx_uj(1,d))];
%             disp(uzenet);
        end
%         uzenet = ['else ág l ciklus és else vége:', 'idx_regi(1,',num2str(d), ') = ', num2str(idx_regi(1,d)), ' l = ', num2str(l), ' k = ', num2str(k), ' idx_uj(1,',num2str(d),') = i = ', num2str(idx_uj(1,d))];
%         disp(uzenet);
    end
%     uzenet = ['Végleges idx_uj(1,',num2str(d),') = ', num2str(idx_uj(1,d))];
%     disp(uzenet);
    kozelipontok(1:3,d) = cableroute(1:3,idx_uj(1,d));
%    palyagorbesegertekek(1,d) = gorbeseg(1,idx_uj(1,d));
end
%--------------------------------------------------------------------------
% Az eremény kijelzése parancssorba:
% if (poziciodarabszam > 1)
%     uzenet = ['Detektor-pálya távolság (xy-sík): d(1) = ', num2str(tavolsagok(1,1)), ', d(2) = ', num2str(tavolsagok(1, poziciodarabszam))];
%     disp(uzenet);
% end
end