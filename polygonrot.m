function xyz = polygonrot(xyz,phi,center)
%--------------------------------------------------------------------------
% Verzió: 2.0
% A függvény célja:
% elforgatni az xyz oszlopvektorokkal megadott sokszöget
% az xy síkban phi szöggel,
% a 'center' középpont körül.
% xyz: Az elforgatandó sokszög pontjainak (3, m) tömbje.
% phi: Az elforgatás szöge.
%--------------------------------------------------------------------------
% Hibaellenörzés: Léteznek a bemeneti változók?
if(exist('xyz')==1 && exist('phi')==1 && exist('center')==1)
%     disp('Minden bemeneti argumentum létezik.');
%     disp('xyz:');disp(xyz);
%     disp('phi:');disp(phi);
%     disp('center:');disp(center);
else
    if (exist('xyz')~=1)
        disp('Error in polygonrot.m: polygonrot(xyz,phi,center) arg1 hiányzik.');
    end
    if (exist('phi')~=1)
        disp('Error in polygonrot.m: polygonrot(xyz,phi,center) arg2 hiányzik.');
    end
    if (exist('center')~=1)
        disp('Error in polygonrot.m: polygonrot(xyz,phi,center) arg3 hiányzik.');
    end
end
%--------------------------------------------------------------------------
% Rotation angle phi is trunkated below 2*pi: 0 <= phi <= 2*pi.
% disp('phi:');disp(phi);
elojel = sign(phi);
phi = mod(abs(phi),2*pi);
phi = elojel*phi;
% Az új koordináták kiszámítása a régib?l oszlopról oszlopra.
% A forgatás mátrixa.
Rot = [cos(phi) (-1)*sin(phi) 0; sin(phi) cos(phi) 0; 0 0 1];
%--------------------------------------------------------------------------
% Hibaellenörzés: A belsö változó megfelelö?Léteznek a bemeneti változók?
% disp('Rot:');disp(Rot);
% if (exist('Rot') ~= 1)
%     Rot = [1 0; 0 1];
%     disp('Rot:');disp(Rot);
% end
%--------------------------------------------------------------------------
% Az új koordináták kiszámítása a régib?l oszlopról oszlopra.
dimvector_xyz = size(xyz);
% xyz_row = dimvector_xyz(1);
xyz_col = dimvector_xyz(2);
%--------------------------------------------------------------------------
% Hibaellenörzés: Megfelelöek a belsö változoók?
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