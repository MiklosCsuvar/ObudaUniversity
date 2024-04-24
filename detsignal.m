function detsignal()
%--------------------------------------------------------------------------
% Verzi�: 8.0
% A f�ggv�ny c�lja:
% 1. Lek�rni a detektor-k�belnyomvonal t�vols�got.
% 2. El�bbi alapj�n kisz�molni a detektorok indukci�j�t.
% 3. El�bbi alapj�n kisz�molni a detektorok jel�nek k�l�nbs�g�t.
%--------------------------------------------------------------------------
global signal_det AvagyD signal_diff detektorszam ADfelbontas ADClimit
global pos_det idxcur_det tavolsag_det kozelipont_det jelmemoriahossz signal_det_tarolt
%--------------------------------------------------------------------------
[tavolsag_det,kozelipont_det,idxcur_det] = position2cabledistance(pos_det,idxcur_det);
cabledistance2detindukcio_v3_0(); % A t�vols�g alapj�n a detektorok m�gneses indukci�j�nak (B[T])kisz�m�t�sa.
detindukcio2detflux(); % Az indukci� (B[T]) alapj�n a fluxus kisz�m�t�sa.
detflux2detfeszultseg(); % A fluxusb�l fesz�lts�g kisz�m�t�sa.
detfeszultseg2erosites(); % A detektorok kimenet�nek feler�s�t�se.
%--------------------------------------------------------------------------
% A detektorokon induk�lt fesz�lts�g digitaliz�l�sa.
if (AvagyD ~= 'a')
    for i = 1:detektorszam
        signal_det(1,i) = ADatalakito(signal_det(1,i),ADfelbontas, ADClimit, AvagyD);% Digitaliz�lt jel: U[V].
    end
    uzenet = ['Digitaliz�lva [1]: U(1) = ', num2str(signal_det(1,1)),', ','U(2) = ', num2str(signal_det(1, detektorszam))];
    disp(uzenet);
end
%--------------------------------------------------------------------------
% A legt�volabbi detektorok jel�nek k�l�nbs�ge.
signal_diff = abs(signal_det(1,1))-abs(signal_det(1,detektorszam));% A detektorok jelei abszolut�rt�k�nek k�l�nbs�ge: U[V].
for i = 1:jelmemoriahossz-1
    signal_det_tarolt(i,:) = signal_det_tarolt(i+1,:);
end
signal_det_tarolt(jelmemoriahossz,:) = signal_det(1,:);
%
end