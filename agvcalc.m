function [polygonbase] = agvcalc()
%--------------------------------------------------------------------------
% Verzió: 2.0
% A függvény célja:
% 1.Kiszámolni az alapeseti - nem elforgatott - AGV pontjait.
% 2. A '0' változatban a kormányzott kerekek vannak hátul, bolygókerék elöl.
% Az '1'-ben fordítva.
% 3. A detektorok elöl maradnak. Az origo a detektorokat összekotö szakasz
% felezöpontja.
%--------------------------------------------------------------------------
global pos_agv d_kerekek l_agv AGVverzio height_det
h = height_det;
%--------------------------------------------------------------------------
%            Bal kerék.                                     Jobb kerék.                                      Bolygókerék (origó).
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
%            Bal kerék.                                  Jobb kerék.                                 Bolygókerék.
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