close all;

%{
%% Exercice 1.1

% 1.1. 
% L4C "short period" : F6
% LE3D5S "medium band" : F7
% STS2 "broad band" : A1

% 1.2
Z1=readsac('Zagros/2001.02.13-19.28.30.A1.Z.SAC'); %broad band
Z2=readsac('Zagros/2001.02.13-19.28.30.F7.Z.SAC'); %medium band
Z3=readsac('Zagros/2001.02.13-19.28.30.F6.Z.SAC'); %short band

%SAC Data File Format http://www.iris.edu/software/sac/manual/file_format.html

% 1.2.1
% Z1 : name of station: kstnm: 'A1'; 
% type of seismometer: kinst: 'STS2'; 
% station coordinates: stla: 29.4411 stlo: 51.3067 ;
% earthquakes coordinates: evla: -4.6800 evlo: 102.5620.

% Z2 : name of station: kstnm: 'F7'; 
% type of seismometer: kinst: 'LE3D5S'; 
% station coordinates: stla: 29.5860  stlo: 51.4329 ;
% earthquakes coordinates: evla: -4.6800 evlo: 102.5620.

% Z3 : name of station: kstnm: 'F6'; 
% type of seismometer: kinst: 'L4C'; 
% station coordinates: stla: 29.7070  stlo: 51.5048;
% earthquakes coordinates: evla: -4.6800  evlo: 102.5620.

%1.2.2 The time step used is the terme "delta", so its corresponding to t:
Z1delta = 0.0250; 
fZ1 = 1/ Z1delta ; % fZ1 = 40 Hz
Z2delta= 0.0160;
fZ2 = 1/ Z2delta ; %fZ2 = 62.5 Hz
Z3delta = 0.0160; 
fZ3 = 1/ Z3delta; %fZ3 = 62.5 Hz

%1.2.3 La fréquence maximale peut être retrouver grâce à la frequence de
%Nyquist qui s'exprime par Fn = (1/2.delta(t)) > fmax

fNy1 = 1 / (2 * Z1delta); % fNy1 = 20 Hz
fNy2 = 1 / (2 * Z2delta); % fNy2 = 31.2500 Hz
fNy3 = 1 / (2 * Z3delta); % fNy3 = 31.2500 Hz

%1.3

subplot(3,1,1) ; plots(Z1) ; xlim([0 200]); title('A1-STS2'); ylabel('signal numérique (in count)'); xlabel('time (in s)'); legend;
subplot(3,1,2) ; plots(Z2) ; xlim([0 200]); title('F7-LE3D5S'); ylabel('signal numérique (in count)'); xlabel('time (in s)'); legend;
subplot(3,1,3) ; plots(Z3) ; xlim([0 200]); title('F6-L4C'); ylabel('signal numérique (in count)'); xlabel('time (in s)'); legend;

%1.4
% L'unité de l'axe des ordonnées est le count.

%1.5
%Ils ont des traces différentes car le type de sismomètre est différent
%pour chaque station, en effet il y a un sismomètre qui enregistre
%seulement les petites fréquences, un autre les moyennes, et un autre les
%grandes (où sont aussi comprises les petites évidemment). Ainsi, cela fait
%varier les traces, en plus du fait que les stations sont à des endroits
%différents donc, il peut y avoir des effets de site qui changent
%légèrement le signal.
%}

%% Exercice 2

% 2.1
% 1 rad/s = 1/2*pi

% L4C - F6:
polesL4C = -4.443/(2*pi);
%  2 poles (Hz)
%   -0.7071+0.7071j
%   -0.7071-0.7071j

% LE3D5S - F7:
% 2 poles (Hz)
polesLE3D5S = -0.8886/(2*pi);
% -0.1414+0.1414j
% -0.1414-0.1414j

% STS2 - A1 : 
% 2 poles (Hz)
polesSTS2 = -0.0371/(2*pi);
% -0.0059+0.0059j
% -0.0059-0.0059j

%z1 = z2 = z3 = zeros(1,2) car on a 0 0 (deux zeros)
z = zeros(1,2);
%c1 = c2 = c3 = 1 le pas
c = 1;

[f1,amp1,ph1] =response([-0.0059+0.0059*1i,-0.0059-0.0059*1i],z,c);
[f2,amp2,ph2] =response([-0.1414+0.1414*1i,-0.1414-0.1414*1i],z,c);
[f3,amp3,ph3] =response([-0.7071+0.7071*1i,-0.7071-0.7071*1i],z,c);

hold on
semilogx(f1,20*log10(amp1),'r')
semilogx(f2,20*log10(amp2),'m')
semilogx(f3,20*log10(amp3),'k')