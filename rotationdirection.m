function forgir = rotationdirection(vec1,vec2)
%--------------------------------------------------------------------------
% Verzi�: 3.0
% A f�ggv�ny c�lja:
% Meghat�rozni az egyenesvonal vagy g�rbe gforg�si ir�ny�t
% (x_i+1,y_i+1) �s (x_i+2,y_i+2) k�z�tt a
% (x_i+1,y_i+1) �s (x_i+2,y_i+2) k�z�tti szakaszhoz k�pest.
% a forg�sir�ny �rt�ke:
% -1, ha negat�v sz�ggel fordul el,
%  0, ha nem fordul el,
% +1, ha poz�it�v sz�ggel fordul el
% a k�s�bbi nyomvonalszakasz.
% Forg�sir�ny-meghat�roz�s
% Probl�ma: Nem tudom kezelni a helyzetet, amikor a sz�g +pi vagy -pi,
% mert ezek a sz�gek azonosak a n�z�pontt�l f�gg�en.
%--------------------------------------------------------------------------
phi1 = acos(vec1'*[1;0;0]);
phi2 = acos(vec2'*[1;0;0]);

if (vec1(2,1)<0)
    phi1 = 2*pi-phi1;
end
if (vec2(2,1)<0)
    phi2 = 2*pi-phi2;
end

deltaphi=phi2-phi1;
%--------------------------------------------------------------------------
if (deltaphi == 0)
    forgir = 0;
elseif ((deltaphi > 0 && deltaphi < +pi) || (deltaphi < -pi && deltaphi > -2*pi))
    forgir = +1;
elseif ((deltaphi < 0 && deltaphi > -pi) || (deltaphi > +pi && deltaphi < +2*pi))
    forgir = -1;
else
    disp('Error [rotationdirection2]: phi = +pi or phi = -pi.');
end
end