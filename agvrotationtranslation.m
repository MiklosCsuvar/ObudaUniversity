function agvrotationtranslation(lepeskoz,phiagvrot)
%--------------------------------------------------------------------------
% Verzió: 9.0
% A függvény célja:
% 0. Paraméterek beolvasása és változók deklarálása.
% 1. Az AGV-t és az érzékelöket (azok koordinátáit) a megadott szöggel elforgatja.
% 2. Eltolja az AGV-t és az érzékelöket (azok koordinátáit) a megadott lépéshosszal (lepeskoz).
%--------------------------------------------------------------------------
% 0. szakasz: Paraméterek beolvasása és változók deklarálása
global delta_r AGVpolygon pos_det pos_agv phi_agv kilepes
%--------------------------------------------------------------------------
% disp('agvrotationtranslation.m:');
if (kilepes == 0)
    %----------------------------------------------------------------------
    % 1. szakasz: AGV elforgatása a középpont körül.
    if (mod(phiagvrot,2*pi) ~= 0)
        centrum = (AGVpolygon(:,1)+AGVpolygon(:,2))/2;
        AGVpolygon = polygonrot(AGVpolygon,phiagvrot,centrum);% Az AGV pontjainak phiagvrot-vel elforgatása pos_agv körül.
        pos_det = polygonrot(pos_det,phiagvrot,centrum);% Az érzékelök pontjainak phiagvrot-vel elforgatása pos_agv körül.
        pos_agv = polygonrot(pos_agv,phiagvrot,centrum);% Az új AGV-pozíció az elforgatás után.
        phi_agv = phi_agv + phiagvrot;
        phi_agv = sign(phi_agv)*mod(abs(phi_agv),2*pi);% Az AGV új szöghelyzete.
    end
    %----------------------------------------------------------------------
    % 2. szakasz: AGV transzlációja.
    if (mod(phiagvrot,2*pi) ~= 0) % Ha nincs mivel elforgatni, akkor csak az aktuális irányba léptetni kell.
        phi = phi_agv + phiagvrot;
    else
        phi = phi_agv;
    end
    delta_r = [lepeskoz*cos(phi);lepeskoz*sin(phi);0];% Eltolás-vektor.
    uzenet = ['delta_r = [',num2str(delta_r(1,1)),';',num2str(delta_r(2,1)),';',num2str(delta_r(3,1)),']'];
    disp(uzenet);
    AGVpolygon = polygonmove(AGVpolygon,delta_r);% Új AGV koordináták az eltolás után.
    pos_det = polygonmove(pos_det,delta_r);% Új érzékelö koordináták az eltolás után.
    pos_agv = polygonmove(pos_agv,delta_r);% Az új AGV-pozíció az eltolás után.
    %----------------------------------------------------------------------
end
uzenet = ['AGV position: x = ',num2str(pos_agv(1,1)),', y = ',num2str(pos_agv(2,1))];
disp(uzenet);
end