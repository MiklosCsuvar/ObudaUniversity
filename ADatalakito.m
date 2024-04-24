function [kimenet] = ADatalakito(bemenet, felbontas, limit, AvagyD)
%--------------------------------------------------------------------------
% Verzi�: 1.0
% A f�ggv�ny c�lja:
% - Digitaliz�lni
% - az anal�g bemenetet
% - a felbont�s (bit) m�rt�ke szerint, el�jelhelyesen (tkp. limit + 1 bit-es a felbont�s)
% - a limit fels� fesz�lts�ghat�rig.
% - Ha az AvagyD 'b', a kimenet sz�m, ha 'd' a kimenet fesz�lts�g.
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