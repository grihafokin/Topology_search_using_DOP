% Software implementation of the paper
% Fokin, G.; Koucheryavy, A. Algorithm for Topology Search Using Dilution 
% of Precision Criterion in Ultra-Dense Network Positioning Service Area.
% Mathematics 2023, xx, xxxx. https://doi.org/xx.xxxx/mathxxxxxxxx
clear all; close all; clc; tic;
sizeh = 500;       % size of the side of square area of the gNB location, m
sizev = 100;       % maximum height of gNB location, m
UEsizeh = sizeh;   % size of the side of square area of the UE location, m
UEsizev = sizev;   % UE location height, m
UEsteph = 20;      % UE location grid step on the plane, m
UEstepv = 20;      % UE location grid step in height, m
dop_case = 'PDOP'; % the geometric DOP factor to search for
N = 1e1;           % max. # of iterations of one gNB position optimization
Nopt = 3;          % number of optimization algorithm cycles
% DOP search criterion for gNB locations by geometric factor
% calc_case='TOA     ';
% calc_case='TDOA    ';
% calc_case='DOA     ';
calc_case='TOA-DOA ';
% calc_case='TDOA-DOA';

% generating a UE coordinate grid; the grid is formed using meshgrid;
% UEX and UEY are the grid points;
% if there are n points in UEX and m points in UEY, then the grid is mxn;
% adding multiple values to UEZ results in multiple mxn grids
UEX = (-UEsizeh/2:UEsteph/2:UEsizeh/2)+0.1;
UEY = (-UEsizeh/2:UEsteph:UEsizeh/2)+0.1;
UEZ = UEsizev+0.1;                       
[ueX, ueY, ueZ] = meshgrid(UEX, UEY, UEZ);

n = 7;        % total number of gNB base stations
nAdd = n - 4; % number of additional gNBs beyond the minimum 4 required
% initially 4 gNB are evenly distributed around origin at maximum spacing; 
% coordinates can be random; in current realization are chosen uniformly
azAng = (2*pi./4).*(1:4); % four angles to get a square;
% initially all gNB are at sizev/2 height; becomes zero after optimization;
% when optimizing for PDOP/VDOP, all gNBs tend to min. height, i.e. to zero
gNBpos = [sizeh/2*[cos(azAng).', sin(azAng).'], ...
          sizev/2*ones(4, 1); zeros(nAdd, 3)];
