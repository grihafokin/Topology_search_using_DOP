% DOP calculation function for a given topology
function [Xh, Yh, pdop, hdop, vdop]=...
    calculate_res_dop(sizeh, UEsteph, UE, gNBm, calc_case)
% UE grid
xh = -sizeh/2:UEsteph:sizeh/2; yh = -sizeh/2:UEsteph:sizeh/2; zh = UE(3); 
[Xh, Yh] = meshgrid(xh, yh); mx=length(xh); ny=length(yh);
hdop=zeros(mx,ny); vdop=zeros(mx,ny); pdop=zeros(mx,ny); 
for m=1:mx
    for n=1:ny
        [pdop(m,n),hdop(m,n),vdop(m,n)] = ...
            calculate_dop(gNBm,[xh(m),yh(n),zh],calc_case);
    end
end
end