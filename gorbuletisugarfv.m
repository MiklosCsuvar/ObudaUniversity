function [gorbuletisugar] = gorbuletisugarfv()
%--------------------------------------------------------------------------
% Verzió: 3.0
% A függvény célja:
% 0. Paraméterek beolvasása és változók deklarálása
% 1. A görbületi sugár kiszámítása.
%--------------------------------------------------------------------------
% 0. szakasz
global vbal vjobb d_kerekek
%--------------------------------------------------------------------------
% 1. szajkasz: Görbületi sugár.
gorbuletisugar = abs(-(d_kerekek/2)*(vbal+vjobb)/(vbal-vjobb));
%--------------------------------------------------------------------------
end