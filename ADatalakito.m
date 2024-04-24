function [kimenet] = ADatalakito(bemenet, felbontas, limit, AvagyD)
%--------------------------------------------------------------------------
% Verzió: 1.0
% A függvény célja:
% - Digitalizálni
% - az analóg bemenetet
% - a felbontás (bit) mértéke szerint, elöjelhelyesen (tkp. limit + 1 bit-es a felbontás)
% - a limit felsö feszültséghatárig.
% - Ha az AvagyD 'b', a kimenet szám, ha 'd' a kimenet feszültség.
%-------------------------------------------------------------------------- 
elojel = sign(bemenet);
bemenet = abs(bemenet);

if (bemenet > limit)
    bemenet = limit;
end

kimenet = 0;
tmp = 0;
while (tmp < felbontas)
    tmp = tmp + 1;
    digit = 0;
    limithanyad = limit/(2^tmp);
    if (bemenet >= limithanyad)
        digit = 1;
    end
    kimenet = 2*kimenet + digit;
    bemenet = bemenet - digit*limithanyad;
end
if (AvagyD == 'd')
    kimenet = limit*kimenet/(2^felbontas-1);
end
kimenet = kimenet*elojel;
% uzenet = ['kimenet = ', num2str(kimenet)];
% disp(uzenet);
end