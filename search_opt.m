% gNB position optimization function
function [gNBpos, gNBposP, dopP, i] = ...
    search_opt(nk, gNBpos, ueX, ueY, ueZ, dSizeH, dSizeV,...
    angStep, Xlim, Ylim, Zlim, maxIter, dop_case, calc_case, optDir)
% Output parameters:
% gNBpos - gNB coordinates after optimizing the position of the nk-th gNB
% gNBposP - intermediate gNB coordinates after nk-th gNB position optimization
% dopP - intermediate DOP values after optimization of the nk-th gNB position
% i - number of iterations performed to optimize the position of the nk-th gNB
% Input parameters:
% nk - gNB number, whose position is being optimized
% gNBpos - array of coordinates of all gNBs
% ueX, ueY, ueZ - arrays of UE coordinates
% dSizeH - optimization step on the plane
% dSizeV - optimization step in height
% angStep - array of azimuths, specifying the direction of the position optimization step
% Xlim, Ylim, Zlim - arrays of gNB position bounds
% maxIter - the maximum number of iterations of the optimization process
% dop_case - optimization criterion (HDOP, VDOP, PDOP)
% optDir - position optimization plane (on the plane, in height)
Nd = numel(ueX);            % number of UE points
% determination of the number of gNB position optimization points
switch (optDir)
    case 'H'
        % number of points in the vicinity of the nkth gNB for optimization on the plane
        Nnext = length(angStep);
    case 'V'
        % number of points in the vicinity of the nkth gNB for height optimization
        Nnext = 2;
end            
% cell array for storing intermediate results of gNB coordinate optimization
gNBposP = cell(1); 
% cell array to store intermediate DOP values during optimization
dopP = cell(1);   

% calculation of DOP at the beginning of the iteration, 
% as an average over all UE position points (ueX, ueY, ueZ)
dop0 = 0;
gNBposP{1} = [gNBposP{1}; gNBpos(nk,:)];
for k=1:Nd
    [pdop0k, hdop0k, vdop0k] = calculate_dop(gNBpos, [ueX(k), ueY(k), ueZ(k)], calc_case);
    switch (dop_case)
        case 'PDOP'
            dop0 = dop0 + pdop0k;
        case 'HDOP'
            dop0 = dop0 + hdop0k;
        case 'VDOP'
            dop0 = dop0 + vdop0k;
    end
end
% to calculate the average over the entire volume of UE locations
dop0 = dop0/Nd; 
    
