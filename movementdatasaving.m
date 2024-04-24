function movementdatasaving()
%--------------------------------------------------------------------------
% Verzió: 1.0
% A függvény célja:
% A kiszámított értékek elmentése.
% A mozgás ábrázolása és a film elmentése azok szükségességétöl függöen.
%--------------------------------------------------------------------------
global cableroute pos_det pos_agv time vbal vjobb signal_diff
global parametermentesfajlba width_cableroute fileID
global signal_det_erositetlen signal_det
global idxcur_agv tavolsag_agv kozelipont_agv gorbeseg
global kozelipont_det tavolsag_det phi_agv2cableroute idxcur_det osszes_megtett_ut
global detektorszam
%--------------------------------------------------------------------------
if(parametermentesfajlba == 1)
    for i = 1:2% Bemeneti adatok a pálya irányszögének kiszámításához az AGV-hez legközelebbi pontban.
        index(i,1)= mod(width_cableroute+idxcur_agv+(-1)^i,width_cableroute);
        if (index(i,1)==0)
            index(i,1) = width_cableroute;
        end
    end
    % A pálya irányszöge:
    phi_path = atan2(cableroute(2,index(2,1))-cableroute(2,index(1,1)),cableroute(1,index(2,1))-cableroute(1,index(1,1)));
    %fprintf(fileID,'%f;%f;%f;%f;%f;%f;%f;%f;%f;%d;%d;%f;%f;%f;%f;%f;%f;%f;%d;%d;%f;%f;%f;%f;%f;%f;%f;%d;%d;%f;%f;%d;%d;%d;%f;%f\n',time,phi_agv2cableroute,tavolsag_agv,pos_agv(1,1),pos_agv(2,1),pos_agv(3,1),kozelipont_agv(1,1),kozelipont_agv(2,1),kozelipont_agv(3,1),gorbeseg(idxcur_agv),idxcur_agv,tavolsag_det(1),pos_det(1,1),pos_det(2,1),pos_det(3,1),kozelipont_det(1,1),kozelipont_det(2,1),kozelipont_det(3,1),gorbeseg(idxcur_det(1)),idxcur_det(1),tavolsag_det(detektorszam),pos_det(1,detektorszam),pos_det(2,detektorszam),pos_det(3,detektorszam),kozelipont_det(1,detektorszam),kozelipont_det(2,detektorszam),kozelipont_det(3,detektorszam),gorbeseg(idxcur_det(detektorszam)),idxcur_det(detektorszam),signal_det_erositetlen(1),signal_det_erositetlen(detektorszam), signal_det(1),signal_det(detektorszam),signal_diff,vbal,vjobb);% A kimenet mentése. Fejléc az automatedinitialisation.m-ben.
