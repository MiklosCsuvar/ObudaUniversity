function cabledistance2detindukcio_v3_0()
%--------------------------------------------------------------------------
% Verzió: 3.0
% A függvény célja:
% Kiszámolni az érzékelök áramvezet?t?l mért távolsága alapján az adott
% pont mágneses indukcióját (B [T]).
% A számítás módja függ a 'vektorvagyskalar' globális változótól.
%--------------------------------------------------------------------------
global detektorszam induction_det mu0 I aramirany haladasiirany
global tavolsag_det height_det vektorvagyskalar pos_det biotsavartpontok
global BSmag X_BSmag Y_BSmag Z_BSmag BX_BSmag BY_BSmag BZ_BSmag BX BY BZ
global X_M Y_M %Z_M
global korabban_szamitott_indukcio
tmp = mu0*I*aramirany*haladasiirany/(2*pi);
%--------------------------------------------------------------------------
disp('cabledistance2detindukcio.m:');
switch vektorvagyskalar
    case 's'
        % Számítások skalárként tárolt mágneses indukcióval (B[T]).
%         disp('Verzio: s')
        for i = 1:detektorszam
            induction_det(3,i) = tmp/sqrt(height_det^2+tavolsag_det(1,i)^2);
        end
    case 'v'
        % Számítások vektorként tárolt mágneses indukcióval ([Bx;By;Bz][T]).
%         disp('Verzio: v')
        induction_det = biotsavartjarulek_v2_0(biotsavartpontok,pos_det,tmp/2);
    case 'BSmag'
%         disp('Verzio: BSmag')
        if (strcmp(korabban_szamitott_indukcio,''))
            for i = 1:detektorszam
                X_BSmag(1,1,1) = pos_det(1,i,1);
                Y_BSmag(1,1,1) = pos_det(2,i,1);
                Z_BSmag(1,1,1) = pos_det(3,i,1);
    %             uzenet = ['X_BSmag(1,1,1) = ',num2str(X_BSmag(1,1,1))];
    %             disp(uzenet);
    %             uzenet = ['Y_BSmag(1,1,1) = ',num2str(Y_BSmag(1,1,1))];
    %             disp(uzenet);
    %             uzenet = ['Z_BSmag(1,1,1) = ',num2str(Z_BSmag(1,1,1))];
    %             disp(uzenet);            
                [BSmag,X_BSmag,Y_BSmag,Z_BSmag,BX_BSmag,BY_BSmag,BZ_BSmag] = BSmag_get_B(BSmag,X_BSmag,Y_BSmag,Z_BSmag);
                induction_det(1:3,i) = [BX_BSmag(1,1,1);BY_BSmag(1,1,1);BZ_BSmag(1,1,1)];
            end
        else
            tmp = X_M(:,1);
            hosszusag(1,1) = size(tmp,1);
            tmp = Y_M(1,:);
            tmp = tmp';
            hosszusag(2,1) = size(tmp,1);
            idx = [0;0];
            for i = 1:detektorszam
                for j = 1:2
                    megvan = 0;
                    for k = 1:hosszusag(j,1)-1
                        if (pos_det(j,i,1) < (X_M(k,1)+X_M(k+1,1))/2)
                            idx(j,1) = k;
                            megvan = 1;
                            break;
                        end
                    end
                    if (megvan == 0)
                        if (pos_det(j,i,1) >= (X_M(k,1)+X_M(k+1,1))/2)
                            idx(j,1) = k;
                        end
                    end
                end
            uzenet = ['(x_idx,y_idx) = (',num2str(idx(1,1)),',',num2str(idx(2,1)),')'];
            disp(uzenet);
            BX_BSmag(1,1,1) = BX(idx(1,1),idx(2,1),1);
            BY_BSmag(1,1,1) = BY(idx(1,1),idx(2,1),1);
            BZ_BSmag(1,1,1) = BZ(idx(1,1),idx(2,1),1);
            induction_det(1:3,i) = [BX_BSmag(1,1,1);BY_BSmag(1,1,1);BZ_BSmag(1,1,1)];                
            end
        end
    otherwise
        disp('cabledistance2detindukcio_v3_0: Téves bmeneti paraméter. cabledistance2detindukcio_v3_0(vektorvagyskalar)')
end
%--------------------------------------------------------------------------
% % Az eremény kijelzése parancssorba:
% for i = 1:detektorszam
%     uzenet = ['B[T](',num2str(i),') = ',num2str(induction_det(1,i)),', ',num2str(induction_det(2,i)),', ',num2str(induction_det(3,i))];
%     disp(uzenet);
% end
%
end