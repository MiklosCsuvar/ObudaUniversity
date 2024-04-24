function biotsavartpontokszamitasa()
%--------------------------------------------------------------------------
% Verzió: 1.0
% A függvény célja:
% Az egyenes szakaszokhoz tartozó - a görbevonalak törtvonalas közelítését
% ide nem számolva - pontok elhagyásával elöállítani azt a ponthalmazt,
% ami alapján a kábel mágneses indukciós nyomvonala - kevesebb pontból - 
% gyorsabban kiszámolható.
%--------------------------------------------------------------------------
global path cableroute
global width_cableroute width_path gorbeseg
global biotsavartpontokindexei biotsavartpontok
%--------------------------------------------------------------------------
tmp = 0;
for i = 1:width_cableroute
    if (gorbeseg(i) == 1)
        tmp = tmp + 1;
    end
end
uzenet = ['Görbevonali pontok [db]: ', num2str(tmp)];
disp(uzenet);
if (tmp > 1) % Ha 1-nél több görbületi pont van, akkor:
    biotsavartpontokindexei = zeros(1,tmp,'int32'); % a Bios-Savart képlethez helyet foglal nekik,
    j = 1; % beáll az 1. tömbelemre.
    for i = 1:width_cableroute % végigvizsgálja az összes nyomvonali pontot, és
        if (gorbeseg(i) == 1) % ha a pont kanyarhoz tartozik, akkor
            biotsavartpontokindexei(1,j) = i; % az indexét elmenti a tömbbe, és
            j = j + 1; % a következö tömbbelemre áll.
        end
    end    
%     vektoregyenloseg1 = (path(1:3,1) == path(1:3,width_path)); % Megállapítja
%     vektoregyenloseg2 = min(vektoregyenloseg1); %  a görbe 1. és utolsó pontjának egyezését.
% %     if(vektoregyenloseg2 == 1) % Ha a pontok egyeznek (azaz zárt görbéröl van szó), akkor:
% %         biotsavartpontokindexei = horzcat(biotsavartpontokindexei,biotsavartpontokindexei(1,1)); % Ti. ezzel lesznek a Biot-Savart-járulékszámítás
% %         % szempontjából zárt hurok elemei a rögzített görbeszakasz pontok
% %         % is, ha az 1. görbeszakasz elött vagy az utolsó után egyenesszakasz jönne.
% %         % Ha véletlenül ugyanaz a pont lenne, mint a megelözö, akkor a járuléka amúgy is 0.
% %         disp('IF ágat végeztem.');
% %     else % Különben (amikor a pontok nem egyeznek (azaz nyílt görbéröl van szó)) a kanyarpontok:
% %         biotsavartpontokindexei = horzcat(1,biotsavartpontokindexei); % elé beszúrja az 1. egyenesszakasz 1. pontját, és
% %         biotsavartpontokindexei = horzcat(biotsavartpontokindexei,width_cableroute); % mögé beszúrja a kábel nyomvonalának
% %         % utolsó pontját, ami elvileg az utolsó egyenesszakasz utolsó pontja.
% %         disp('ELSE ágat végeztem.');        
% %     end
%     if(vektoregyenloseg2 == 0) % Ha a pontok nem egyeznek (azaz nyílt görbéröl van szó), akkor:
    if(min(path(1:3,1) == path(1:3,width_path))) % Ha a pontok nem egyeznek (azaz nyílt görbéröl van szó), akkor:
        biotsavartpontokindexei = horzcat(1,biotsavartpontokindexei); % elé beszúrja az 1. egyenesszakasz 1. pontját, és
        biotsavartpontokindexei = horzcat(biotsavartpontokindexei,width_cableroute); % mögé beszúrja a kábel nyomvonalának
        % utolsó pontját, ami elvileg az utolsó egyenesszakasz utolsó pontja.
    end        
else %különben (amikor nincsenek kanyarok, csak egyenes szakaszok),
    biotsavartpontokindexei = zeros(1,width_path,'int32'); % helyet foglal nekik,
    for i = 1:width_path % vizsgálatot indít a teljes tervezett nyomvonalra,
        for j = 1:width_cableroute % és annak minden valós pontjára,
            tmp1 = (cableroute(1:3,j) == path(1:3,i)); % és ahol a kettö egyezik,
            tmp2 = min(tmp1);
            if(tmp2 == 1)
                biotsavartpontokindexei(1,i) = j; % annak indexét elmenti a tömbbe.
            end
        end
    end
end
dim = size(biotsavartpontokindexei);
width_biotsavartpontok = dim(2);
biotsavartpontok = zeros(3,width_biotsavartpontok,'double');
for i = 1:width_biotsavartpontok
    uzenet = ['biotsavartpontokindexei(1,i)'];
    disp(uzenet);
    uzenet = [biotsavartpontokindexei(1,i)];
    disp(uzenet);
    biotsavartpontok(1:3,i) = cableroute(1:3,biotsavartpontokindexei(1,i));
end
end