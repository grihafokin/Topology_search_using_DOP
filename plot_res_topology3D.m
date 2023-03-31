% topology plotting function in the space in 3D
function plot_res_topology3D(gNB, sizeh, UEsizeh, dop_string)
n = size(gNB, 1);
ang = wrapTo360(atan2d(gNB(:,2), gNB(:,1)));
dist = sqrt(sum(gNB(:,1:2).^2, 2));

str0=sprintf('gNB topology in space');
figure('Name',strcat(str0,dop_string)); title(char(str0,dop_string));
hold on; grid on; 
for j=1:n
    plot3(gNB(j,1), gNB(j,2), gNB(j,3), 'o','linewidth',3); 
    set(gca,'ColorOrderIndex',j);
    plot3([gNB(j,1); gNB(j,1)], [gNB(j,2); gNB(j,2)], ...
        [0; gNB(j,3)], 'linewidth',3);
    str1=sprintf('gNB_{%.0f} (%.0f, %.0f, %.1f);',...
        j,gNB(j,1),gNB(j,2),gNB(j,3));
    str2=sprintf('h_%i=%.1f m', j, gNB(j,3));
    str3=sprintf('d_%i=%.1f m', j, dist(j));
    str4=sprintf('\\Delta\\phi_{1%i}=%.0f\\circ',...
        j, wrapTo180(ang(j)-ang(1))); 
    text(gNB(j,1),gNB(j,2),gNB(j,3),char(str1,str2,str3,str4));
    set(gca,'ColorOrderIndex',j);
    plot([0; gNB(j,1)], [0; gNB(j,2)], '--', 'linewidth',3);
end
for j=2:n
    set(gca,'ColorOrderIndex',j); arcEnd = sort([ang(1), ang(j)]);
    arcAng = linspace(arcEnd(1), arcEnd(2), 20);
    plot_arc(arcAng, dist(j)*0.12*(j-1), [0, 0]);
end
xlabel('x, m'); ylabel('y, m'); zlabel('z, m'); view(-30, 80);
workArea = [-UEsizeh, -UEsizeh; -UEsizeh,  UEsizeh; 
             UEsizeh,  UEsizeh;  UEsizeh, -UEsizeh]/2;
workAreaPlgn = polyshape(workArea);
plot(workAreaPlgn, 'FaceColor', [255,  0,  0]./255, 'EdgeColor', 'none');
% axis([-sizeh/2 sizeh/2, -sizeh/2, sizeh/2]);
plot(0, 0, 'mo','linewidth',3); axis('tight');
% text(0, 0, sprintf('UE (%.0f, %.0f, %.0f)', [0,0,3]));
end