function [delta_absU_max, delta_absU_max_position, absU_max, absU_max_position] = deltaumax()
%--------------------------------------------------------------------------
% Verzió: 2.0
% A függvény célja:
% 1. Kiszámolja a lehetséges legnagyobb feszültségkülönbséget.
% 2. Ha kell, az analóg eredményt digitalizálja.
%--------------------------------------------------------------------------
% Változók.
global d_det height_det amplitude_U delta_t vmax AGVpolygon
global vektorvagyskalar pos_agv pos_det cableroute signal_det_erositetlen
global width_cableroute detektorszam
global width_vizsgalandoindexek maximumhelykereses_elorehaladas
global deltaumaxhivta vizsgalandoindexek
global egysegvektor vizsgalandopont_erinto_vektora vizsgalandopont_normal_vektora
global tovabb_vizsgalandopont_indexe tovabb_vizsgalandopont_tavolsaga
global tovabb_vizsgalando_ertek deltaumaxkereses vizsgalandopont_vektora
global indukcio_finomkozelites_pontossag
%--------------------------------------------------------------------------
tmp = 0;
delta_absU_max = 0; % [V]
delta_absU_max_position = 0; % [m]
absU_max = 0; % [V]
absU_max_position = 0; % [m]
lepeskoz = 0.01; % [m]
alsohatar =  -d_det; % [m]
felsohatar = +d_det; % [m]
egysegvektor = zeros(3,3,'double');
vizsgalandopont_vektora = zeros(3,width_vizsgalandoindexek,'double');
vizsgalandopont_erinto_vektora = zeros(3,width_vizsgalandoindexek,'double');
vizsgalandopont_normal_vektora = zeros(3,width_vizsgalandoindexek,'double');
tovabb_vizsgalandopont_indexe = zeros(1,2,'int32');
tovabb_vizsgalandoindexek_indexei = zeros(1,2,'int32');
tovabb_vizsgalandopont_tavolsaga = zeros(1,2,'double');
tovabb_vizsgalando_ertek = zeros(1,2,'double');
regi_ertek = zeros(1,2,'double');
deltaumaxkereses = zeros(3,1,'double');
%--------------------------------------------------------------------------
disp('deltaumax.m indul.');
if (vektorvagyskalar == 's')
    % A maximumhely durva közelítése.
    for AGVnyomvonaltavolsag = alsohatar:lepeskoz:felsohatar
        if (height_det^2+(AGVnyomvonaltavolsag-d_det/2)^2 > 0)
            signal_det1 = amplitude_U*(AGVnyomvonaltavolsag-d_det/2)/(height_det^2+(AGVnyomvonaltavolsag-d_det/2)^2);% 1. érzékelö jele: U[V].
        else
            signal_det1 = 0;
        end
        if (height_det^2+(AGVnyomvonaltavolsag+d_det/2)^2 > 0)
            signal_det2 = amplitude_U*(AGVnyomvonaltavolsag+d_det/2)/(height_det^2+(AGVnyomvonaltavolsag+d_det/2)^2);% 2. érzékelö jele: U[V].
        else
            signal_det2 = 0;
        end
        signal_diff = abs(signal_det1) - abs(signal_det2);% Az érzékelök jelének különbsége: U[V].
        tmp = signal_diff;
        if(tmp > delta_absU_max)
            delta_absU_max = tmp;
            delta_absU_max_position = AGVnyomvonaltavolsag;
        end
        tmp = max(abs(signal_det1),abs(signal_det2));
        if(tmp > absU_max)
            absU_max = tmp;
            absU_max_position = AGVnyomvonaltavolsag;
        end
    end
    uzenet = ['Durva: delta_absU_max_position = ', num2str(delta_absU_max_position),' m'];
    disp(uzenet);
    uzenet = ['Durva: delta_absU_max = ', num2str(delta_absU_max),' V'];
    disp(uzenet);
    %----------------------------------------------------------------------
    % A maximumhely finom közelítése.
    regidelta_absU_max = delta_absU_max;
    regi_absU_max = absU_max;
