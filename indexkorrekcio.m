function korrigalt_index = indexkorrekcio(eredeti_index,alsohatar,felsohatar)
%--------------------------------------------------------------------------
% Verzió: 1.0
% A függvény célja:
% Adott egész szám(!) (..., -1, 0, 1, ...) alsó és felsö indexelései
% határral megadott indextartományban megkeresi az új index helyét.
% Példa:
% tartomány     bemenet kimenet
% [1, ..., 100] +103     +3
% [1, ..., 100] -3      +97
% [-20,...,-11] +1      -19
% [-20,...,-11] -3      -13
% [-20,...,-11] -23     -13
%--------------------------------------------------------------------------
if (eredeti_index > felsohatar || eredeti_index < alsohatar)
    if (eredeti_index > felsohatar)
        korrigalt_index = mod(eredeti_index-felsohatar,felsohatar-(alsohatar-1)) + (alsohatar - 1);
    else
        korrigalt_index = felsohatar - mod(abs(eredeti_index-(alsohatar-1)),felsohatar-(alsohatar-1));
    end
else
    korrigalt_index = eredeti_index;
end
%
end