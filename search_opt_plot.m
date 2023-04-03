% optimization process plotting function
function search_opt_plot(dop, iterH, iterV, dop_case)
Nopt = size(iterH, 1); % number of optimization process cycles
n = size(iterH, 2);    % number of gNB
currInd = 1;           % start index of optimization subprocess
% on plane or height among total number of iterations (number of values in dop)
lineNum = 1;           % optimization subprocess line number,
                       % needed for alternating chart colors
nOptPrevInd = 1;       % index of the beginning of the optimization cycle,
                       % needed for text positioning Optimization cycle %i
figure('Name', ...
    sprintf('Process of gNB topology search by criterion %s ', dop_case));
plot(dop); hold on; grid on;
for j=1:Nopt % cycle by number of optimization cycles
    % cycle on the number of main gNBs (minimum number of gNBs is 4),
    % to display the optimization process on the plane
    for i=1:4
        if (mod(lineNum, 2) == 1) % for alternating chart colors
            set(gca,'ColorOrderIndex', 1);
        end
        plot(currInd:currInd+iterH(j,i)-1,dop(currInd:currInd+iterH(j,i)-1));
        textX = round(mean(currInd:currInd+iterH(j,i)-1));
        text(textX, dop(textX), ...
            sprintf('H_{%i}', i), 'HorizontalAlignment', 'center');
        currInd = currInd + iterH(j,i);
        lineNum = lineNum + 1;
    end
    
    % cycle on the number of main gNBs (minimum number of gNBs is 4),
    % to display the optimization process in heigh
    for i=1:4
        if (mod(lineNum, 2) == 1)
            set(gca,'ColorOrderIndex', 1);
        end
        plot(currInd:currInd+iterV(j,i)-1,dop(currInd:currInd+iterV(j,i)-1))
        textX = round(mean(currInd:currInd+iterV(j,i)-1));
        text(textX, dop(textX), ...
            sprintf('V_{%i}', i), 'HorizontalAlignment', 'center');
        currInd = currInd + iterV(j,i);
        lineNum = lineNum + 1;
    end
    % cycle on the number of additional gNBs,
    % to display the optimization process on the plane
    for i=5:n
        if (mod(lineNum, 2) == 1)
            set(gca,'ColorOrderIndex', 1);
        end
        plot(currInd:currInd+iterH(j,i)-1,dop(currInd:currInd+iterH(j,i)-1));
        textX = round(mean(currInd:currInd+iterH(j,i)-1));
        text(textX, dop(textX), ...
            sprintf('H_{%i}', i), 'HorizontalAlignment', 'center');
        currInd = currInd + iterH(j,i);
        lineNum = lineNum + 1;
    end
    % cycle on the number of additional gNBs,
    % to display optimization process in height
    for i=5:n
        if (mod(lineNum, 2) == 1)
            set(gca,'ColorOrderIndex', 1);
        end
        plot(currInd:currInd+iterV(j,i)-1,dop(currInd:currInd+iterV(j,i)-1));
        textX = round(mean(currInd:currInd+iterV(j,i)-1));
        text(textX, dop(textX), ...
            sprintf('V_{%i}', i), 'HorizontalAlignment', 'center');
        currInd = currInd + iterV(j,i);
        lineNum = lineNum + 1;
    end
    
    plot([currInd, currInd], [min(dop)*0.95, max(dop)*1.05], 'r--')
    text((currInd + nOptPrevInd)/2, max(dop)*1.05, ...
        sprintf('Search cycle #%i',j),'HorizontalAlignment','center');
    nOptPrevInd = currInd;
end
xlabel('Search iteration number'); ylabel(dop_case);  
end