%    i = 1;
    vantovabb = 1;
    while(vantovabb == 1)
        tmp_lepeskoz = lepeskoz;
        lepeskoz = lepeskoz/10;
        alsohatar = delta_absU_max_position - tmp_lepeskoz;
        felsohatar = delta_absU_max_position + tmp_lepeskoz;
        for AGVnyomvonaltavolsag = alsohatar:lepeskoz:felsohatar
            if (height_det^2+(AGVnyomvonaltavolsag-d_det/2)^2 > 0)
                signal_det1 = amplitude_U*(AGVnyomvonaltavolsag-d_det/2)/(height_det^2+(AGVnyomvonaltavolsag-d_det/2)^2);% 1. érzékelö jele: U[V].
            else
                signal_det1 = 0;
            end
            if (height_det^2+(AGVnyomvonaltavolsag+d_det/2)^2 > 0)
                signal_det2 = amplitude_U*(AGVnyomvonaltavolsag+d_det/2)/(height_det^2+(AGVnyomvonaltavolsag+d_det/2)^2);% 2. érzékelö jele: U[V].
            else
                signal_det2 = 0;
            end
            signal_diff = abs(signal_det1) - abs(signal_det2);% Az érzékelök jelének különbsége: U[V].
            tmp = signal_diff;
            if(tmp > delta_absU_max)
                delta_absU_max = tmp;
                delta_absU_max_position = AGVnyomvonaltavolsag;
            end
            tmp = max(abs(signal_det1),abs(signal_det2));
            if(tmp > absU_max)
                absU_max = tmp;
                absU_max_position = AGVnyomvonaltavolsag;
            end
        end
%        i = i + 1;
        if (delta_absU_max ~= regidelta_absU_max || absU_max ~= regi_absU_max)
            regidelta_absU_max = delta_absU_max;
        else
            vantovabb = 0;
        end
    end
    uzenet = ['Finom: delta_absU_max_position = ', num2str(delta_absU_max_position),' m'];
    disp(uzenet);
    uzenet = ['Finom: delta_absU_max = ', num2str(delta_absU_max),' V'];
    disp(uzenet);
    uzenet = ['Finom: abs(U)_max_position = ', num2str(absU_max_position),' m'];
    disp(uzenet);
    uzenet = ['Finom: abs(U)_max = ', num2str(absU_max),' V'];
    disp(uzenet);    
    %----------------------------------------------------------------------
else
    deltaumaxhivta = 1;
    % Vektoriális B[T]-vel számolás a Biot-Savart törvény alapján.
    uzenet = ['Vektoriális B[T]-vel számolás a Biot-Savart törvény alapján.'];
    disp(uzenet);
    %----------------------------------------------------------------------
    % A vezérlöjel maximumhelyét adó pont kiválasztása a kijelölt pontok közül.
    uzenet = ['% A vezérlöjel maximumhely durva közelítése a kijelölt pontok körül:'];
    disp(uzenet);
    dim = size(vizsgalandoindexek);
    width_vizsgalandoindexek = dim(2);
    %----------------------------------------------------------------------
    % A vezérlöjel maximumhely durva közelítése minden pont körül.
    for i = 1:width_vizsgalandoindexek
        vizsgalandopont_vektora(1:3,i) = cableroute(1:3,vizsgalandoindexek(1,i));
        pos_agv = vizsgalandopont_vektora(1:3,i);
        uzenet = ['vizsgalandoindex = ',num2str(vizsgalandoindexek(1,i))];
        disp(uzenet);
        for j = 1:1:2
            tmpidx = vizsgalandoindexek(1,i)+((-1)^j); % Ha a kiválasztott indexü ideiglenes pont véletlenül
            tmpidx = indexkorrekcio(tmpidx,1,width_cableroute);
            tmp = (cableroute(1:3,tmpidx) == pos_agv); % A kiválasztott pont esetleg a kábelszámítás hibája miatt
            while(min(tmp) == 1) % egyezik az AGV pozíciójával?
                tmpidx = tmpidx +(-1)^j; % Akkor ugyanabba az irányba haladva
                tmpidx = indexkorrekcio(tmpidx,1,width_cableroute);
                tmp = (cableroute(1:3,tmpidx(1,i)) == pos_agv);
            end
