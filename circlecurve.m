function curvepoints = circlecurve(center,R,phi1,phi2,delta)
%--------------------------------------------------------------------------
% Verzió: 1.0
% A függvény célja:
% Kisimítani az egyeneszskaszok találkozását, és ennek éerdekében:
% Kiszámolja a Calculate points of a circle curve section centered at 'center' bemenet központú görbeszakasz pontjait.
% az 'R' bemeneti sugár alapján 'phi1' és 'phi2' szögek között,
% a 'delta' bemenetnek megfelelö felbontással (a pontok távolsága).
%--------------------------------------------------------------------------
alpha = 2*asin(delta/2/R); % Az egymás melletti szögtartományok távolsága.
n = ceil(abs(phi2-phi1)/alpha); % A szögtartományok száma a [phi1;phi2] intervallumban.
phi = linspace(phi1,phi2,n+1);% A görbe egy phi méretü intervalluma.
x = center(1,1) + R*cos(phi);% A körvonal x koordinátái.
y = center(2,1) + R*sin(phi);% A körvonal y koordinátái.
z = center(3,1) + 0*phi;     % A körvonal z koordinátái.
curvepoints = vertcat(x,y,z);% A körívszakasz pontjai.
end