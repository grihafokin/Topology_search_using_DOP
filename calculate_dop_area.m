% DOP calculations for a given placement 
% of gNB in region of sizeh with step UEsteph
function [Xh, Yh, pdop, hdop, vdop] = ...
    calculate_dop_area(sizeh, UEsteph, UEh, gNBm,calc_case)
% UE placement grid
xh = -sizeh/2:UEsteph:sizeh/2; yh = -sizeh/2:UEsteph:sizeh/2; 
[Xh, Yh] = meshgrid(xh, yh);
n = numel(Xh);
hdop=zeros(size(Xh)); vdop=zeros(size(Xh)); pdop=zeros(size(Xh));
for m=1:n
    [pdop(m),hdop(m),vdop(m)] = ...
        calculate_dop(gNBm,[Xh(m),Yh(m),UEh],calc_case);
end
end