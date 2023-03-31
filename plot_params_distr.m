% function for plotting distributions of topology spatial parameters
function plot_params_distr(inds, mininds, maxinds, ...
    dn, dphi1n, hn, dop_case, pdop, hdop, vdop, dop_string)
str0=sprintf('Distribution of gNB spatial parameters'); 
figure('Name',strcat(str0, dop_string));
n=size(dn,1); % gNB number
counts=50;    % number of split intervals

% the most characteristic distances
subplot(2,2,1); hold on; grid on; 
str1=sprintf('Distribution of gNB distances'); title(strvcat(str1, dop_string));
for i=1:n histogram(dn(i,:), counts+i, 'Normalization','probability'); end 
legendCelldn = strsplit(sprintf('\\itd_{%i} ', 1:n));
legend(legendCelldn(1:end-1));
xlabel('\itd_{n}'); ylabel('\itf(\itd_{\itn})');

% the most characteristic angles
subplot(2,2,2); hold on; grid on;
str2=sprintf('Distribution of gNB angles'); title(strvcat(str2, dop_string));
set(gca,'ColorOrderIndex', 2);  
for i=1:n-1 histogram(dphi1n(i,:), counts+i,'Normalization','probability'); end
legendCelldphi = strsplit(sprintf('\\Delta\\phi_{1%i} ', 2:n));
legend(legendCelldphi(1:end-1));
xlabel('\Delta\phi_{1\itn}'); ylabel('\itf(\Delta\phi_{1\itn})');

% the most characteristic heights
subplot(2,2,3); hold on; grid on; 
str3=sprintf('Distribution of gNB heights'); title(strvcat(str3, dop_string));
for i=1:n histogram(hn(i,:), counts+i, 'Normalization','probability'); end
legendCellh = strsplit(sprintf('\\ith_{%i} ', 1:n));
legend(legendCellh(1:end-1));
xlabel('\ith_{n}'); ylabel('\itf(\ith_{\itn})');

% DOP distribution
subplot(2,2,4); hold on; grid on; 
str4=sprintf('DOP distribution'); title(strvcat(str4, dop_string));
if dop_case=='HDOP'
    vdoph = vdop(inds); vdoph = vdoph(mininds:maxinds);
    histogram(vdoph, 95, 'Normalization', 'probability');  
    pdoph = pdop(inds); pdoph = pdoph(mininds:maxinds);
    histogram(pdoph, 100, 'Normalization', 'probability');  
    xlabel('DOP'); ylabel('\itf(\rmDOP)'); legend('VDOP','PDOP');
elseif dop_case=='VDOP'
    hdopv = hdop(inds); hdopv = hdopv(mininds:maxinds);
    histogram(hdopv, 95, 'Normalization', 'probability');  
    pdopv = pdop(inds); pdopv = pdopv(mininds:maxinds);
    histogram(pdopv, 100, 'Normalization', 'probability');  
    xlabel('DOP'); ylabel('\itf(\rmDOP)'); legend('HDOP','PDOP');
elseif dop_case=='PDOP'
    hdopp = hdop(inds); hdopp = hdopp(mininds:maxinds);
    histogram(hdopp, 95, 'Normalization', 'probability');  
    vdopp = vdop(inds); vdopp = vdopp(mininds:maxinds);
    histogram(vdopp, 100, 'Normalization', 'probability');  
    xlabel('DOP'); ylabel('\itf(\rmDOP)'); legend('HDOP','VDOP');
end        
end