% gNBpos = [X(randi(numel(X),n,1)).'...
%           Y(randi(numel(Y),n,1)).'...
%           Z(randi(numel(Z),n,1)).'];

dSizeHDefault = 1e1; % initial step of position optimization on the plane
dSizeVDefault = 1e0; % initial step of position optimization on the height
% array of azimuth angles, specifying the direction of the position 
% optimization step; number of angular steps when calculating the 
% coordinates of points in the neighborhood of gNB position to be optimized; 
% the more points, the more accurate is the direction of DOP decrease, 
% but the algorithm works longer
angSteps = 20; 
% angular step when calculating the coordinates 
% of points in the vicinity of the optimized position of gNB
angStep = (2*pi./angSteps).*(1:angSteps);
% array of gNB position bounds
Xlim = [-sizeh/2, sizeh/2];
Ylim = [-sizeh/2, sizeh/2];
Zlim = [0, sizev];
% cell array to store intermediate gNB coordinate optimization results
gNBposP = cell(1, n);      
% cell array to store intermediate DOP values during optimization
dopP = cell(1);     
% array of number of optimization iterations performed
% on the plane for each gNB on each optimization cycle
numIterH = zeros(Nopt, n); 
% array of number of optimization iterations performed
% on the height for each gNB on each optimization cycle
numIterV = zeros(Nopt, n); 
% 4 gNB - the minimum number of gNB to determine the coordinates in space
for nOpt=1:Nopt % cycle by the number of cycles of optimization algorithm
    if (nOpt == 1)
        nkEnd = 4; % number of gNBs, involved in optimization on 1st cycle
    else
        % number of gNBsm involved in optimization on all cycles except 1st
        nkEnd = n;
    end

    for nk=1:nkEnd % optimization cycle of position of 4 gNBs on the plane
        fprintf('Cycle# %i, gNB %i: location search by coordinates xy...\n',nOpt,nk);
        dSizeH = dSizeHDefault;
        dSizeV = dSizeVDefault;
        [gNBpos(1:nkEnd,:), gNBposPn, dopPn, nIter] = ...
            search_opt(nk, gNBpos(1:nkEnd,:), ueX, ueY, ueZ, ...
            dSizeH, dSizeV, angStep, Xlim, Ylim, Zlim, N, dop_case, calc_case, 'H');
        % save intermediate DOP values 
        % after optimizing the position of the nk-th gNB
        dopP{1} = [dopP{1}, dopPn{:}];
        % save intermediate gNB coordinates
        % after optimizing the position of the nk-th gNB
        gNBposP{nk} = [gNBposP{nk}; gNBposPn{:}];
        % save number of completed iterations for
        % optimization of the position on the plane of the nk-th gNB
        numIterH(nOpt, nk) = nIter;              
    end

    % height optimization cycle for 4 gNBs
    for nk=1:nkEnd
        fprintf('Cycle# %i, gNB %i: location search by coordinates z ...\n',nOpt,nk);
        dSizeV = dSizeVDefault;        
        [gNBpos(1:nkEnd,:), gNBposPn, dopPn, nIter] = ...
            search_opt(nk, gNBpos(1:nkEnd,:), ueX, ueY, ueZ, ...
            dSizeH, dSizeV, angStep, Xlim, Ylim, Zlim, N, dop_case, calc_case, 'V');
        % save intermediate DOP values
        % after optimizing the position of the nk-th gNB
        dopP{1} = [dopP{1}, dopPn{:}];
        % сохранение промежуточных координат gNB 
        % после оптимизации положения nk-й gNB
        gNBposP{nk} = [gNBposP{nk}; gNBposPn{:}];
        % save number of completed iterations for
        % optimization of the position on the height of the nk-th gNB
        numIterV(nOpt, nk) = nIter;             
    end

    % on the first optimization cycle, each additional gNB 
    % is added to the optimization process in turn (sequentally)
    if (nOpt == 1) 
        % additional gNB position optimization cycle on the plane 
        % starts from 5, because minimum number of gNBs is equal to 4, 
        % respectively, from the 5th to the nth, these are additional gNBs
        for nk=5:n
            fprintf('Cycle# %i, gNB %i: location search by coordinates xy...\n',nOpt,nk);
            dSizeH = dSizeHDefault;
            dSizeV = dSizeVDefault;
            [gNBpos(1:nk,:), gNBposPn, dopPn, nIter] = ...
                search_opt(nk, gNBpos(1:nk,:), ueX, ueY, ueZ, ...
                dSizeH, dSizeV, angStep, Xlim, Ylim, Zlim, N, dop_case, calc_case, 'H');
            % save intermediate DOP values
            % after optimizing the position of the nk-th gNB
            dopP{1} = [dopP{1}, dopPn{:}];            
            % save intermediate gNB coordinates
            % after optimizing the position of the nk-th gNB
            gNBposP{nk} = [gNBposP{nk}; gNBposPn{:}];
            % save number of completed iterations
            % height position optimization nk-th gNB
            numIterH(nOpt, nk) = nIter;              
        end
    
    % additional gNB position optimization cycle in height starts from 5,
    % because minimum number of gNBs is equal to 4, respectively, 
    % from the 5th to the nth, these are additional gNBs
    for nk=5:n
        fprintf('Cycle# %i, gNB %i: location search by coordinates z ...\n',nOpt,nk);
        dSizeV = dSizeVDefault;
        
        [gNBpos(1:n,:), gNBposPn, dopPn, nIter] = ...
            search_opt(nk, gNBpos(1:n,:), ueX, ueY, ueZ, ...
            dSizeH, dSizeV, angStep, Xlim, Ylim, Zlim, N, dop_case, calc_case, 'V');
        % save intermediate DOP values
        % after optimizing the position of the nk-th gNB
        dopP{1} = [dopP{1}, dopPn{:}];
        % save intermediate gNB coordinates
        % after optimizing the position of the nk-th gNB
        gNBposP{nk} = [gNBposP{nk}; gNBposPn{:}];      
        % save number of completed iterations
        % height position optimization nk-th gNB
        numIterV(nOpt, nk) = nIter;
    end
    end %  if (nOpt == 1)     
end % for nOpt=1:Nopt

% OUTPUT RESULTS
maxdop = 2;  % maximum DOP value; only for plotting contours
dop_string =sprintf('for gNB placements with %s<%.1f using %s',...
    dop_case, maxdop, calc_case);

plot_res_topology3D(gNBpos, sizeh, UEsizeh, dop_string);
% plot_search_layout_UE(gNBpos, ueX, ueY, ueZ, UEsizeh, UEsteph, UEsizev);

% additional plot of ll rows and kk columns
% ll - number of UE height values, kk - 3 columns for 3 DOP contours
search_opt_plot(dopP{:}, numIterH, numIterV, dop_case);
plot_dop_area(UEsizeh, UEsteph, [UEstepv:UEstepv*2:UEsizev], gNBpos, calc_case,maxdop);

% search results in an optimized DOP, 
% which improves with the number of iterations;
% the second argument is the step on plane, for generation grid of points, 
% at which DOP will be calculated with the resulting gNB configuration;
% the third argument is the height;
% in optimization there can be several UE heights, they are set in ueZ;
% [Xh, Yh, pdop, hdop, vdop] = ...
%     calculate_dop_area(UEsizeh, UEsteph, mean(ueZ(:)), gNBpos,calc_case);
% plot_res_dop(Xh, Yh, pdop, hdop, vdop, gNBpos, UEsizeh, dop_string);
% plot_res_dop_distr(Xh, Yh, ...
%     pdop, hdop, vdop, dop_string, gNBpos, maxdop);