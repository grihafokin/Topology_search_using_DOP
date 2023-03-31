function plot_dop_area(sizeh, UEsteph, UEh, gNBm, calc_case,varargin)
nUEh = length(UEh); 
figure;
for k=1:nUEh
    [Xh, Yh, pdop, hdop, vdop] = ...
        calculate_dop_area(sizeh, UEsteph, UEh(k), gNBm,calc_case);
    if(length(varargin) == 1)
        maxhdop = varargin{1};
        maxpdop = varargin{1};
        maxvdop = varargin{1};
    else
        maxpdop = mean(pdop(:));
        maxhdop = mean(hdop(:));
        maxvdop = mean(vdop(:));
    end
    pdopm = pdop; pdopm(pdopm > maxpdop) = 0;
    hdopm = hdop; hdopm(hdopm > maxhdop) = 0;
    vdopm = vdop; vdopm(vdopm > maxvdop) = 0;
    
    sb = subplot(nUEh,3,1+3*(k-1)); hold on; grid on; 
    contour(Xh, Yh, hdopm, 5,'r','ShowText','on'); 
    % contour(Xh, Yh, hdopm,'r'); 
    title(sprintf('Positioning area, satisfying HDOP<%.1f', maxhdop));
    plot_res_topology2D(gNBm); legend('HDOP');
    
    subplot(nUEh,3,2+3*(k-1)); hold on; grid on;
    contour(Xh, Yh, vdopm, 5,'b','ShowText','on');  
    % contour(Xh, Yh, vdopm,'b'); 
    title(sprintf('Positioning area, satisfying VDOP<%.1f', maxvdop));
    plot_res_topology2D(gNBm); legend('VDOP');

    subplot(nUEh,3,3+3*(k-1)); hold on; grid on;
    contour(Xh, Yh, pdopm,5, 'g','ShowText','on'); 
    % contour(Xh, Yh, pdopm,'g');
    title(sprintf('Positioning area, satisfying PDOP<%.1f', maxpdop));
    plot_res_topology2D(gNBm); legend('PDOP');
        
    annotation('textbox',[0.03, sb.Position(2)+sb.Position(4)/1.85,0.05,...
        0.01],'string',sprintf('h_{UE}=%.0f m',UEh(k)),'LineStyle','none');
    end
end