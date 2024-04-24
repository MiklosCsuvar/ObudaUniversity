% simulation
%--------------------------------------------------------------------------
% Verzi�: 3.0
% A f�ggv�ny c�lja:
% 1. El�k�sz�teni egy soksz�get (az AGV-t) �s inicializ�lni.
% 2. Megpr�b�lni az AGV-t a nyomvonal ment�n mozgatni.
% 3. A k�pf�jl lez�r�sa. Configuration.m m�s n�ven elment�se.
%--------------------------------------------------------------------------
% Szakasz 1: Inicializ�l�s
% Az �br�zol�s alap�llapotba helyez�se.
close all;% Minden �bra �s plottol�s le�ll�t�sa.
clear all;% Minden adat t�rl�se a mem�ri�b�l.
%--------------------------------------------------------------------------
global mozgas filmmaking writerObj parametermentesfajlba siker
%--------------------------------------------------------------------------
configuration; % A k�zzel szerkesztend� param�terek beolvas�sa.
automatedinitialisation(); % Param�terek kezd��rt�k�nek automatikus kisz�m�t�sa a k�zzel
% bevitt param�terek alapj�n.
%--------------------------------------------------------------------------
% Szakasz 2: AGV k�belnyomvonal ment�n mozg�sa
if (mozgas == 1)
    agvmoving();
end
%--------------------------------------------------------------------------
% Szakasz 3: Videof�jl lez�r�sa.
if (filmmaking == 1)
    close(writerObj);
end
if (parametermentesfajlba == 1)
    fclose('all');
end
if (siker == 1)
    disp('A szimul�ci� sikeresen befejez�d�tt.');
end
disp('main.m stops.')
disp('****************************************************************************************************')