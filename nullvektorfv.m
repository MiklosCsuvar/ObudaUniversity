function kimenet = nullvektorfv(v)
%--------------------------------------------------------------------------
% Verzió: 2.0
% A függvény célja:
% A bemeneti vektorral egyezö sor és oszlopszámú nullvektort elöállítani.
% Ezért
% 1. Ellenörzi, hogy a bemenet valóban vektor-e.
% 2. Ha nem, akkor hibaüzenetet ad.
% 3. Ha igen, a bemenet alapján képzi a kimenetet.
%--------------------------------------------------------------------------
dim = size(v);
if (dim(1) > 1 && dim(2) > 1) % Ellenörzi: A bemenet vektor?
    % 1. szakasz
    disp('Error in nullvektorfv.m: A bemeneti tömb nem vektor.')
else
    % 2. szakasz
    kimenet = zeros(dim(1),dim(2),'double');
end
end