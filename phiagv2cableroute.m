function phiagv2cableroute()
%--------------------------------------------------------------------------
% Verrzió: 2.1
% A függvény célja:
% Az érzékelök elhelyezkedése és az AGV-hez legközelebbi pályapont alapján
% kiszámítani az AGV haladási iránya és a pálya által bezárt szöget [rad].
%--------------------------------------------------------------------------
global phi_agv2cableroute pos_det cableroute idxcur_agv haladasiirany
global width_cableroute detektorszam
%--------------------------------------------------------------------------
% A szélsö érzékelök közötti vektor:
v_db2dj = pos_det(:,detektorszam)-pos_det(:,1);
% A bal oldali érzékelöböl a jobb oldaliba mutató vektor.
%--------------------------------------------------------------------------
% Az AGV haladási irányvektora:
index1 = indexkorrekcio(idxcur_agv+haladasiirany,1,width_cableroute);
index2 = indexkorrekcio(idxcur_agv-haladasiirany,1,width_cableroute);
v_agvdir = cableroute(:,index1)-cableroute(:,index2);
%--------------------------------------------------------------------------
% Az AGV haladási irányvektora és a pálya által bezárt szög (rad):
phi_agv2cableroute = pi/2 - acos((v_db2dj'*v_agvdir)/(norm(v_db2dj,2)*norm(v_agvdir,2)));
end