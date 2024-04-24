function [gorbuletisugar] = gorbuletisugarfv()
%--------------------------------------------------------------------------
% Verzi�: 3.0
% A f�ggv�ny c�lja:
% 0. Param�terek beolvas�sa �s v�ltoz�k deklar�l�sa
% 1. A g�rb�leti sug�r kisz�m�t�sa.
%--------------------------------------------------------------------------
% 0. szakasz
global vbal vjobb d_kerekek
%--------------------------------------------------------------------------
% 1. szajkasz: G�rb�leti sug�r.
gorbuletisugar = abs(-(d_kerekek/2)*(vbal+vjobb)/(vbal-vjobb));
%--------------------------------------------------------------------------
end