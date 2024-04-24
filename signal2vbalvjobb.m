function signal2vbalvjobb()
%--------------------------------------------------------------------------
% Verzió: 1.0
% A függvény célja:
% Az érzékelök jele alapján kiszámolni a bal és a jobb kerék sebességét.
% A korábbi verziókat nem dobtam ki, hanem switch-case-szel benne hagytam a
% függvényben.
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
        % % A sebességek a Sanyi által megadottak lehetnek, ÉS
        % % a sebességek azonos elöjelüek, ÉS
        % % kerekenként szabadon vlaszthatók.
        % 1. verzió:
        % vtomb = [1/2.5;1/3;1/4;0]; % Az AGV lehetséges sbességei [m/s].
        % 2. verzió:
        % vtomb = (1/8)*(1/2.5)*[8;7;6;5;4;3;2;1;0]; % Az AGV lehetséges sbességei [m/s].
        % Ilyen sebességgel és 32 bites türéssel nagyon szépen megy. 60 s alatt
        % 3,25 kör.
        vtmp = -vmax*signal_diff/signal_max;
        uzenet = ['vtmp = -vmax*signal_diff/signal_max = ', num2str(-vmax), ' * ', num2str(signal_diff), '/', num2str(signal_max), ' = ', num2str(vtmp)];
        disp(uzenet);
        %
        if (vtmp == 0 || abs(signal_diff) <= nullakorulitures) % Elöre megy.
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
            % disp('Else ágba lépek.')
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
        % 2.5. verzió: A kanyarok felzabálják az idöt.
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
        % A sebességek különbsége a szabályozójellel egyenesen arányos, ÉS
        % a sebességek azonos elöjelüek.
        % A modell alapvetöen a vtomb = [1/2.5;1/3;1/4;0] sebességek
        % felhasználására készült.        
        % 3. verzió:
        vtmp = (vmax/2)*signal_diff/signal_max;
        vtmp2 = vmax/2;
        uzenet = ['vtmp = vmax*signal_diff/signal_max = ', num2str(vmax), ' * ', num2str(signal_diff), '/', num2str(signal_max), ' = ', num2str(vtmp)];
        disp(uzenet);
        %
        if (abs(signal_diff)<=nullakorulitures) % Elöre megy.
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
        % A sebességek különbsége a szabályozójellel egyenesen arányos, ÉS
        % a sebességek azonos elöjelüek.
        % A modell alapvetöen a vtomb = [1/2.5;1/3;1/4;0] sebességek
        % felhasználására készült.
        % 4. verzió:
        vtmp = 2*(vmax/2)*signal_diff/signal_max;
        vtmp2 = vmax/2;
        uzenet = ['vtmp = vmax*signal_diff/signal_max = ', num2str(vmax), ' * ', num2str(signal_diff), '/', num2str(signal_max), ' = ', num2str(vtmp)];
        disp(uzenet);
        %
        if (abs(signal_diff)<=nullakorulitures) % Elöre megy.
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
        % A sebességek különbsége a szabályozójellel egyenesen arányos, ÉS
        % a sebességek azonos elöjelüek.
        % A modell alapvetöen a vtomb = [1/2.5;1/3;1/4;0] sebességek
        % felhasználására készült.
        % 5. verzió:
        vtmp = 4*(vmax/2)*signal_diff/signal_max;
        vtmp2 = vmax/2;
        uzenet = ['vtmp = vmax*signal_diff/signal_max = ', num2str(vmax), ' * ', num2str(signal_diff), '/', num2str(signal_max), ' = ', num2str(vtmp)];
        disp(uzenet);
        %
        if (abs(signal_diff)<=nullakorulitures) % Elöre megy.
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
        % A sebességek a szabályozójellel egyenesen arányosak, ÉS
        % ellentétes elöjelüek.
        % 6. verzió
        % vtomb = [1/2.5;1/3;1/4;0]; % Az AGV lehetséges sbességei [m/s].
        % 7. verzió
        % vtomb = 4*[1/2.5;1/3;1/4;0]; % Az AGV lehetséges sbességei [m/s].
        vtomb = 4*[1/2.5;1/3;1/4;0]; % Az AGV lehetséges sbességei [m/s].
        if (abs(signal_diff) <= nullakorulitures) % Elöre megy.
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
        % 8. verzió: B vektorjellegének figyelembe vétele. Szabályozás abs(BZ)
        % alapján.
        if (abs(signal_det(1,1)) >= abs(signal_det(1,2)) && abs(signal_det(1,2)) <= abs(signal_det(1,3)))
            vbal = vmax;
            vjobb = vmax;
        else
            vbal = vmax*abs(signal_det(1,2))/abs(signal_det(1,1));
            vjobb = vmax*abs(signal_det(1,2))/abs(signal_det(1,3));
        end
    otherwise
        disp('Switch case otherwise ága. Niincs definiálva.');
end
uzenet = ['vbal = ', num2str(vbal), ', vjobb = ', num2str(vjobb)];
disp(uzenet);
end