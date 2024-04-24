function erzekelok = detcalc()
%--------------------------------------------------------------------------
% Verzió: 1.0
% A függvény célja:
% Kiszámolnia az érzékelök pozícióját a bemenetek alapján:
% - AGV pozíciója és
% - az érzékelök távolsága.
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