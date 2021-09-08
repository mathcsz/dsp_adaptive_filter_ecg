% Adaptive filter application

% Objective: To compare the LMS and the RLS adaptive filter algorithms in a 
% fetal ECG (FECG) extraction application.

% The FECG extraction strategy that will be simulated consist of measuring the 
% FECG signal from the abdomen of the mother and use an adaptive noise canceller 
% filter to remove the mother's ECG (MECG). A signal measured from the chest of 
% the mother is used as the noise reference signal.  

% The two algorithms will be compared with respect to the RMSE obtained between 
% the extracted signal and the original FEGC.

% The filter parameters were obtained empirically, adopting a compromise 
% solution between efficiency and stability.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Analysis of results:
% It was possible to observe that both filters presented satisfactory results.
% With the filtered signal, it is now possible to visually identify the 
% QRS complex as well as the P and T waves of almost all pulses. 

% In addition, the comparison of the signals obtained from each filter with the
% original signal showed that the RLS filter presented greater efficiency, 
% in addition to having a shorter convergence time, despite its slightly more 
% complex implementation. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all
pkg load signal

fs=1000;
At = 0.5;

% Fetal ECG (120 bpm)
ecgBebe = ecgsyn(fs, 8, 0, 120, 1, 0.5, fs)';
l = length(ecgBebe);

% ECG from mother's chest (60 bpm)
% mixed with an attenuated sample of the FECG
ecgMae = ecgsyn(fs, 8, 0, 60, 1.5, 0.5, fs)'(1:l);
ecgMae += 0.01*ecgBebe;

% Signal measured from the abdomen of the mother.
ecg = 0.7*ecgMae + At*ecgBebe;


% RLS filter
rlsFilter(0, 0, 5, 0.997, 1);
for i = 1:l
  [y, eRls(i)] = rlsFilter(ecgMae(i), ecg(i), 0, 0, 0);
 
% Real time
##  if (mod(i, 20) == 0)
##    plot(eRls);
##    grid on;  
##    ylim([-1 2]);
##    pause(0.01)
##  end
endfor

% LMS filter
lmsFilter(0, 0, 10, 0.01, 1);
for i = 1:l
  [y, eLms(i)] = lmsFilter(ecgMae(i), ecg(i), 0, 0, 0);
 
% Real time
##  if (mod(i, 20) == 0)
##    plot(eLms);
##    grid on;  
##    ylim([-1 2]);
##    pause(0.01)
##  end
endfor

% Results
subplot(4, 1, 1);
plot(ecgBebe)
ylim([-0.5 1.5]) 
xlabel("FETAL ECG")
grid on;

subplot(4, 1, 2);
plot(ecg)
ylim([-0.5 1.5]) 
xlabel("ECG FETAL + MOTHER")
grid on;

subplot(4, 1, 3);
plot((1/At)*eRls)
ylim([-0.5 1.5]) 
xlabel("FILTERED FECG (RLS)")
grid on;

subplot(4, 1, 4);
plot((1/At)*eLms)
ylim([-0.5 1.5]) 
xlabel("FILTERED FECG (LMS)")
grid on;

errEcg = weightedErms(ecgBebe, ecg)
errRls = weightedErms(ecgBebe, eRls)
errLms = weightedErms(ecgBebe, eLms)

##figure
##bar([errEcg, errLms, errRls;]);
##legend({"ECG","LMS","RLS"})
