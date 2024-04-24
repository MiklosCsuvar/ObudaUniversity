function forgir = rotationdirection(vec1,vec2)
%--------------------------------------------------------------------------
% Verzió: 3.0
% A függvény célja:
% Meghatározni az egyenesvonal vagy görbe gforgási irányát
% (x_i+1,y_i+1) és (x_i+2,y_i+2) között a
% (x_i+1,y_i+1) és (x_i+2,y_i+2) közötti szakaszhoz képest.
% a forgásirány értéke:
% -1, ha negatív szöggel fordul el,
%  0, ha nem fordul el,
% +1, ha pozíitív szöggel fordul el
% a késöbbi nyomvonalszakasz.
% Forgásirány-meghatározás
% Probléma: Nem tudom kezelni a helyzetet, amikor a szög +pi vagy -pi,
% mert ezek a szögek azonosak a nézöponttól függöen.
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