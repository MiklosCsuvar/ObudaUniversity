function phi = anglevec2vecxy(r1,r2)
%--------------------------------------------------------------------------
% Verzió: 1.0
% A függvény célja:
% - Kiszámolni a bezárt szöget az xy síkban.
% - 2 db, nem feltétlenül egységvektor között, elöjelhelyesen.
%--------------------------------------------------------------------------
r_erinto = r2;
r_normalis = polygonrot(r_erinto,-pi/2,[0;0;0]);
abs_alpha = acos((r1'*r_erinto)/(norm(r1,2)*norm(r_erinto,2)));
abs_beta = acos((r1'*r_normalis)/(norm(r1,2)*norm(r_normalis,2)));
if (abs_beta >= pi/2 && abs_beta <= pi)
    phi = +1 * abs_alpha;
end
if (abs_beta >= 0 && abs_beta < pi/2)
    phi = -1 * abs_alpha;
end
%
end