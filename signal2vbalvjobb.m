function signal2vbalvjobb()
%--------------------------------------------------------------------------
% Verzi�: 1.0
% A f�ggv�ny c�lja:
% Az �rz�kel�k jele alapj�n kisz�molni a bal �s a jobb ker�k sebess�g�t.
% A kor�bbi verzi�kat nem dobtam ki, hanem switch-case-szel benne hagytam a
% f�ggv�nyben.
%--------------------------------------------------------------------------
global signal_diff nullakorulitures vmax vbal vjobb signal_max
global vtomb vtomb_meret deltavbalvjobbtomb deltavbalvjobboszlop deltavbalvjobboszlopsorszam
global signal_det signal2sebesseg_verzio
vtmp = 0;
deltav = 0;
%--------------------------------------------------------------------------
% uzenet = ['signal2vbalvjobb.m:'];
% disp(uzenet);
%--------------------------------------------------------------------------
switch signal2sebesseg_verzio
    case '1-2'
        % % Ebben a modellben:
        % % A sebess�gek a Sanyi �ltal megadottak lehetnek, �S
        % % a sebess�gek azonos el�jel�ek, �S
        % % kerekenk�nt szabadon vlaszthat�k.
        % 1. verzi�:
        % vtomb = [1/2.5;1/3;1/4;0]; % Az AGV lehets�ges sbess�gei [m/s].
        % 2. verzi�:
        % vtomb = (1/8)*(1/2.5)*[8;7;6;5;4;3;2;1;0]; % Az AGV lehets�ges sbess�gei [m/s].
        % Ilyen sebess�ggel �s 32 bites t�r�ssel nagyon sz�pen megy. 60 s alatt
        % 3,25 k�r.
        vtmp = -vmax*signal_diff/signal_max;
        uzenet = ['vtmp = -vmax*signal_diff/signal_max = ', num2str(-vmax), ' * ', num2str(signal_diff), '/', num2str(signal_max), ' = ', num2str(vtmp)];
        disp(uzenet);
        %
        if (vtmp == 0 || abs(signal_diff) <= nullakorulitures) % El�re megy.
            vbal = vmax;
            vjobb = vmax;
            if (vtmp == 0)
                disp('vtmp = 0');
            end
            if (abs(signal_diff) <= nullakorulitures)
                uzenet = ['abs(signal_diff) = ',num2str(abs(signal_diff)),' <= nullakorulitures = ',num2str(nullakorulitures)];
                disp(uzenet);
            end
        else
            % disp('Else �gba l�pek.')
            if(vtmp > 0)
                disp('vtmp > 0');
                i = 1;
                while(deltavbalvjobboszlop(i,1) > 0)
                    if(vtmp <= deltavbalvjobboszlop(i,1) && vtmp > deltavbalvjobboszlop(i+1,1))
                        deltav = deltavbalvjobboszlop(i,1);
                        break;
                    end
                    i = i + 1;
                end
            end
            %
            if(vtmp < 0)
                disp('vtmp < 0');
                i = deltavbalvjobboszlopsorszam;
                while(deltavbalvjobboszlop(i,1) < 0)
                    if(vtmp >= deltavbalvjobboszlop(i,1) && vtmp < deltavbalvjobboszlop(i-1,1))
                        deltav = deltavbalvjobboszlop(i,1);
                        break;
                    end
                    i = i - 1;
                end 
            end
            uzenet = ['deltav = ', num2str(deltav)];
            disp(uzenet);
            vbal = vmax;
            vjobb = vmax;    
            for i = vtomb_meret-1:-1:1
                for j = 1:1:(vtomb_meret-i)
                    sor = i;
                    oszlop = i+j;
                    for k = 0:1
                        if (k == 1)
                            tmp = sor;
                            sor = oszlop;
                            oszlop = tmp;
                        end
                        uzenet = ['i = ', num2str(sor), ', j = ', num2str(oszlop), ', deltavbalvjobbtomb = ',num2str(deltavbalvjobbtomb(sor,oszlop))];
                        disp(uzenet);
                        if (deltav == deltavbalvjobbtomb(sor,oszlop))
                            vbal = vtomb(sor,1);
                            vjobb = vtomb(oszlop,1);
                            uzenet = ['Megvan: i = ', num2str(sor), ', j = ', num2str(oszlop), ', deltavbalvjobbtomb = ',num2str(deltavbalvjobbtomb(sor,oszlop))];
                            disp(uzenet);
                        end
                    end
                    if (~(vbal == vmax && vjobb == vmax))
                        break;
                    end
                end
                if (~(vbal == vmax && vjobb == vmax))
                    break;
                end
            end
        end
    %----------------------------------------------------------------------
    case '2.5'
        % 2.5. verzi�: A kanyarok felzab�lj�k az id�t.
        vtmp = -vmax*signal_diff/signal_max;
        if (vtmp > 0)
            vbal = vtmp;
            vjobb = 0;
        end
        if (vtmp == 0)
            vbal = vmax;
            vjobb = vmax;
        end

        if (vtmp < 0)
            vbal = 0;
            vjobb = -vtmp;
        end
    %----------------------------------------------------------------------
    case '3'
        % Ebben a modellben:
        % A sebess�gek k�l�nbs�ge a szab�lyoz�jellel egyenesen ar�nyos, �S
        % a sebess�gek azonos el�jel�ek.
        % A modell alapvet�en a vtomb = [1/2.5;1/3;1/4;0] sebess�gek
        % felhaszn�l�s�ra k�sz�lt.        
        % 3. verzi�:
        vtmp = (vmax/2)*signal_diff/signal_max;
        vtmp2 = vmax/2;
        uzenet = ['vtmp = vmax*signal_diff/signal_max = ', num2str(vmax), ' * ', num2str(signal_diff), '/', num2str(signal_max), ' = ', num2str(vtmp)];
        disp(uzenet);
        %
        if (abs(signal_diff)<=nullakorulitures) % El�re megy.
            vbal = vmax;
            vjobb = vmax;
            uzenet = ['abs(signal_diff) = ',num2str(abs(signal_diff)),' <= nullakorulitures = ',num2str(nullakorulitures)];
            disp(uzenet);
        else
            vbal = vtmp2 - vtmp;
            vjobb = vtmp2 + vtmp;
        end
    %----------------------------------------------------------------------
    case '4'
        % Ebben a modellben:
        % A sebess�gek k�l�nbs�ge a szab�lyoz�jellel egyenesen ar�nyos, �S
        % a sebess�gek azonos el�jel�ek.
        % A modell alapvet�en a vtomb = [1/2.5;1/3;1/4;0] sebess�gek
        % felhaszn�l�s�ra k�sz�lt.
        % 4. verzi�:
        vtmp = 2*(vmax/2)*signal_diff/signal_max;
        vtmp2 = vmax/2;
        uzenet = ['vtmp = vmax*signal_diff/signal_max = ', num2str(vmax), ' * ', num2str(signal_diff), '/', num2str(signal_max), ' = ', num2str(vtmp)];
        disp(uzenet);
        %
        if (abs(signal_diff)<=nullakorulitures) % El�re megy.
            vbal = vmax;
            vjobb = vmax;
            uzenet = ['abs(signal_diff) = ',num2str(abs(signal_diff)),' <= nullakorulitures = ',num2str(nullakorulitures)];
            disp(uzenet);
        else
            vbal = vtmp2 - vtmp;
            vjobb = vtmp2 + vtmp;
        end
    %----------------------------------------------------------------------
    case '5'
        % Ebben a modellben:
        % A sebess�gek k�l�nbs�ge a szab�lyoz�jellel egyenesen ar�nyos, �S
        % a sebess�gek azonos el�jel�ek.
        % A modell alapvet�en a vtomb = [1/2.5;1/3;1/4;0] sebess�gek
        % felhaszn�l�s�ra k�sz�lt.
        % 5. verzi�:
        vtmp = 4*(vmax/2)*signal_diff/signal_max;
        vtmp2 = vmax/2;
        uzenet = ['vtmp = vmax*signal_diff/signal_max = ', num2str(vmax), ' * ', num2str(signal_diff), '/', num2str(signal_max), ' = ', num2str(vtmp)];
        disp(uzenet);
        %
        if (abs(signal_diff)<=nullakorulitures) % El�re megy.
            vbal = vmax;
            vjobb = vmax;
            uzenet = ['abs(signal_diff) = ',num2str(abs(signal_diff)),' <= nullakorulitures = ',num2str(nullakorulitures)];
            disp(uzenet);
        else
            vbal = vtmp2 - vtmp;
            vjobb = vtmp2 + vtmp;
        end        
        %----------------------------------------------------------------------
    case '6-7'
        % Ebben a modellben:
        % A sebess�gek a szab�lyoz�jellel egyenesen ar�nyosak, �S
        % ellent�tes el�jel�ek.
        % 6. verzi�
        % vtomb = [1/2.5;1/3;1/4;0]; % Az AGV lehets�ges sbess�gei [m/s].
        % 7. verzi�
        % vtomb = 4*[1/2.5;1/3;1/4;0]; % Az AGV lehets�ges sbess�gei [m/s].
        vtomb = 4*[1/2.5;1/3;1/4;0]; % Az AGV lehets�ges sbess�gei [m/s].
        if (abs(signal_diff) <= nullakorulitures) % El�re megy.
            vbal = vmax;
            vjobb = vmax;
            uzenet = ['abs(signal_diff) = ',num2str(abs(signal_diff)),' <= nullakorulitures = ',num2str(nullakorulitures)];
            disp(uzenet);
        else
            vtmp = vmax*signal_diff/signal_max;
            uzenet = ['vtmp = vmax*signal_diff/signal_max = ', num2str(vmax), ' * ', num2str(signal_diff), '/', num2str(signal_max), ' = ', num2str(vtmp)];
            disp(uzenet);
            vbal = -vtmp;
            vjobb = -vbal;
        end
    %----------------------------------------------------------------------
    case '8'
        % 8. verzi�: B vektorjelleg�nek figyelembe v�tele. Szab�lyoz�s abs(BZ)
        % alapj�n.
        if (abs(signal_det(1,1)) >= abs(signal_det(1,2)) && abs(signal_det(1,2)) <= abs(signal_det(1,3)))
            vbal = vmax;
            vjobb = vmax;
        else
            vbal = vmax*abs(signal_det(1,2))/abs(signal_det(1,1));
            vjobb = vmax*abs(signal_det(1,2))/abs(signal_det(1,3));
        end
    otherwise
        disp('Switch case otherwise �ga. Niincs defini�lva.');
end
uzenet = ['vbal = ', num2str(vbal), ', vjobb = ', num2str(vjobb)];
disp(uzenet);
end