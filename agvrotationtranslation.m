function agvrotationtranslation(lepeskoz,phiagvrot)
%--------------------------------------------------------------------------
% Verzi�: 9.0
% A f�ggv�ny c�lja:
% 0. Param�terek beolvas�sa �s v�ltoz�k deklar�l�sa.
% 1. Az AGV-t �s az �rz�kel�ket (azok koordin�t�it) a megadott sz�ggel elforgatja.
% 2. Eltolja az AGV-t �s az �rz�kel�ket (azok koordin�t�it) a megadott l�p�shosszal (lepeskoz).
%--------------------------------------------------------------------------
% 0. szakasz: Param�terek beolvas�sa �s v�ltoz�k deklar�l�sa
global delta_r AGVpolygon pos_det pos_agv phi_agv kilepes
%--------------------------------------------------------------------------
% disp('agvrotationtranslation.m:');
if (kilepes == 0)
    %----------------------------------------------------------------------
    % 1. szakasz: AGV elforgat�sa a k�z�ppont k�r�l.
    if (mod(phiagvrot,2*pi) ~= 0)
        centrum = (AGVpolygon(:,1)+AGVpolygon(:,2))/2;
        AGVpolygon = polygonrot(AGVpolygon,phiagvrot,centrum);% Az AGV pontjainak phiagvrot-vel elforgat�sa pos_agv k�r�l.
        pos_det = polygonrot(pos_det,phiagvrot,centrum);% Az �rz�kel�k pontjainak phiagvrot-vel elforgat�sa pos_agv k�r�l.
        pos_agv = polygonrot(pos_agv,phiagvrot,centrum);% Az �j AGV-poz�ci� az elforgat�s ut�n.
        phi_agv = phi_agv + phiagvrot;
        phi_agv = sign(phi_agv)*mod(abs(phi_agv),2*pi);% Az AGV �j sz�ghelyzete.
    end
    %----------------------------------------------------------------------
    % 2. szakasz: AGV transzl�ci�ja.
    if (mod(phiagvrot,2*pi) ~= 0) % Ha nincs mivel elforgatni, akkor csak az aktu�lis ir�nyba l�ptetni kell.
        phi = phi_agv + phiagvrot;
    else
        phi = phi_agv;
    end
    delta_r = [lepeskoz*cos(phi);lepeskoz*sin(phi);0];% Eltol�s-vektor.
    uzenet = ['delta_r = [',num2str(delta_r(1,1)),';',num2str(delta_r(2,1)),';',num2str(delta_r(3,1)),']'];
    disp(uzenet);
    AGVpolygon = polygonmove(AGVpolygon,delta_r);% �j AGV koordin�t�k az eltol�s ut�n.
    pos_det = polygonmove(pos_det,delta_r);% �j �rz�kel� koordin�t�k az eltol�s ut�n.
    pos_agv = polygonmove(pos_agv,delta_r);% Az �j AGV-poz�ci� az eltol�s ut�n.
    %----------------------------------------------------------------------
end
uzenet = ['AGV position: x = ',num2str(pos_agv(1,1)),', y = ',num2str(pos_agv(2,1))];
disp(uzenet);
end