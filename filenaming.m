function tmpfilelocation = filenaming(filelocation,filename)
%--------------------------------------------------------------------------
% Verzi�: 2.0
% A f�ggv�ny c�lja:
% Automatikus f�jln�vel��ll�t�s.
% A blokkok az al�bbiak:
% 1. filelocation (path): Valami 'C:/Documents/...'-szer�.
% filename: A t�nyleges f�jln�v alapja, pl. 'avgmoving'.
% 2. A blokkokat �sszef�zni.
%--------------------------------------------------------------------------
tmpfilelocation = strcat(filelocation,filename,'_');
c = clock; % Id� (�v, h�nap, nap, �ra, perc, m�sodperc).
c = fix(c);% Rounds above time towards zero.
for szoindex = 1:6 % T�puskonverzi: id� -> sz�veg.
    % 1. �v, 2. h�nap, 3. nap, 4. �ra, 5. perc, 6. m�sodperc a szimul�ci� kezdetekor.
    tmpint = cast(c(szoindex), 'uint32');
    if(c(szoindex)<10)
        tmpfilelocation = strcat(tmpfilelocation,'0',int2str(tmpint));% �talak�t�s: '6' -> '06' stb.
    else
        tmpfilelocation = strcat(tmpfilelocation,int2str(tmpint));
    end
end
end