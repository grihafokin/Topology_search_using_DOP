% function to plot gNB and UE location grid in space
function plot_search_layout_gNB(X, Y, Z, UE, sizeh, steph, sizev, stepv)
str0=('gNB location:');
str1=(strcat(' \itD=',num2str(sizeh),' m, ',...
    ' \DeltaD=',num2str(steph),' m,'));
str2=(strcat(' \itV=',num2str(sizev),' m, ',...
    ' \DeltaV=',num2str(stepv),' m;'));
str3=(strcat(' UE=(',num2str(UE(1)),',',...
    num2str(UE(2)),',',num2str(UE(3)),') m'));
str=strcat(str0,str1,str2,str3);
figure('Name',str); 
plot3(UE(1),UE(2),UE(3),'mo','MarkerSize',5,'linewidth',2);hold on;
for i=1:length(X)
    for j=1:length(Y)
        for k=1:length(Z)
            plot3(X(i),Y(j),Z(k),'ko','MarkerSize',2,'linewidth',1);
            hold on;
        end
    end
end
title(str); legend('UE','gNB'); hold on; grid on;
xlabel('x, m');  ylabel('y, m'); zlabel('z, m'); 
end