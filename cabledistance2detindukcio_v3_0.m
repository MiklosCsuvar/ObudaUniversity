function cabledistance2detindukcio_v3_0()
%--------------------------------------------------------------------------
% Verzi�: 3.0
% A f�ggv�ny c�lja:
% Kisz�molni az �rz�kel�k �ramvezet?t?l m�rt t�vols�ga alapj�n az adott
% pont m�gneses indukci�j�t (B [T]).
% A sz�m�t�s m�dja f�gg a 'vektorvagyskalar' glob�lis v�ltoz�t�l.
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
        % Sz�m�t�sok skal�rk�nt t�rolt m�gneses indukci�val (B[T]).
%         disp('Verzio: s')
        for i = 1:detektorszam
            induction_det(3,i) = tmp/sqrt(height_det^2+tavolsag_det(1,i)^2);
        end
    case 'v'
        % Sz�m�t�sok vektork�nt t�rolt m�gneses indukci�val ([Bx;By;Bz][T]).
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
        disp('cabledistance2detindukcio_v3_0: T�ves bmeneti param�ter. cabledistance2detindukcio_v3_0(vektorvagyskalar)')
end
%--------------------------------------------------------------------------
% % Az erem�ny kijelz�se parancssorba:
% for i = 1:detektorszam
%     uzenet = ['B[T](',num2str(i),') = ',num2str(induction_det(1,i)),', ',num2str(induction_det(2,i)),', ',num2str(induction_det(3,i))];
%     disp(uzenet);
% end
%
end