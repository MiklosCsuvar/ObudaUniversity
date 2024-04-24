function curvepoints = circlecurve(center,R,phi1,phi2,delta)
%--------------------------------------------------------------------------
% Verzi�: 1.0
% A f�ggv�ny c�lja:
% Kisim�tani az egyeneszskaszok tal�lkoz�s�t, �s ennek �erdek�ben:
% Kisz�molja a Calculate points of a circle curve section centered at 'center' bemenet k�zpont� g�rbeszakasz pontjait.
% az 'R' bemeneti sug�r alapj�n 'phi1' �s 'phi2' sz�gek k�z�tt,
% a 'delta' bemenetnek megfelel� felbont�ssal (a pontok t�vols�ga).
%--------------------------------------------------------------------------
alpha = 2*asin(delta/2/R); % Az egym�s melletti sz�gtartom�nyok t�vols�ga.
n = ceil(abs(phi2-phi1)/alpha); % A sz�gtartom�nyok sz�ma a [phi1;phi2] intervallumban.
phi = linspace(phi1,phi2,n+1);% A g�rbe egy phi m�ret� intervalluma.
x = center(1,1) + R*cos(phi);% A k�rvonal x koordin�t�i.
y = center(2,1) + R*sin(phi);% A k�rvonal y koordin�t�i.
z = center(3,1) + 0*phi;     % A k�rvonal z koordin�t�i.
curvepoints = vertcat(x,y,z);% A k�r�vszakasz pontjai.
end