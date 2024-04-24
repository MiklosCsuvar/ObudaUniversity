function kimenet = nullvektorfv(v)
%--------------------------------------------------------------------------
% Verzi�: 2.0
% A f�ggv�ny c�lja:
% A bemeneti vektorral egyez� sor �s oszlopsz�m� nullvektort el��ll�tani.
% Ez�rt
% 1. Ellen�rzi, hogy a bemenet val�ban vektor-e.
% 2. Ha nem, akkor hiba�zenetet ad.
% 3. Ha igen, a bemenet alapj�n k�pzi a kimenetet.
%--------------------------------------------------------------------------
dim = size(v);
if (dim(1) > 1 && dim(2) > 1) % Ellen�rzi: A bemenet vektor?
    % 1. szakasz
    disp('Error in nullvektorfv.m: A bemeneti t�mb nem vektor.')
else
    % 2. szakasz
    kimenet = zeros(dim(1),dim(2),'double');
end
end