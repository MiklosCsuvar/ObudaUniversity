% simulation
%--------------------------------------------------------------------------
% Verzió: 3.0
% A függvény célja:
% 1. Elökészíteni egy sokszöget (az AGV-t) és inicializálni.
% 2. Megpróbálni az AGV-t a nyomvonal mentén mozgatni.
% 3. A képfájl lezárása. Configuration.m más néven elmentése.
%--------------------------------------------------------------------------
% Szakasz 1: Inicializálás
% Az ábrázolás alapállapotba helyezése.
close all;% Minden ábra és plottolás leállítása.
clear all;% Minden adat törlése a memóriából.
%--------------------------------------------------------------------------
global mozgas filmmaking writerObj parametermentesfajlba siker
%--------------------------------------------------------------------------
configuration; % A kézzel szerkesztendö paraméterek beolvasása.
automatedinitialisation(); % Paraméterek kezdöértékének automatikus kiszámítása a kézzel
% bevitt paraméterek alapján.
%--------------------------------------------------------------------------
% Szakasz 2: AGV kábelnyomvonal mentén mozgása
if (mozgas == 1)
    agvmoving();
end
%--------------------------------------------------------------------------
% Szakasz 3: Videofájl lezárása.
if (filmmaking == 1)
    close(writerObj);
end
if (parametermentesfajlba == 1)
    fclose('all');
end
if (siker == 1)
    disp('A szimuláció sikeresen befejezödött.');
end
disp('main.m stops.')
disp('****************************************************************************************************')