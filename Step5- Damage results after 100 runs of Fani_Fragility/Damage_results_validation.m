clear all
clc

load Collapse_100_runs
load PDS_100_runs
load Total_100_runs

% Mean and median of results
Mean_Total = mean(Total_100_runs);
Median_Total = median(Total_100_runs);

Mean_Col = mean(Collapse_100_runs);
Median_Col = median(Collapse_100_runs);

Mean_PDS = mean(PDS_100_runs);
Median_PDS = median(PDS_100_runs);


figure(1)

set(gcf, 'Units', 'inches', 'Position', [0 0 4.5 3.5])
histogram(Total_100_runs)
hold on
plot([128 128],[0 10],'r','LineStyle','--','LineWidth',2)

box on
grid on
set(gca, 'Fontname','Times New Roman','fontsize', 12);
xlabel('Total damaged towers')
ylabel('Count')