figure
h1 = histogram('Categories',{'EX' 'IX' 'TB1' 'TB2' 'TB3'},'FontSize',12,'BinCounts',[1.8081 1.2943 0.8544 1.0249 0.5525])
% hold on
% h2 = histogram('Categories',{'Age' 'KPS' 'NSCLC' 'Number of Mets' 'Any Driver' 'EGFR' 'ALK' 'BRAF' 'KRAS' 'PD-L1' 'ROS1' 'Other'},'BinCounts',[0.1 0.1 0.1 0.1 1 0.1 0.1 0.1 0.1 0.1 0.1 0.1])
% h3 = histogram('Categories',{'Age' 'KPS' 'NSCLC' 'Number of Mets' 'Any Driver' 'EGFR' 'ALK' 'BRAF' 'KRAS' 'PD-L1' 'ROS1' 'Other'},'BinCounts',[0.1 0.1 0.1 0.1 0.1 0.1 0.1 0.1 0.1 0.1 0.1 0.1])
% set(h1,'FaceColor',[0 0 1],'EdgeColor','none',facealpha,0.2,'DisplayName','ECPFS');
% set(h2,'FaceColor',[1 0 0],'EdgeColor','none',facealpha,0.2,'DisplayName','ICPFS');
% hold off
% legend
%xlabel('Population','FontSize',12,'FontWeight','bold','Color','r')
%%
figure
h1 = histogram('Categories',{'EX' 'IX' 'TB1' 'TB2' 'TB3'},'BinCounts',[0.104 0.14 0.114 0.144 0.105])
hold on
h2 = histogram('Categories',{'EX' 'IX' 'TB1' 'TB2' 'TB3'},'BinCounts',[0.031 0.018 0.029 0.028 0.027])
ylim([0 0.6]);
yline(0.5, 'LineWidth', 2, 'Color', 'r');
yline(0.25, 'LineWidth', 2, 'Color', 'm');
%legend('Max Error', 'Absolute Median Error (mm)', 'Tolerance', 'Action Level')
set(h1,'FaceColor',[0 0 1],'EdgeColor','none',facealpha,0.2,'DisplayName','Max Error');
set(h2,'FaceColor',[1 0 0],'EdgeColor','none',facealpha,0.2,'DisplayName','Absolute Median Error (mm)');
hold off

% %%
% figure
% y = [2 4 6 10 14 16 20];
% TB2 = [0.39 0.64 0.89 1.4 1.9 2.17 2.68];
% plot(TB2, y, '-x', 'color', 'b', Linewidth=1.5)
% ylim([-2 22])
% xlim([0 3])
% hold on
% syms x
% yTB2 = 7.8613*x-1.0249;
% fplot(yTB2,[0 3], 'color', 'b', Linewidth=1.5)
% grid on
% 
% TB1 = [0.37 0.62 0.87 1.38 1.89 2.15 2.66];
% plot(TB1, y, '-x', 'color', 'r', Linewidth=1.5)
% ylim([-2 22])
% xlim([0 3])
% hold on
% syms x
% yTB1 = 7.852*x-.8544;
% fplot(yTB1,[0 3], 'color', 'r', Linewidth=1.5)
% 
% TB3 = [0.35 0.61 0.88 1.41 1.95 2.22 2.76];
% plot(TB3, y, '-x', 'color', 'g', Linewidth=1.5)
% ylim([-2 22])
% xlim([0 3])
% hold on
% syms x
% yTB3 = 7.456*x-.5525;
% fplot(yTB3,[0 3], 'color', 'g', Linewidth=1.5)
% 
% EX = [0.51 0.77 1.03 1.57 2.11 2.37 2.90];
% plot(EX, y, '-x', 'color', 'c', Linewidth=1.5)
% ylim([-2 22])
% xlim([0 3])
% hold on
% syms x
% yEX = 7.5134*x-1.8081;
% fplot(yEX,[0 3], 'color', 'c', Linewidth=1.5)
% 
% IX = [0.44 0.70 0.97 1.505 2.03 2.29 2.83];
% plot(IX, y, '-x', 'color', 'm', Linewidth=1.5)
% ylim([-2 22])
% xlim([0 3])
% hold on
% syms x
% yIX = 7.5204*x-1.2943;
% fplot(yIX,[0 3], 'color', 'm', Linewidth=1.5)
% 
% fplot(0,'color','k')

%%
figure
y = [2 4 6 10 14 16 20];
TB2 = [0.39 0.64 0.89 1.4 1.9 2.17 2.68];
plot(y,TB2, '-x', 'color', 'b', Linewidth=1.5)
xlim([-2.5 22])
ylim([-0.5 3])
hold on
syms x
yTB2 = (x+1.0249)/7.8613;
fplot(yTB2,[-2.5 22], 'color', 'b', Linewidth=1.5)
grid on

TB1 = [0.37 0.62 0.87 1.38 1.89 2.15 2.66];
plot(y,TB1, '-x', 'color', 'c', Linewidth=1.5)
xlim([-2.5 22])
ylim([-0.5 3])
hold on
syms x
yTB1 = (x+.8544)/7.852;
fplot(yTB1,[-2.5 22], 'color', 'c', Linewidth=1.5)

TB3 = [0.35 0.61 0.88 1.41 1.95 2.22 2.76];
plot(y,TB3, '-x', 'color', 'g', Linewidth=1.5)
xlim([-2.5 22])
ylim([-0.5 3])
hold on
syms x
yTB3 = (x+.5525)/7.456;
fplot(yTB3,[-2.5 22], 'color', 'g', Linewidth=1.5)


EX = [0.51 0.77 1.03 1.57 2.11 2.37 2.90];
plot(y,EX, '-x', 'color', 'm', Linewidth=1.5)
xlim([-2.5 22])
ylim([-0.5 3])
hold on
syms x
yEX = (x+1.8081)/7.5134;
fplot(yEX,[-2.5 22], 'color', 'm', Linewidth=1.5)

IX = [0.44 0.70 0.97 1.505 2.03 2.29 2.83];
plot(y,IX, '-x', 'color', 'r', Linewidth=1.5)
xlim([-2.5 22])
ylim([-0.5 3])
hold on
syms x
yIX = (x+1.2943)/7.5204;
fplot(yIX,[-2.5 22], 'color', 'r', Linewidth=1.5)


fplot(0,'color','k')
xline(0, 'color', 'k')
