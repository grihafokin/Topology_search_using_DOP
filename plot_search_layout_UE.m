% function for plotting a grid of UE 
% locations for which the search is performed
function plot_search_layout_UE(gNBpos, ueX, ueY, ueZ,...
    UEsizeh, UEsteph, UEsizev)
str0=('UE placement grid for');
str1=(strcat(' \itD=',num2str(UEsizeh),' m, ',...
    ' \DeltaD=',num2str(UEsteph),' m,'));
str2=(strcat(' \itV=',num2str(UEsizev),' m, '));
str=strcat(str0,str1,str2);
figure('Name',str); hold on;
nH = size(ueZ, 3);
for i=1:nH
    plot3(ueX(:,:,i), ueY(:,:,i), ueZ(:,:,i),...
        'o', 'Color', [0, 113, 188]/255); hold on;
end   
plot_res_topology2D(gNBpos);
title(str); legend('UE');
grid on; xlabel('x, m'); ylabel('y, m');
end