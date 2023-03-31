% Software implementation of the paper
% Fokin, G.; Koucheryavy, A. Algorithm for Topology Search Using Dilution 
% of Precision Criterion in Ultra-Dense Network Positioning Service Area.
% Mathematics 2023, xx, xxxx. https://doi.org/xx.xxxx/mathxxxxxxxx

clear all; close all; clc; tic;
sizeh = 500;     % max. length of gNB location area in horizontal plane, m
steph = 1;       % grid spacing of possible horizontal locations of gNBs, m
sizev = 100;     % max. height of gNB location area in vertical plane, m
stepv = steph;   % vertical grid spacing of possible gNB locations, m
UEsizeh=sizeh;   % max. length of UE location area in horizontal plane, m
UEsteph = 1;     % grid spacing of possible horizontal locations of UEs, m
N = 1e5;         % number of iterations
UE =[0.1,0.1,3]; % UE [x,y,z] coordinates, m
n = 4;           % number of gNB base stations in a given region of space
% gNB coordinate grid formation
X = -sizeh/2:steph:sizeh/2; Y = -sizeh/2:steph:sizeh/2; Z = 0:stepv:sizev;
% plot construction of a grid of location of gNB and UE in space
% plot_search_layout_gNB(X, Y, Z, UE, sizeh, steph, sizev, stepv);
rng('default')
% division of the lattice into regions: 
% gNBs are located each in its own quadrant
xi = [1, ceil(length(X)/2);          
      1, ceil(length(X)/2);
      ceil(length(X)/2), length(X);  
      ceil(length(X)/2), length(X);
      ceil(length(X)/2)-1, ceil(length(X)/2)+1];
yi = [1, ceil(length(Y)/2);          
      ceil(length(Y)/2), length(Y);
      ceil(length(Y)/2), length(Y);  
      1, ceil(length(Y)/2);
      ceil(length(Y)/2)-1, ceil(length(Y)/2)+1];
zi = [1, length(Z)];

% array initialization
gNB = zeros(n,3,N); pdop = zeros(N,1); hdop = zeros(N,1); vdop =zeros(N,1);
% search criterion for gNB placements by geometric DOP factor
% calc_case='TOA     ';
% calc_case='TDOA    ';
% calc_case='DOA     ';
% calc_case='TOA-DOA ';
calc_case='TDOA-DOA';

