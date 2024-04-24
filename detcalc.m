function erzekelok = detcalc()
%--------------------------------------------------------------------------
% Verzi�: 1.0
% A f�ggv�ny c�lja:
% Kisz�molnia az �rz�kel�k poz�ci�j�t a bemenetek alapj�n:
% - AGV poz�ci�ja �s
% - az �rz�kel�k t�vols�ga.
%--------------------------------------------------------------------------
global detektorszam pos_agv d_det height_det
% h = height_det;
% erzekelok = [[pos_agv(1,1)-d_det/2;pos_agv(2,1)+0;h],[pos_agv(1,1)+d_det/2;pos_agv(2,1)+0;h]];
erzekelok = zeros(3,detektorszam,'double');
%--------------------------------------------------------------------------
for i = 1:detektorszam
    erzekelok(1:3,i) = [pos_agv(1,1)-d_det/2+(i-1)*d_det/(detektorszam-1);pos_agv(2,1) + 0; height_det];
end
end