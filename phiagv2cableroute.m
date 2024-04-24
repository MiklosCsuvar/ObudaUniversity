function phiagv2cableroute()
%--------------------------------------------------------------------------
% Verrzi�: 2.1
% A f�ggv�ny c�lja:
% Az �rz�kel�k elhelyezked�se �s az AGV-hez legk�zelebbi p�lyapont alapj�n
% kisz�m�tani az AGV halad�si ir�nya �s a p�lya �ltal bez�rt sz�get [rad].
%--------------------------------------------------------------------------
global phi_agv2cableroute pos_det cableroute idxcur_agv haladasiirany
global width_cableroute detektorszam
%--------------------------------------------------------------------------
% A sz�ls� �rz�kel�k k�z�tti vektor:
v_db2dj = pos_det(:,detektorszam)-pos_det(:,1);
% A bal oldali �rz�kel�b�l a jobb oldaliba mutat� vektor.
%--------------------------------------------------------------------------
% Az AGV halad�si ir�nyvektora:
index1 = indexkorrekcio(idxcur_agv+haladasiirany,1,width_cableroute);
index2 = indexkorrekcio(idxcur_agv-haladasiirany,1,width_cableroute);
v_agvdir = cableroute(:,index1)-cableroute(:,index2);
%--------------------------------------------------------------------------
% Az AGV halad�si ir�nyvektora �s a p�lya �ltal bez�rt sz�g (rad):
phi_agv2cableroute = pi/2 - acos((v_db2dj'*v_agvdir)/(norm(v_db2dj,2)*norm(v_agvdir,2)));
end