%             tmpidx = tmpidx + 5*(-1)^j; % Akkor ugyanabba az irányba haladva
%             tmpidx = indexkorrekcio(tmpidx,1,width_cableroute);
            uzenet = ['tmpidx = ', num2str(tmpidx)];
            disp(uzenet);
            uzenet = [cableroute(1:3,tmpidx)];
            disp(uzenet);
            tmpvec = cableroute(1:3,tmpidx) - pos_agv; % Meghatározni az AGV pozíciójából
            egysegvektor(1:3,j) = tmpvec/norm(tmpvec,2); % ide mutató egységvektort.
            uzenet = ['egysegvektor(1:3,j) = '];
            disp(uzenet);
            uzenet = [egysegvektor(1:3,j)];
            disp(uzenet);
        end
            egysegvektor(1:3,3) = egysegvektor(1:3,2)-egysegvektor(1:3,1);            
            uzenet = ['egysegvektor(1:3,3) = '];
            disp(uzenet);
            uzenet = [egysegvektor(1:3,3)];
            disp(uzenet);            
            vizsgalandopont_erinto_vektora(1:3,i) = egysegvektor(1:3,3)/norm(egysegvektor(1:3,3),2);
            vizsgalandopont_normal_vektora(1:3,i) = polygonrot(vizsgalandopont_erinto_vektora(1:3,i),-pi/2,[0;0;0]);            
        uzenet = ['vizsgalandoindex = ',num2str(vizsgalandoindexek(1,i))];
        disp(uzenet);
        uzenet = ['pos_agv, pályaérintö egységvektor, pályanormális egységvektor'];
        disp(uzenet);
        uzenet = [cableroute(1:3,vizsgalandoindexek(1,i)),vizsgalandopont_erinto_vektora(1:3,i),vizsgalandopont_normal_vektora(1:3,i)];
        disp(uzenet);
    end
    
    vizsgalaticiklus = 1;
    while (vizsgalaticiklus > 0)
        uzenet = ['Vizsgálati ciklus: ',num2str(vizsgalaticiklus)];
        disp(uzenet);
        
        if (vizsgalaticiklus == 1)
            dim = size(vizsgalandoindexek);
            width_vizsgalandoindexek = dim(2);    
            vizsgalandoindexek_indexei = zeros(1,width_vizsgalandoindexek,'int32');
            for i = 1:width_vizsgalandoindexek
                vizsgalandoindexek_indexei(1,i) = i;
            end
        else
            vizsgalandoindexek_indexei = tovabb_vizsgalandoindexek_indexei;
        end
        dim = size(vizsgalandoindexek_indexei);
        width_vizsgalandoindexek_indexei = dim(2);       

        for i = vizsgalandoindexek_indexei
            maximumhelykereses_elorehaladas = i;

            if (vizsgalaticiklus == 1)
                uzenet = ['Maximumhely durva közelítés.'];
            end
            if (vizsgalaticiklus > 1)
                uzenet = ['Maximumhely finom közelítés.'];
            end        
            disp(uzenet);

            pos_agv = cableroute(1:3,vizsgalandoindexek(1,i));
            AGVpolygon = agvcalc();
            pos_det = detcalc();
            tmp1 = pos_det(1:3,1)-pos_det(1:3,detektorszam);
            tmp2 = vizsgalandopont_erinto_vektora(1:3,i);
            phi = anglevec2vecxy(tmp1,tmp2);  % A detektorok egyenese és a pálya érintöje által bezárt szög.
            phi_elf = pi/2 - phi;
            centrum = (pos_det(1:3,1)+pos_det(1:3,detektorszam))/2;
            AGVpolygon = polygonrot(AGVpolygon,phi_elf,centrum);
            pos_det = polygonrot(pos_det,phi_elf,centrum);
            tmp1 = pos_det(1:3,1)-pos_det(1:3,detektorszam);
            tmp2 = vizsgalandopont_erinto_vektora(1:3,i);
            phi = anglevec2vecxy(tmp1,tmp2);  % A detektorok egyenese és a pálya érintöje által bezárt szög.
            uzenet = ['Detektorok elforgatás után. phi = ',num2str(phi)];
            disp(uzenet);
            pos_agv_alap = pos_agv;
            AGVpolygon_alap = AGVpolygon;
            pos_det_alap = pos_det;
            % A maximumhely közelítése.
            sorszam = find(vizsgalandoindexek_indexei == i);
            if (vizsgalaticiklus > 1)
                regi_lepeskoz = lepeskoz;
                alappont = tovabb_vizsgalandopont_tavolsaga(1,sorszam);
                alsohatar = alappont - regi_lepeskoz;
                felsohatar = alappont + regi_lepeskoz;
                lepeskoz = regi_lepeskoz/10;
            end

            for AGVnyomvonaltavolsag = alsohatar:lepeskoz:felsohatar
                deltaumaxkereses = AGVnyomvonaltavolsag*vizsgalandopont_normal_vektora(1:3,i);
                pos_agv = polygonmove(pos_agv_alap,deltaumaxkereses);
                AGVpolygon = polygonmove(AGVpolygon_alap,deltaumaxkereses);
                pos_det = polygonmove(pos_det_alap,deltaumaxkereses);
                cabledistance2detindukcio_v3_0(); % A távolság alapján a detektorok mágneses indukciójának (B[T])kiszámítása.
                detindukcio2detflux(); % Az indukció (B[T]) alapján a fluxus kiszámítása.
                detflux2detfeszultseg(); % A fluxusból feszültség kiszámítása.
                signal_det1 = signal_det_erositetlen(1,1);
                signal_det2 = signal_det_erositetlen(1,2);
                signal_diff = abs(signal_det1) - abs(signal_det2);% Az érzékelök jelének különbsége: U[V].
                % delta_absU_max vizsgálata:
                tmp = signal_diff;
                if(tmp > tovabb_vizsgalando_ertek(1,1))
                    tovabb_vizsgalandoindexek_indexei(1,1) = i;
                    tovabb_vizsgalando_ertek(1,1) = tmp;
                    tovabb_vizsgalando_indexek(1,1) = vizsgalandoindexek(1,tovabb_vizsgalandoindexek_indexei(1,1));
                    tovabb_vizsgalandopont_tavolsaga(1,1) = AGVnyomvonaltavolsag;                    
                end
                % max(abs(U)) vizsgálata:
                tmp = max(abs(signal_det1),abs(signal_det2));
                if(tmp > tovabb_vizsgalando_ertek(1,2))
                    tovabb_vizsgalandoindexek_indexei(1,2) = i;
                    tovabb_vizsgalando_ertek(1,2) = tmp;
                    tovabb_vizsgalando_indexek(1,2) = vizsgalandoindexek(1,tovabb_vizsgalandoindexek_indexei(1,2));
                    tovabb_vizsgalandopont_tavolsaga(1,2) = AGVnyomvonaltavolsag;
                end
                filmezes();
            end            
        end
        
        igazsag = 1;
        for i = 1:2
            tmp1 = tovabb_vizsgalando_ertek(1,i);
            tmp2 = regi_ertek(1,i);
            ciklusjavulas = (abs((tmp1-tmp2)/tmp1) <= indukcio_finomkozelites_pontossag);
            igazsag = igazsag && ( ~(regi_ertek(1,i) < tovabb_vizsgalando_ertek(1,i)) || ciklusjavulas);
        end
        if (igazsag)
            vizsgalaticiklus = 0;
        else
            for i = 1:2
                 regi_ertek(1,i) = tovabb_vizsgalando_ertek(1,i);
            end
            vizsgalaticiklus = vizsgalaticiklus + 1;            
        end
        
        delta_absU_max = tovabb_vizsgalando_ertek(1,1);
        delta_absU_max_position = tovabb_vizsgalandopont_tavolsaga(1,1);
        absU_max = tovabb_vizsgalando_ertek(1,2);
        absU_max_position = tovabb_vizsgalandopont_tavolsaga(1,2);
        
        dim = size(vizsgalandoindexek_indexei);
        width_vizsgalando = dim(2);
        if (vizsgalaticiklus == 1)
            uzenet = ['Maximumhely durva közelítés. Feldolgozás alatt a(z) ', num2str(sorszam), '/', num2str(width_vizsgalandoindexek_indexei), '. kijelölt kábelindex.'];
        end
        if (vizsgalaticiklus == 0)
            uzenet = ['Maximumhely finom közelítés. Feldolgozás alatt a(z) ', num2str(sorszam), '/', num2str(width_vizsgalandoindexek_indexei), '. kijelölt kábelindex.'];
        end        
        disp(uzenet);
        if (vizsgalaticiklus == 1 || vizsgalaticiklus == 0)
            uzenet = ['delta(abs(U))_max = ', num2str(tovabb_vizsgalando_ertek(1,1)),' V'];
            disp(uzenet);
            uzenet = ['Kábelnyomvonal-index = ', num2str(vizsgalandoindexek(1,tovabb_vizsgalandoindexek_indexei(1,1)))];
            disp(uzenet);
            uzenet = ['AGV-nyomvonal távolság = ', num2str(tovabb_vizsgalandopont_tavolsaga(1,1)),' m'];
            disp(uzenet);
            uzenet = ['abs(U)_max = ', num2str(tovabb_vizsgalando_ertek(1,2)),' V'];
            disp(uzenet);
            uzenet = ['Kábelnyomvonal-index = ', num2str(vizsgalandoindexek(1,tovabb_vizsgalandoindexek_indexei(1,2)))];
            disp(uzenet);
            uzenet = ['AGV-nyomvonal távolság = ', num2str(tovabb_vizsgalandopont_tavolsaga(1,2)),' m'];
            disp(uzenet);
        end
    end
end
%
end