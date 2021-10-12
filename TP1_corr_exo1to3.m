clear all; close all

%% 1.
% Z=readsac('Zagros/2001.02.13-19.28.30.A1.Z.SAC');
% Z


% 1.1. 
% F6 --> L4C
% F9 --> LE3D5S
% A1 --> STS2

% 1.2.
Z1=readsac('Zagros/2001.02.13-19.28.30.F6.Z.SAC'); % L4C (Courte-Periode)
Z2=readsac('Zagros/2001.02.13-19.28.30.F9.Z.SAC'); % LE3D5S (Moyenne-Bande)
Z3=readsac('Zagros/2001.02.13-19.28.30.A1.Z.SAC'); % STS2 (Large-Bande)

% SAC MANUAL - SAC FORMAT
% http://www.iris.edu/software/sac/manual/file_format.html

% 1.3. 

% LES CHAMPS
% - nom de la station : kstnm
% - type de sismometre : kinst
% - coordonnees stations : (sltla, stlo)
% - coordonnees evt : (evla, evlo)

% - frequence d'echantillonnage : 1/delta
delta1 = Z1.delta;
fech1 = 1/Z1.delta % 62.5 Hz
delta2 = Z2.delta;
fech2 = 1/Z2.delta % 62.5 Hz
delta3 = Z3.delta;
fech3 = 1/Z3.delta % 40 Hz

% - frequence max du signal que l'on peut ???tudier : frequence de Nyquist
fNy1 = 1 / (2 * Z1.delta) % 31.25 Hz
fNy2 = 1 / (2 * Z2.delta) % 31.25 Hz
fNy3 = 1 / (2 * Z3.delta) % 20 Hz


% 1.4.
figure(1);
subplot(3,1,1) ;plots(Z1) ; xlim([0 200])
title('F6 - L4C');
ylabel('count')
subplot(3,1,2) ;plots(Z2) ; xlim([0 200])
title('F9 - LE3D5S');
ylabel('count')
subplot(3,1,3) ;plots(Z3) ; xlim([0 200])
title('A1 - STS2');
xlabel('time (s)')
ylabel('count')

% 1.5. l'axe des ordonnees est gradue en count (number in the digital
% recording)
% En fait on passe de depl/vit/acc a V puis count avec les deux fonctions
% de transfert associees au capteur et digitaliseur/numeriseur

% 1.6. Les traces ne se ressemblent pas car
%   - tres legeres differences due a des structures un peu
%     differentes sous les stations
%   - plus grosses differences (dephasage, contenu frequentiel)
%     du a differentes reponses instrumentales
%     courtes periodes --> HF
%     moyennes periodes --> MF
%     Large-bande --> il y a tout, y compris les
%     longues periodes

%% 2.
% Reponses instrumentales

% PARTIE CAPTEURS
% - F6 --> L4C :
% 2 zeros
% 2 poles (Hz)
%       -0.7071068+0.70710676j
%       -0.7071068-0.70710676j

f01=1;                              % frequence propre (Hz)
h1=0.707;                           % amortissement
Sv1=167;                            % sensibilite bobine (V/m.s-1)

z1=zeros(1,2)';                     % zeros (rad/s)
p1=[-0.7071068+0.70710676*j ...     % poles (Hz)
    -0.7071068-0.70710676*j]';
p1=2*pi*p1;                         % (Hz) -> (rad/s)
c1=1;                               % scale factor

% - F9 --> LE3D5S :
% 2 zeros
% 2 poles (Hz)
%       0.1414+0.14144270j
%       -0.1414-0.14144270j
%       -0.05+0.0j
f02=0.2;                            % frequence propre (Hz)
h2=0.707;                           % amortissement
Sv2=400;                            % sensibilite bobine (V/m.s-1)
z2=zeros(1,2)';                     % zeros (rad/s)
p2=[-0.1414+0.14144270*j ...        % poles (Hz)
    -0.1414-0.14144270*j];
%    -0.05+0.0*j]';
p2=2*pi*p2;                         % (Hz) -> (rad/s)
c2=1;                               % scale factor


% - A1 --> STS2
% 2 zeros
% 2 poles (rad/s)
%       -0.037024       +0.037024 
%       -0.037024       -0.037024
f03=0.2;                            % frequence propre (Hz)
h3=0.707;                           % amortissement
Sv3=1500;                           % sensibilite bobine (V/m.s-1)
z3=zeros(1,2)';                     % zeros (rad/s)
p3=[-0.037024+0.037024*j ...        % poles (rad/s)
    -0.037024-0.037024*j]';
c3=1;                               % scale factor
%c3=6.32e8;
% QUESTION : Lien entre la constante et les parametres du systeme ???

% NUMERISEURS
G1=745;                             % (nV/counts)
G2=745;                             % (nV/counts)
G3=2374;                            % (nV/counts)

