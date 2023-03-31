% function for calculating distributions of gNB configuration parameters
function [dnd, dnm, dphi1nd, dphi1nm, hnd, hnm] = ...
    calculate_params_distr(dn, dphi1n, hn)
n=size(dn,1); % number of gNB
counts=100;   % number of split intervals
dnd=zeros(n,counts); dnm=zeros(1,n); 
hnd=zeros(n,counts); hnm=zeros(1,n);
for i=1:n
    % range distribution and most characteristic ranges
    [dnd(i,:),dndedges(i,:)] = histcounts(dn(i,:),...
        counts,'Normalization', 'probability');
    [~, dnd_maxind(i)]=max(dnd(i,:));
    dnm(i)=mean(dndedges(i,dnd_maxind(i):dnd_maxind(i)+1));
    % height distribution and most characteristic heights
    [hnd(i,:),hndedges(i,:)] = histcounts(hn(i,:),...
        counts,'Normalization', 'probability');
    [~, hnd_maxind(i)]=max(hnd(i,:));
    hnm(i)=mean(hndedges(i,hnd_maxind(i):hnd_maxind(i)+1));
end
dphi1nd=zeros(n-1,counts); dphi1nm=zeros(1,n-1); 
for i=1:n-1
    % distribution of angles and most characteristic angles
    [dphi1nd(i,:),dphi1ndedges(i,:)] = histcounts(dphi1n(i,:),...
        counts,'Normalization', 'probability');
    [~, dphi1nd_maxind(i)]=max(dphi1nd(i,:));
    dphi1nm(i)=mean(dphi1ndedges(i,dphi1nd_maxind(i):dphi1nd_maxind(i)+1));
end  
end