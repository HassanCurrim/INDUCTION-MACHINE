clc
clear
close all

%% IM PARAMETERS
Rs   = 0.24; 
Rr   = 0.175;
Rks = Rr + Rs;

Ls   = 59.4e-3;
Lr   = 59.1e-3;
Lm   = 57e-3;
Lks = Ls - Lm^2/Lr;

np   = 3;
n    = 6;
vsat = 380;
fn   = 50;

wb=2*pi*fn/np;

% additional
J   = 0.4;
B   = 0.068;  % Stima
k   = 0.009; % proportional factor of mech. load characteristic 
r   = 4; % Transmission ratio
tau = 100; % time constant for low pass filter in VI-Estimator


%% Controller Tuning
phase_margin = 60;
opts = pidtuneOptions("PhaseMargin", phase_margin);

% dq-current controller
tau_ix = Lks/Rks;
bw_ix = 5/tau_ix; % Controller Bandwidth
G_ix = tf(1, [Lks Rks]);
R_ix = pidtune(G_ix, "PI", bw_ix, opts);

% Speed controller
tau_spd = J/B*0.1;
bw_spd = 5/tau_spd; % Controller Bandwidth
G_spd = tf(1, [J B]);
R_spd = pidtune(G_spd, "PI", bw_spd, opts);

% Rotor Flux controller
tau_rFlx = Lm/Rr;
bw_rFlx = 3/tau_rFlx; % Controller Bandwidth
G_rFlx = tf(Lm, [Lm/Rr 1]);
R_rFlx = pidtune(G_rFlx, "PI", bw_rFlx, opts);

%% Simulation
%out = sim("IM_sim_model");

%% Plot of torque and speed from the "to workspace" in the simulink.
% if you uncomment this section, you will have to run it seprately using 
% "run section" after the run of the simulink file because the variables 
% speed and torque are saved in the workspace from simulink.

% V=220;
% 
% Lkr = Ls*(Ls*Lr - Lm^2)/Lm^2;
% Xk = 2*pi*50*Lkr;
% 
% wb=2*pi*50/np;
% 
% coppia = @(wr) 3*(Rr./((wb - wr)/wb)).*((V^2)./(((Rr./((wb - wr)/wb)).^2+(Xk)^2)*wb));
% 
% plot(speed,torque,'k',0:0.1:wb,coppia(0:0.1:wb),'r','LineWidth',1)
% grid on;


%% Simulation Data
% theta_s = sin(out.IM_Data.Data(:,1));
% theta_r = sin(out.IM_Data.Data(:,2));
% 
% wm = out.IM_Data.Data(:,3);
% me = out.IM_Data.Data(:,4);
% 
% ir_AB = out.IM_Data.Data(:,5);
% is_AB = out.IM_Data.Data(:,6);
% 
% t_sim = out.tout;
% 
% %% Plots
% figure(1)
% subplot(3,1,1)
% yyaxis left
% plot(t_sim, theta_s);
% hold on
% ylabel("Stator Flux Position / rad")
% yyaxis right
% plot(t_sim, theta_r);
% hold off
% xlabel("Time / s")
% ylabel("Rotor Flux Position / rad")
% grid on
% 
% subplot(3,1,2)
% plot(wm, me);
% xlabel("Mechanical Speed / RPM")
% ylabel("Torque / Nm")
% grid on
% 
% subplot(3,1,3)
% yyaxis left
% plot(t_sim, ir_AB);
% hold on
% ylabel("Rotor Current Magnitude / A")
% yyaxis right
% plot(t_sim, is_AB);
% hold off
% xlabel("Time / s")
% ylabel("Stator Current Magnitude / A")
% 
% grid on