%            fprintf(fileID,'%f;%f;%d;%f;%f;%f;%f;%f;%f;%f;%f;%f;%f;%d;%d;%f;%f;%f;%f;%f;%f;%f;%d;%d;%f;%d;%f;%f;%f;%f;%f;%f;%f;%d;%d;%f;%d;%f;%f;%f;%f;%f;%f;%f;%d;%d;%f;%d\n',time,osszes_megtett_ut,signal_diff,vbal,vjobb, phi_agv2cableroute,tavolsag_agv,pos_agv(1,1),pos_agv(2,1),pos_agv(3,1),kozelipont_agv(1,1),kozelipont_agv(2,1),kozelipont_agv(3,1),gorbeseg(idxcur_agv),idxcur_agv,tavolsag_det(1),pos_det(1,1),pos_det(2,1),pos_det(3,1),kozelipont_det(1,1),kozelipont_det(2,1),kozelipont_det(3,1),gorbeseg(idxcur_det(1)),idxcur_det(1), signal_det_erositetlen(1),signal_det(1), tavolsag_det(2),pos_det(1,2),pos_det(2,2),pos_det(3,2),kozelipont_det(1,2),kozelipont_det(2,2),kozelipont_det(3,2),gorbeseg(idxcur_det(2)),idxcur_det(2), signal_det_erositetlen(2), signal_det(2),tavolsag_det(3),pos_det(1,3),pos_det(2,3),pos_det(3,3),kozelipont_det(1,3),kozelipont_det(2,3),kozelipont_det(3,3),gorbeseg(idxcur_det(3)),idxcur_det(3),signal_det_erositetlen(3),signal_det(3));
    switch detektorszam
        case 2
            %fprintf(fileID,'%f;%f;%d;%f;%f;%f;%f;%f;%f;%f;%f;%f;%f;%d;%d;%f;%f;%f;%f;%f;%f;%f;%d;%d;%f;%d;%f;%f;%f;%f;%f;%f;%f;%d;%d;%f;%d\n',time,osszes_megtett_ut,signal_diff,vbal,vjobb, phi_agv2cableroute,tavolsag_agv,pos_agv(1,1),pos_agv(2,1),pos_agv(3,1),kozelipont_agv(1,1),kozelipont_agv(2,1),kozelipont_agv(3,1),gorbeseg(idxcur_agv),idxcur_agv,tavolsag_det(1),pos_det(1,1),pos_det(2,1),pos_det(3,1),kozelipont_det(1,1),kozelipont_det(2,1),kozelipont_det(3,1),gorbeseg(idxcur_det(1)),idxcur_det(1), signal_det_erositetlen(1),signal_det(1), tavolsag_det(2),pos_det(1,2),pos_det(2,2),pos_det(3,2),kozelipont_det(1,2),kozelipont_det(2,2),kozelipont_det(3,2),gorbeseg(idxcur_det(2)),idxcur_det(2), signal_det_erositetlen(2), signal_det(2));
            fprintf(fileID,'%f;%f;%f;%f;%f;%f;%f;%f;%f;%f;%f;%f;%f;%f;%f;%f;%f;%f;%f;%f;%f;%f;%f;%f;%f;%f;%f;%f;%f;%f;%f;%f;%f;%f;%f;%f;%f\n',time,osszes_megtett_ut,signal_diff,vbal,vjobb, phi_agv2cableroute,tavolsag_agv,pos_agv(1,1),pos_agv(2,1),pos_agv(3,1),kozelipont_agv(1,1),kozelipont_agv(2,1),kozelipont_agv(3,1),gorbeseg(idxcur_agv),idxcur_agv,tavolsag_det(1),pos_det(1,1),pos_det(2,1),pos_det(3,1),kozelipont_det(1,1),kozelipont_det(2,1),kozelipont_det(3,1),gorbeseg(idxcur_det(1)),idxcur_det(1), signal_det_erositetlen(1),signal_det(1), tavolsag_det(2),pos_det(1,2),pos_det(2,2),pos_det(3,2),kozelipont_det(1,2),kozelipont_det(2,2),kozelipont_det(3,2),gorbeseg(idxcur_det(2)),idxcur_det(2), signal_det_erositetlen(2), signal_det(2));
        otherwise
            %fprintf(fileID,'%f;%f;%d;%f;%f;%f;%f;%f;%f;%f;%f;%f;%f;%d;%d;%f;%f;%f;%f;%f;%f;%f;%d;%d;%f;%d;%f;%f;%f;%f;%f;%f;%f;%d;%d;%f;%d;%f;%f;%f;%f;%f;%f;%f;%d;%d;%f;%d\n',time,osszes_megtett_ut,signal_diff,vbal,vjobb, phi_agv2cableroute,tavolsag_agv,pos_agv(1,1),pos_agv(2,1),pos_agv(3,1),kozelipont_agv(1,1),kozelipont_agv(2,1),kozelipont_agv(3,1),gorbeseg(idxcur_agv),idxcur_agv,tavolsag_det(1),pos_det(1,1),pos_det(2,1),pos_det(3,1),kozelipont_det(1,1),kozelipont_det(2,1),kozelipont_det(3,1),gorbeseg(idxcur_det(1)),idxcur_det(1), signal_det_erositetlen(1),signal_det(1), tavolsag_det(2),pos_det(1,2),pos_det(2,2),pos_det(3,2),kozelipont_det(1,2),kozelipont_det(2,2),kozelipont_det(3,2),gorbeseg(idxcur_det(2)),idxcur_det(2), signal_det_erositetlen(2), signal_det(2),tavolsag_det(3),pos_det(1,3),pos_det(2,3),pos_det(3,3),kozelipont_det(1,3),kozelipont_det(2,3),kozelipont_det(3,3),gorbeseg(idxcur_det(3)),idxcur_det(3),signal_det_erositetlen(3),signal_det(3));
            fprintf(fileID,'%f;%f;%f;%f;%f;%f;%f;%f;%f;%f;%f;%f;%f;%f;%f;%f;%f;%f;%f;%f;%f;%f;%f;%f;%f;%f;%f;%f;%f;%f;%f;%f;%f;%f;%f;%f;%f;%f;%f;%f;%f;%f;%f;%f;%f;%f;%f;%f\n',time,osszes_megtett_ut,signal_diff,vbal,vjobb, phi_agv2cableroute,tavolsag_agv,pos_agv(1,1),pos_agv(2,1),pos_agv(3,1),kozelipont_agv(1,1),kozelipont_agv(2,1),kozelipont_agv(3,1),gorbeseg(idxcur_agv),idxcur_agv,tavolsag_det(1),pos_det(1,1),pos_det(2,1),pos_det(3,1),kozelipont_det(1,1),kozelipont_det(2,1),kozelipont_det(3,1),gorbeseg(idxcur_det(1)),idxcur_det(1), signal_det_erositetlen(1),signal_det(1), tavolsag_det(2),pos_det(1,2),pos_det(2,2),pos_det(3,2),kozelipont_det(1,2),kozelipont_det(2,2),kozelipont_det(3,2),gorbeseg(idxcur_det(2)),idxcur_det(2), signal_det_erositetlen(2), signal_det(2),tavolsag_det(3),pos_det(1,3),pos_det(2,3),pos_det(3,3),kozelipont_det(1,3),kozelipont_det(2,3),kozelipont_det(3,3),gorbeseg(idxcur_det(3)),idxcur_det(3),signal_det_erositetlen(3),signal_det(3));
    end
end
end