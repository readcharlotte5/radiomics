
%ECPFS
% categories = ["Age" "KPS" "NSCLC" "Number of Mets" "Any Driver" "EGFR" "ALK" "BRAF" "KRAS" "PD-L1" "ROS1" "Other"];
% valuesECPFS = [0.1 0.1 0.1 1 2 11 1 0.1 1 0.1 0.1 0.1];
% figure
% bar(categories, valuesECPFS)
% 
% %ICPFS
% valuesICPFS = [0.1 0.1 0.1 0.1 1 0.1 0.1 0.1 0.1 0.1 0.1 0.1];
% figure
% bar(categories, valuesICPFS)
% 
% %OS
% valuesOS = [0.1 0.1 0.1 0.1 0.1 0.1 0.1 0.1 0.1 0.1 0.1 0.1];
% figure
% bar(categories, valuesOS)
%%
% for t=1:10000
% H1(t)=normrnd(0,0.05);
% H2(t)=normrnd(0,0.10); 
% H3(t)=normrnd(0,0.30);
% end

% map = brewermap(3,'Set1'); 
% figure
% histf(H1,-1.3:.01:1.3,'facecolor',map(1,:),'facealpha',.5,'edgecolor','none')
% hold on
% histf(H2,-1.3:.01:1.3,'facecolor',map(2,:),'facealpha',.5,'edgecolor','none')
% histf(H3,-1.3:.01:1.3,'facecolor',map(3,:),'facealpha',.5,'edgecolor','none')
% box off
% axis tight
% legalpha('H1','H2','H3','transparent blue box','transparent red box','transparent green','location','northwest')
% legend boxoff

figure
h1 = histogram('Categories',{'Age' 'KPS' 'NSCLC' 'Number of Mets' 'Any Driver' 'EGFR' 'ALK' 'BRAF' 'KRAS' 'PD-L1' 'ROS1' 'Other'},'BinCounts',[0.1 0.1 0.1 1 2 11 1 0.1 1 0.1 0.1 0.1])
hold on
h2 = histogram('Categories',{'Age' 'KPS' 'NSCLC' 'Number of Mets' 'Any Driver' 'EGFR' 'ALK' 'BRAF' 'KRAS' 'PD-L1' 'ROS1' 'Other'},'BinCounts',[0.1 0.1 0.1 0.1 1 0.1 0.1 0.1 0.1 0.1 0.1 0.1])
h3 = histogram('Categories',{'Age' 'KPS' 'NSCLC' 'Number of Mets' 'Any Driver' 'EGFR' 'ALK' 'BRAF' 'KRAS' 'PD-L1' 'ROS1' 'Other'},'BinCounts',[0.1 0.1 0.1 0.1 0.1 0.1 0.1 0.1 0.1 0.1 0.1 0.1])
set(h1,'FaceColor',[0 0 1],'EdgeColor','none',facealpha,0.2,'DisplayName','ECPFS');
set(h2,'FaceColor',[1 0 0],'EdgeColor','none',facealpha,0.2,'DisplayName','ICPFS');
set(h3,'FaceColor',[1 0 0],'EdgeColor','none',facealpha,0.2,'DisplayName','Overall Survival');
hold off
legend

