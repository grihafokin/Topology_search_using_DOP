% topology plotting function on the plane in 2D
function plot_res_topology2D(gNBm)
n = size(gNBm, 1);
plot(gNBm(:,1), gNBm(:,2),'ko','MarkerSize',3,'linewidth',2); 
nbText = strsplit(sprintf('gNB_{%i} ', 1:n));
text(gNBm(:,1), gNBm(:,2), vertcat(nbText{:}));
xlabel('x, m'); ylabel('y, m');
end