for i=1:N
    % selection of gNB coordinates for the i-th iteration of calculation
    gNBxi = [randi([xi(1,1), xi(1,2)]); 
             randi([xi(2,1), xi(2,2)]);
             randi([xi(3,1), xi(3,2)]); 
             randi([xi(4,1), xi(4,2)]);
             randi([xi(5,1), xi(5,2)])];
    gNByi = [randi([yi(1,1), yi(1,2)]); 
             randi([yi(2,1), yi(2,2)]);
             randi([yi(3,1), yi(3,2)]); 
             randi([yi(4,1), yi(4,2)]);
             randi([yi(5,1), yi(5,2)])];
    gNBzi = [randi([zi(1), zi(2)]);
             randi([zi(1), zi(2)]);
             randi([zi(1), zi(2)]);
             randi([zi(1), zi(2)]);
             randi([zi(1), zi(2)])];
    gNBi = [X(gNBxi).', Y(gNByi).', Z(gNBzi).'];
    gNB(:,:,i) = gNBi(1:n,:);
    % PDOP, HDOP, VDOP calculation
    [pdop(i), hdop(i), vdop(i)] = calculate_dop(gNBi, UE, calc_case);
end

% gNB placement search DOP criteria
mindop = 0.1; maxdop = 10;  % minimum and maximum DOP value

% finding gNB topologies by the criterion PDOP = [mindop, maxdop]
[dops_p, inds_p, mininds_p, maxinds_p, gNBdop_p, dn_p, dphi1n_p, hn_p]=...
    dop_process(pdop, gNB, UE, mindop, maxdop);
[dnd_p, dnm_p, dphi1nd_p, dphi1nm_p, hnd_p, hnm_p] = ...
    calculate_params_distr(dn_p, dphi1n_p, hn_p);
dop_case='PDOP';
str_p=sprintf('for gNB placements with %s<%.1f using %s',...
    dop_case, dops_p(maxinds_p),calc_case);
plot_params_distr(inds_p, mininds_p, maxinds_p, ...
    dn_p, dphi1n_p, hn_p, dop_case, pdop, hdop, vdop, str_p);
[gNBm_p]=calculate_layout(dnm_p, dphi1nm_p, hnm_p);
plot_res_topology3D(gNBm_p, sizeh, UEsizeh, str_p);
[Xh, Yh, pdop_p, hdop_p, vdop_p]=...
    calculate_res_dop(sizeh, UEsteph, UE, gNBm_p, calc_case);
plot_res_dop_distr(Xh,Yh,pdop_p,hdop_p, vdop_p, str_p,gNBm_p,maxdop);
% plot_res_dop(Xh, Yh, pdop_p, hdop_p, vdop_p, gNBm_p, UEsizeh, str_p);

% 
% % finding gNB topologies by the criterion HDOP = [mindop, maxdop]
% [dops_h, inds_h, mininds_h, maxinds_h, gNBdop_h, dn_h, dphi1n_h, hn_h]=...
%     dop_process(hdop, gNB, UE, mindop, maxdop);
% [dnd_h, dnm_h, dphi1nd_h, dphi1nm_h, hnd_h, hnm_h] = ...
%     calculate_params_distr(dn_h, dphi1n_h, hn_h);
% dop_case='HDOP';
% str_h=sprintf('for gNB placements with %s<%.1f using %s',...
%     dop_case, dops_h(maxinds_h),calc_case);
% plot_params_distr(inds_h, mininds_h, maxinds_h, ...
%     dn_h, dphi1n_h, hn_h, dop_case, pdop, hdop, vdop, str_h);
% [gNBm_h]=calculate_layout(dnm_h, dphi1nm_h, hnm_h);
% plot_res_topology3D(gNBm_h, sizeh, UEsizeh, str_h);
% [Xh, Yh, pdop_h, hdop_h, vdop_h]=...
%     calculate_res_dop(sizeh, UEsteph, UE, gNBm_h,calc_case);
% plot_res_dop(Xh, Yh, pdop_h, hdop_h, vdop_h, gNBm_h, UEsizeh, str_h);
% plot_res_dop_distr(Xh, Yh, pdop_h, hdop_h, vdop_h, str_h,gNBm_h,maxdop);
% 
% % finding gNB topologies by the criterion VDOP = [mindop, maxdop]
% [dops_v, inds_v, mininds_v, maxinds_v, gNBdop_v, dn_v, dphi1n_v, hn_v]=...
%     dop_process(vdop, gNB, UE, mindop, maxdop);
% [dnd_v, dnm_v, dphi1nd_v, dphi1nm_v, hnd_v, hnm_v] = ...
%     calculate_params_distr(dn_v, dphi1n_v, hn_v);
% dop_case='VDOP';
% str_v=sprintf('for gNB placements with %s<%.1f using %s',...
%     dop_case, dops_v(maxinds_v),calc_case);
% plot_params_distr(inds_v, mininds_v, maxinds_v, ...
%     dn_v, dphi1n_v, hn_v, dop_case, pdop, hdop, vdop, str_v);
% [gNBm_v]=calculate_layout(dnm_v, dphi1nm_v, hnm_v);
% plot_res_topology3D(gNBm_v, sizeh, UEsizeh, str_v);
% [Xh, Yh, pdop_v, hdop_v, vdop_v]=...
%     calculate_res_dop(sizeh, UEsteph, UE, gNBm_v, calc_case);
% plot_res_dop(Xh, Yh, pdop_v, hdop_v, vdop_v, gNBm_v, UEsizeh, str_v);
% plot_res_dop_distr(Xh,Yh,pdop_v,hdop_v, vdop_v, str_v,gNBm_v,maxdop);

toc