function [polygonbase] = agvcalc()
%--------------------------------------------------------------------------
% Verzi�: 2.0
% A f�ggv�ny c�lja:
% 1.Kisz�molni az alapeseti - nem elforgatott - AGV pontjait.
% 2. A '0' v�ltozatban a korm�nyzott kerekek vannak h�tul, bolyg�ker�k el�l.
% Az '1'-ben ford�tva.
% 3. A detektorok el�l maradnak. Az origo a detektorokat �sszekot� szakasz
% felez�pontja.
%--------------------------------------------------------------------------
global pos_agv d_kerekek l_agv AGVverzio height_det
h = height_det;
%--------------------------------------------------------------------------
%            Bal ker�k.                                     Jobb ker�k.                                      Bolyg�ker�k (orig�).
polygon0 = [[pos_agv(1,1)-d_kerekek/2;pos_agv(2,1)-l_agv;h],[pos_agv(1,1)+d_kerekek/2;pos_agv(2,1)-l_agv;h],[pos_agv(1,1)+0;pos_agv(2,1)+0;h]];
polygon0 = [polygon0,polygon0(:,1)];
%
%         W
%         |
%     D---0---D
%        /|\
%       /   \
%      /     \
%     /       \
%    /         \
%   /           \
% |/             \|
% W---------------W
% |               |
%
%            Bal ker�k.                                  Jobb ker�k.                                 Bolyg�ker�k.
polygon1 = [[pos_agv(1,1)-d_kerekek/2;pos_agv(2,1)+0;h],[pos_agv(1,1)+d_kerekek/2;pos_agv(2,1)+0;h],[pos_agv(1,1);0-l_agv;h]];
polygon1 = [polygon1,polygon1(:,1)];
%
% |               |
% W---D---0---D---W
% |\             /|
%   \           / 
%    \         /
%     \       /
%      \     /
%       \   /
%        \|/
%         W
%         |
%         
if (AGVverzio == 0)
    polygonbase = polygon0;
else
    polygonbase = polygon1;
end
end