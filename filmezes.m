function filmezes()
%--------------------------------------------------------------------------
% Verzi�: 2.0
% A f�ggv�ny c�lja:
% 1. El�k�sz�t egy �br�t.
% 2. �pr�zolja: nyomvonal (path), AGV, �rz�kel�k.
% 3. Megjelen�ti a c�met �s cimk�ket.
% 4. K�perny�k�pet r�gz�t, �s hozz�f�zi a k�pet a filmf�jlhoz.
%--------------------------------------------------------------------------
close all;% Az el�z� �bra bez�r�sa.
global cableroute AGVpolygon pos_det
global time pos_agv tavolsag_agv phi_agv2cableroute
global x_min x_max y_min y_max
global plotting filmmaking szimhossz_tervezett writerObj
%--------------------------------------------------------------------------
if (plotting==1)
    % 1. szakasz: Tengely-be�ll�t�s
    axis([x_min x_max y_min y_max]);
    hold on;
    %----------------------------------------------------------------------
    % 2. szakasz: �br�zol�s
    plot(cableroute(1,:),cableroute(2,:),AGVpolygon(1,:),AGVpolygon(2,:),pos_det(1,:),pos_det(2,:), pos_agv(1,1), pos_agv(2,1));
    %--------------------------------------------------------------------------
    % 3. szakasz: C�m �s c�mk�k
    FormatSpec_time = '%+8.3f';
    FormatSpec_pos = '%+6.3f';
    FormatSpec_dagv2path = '%+6.3f';
    FormatSpec_phi = '%+5.3f';
    title(['time[s]:',num2str(szimhossz_tervezett, FormatSpec_time),'/',num2str(time,FormatSpec_time),'; pos(x,y)[m]: ',num2str(pos_agv(1,1),FormatSpec_pos),', ',num2str(pos_agv(2,1),FormatSpec_pos), '; d[m] = ', num2str(tavolsag_agv,FormatSpec_dagv2path),'; phi[r]: ',num2str(phi_agv2cableroute,FormatSpec_phi)]);
    %----------------------------------------------------------------------
    % 4. szakasz: K�perny�k�p k�sz�t�se �s a videof�jlba f�z�se.
    if (filmmaking==1)
        frame = getframe(gcf);
        writeVideo(writerObj,frame);
    end
else
    uzenet = ['Id� [s] - eltelt/�sszes : ',num2str(time),'/',num2str(szimhossz_tervezett)];
    disp(uzenet);
end
end