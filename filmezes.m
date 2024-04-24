function filmezes()
%--------------------------------------------------------------------------
% Verzió: 2.0
% A függvény célja:
% 1. Elökészít egy ábrát.
% 2. Áprázolja: nyomvonal (path), AGV, érzékelök.
% 3. Megjeleníti a címet és cimkéket.
% 4. Képernyöképet rögzít, és hozzáfüzi a képet a filmfájlhoz.
%--------------------------------------------------------------------------
close all;% Az elözö ábra bezárása.
global cableroute AGVpolygon pos_det
global time pos_agv tavolsag_agv phi_agv2cableroute
global x_min x_max y_min y_max
global plotting filmmaking szimhossz_tervezett writerObj
%--------------------------------------------------------------------------
if (plotting==1)
    % 1. szakasz: Tengely-beállítás
    axis([x_min x_max y_min y_max]);
    hold on;
    %----------------------------------------------------------------------
    % 2. szakasz: Ábrázolás
    plot(cableroute(1,:),cableroute(2,:),AGVpolygon(1,:),AGVpolygon(2,:),pos_det(1,:),pos_det(2,:), pos_agv(1,1), pos_agv(2,1));
    %--------------------------------------------------------------------------
    % 3. szakasz: Cím és címkék
    FormatSpec_time = '%+8.3f';
    FormatSpec_pos = '%+6.3f';
    FormatSpec_dagv2path = '%+6.3f';
    FormatSpec_phi = '%+5.3f';
    title(['time[s]:',num2str(szimhossz_tervezett, FormatSpec_time),'/',num2str(time,FormatSpec_time),'; pos(x,y)[m]: ',num2str(pos_agv(1,1),FormatSpec_pos),', ',num2str(pos_agv(2,1),FormatSpec_pos), '; d[m] = ', num2str(tavolsag_agv,FormatSpec_dagv2path),'; phi[r]: ',num2str(phi_agv2cableroute,FormatSpec_phi)]);
    %----------------------------------------------------------------------
    % 4. szakasz: Képernyökép készítése és a videofájlba füzése.
    if (filmmaking==1)
        frame = getframe(gcf);
        writeVideo(writerObj,frame);
    end
else
    uzenet = ['Idö [s] - eltelt/összes : ',num2str(time),'/',num2str(szimhossz_tervezett)];
    disp(uzenet);
end
end