% 2.1
[f1,amp1,pha1]=response(p1,z1,c1);
[f2,amp2,pha2]=response(p2,z2,c2);
[f3,amp3,pha3]=response(p3,z3,c3);
% [f1,amp1,pha1]=response(p1,z1,Sv1);
% [f2,amp2,pha2]=response(p2,z2,Sv2);
% [f3,amp3,pha3]=response(p3,z3,Sv3);

% 2.2 Reponse en amplitude
figure(2);
semilogx(f1,20*log10(amp1),'k');
hold on
semilogx(f2,20*log10(amp2),'b');
semilogx(f3,20*log10(amp3),'r');
xlabel('frequency (Hz)')
grid on
title('reponse en amplitude des capteurs')
ylabel('')
legend('L4C','LE3D5S','STS2')

% 2.3 Frequences de coupure (Hz)
fc1=1;
fc2=0.2;
fc3 = 0.0085;

% 2.4 La gamme de frequence pour laquelle la reponse
% est constante et maximale s'elargit en allant des capteurs
% courte periode a moyenne periode et large-bande

% 2.5 Reponse en phase
figure(3);
semilogx(f1,pha1*360/(2*pi),'k');
hold on
semilogx(f2,pha2*360/(2*pi),'b');
semilogx(f3,pha3*360/(2*pi),'r');
xlabel('frequency (Hz)')
grid on
title('reponse en phase des capteurs')
ylabel('Phase (degre)')
legend('L4C','LE3D5S','STS2')

% 2.6 Non, a contenu frequentiel donne, l'arrivee de l'onde
% P sera dephasee en fonction des caracteristiques du capteur
% Pourquoi ?
% - La phase est nulle sur une bonne part de la bande
% passante des reponses -> pas de dephasage pour ces frequences
% - En bordure de la bande passante, pour les basses freq, la
% phase des signaux enregistres est modifiee, jusqu'??? un dephasage
% de pi pour les signaux les plus basse freq (100 s) et le capteur
% courte periode. L'effet du dephasage de poi est evident pour le
% fort signal basse freq enregistre par le capteur moyenne-bande

% 3.
% 3.1 Deconvolution : S(f) = E(f) * I(f)
%                     E(f) ~ S(f) * I(f)^-1
%
% En pratique, division dans le domaine frequentiel avec un water-level
% destine a eviter la division du spectre du sismo par des "trous" dans
% la reponse de l'instrument

% 3.2 Deconvolution


% Apply digitalizer gain (no need for coal sensitivity
% because already taken into account in deconv_instr
Z1.trace=Z1.trace*G1;   % count -> nV
Z2.trace=Z2.trace*G2;
Z3.trace=Z3.trace*G3;

Z1.trace=Z1.trace*10^-9; % nV -> V
Z2.trace=Z2.trace*10^-9;
Z3.trace=Z3.trace*10^-9;

Z1deconv=deconv_instr(Z1); % V -> m/s
Z2deconv=deconv_instr(Z2);
Z3deconv=deconv_instr(Z3);

%Z4deconv=deconv_instr(Z1,'STS2');
%Z5deconv=deconv_instr(Z3,'L4C');

figure(4)
subplot(3,1,1) ;plots(Z1deconv) ; xlim([0 200])
title('F6 - L4C');
ylabel('m/s')
ylim([-1e-4 1e-4])
subplot(3,1,2) ;plots(Z2deconv) ; xlim([0 200])
title('F9 - LE3D5S');
ylabel('m/s')
ylim([-1e-4 1e-4])
subplot(3,1,3) ;plots(Z3deconv) ; xlim([0 200])
title('A1 - STS2');
xlabel('time (s)')
ylabel('m/s')
ylim([-1e-4 1e-4])

% figure
% subplot(3,1,1) ;plots(Z4deconv) ; xlim([0 200])
% title('F6 - STS2');
% xlabel('time (s)')
% ylabel('m/s')
% subplot(3,1,2) ;plots(Z5deconv) ; xlim([0 200])
% title('A1 - L4C');
% ylabel('m/s')
% xlabel('time (s)')

% 3.3 Les traces se ressemblent plus car on a enleve la
% reponse instrumentale qui induisait dephasages et
% distorsion en amplitude de la vitesse de deplacement
% du sol.


% ATTENTION: Si le capteur n'est pas en mesure d'enregistrer
% les mvts du sol dans une gamme de freq donnee, la deconvolution va
% avoir pour resultat d'amplifier du signal associe a du bruit
% electronique.
% Le mvt du sol enregistre avec le capteur CP
% diminue les amplitudes enregistrees a LP. Deconvoluer ->
% restitue les LP. Mais egalement presence de bruit elec.

% Si deconvolue STS2 avec reponse L4C CP alors longues periodes
% amplifiees anormalement. Resultat -> signal LP