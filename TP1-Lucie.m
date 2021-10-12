
close all
Z1=readsac('Zagros/2001.02.13-19.28.30.A1.Z.SAC');
Z2=readsac('Zagros/2001.02.13-19.28.30.F7.Z.SAC');
Z3=readsac('Zagros/2001.02.13-19.28.30.F6.Z.SAC');
%plot trace
subplot(3,1,1);
plots(Z1);
xlim([0 200]);
subplot(3,1,2);
plots(Z2);
xlim([0 200]);
subplot(3,1,3);
plots(Z3);
xlim([0 200]);
%instrumental responses
%subplot(3,1,1)
c=167/(745*10^-9);
[f1,ampli1,phase1] =response([-4.443+4.443*1i,-4.443-4.443*1i],[0;0],c);
%semilogx(f1,20*log10(ampli1))
%subplot(3,1,2)
c=400/(745*10^-9);
[f2,ampli2,phase2] =response([-0.8886+0.8886*1i,-0.8886-0.8886*1i],[0;0],c);
%semilogx(f2,20*log10(ampli2))
%subplot(3,1,3)
c=1500/(2374*10^-9);
[f3,ampli3,phase3] =response([-0.0371+0.0371*1i,-0.0371-0.0371*1i],[0;0],c);
semilogx(f1,20*log10(ampli1),f2,20*log10(ampli2),f3,20*log10(ampli3));
%legend(Z1,Z2,Z3)
semilogx(f1,phase1,f2,phase2,f3,phase3);

%instrumental response correction
Z1deconv=deconv_instr(Z1);
Z2deconv=deconv_instr(Z2);
Z3deconv=deconv_instr(Z3);
subplot(3,1,1);
plots(Z1deconv);
xlim([0 200]);
subplot(3,1,2);
plots(Z2deconv);
xlim([0 200]);
subplot(3,1,3);
plots(Z3deconv);
xlim([0 200]);
%Apply the gain from the digitizer to the seismic trace (count > nV).
%multiply by digitizer gain to have nV
%Z1correct doit être un stream (trace + metadata) avant de modifier la trace
Z1correct=Z1deconv;
Z1correct.trace=745*Z1deconv.trace;
Z2correct=Z2deconv;
Z2correct.trace=745*Z2deconv.trace;
Z3correct=Z3deconv;
Z3correct.trace=745*Z3deconv.trace;
%afficher les 3 corrections
subplot(3,1,1);
plots(Z1correct);
xlim([0 200]);
subplot(3,1,2);
plots(Z2correct);
xlim([0 200]);
subplot(3,1,3);
plots(Z3correct);
xlim([0 200]);
%Displacement, velocity, acceleration
Z1vel=Z1;
Z1disp=vel2acc(Z1);
Z1acc=vel2disp(Z1);
%attention fréquence en s-1
Z1velfil=hpf(Z1vel,1/150);
Z1dispfil=hpf(Z1disp,1/150);
Z1accfil=hpf(Z1acc,1/150);
close all
%afficher les différentes traces filtrées
subplot(3,1,1);
plots(Z1dispfil);
xlim([0 200]);
subplot(3,1,2);
plots(Z1velfil);
xlim([0 200]);
subplot(3,1,3);
plots(Z1accfil);
xlim([0 200]);
%Power spectrum
%cut traces
Z1P=cut_tr(Z1,0,540);
Z1S=cut_tr(Z1,530,1330);
Z1surf=cut_tr(Z1,1330,4500);
subplot(3,1,1);
plots(Z1P);
xlim([0 200]);
subplot(3,1,2);
plots(Z1S);
xlim([0 200]);
subplot(3,1,3);
plots(Z1surf);
xlim([0 200]);
%power-spectral density
%https://fr.mathworks.com/help/signal/ref/pwelch.html#d123e140077
close all
[pZ1P,fP]=pwelch(Z1P.trace,[],[],[],1/Z1P.delta);
[pZ1S,fS]=pwelch(Z1S.trace,[],[],[],1/Z1S.delta);
[pZ1surf,fsurf]=pwelch(Z1surf.trace,[],[],[],1/Z1surf.delta);
subplot(3,1,1);
%change to dB
semilogx(fP, 10*log10(pZ1P));
xlim([0 200]);
subplot(3,1,2);
semilogx(fS, 10*log10(pZ1S));
xlim([0 200]);
subplot(3,1,3);
semilogx(fsurf, 10*log10(pZ1surf));
xlim([0 200]);
%Noise spectrum
B2Z=readsac('Zagros/bruitB2.Z.SAC');
B2N=readsac('Zagros/bruitB2.N.SAC');
B2E=readsac('Zagros/bruitB2.E.SAC');
[pB2Z,fZ]=pwelch(B2Z.trace,[],[],[],1/B2Z.delta);
[pB2N,fN]=pwelch(B2N.trace,[],[],[],1/B2N.delta);
[pB2E,fE]=pwelch(B2E.trace,[],[],[],1/B2E.delta);
subplot(3,1,1);
semilogx(fZ, 10*log10(pB2Z));
xlim([0 200]);
hold on;
plot(F_NLNM,NLNMvel,'m');
plot(F_NHNM,NHNMvel,'m');
load peterson.mat
subplot(3,1,2);
semilogx(fN, 10*log10(pB2N));
xlim([0 200]);
hold on;
plot(F_NLNM,NLNMvel,'m');
plot(F_NHNM,NHNMvel,'m');
subplot(3,1,3);
semilogx(fE, 10*log10(pB2E));
xlim([0 200]);
hold on;
plot(F_NLNM,NLNMvel,'m');
plot(F_NHNM,NHNMvel,'m');