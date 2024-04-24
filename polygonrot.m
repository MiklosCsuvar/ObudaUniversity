function xyz = polygonrot(xyz,phi,center)
%--------------------------------------------------------------------------
% Verzi�: 2.0
% A f�ggv�ny c�lja:
% elforgatni az xyz oszlopvektorokkal megadott soksz�get
% az xy s�kban phi sz�ggel,
% a 'center' k�z�ppont k�r�l.
% xyz: Az elforgatand� soksz�g pontjainak (3, m) t�mbje.
% phi: Az elforgat�s sz�ge.
%--------------------------------------------------------------------------
% Hibaellen�rz�s: L�teznek a bemeneti v�ltoz�k?
if(exist('xyz')==1 && exist('phi')==1 && exist('center')==1)
%     disp('Minden bemeneti argumentum l�tezik.');
%     disp('xyz:');disp(xyz);
%     disp('phi:');disp(phi);
%     disp('center:');disp(center);
else
    if (exist('xyz')~=1)
        disp('Error in polygonrot.m: polygonrot(xyz,phi,center) arg1 hi�nyzik.');
    end
    if (exist('phi')~=1)
        disp('Error in polygonrot.m: polygonrot(xyz,phi,center) arg2 hi�nyzik.');
    end
    if (exist('center')~=1)
        disp('Error in polygonrot.m: polygonrot(xyz,phi,center) arg3 hi�nyzik.');
    end
end
%--------------------------------------------------------------------------
% Rotation angle phi is trunkated below 2*pi: 0 <= phi <= 2*pi.
% disp('phi:');disp(phi);
elojel = sign(phi);
phi = mod(abs(phi),2*pi);
phi = elojel*phi;
% Az �j koordin�t�k kisz�m�t�sa a r�gib?l oszlopr�l oszlopra.
% A forgat�s m�trixa.
Rot = [cos(phi) (-1)*sin(phi) 0; sin(phi) cos(phi) 0; 0 0 1];
%--------------------------------------------------------------------------
% Hibaellen�rz�s: A bels� v�ltoz� megfelel�?L�teznek a bemeneti v�ltoz�k?
% disp('Rot:');disp(Rot);
% if (exist('Rot') ~= 1)
%     Rot = [1 0; 0 1];
%     disp('Rot:');disp(Rot);
% end
%--------------------------------------------------------------------------
% Az �j koordin�t�k kisz�m�t�sa a r�gib?l oszlopr�l oszlopra.
dimvector_xyz = size(xyz);
% xyz_row = dimvector_xyz(1);
xyz_col = dimvector_xyz(2);
%--------------------------------------------------------------------------
% Hibaellen�rz�s: Megfelel�ek a bels� v�ltozo�k?
% dimvector_Rot = size(Rot);
% Rot_row = dimvector_Rot(1);
% Rot_col = dimvector_Rot(2);
% 
% if (Rot_col ~= xyz_row)
%     disp('Rot_col ~= xyz_row');
%     disp('Rot_row:');disp(Rot_row);
%     disp('Rot_col:');disp(Rot_col);
%     disp('xyz_row:');disp(xyz_row);
%     disp('xyz_col:');disp(xyz_col);
%     disp('Rot:');disp(Rot);
%     disp('xyz:');disp(xyz);
% end
%--------------------------------------------------------------------------
%disp('xyz bemenet:');disp(xyz);
for j = 1:xyz_col
    xyz(:,j) = xyz(:,j)-center;
    xyz(:,j) = Rot*xyz(:,j);
    xyz(:,j) = xyz(:,j)+center;
end
%disp('xyz kimenet:');disp(xyz);
end