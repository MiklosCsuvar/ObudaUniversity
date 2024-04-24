function tmpfilelocation = filenaming(filelocation,filename)
%--------------------------------------------------------------------------
% Verzió: 2.0
% A függvény célja:
% Automatikus fájlnévelöállítás.
% A blokkok az alábbiak:
% 1. filelocation (path): Valami 'C:/Documents/...'-szerü.
% filename: A tényleges fájlnév alapja, pl. 'avgmoving'.
% 2. A blokkokat összefüzni.
%--------------------------------------------------------------------------
tmpfilelocation = strcat(filelocation,filename,'_');
c = clock; % Idö (év, hónap, nap, óra, perc, másodperc).
c = fix(c);% Rounds above time towards zero.
for szoindex = 1:6 % Típuskonverzi: idö -> szöveg.
    % 1. év, 2. hónap, 3. nap, 4. óra, 5. perc, 6. másodperc a szimuláció kezdetekor.
    tmpint = cast(c(szoindex), 'uint32');
    if(c(szoindex)<10)
        tmpfilelocation = strcat(tmpfilelocation,'0',int2str(tmpint));% Átalakítás: '6' -> '06' stb.
    else
        tmpfilelocation = strcat(tmpfilelocation,int2str(tmpint));
    end
end
end