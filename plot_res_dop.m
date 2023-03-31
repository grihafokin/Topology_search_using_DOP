% DOP plotting function for a given gNB topology in positioning area
function plot_res_dop(Xh, Yh, pdop, hdop, vdop, gNBm, UEsizeh, dop_string)
str0=sprintf('HDOP, VDOP, PDOP');
figure('Name',strcat(str0,dop_string)); hold on; grid on;
workArea = [-UEsizeh, -UEsizeh; -UEsizeh,  UEsizeh; 
             UEsizeh,  UEsizeh;  UEsizeh, -UEsizeh]/2;
workAreaPlgn = polyshape(workArea);

subplot(2,2,1); surf(Xh, Yh, hdop); colorbar; hold on; grid on;
title(char(sprintf('HDOP in positioning area'),dop_string));
xlabel('x, m'); ylabel('y, m'); zlabel('HDOP'); 
plot_res_topology2D(gNBm); hold on; axis('tight');
plot(workAreaPlgn, 'FaceColor', [255,  0,  0]./255, 'EdgeColor', 'none');

subplot(2,2,2); surf(Xh, Yh, vdop); colorbar; hold on; grid on;
title(char(sprintf('VDOP in positioning area'),dop_string));
xlabel('x, m'); ylabel('y, m'); zlabel('VDOP'); 
plot_res_topology2D(gNBm); hold on; axis('tight');
plot(workAreaPlgn, 'FaceColor', [255,  0,  0]./255, 'EdgeColor', 'none');

subplot(2,2,3); surf(Xh, Yh, pdop); colorbar; hold on; grid on;
title(char(sprintf('PDOP in positioning area'),dop_string));
xlabel('x, m'); ylabel('y, m'); zlabel('PDOP'); 
plot_res_topology2D(gNBm); hold on; axis('tight');
plot(workAreaPlgn, 'FaceColor', [255,  0,  0]./255, 'EdgeColor', 'none');

subplot(2,2,4); hold on; grid on;
title(char(sprintf('Placement of gNB on a plane'),dop_string));
plot_res_topology2D(gNBm); hold on; axis('tight');
plot(workAreaPlgn, 'FaceColor', [255,  0,  0]./255, 'EdgeColor', 'none');
end