% the main cycle of the optimization process
for i=1:maxIter
    dopP{1} = [dopP{1}, dop0];
    switch (optDir)
        % calculation of the array of coordinates of points in the vicinity 
        % of the nk-th gNB on the plane for current optimization iteration 
        % (Nnext new positions)
        case 'H'
            % calculation of the X coordinate of new Nnext points
            gNBposXnext = gNBpos(nk, 1) + cos(angStep)*dSizeH;
            % calculation of the Y coordinate of new Nnext points
            gNBposYnext = gNBpos(nk, 2) + sin(angStep)*dSizeH;
            % limitation of point coordinates in accordance with 
            % the boundaries of the gNB position on the plane
            gNBposXnext(gNBposXnext < Xlim(1)) = Xlim(1);      
            gNBposXnext(gNBposXnext > Xlim(end)) = Xlim(end);  
            gNBposYnext(gNBposYnext < Ylim(1)) = Ylim(1);      
            gNBposYnext(gNBposYnext > Ylim(end)) = Ylim(end);  
        % calculation of the array of coordinates of points in the vicinity
        % of the nk-th gNB in height for the current optimization iteration
        case 'V' 
            % calculation of the height of new Nnext points
            gNBposZnext = gNBpos(nk, 3) + [-dSizeV, dSizeV];
            % height limit for new points on minimum and maximum values
            gNBposZnext(gNBposZnext < Zlim(1)) = Zlim(1);
            gNBposZnext(gNBposZnext > Zlim(end)) = Zlim(end);
    end % switch (optDir)
    
    % DOP calculation, taking into account new Nnext position points 
    % of the nk-th gNB; for Nnext points in the vicinity of the nkth gNB,
    % whose coordinates were calculated in switch (optDir)
    dopNext = zeros(1, Nnext);
    for j=1:Nnext
        % formation of an array of gNB coordinates, 
        % taking into account the position points of the nk-th gNB
        gNBposNext = gNBpos;
        switch (optDir)
            case 'H'
                % formation of an array of gNB coordinates, in which on each
                % iteration j algorithm uses the new coordinates (for the given
                % of the case x and y only) of nk-th gNB from among Nnext points
                gNBposNext(nk,:) = ...
                    [gNBposXnext(j), gNBposYnext(j), gNBpos(nk, 3)];
            case 'V'
                % formation of an array of gNB coordinates, in which on each
                % iteration j algorithm uses the new coordinates (for the given
                % of the case only z) of nk-th gNB from among Nnext points
                gNBposNext(nk,:) = ...
                    [gNBpos(nk, 1), gNBpos(nk, 2), gNBposZnext(j)];
                % gNBposNext(:,3) = gNBposZnext(:, j);
        end
        % calculation of DOP for the i-th iteration, as an 
        % average over all UE position points (ueX, ueY, ueZ)
        for k=1:Nd
            [pdopNj, hdopNj, vdopNj] = ...
                calculate_dop(gNBposNext, [ueX(k), ueY(k), ueZ(k)], calc_case);
            switch (dop_case)
                case 'PDOP'
                    dopNext(j) = dopNext(j) + pdopNj;
                case 'HDOP'
                    dopNext(j) = dopNext(j) + hdopNj;
                case 'VDOP'
                    dopNext(j) = dopNext(j) + vdopNj;
            end
        end
    end
    dopNext = dopNext./Nd;
    
    % finding the minimum DOP value among Nnext positions of the nk-th gNB
    [minDop, indMin] = min(dopNext);
    
    % if the new value of minDop is less than the value, received at the 
    % beginning iteration dop0, then use new coordinates of nk-th gNB 
    % (from Nnext new ones) for which DOP is minimal; if minDop > dop0, 
    % then decrease step optimization of position of nk-th gNB 
    % on the plane (dSizeH) and/or in height (dSizeV)
    if (minDop < dop0)            
        switch (optDir)
            case 'H'
                gNBpos(nk,1:2) = [gNBposXnext(indMin), gNBposYnext(indMin)];
            case 'V'
                gNBpos(nk,3) = gNBposZnext(indMin);
        end
        % if found a new position of the nk-th gNB (which gives a smaller dop),
        % then overwrite the dop0 value for subsequent optimization iterations
        dop0 = minDop;
    else
        switch (optDir)
            case 'H'
                % if among the new Nnext points there are no thoseб that reduce
                % dop, then we reduce the optimization step on the plane, thereby
                % narrowing the search area for the optimal position of gNB on the plane
                dSizeH = dSizeH*0.7; 
            case 'V'
                % if among the new Nnext points there are no thoseб that reduce
                % dop, then we reduce optimization step in height, thereby
                % narrowing the search area for the optimal gNB position in height
                dSizeV = dSizeV*0.85;
        end
    end % if (minDop < dop0)   
    
    % completion of the position optimization process,
    % if the optimization step becomes small
    switch (optDir)
        case 'H'
            % completion of the process of optimizing the position on the 
            % plane, if the optimization step becomes less than 1 m

            if (dSizeH < 1)
                break; % exit from the main loop for i=1:maxIter
            end
        case 'V'           
            % completion of the position optimization process in height,
            % if the optimization step becomes less than 0.2 m
            if (dSizeV < 0.2)
                break; % exit from the main loop for i=1:maxIter
            end
    end
end % for i=1:maxIter
end