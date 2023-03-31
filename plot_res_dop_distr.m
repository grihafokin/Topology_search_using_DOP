function plot_res_dop_distr(Xh, Yh,...
    pdop, hdop, vdop, dop_string, gNBm, maxdop)
str0=sprintf('HDOP, VDOP, PDOP distribution in positioning area');
figure('Name',strcat(str0,dop_string)); hold on; grid on;

subplot(3,2,1); hold on; grid on;
title(char(sprintf('HDOP distribution in positioning area'),dop_string));
histogram(hdop, 100, 'Normalization', 'probability');  
xlabel('HDOP'); ylabel('\itf(\rmHDOP)');

subplot(3,2,3); hold on; grid on;
title(char(sprintf('VDOP distribution in positioning area'),dop_string));
histogram(vdop, 100, 'Normalization', 'probability');  
xlabel('VDOP'); ylabel('\itf(\rmVDOP)');

subplot(3,2,5); hold on; grid on;
title(char(sprintf('PDOP distribution in positioning area'),dop_string));
histogram(pdop, 100, 'Normalization', 'probability');  
xlabel('PDOP'); ylabel('\itf(\rmPDOP)');

subplot(3,2,6); hold on; grid on;
title(char(sprintf('Positioning area, that meets the conditions'), ...
    dop_string));
mx=size(pdop,1); ny=size(pdop,2);
pdopm=zeros(mx,ny); hdopm=zeros(mx,ny); vdopm=zeros(mx,ny);
for i=1:mx
    for j=1:ny
        if pdop(i,j)<maxdop
            pdopm(i,j)=pdop(i,j);
        end
        if hdop(i,j)<maxdop
            hdopm(i,j)=hdop(i,j);
        end
        if vdop(i,j)<maxdop
            vdopm(i,j)=vdop(i,j);
        end
    end
end
subplot(3,2,2); hold on; grid on; 
contour(Xh, Yh, hdopm, 'r','ShowText','on'); 
%contour(Xh, Yh, hdopm,'r'); contourf(Xh, Yh, hdopm, 'r','ShowText','on');
title(char(sprintf('Positioning area, that meets conditions HDOP<%.1f',...
    maxdop),dop_string));
plot_res_topology2D(gNBm); legend('HDOP'); 

subplot(3,2,4); hold on; grid on;
contour(Xh, Yh, vdopm, 'b','ShowText','on'); 
% contour(Xh, Yh, vdopm,'b'); contourf(Xh, Yh, vdopm, 'b','ShowText','on');
title(char(sprintf('Positioning area, that meets conditions VDOP<%.1f',...
    maxdop),dop_string));
plot_res_topology2D(gNBm); legend('VDOP'); 

subplot(3,2,6); hold on; grid on;
contour(Xh, Yh, pdopm, 'g','ShowText','on'); 
% contour(Xh, Yh, pdopm,'g'); contourf(Xh, Yh, pdopm, 'g','ShowText','on');
title(char(sprintf('Positioning area, that meets conditions PDOP<%.1f',...
    maxdop),dop_string));
plot_res_topology2D(gNBm); legend('PDOP'); 
end