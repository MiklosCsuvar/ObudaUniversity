function detsignal()
%--------------------------------------------------------------------------
% Verzió: 8.0
% A függvény célja:
% 1. Lekérni a detektor-kábelnyomvonal távolságot.
% 2. Elöbbi alapján kiszámolni a detektorok indukcióját.
% 3. Elöbbi alapján kiszámolni a detektorok jelének különbségét.
%--------------------------------------------------------------------------
global signal_det AvagyD signal_diff detektorszam ADfelbontas ADClimit
global pos_det idxcur_det tavolsag_det kozelipont_det jelmemoriahossz signal_det_tarolt
%--------------------------------------------------------------------------
[tavolsag_det,kozelipont_det,idxcur_det] = position2cabledistance(pos_det,idxcur_det);
cabledistance2detindukcio_v3_0(); % A távolság alapján a detektorok mágneses indukciójának (B[T])kiszámítása.
detindukcio2detflux(); % Az indukció (B[T]) alapján a fluxus kiszámítása.
detflux2detfeszultseg(); % A fluxusból feszültség kiszámítása.
detfeszultseg2erosites(); % A detektorok kimenetének felerösítése.
%--------------------------------------------------------------------------
% A detektorokon indukált feszültség digitalizálása.
if (AvagyD ~= 'a')
    for i = 1:detektorszam
        signal_det(1,i) = ADatalakito(signal_det(1,i),ADfelbontas, ADClimit, AvagyD);% Digitalizált jel: U[V].
    end
    uzenet = ['Digitalizálva [1]: U(1) = ', num2str(signal_det(1,1)),', ','U(2) = ', num2str(signal_det(1, detektorszam))];
    disp(uzenet);
end
%--------------------------------------------------------------------------
% A legtávolabbi detektorok jelének különbsége.
signal_diff = abs(signal_det(1,1))-abs(signal_det(1,detektorszam));% A detektorok jelei abszolutértékének különbsége: U[V].
for i = 1:jelmemoriahossz-1
    signal_det_tarolt(i,:) = signal_det_tarolt(i+1,:);
end
signal_det_tarolt(jelmemoriahossz,:) = signal_det(1,:);
%
end