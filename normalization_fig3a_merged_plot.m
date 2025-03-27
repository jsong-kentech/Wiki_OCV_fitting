clc;clear;close all

% Cycles = {'CYC O', 'CYC 100', 'CYC 200', 'CYC 300', 'CYC 400', 'CYC 500', 'CYC 600', 'CYC 800', 'CYC 1000'};
% Stock = { , 'CYC 400', 'CYC 600', 'CYC 800', 'CYC 1000'};

% cycles1 = [0, 400, 600, 800, 1000];
% cycles2 = [0, 100, 200, 300, 400, 500]; 

%% Variable name change 

data_folder1 = "G:\공유 드라이브\GSP_Data\1C1C.mat"; 
data_folder2 = "G:\공유 드라이브\GSP_Data\QC1C cycles.mat"; 
data_folder3 = "G:\공유 드라이브\GSP_Data\new_samples.mat";
save_path = "G:\공유 드라이브\GSP_Data";


load(data_folder1);
data_merged1 = data_merged;
load(data_folder2);
data_merged2 = data_merged;
load(data_folder3);
data_merged3 = data_merged.data;


cycles1 = [0, 400, 600, 800, 1000];
cycles2 = [0, 100, 200, 300, 400, 500];

M_LLI1 = [data_merged1(1:5).NdQ_LLI];
M_LLI2 = [data_merged2(1:6).NdQ_LLI];
M_LAMp1 = [data_merged1(1:5).NdQ_LAMp];
M_LAMp2 = [data_merged2(1:6).NdQ_LAMp];
M_R1 = [data_merged1(1:5).NR];
M_R2 = [data_merged2(1:6).NR];


combined_cycles = unique([cycles1, cycles2]);


y1 = zeros(length(combined_cycles), 3); 
for i = 1:length(cycles1)
    idx = combined_cycles == cycles1(i);
    y1(idx, :) = [M_LLI1(i), M_LAMp1(i), M_R1(i)];
end


y2 = zeros(length(combined_cycles), 3); 
for i = 1:length(cycles2)
    idx = combined_cycles == cycles2(i);
    y2(idx, :) = [M_LLI2(i), M_LAMp2(i), M_R2(i)];
end

%오프셋 설정
offset_cycles = [0, 400];
offset = 16.7;

% x1 X축 위치 조정
x1_adjusted = combined_cycles;
x1_adjusted(ismember(combined_cycles, offset_cycles)) = x1_adjusted(ismember(combined_cycles, offset_cycles)) - offset;

% x2 X축 위치 조정
x2_adjusted = combined_cycles;
x2_adjusted(ismember(combined_cycles, offset_cycles)) = x2_adjusted(ismember(combined_cycles, offset_cycles)) + offset;

% 막대 그래프 설정
barWidth = 0.4; 

colors =    [0.937254901960784	0.752941176470588	0;   
             0	0.450980392156863	0.760784313725490;    
             0.125490196078431	0.521568627450980	0.305882352941177];  

data_C_Q = [56.9 56.0 55.3 54.7 53.9];
Crate_Q = [56.3 54.9 54.4 53.7 52.9];

Q_C_max = 56.9;

Q_norm1 = 1 - (abs(data_C_Q) / abs(Q_C_max));
Q_norm3 = data_merged3(1).SOH./100;
Q_norm3 = Q_norm3';



C_Q_norm1 = abs(Crate_Q) / abs(Q_C_max);

% x와 y 데이터 설정 
x = [-17, 383, 600, 800, 1000];
x3 = [-17, 200, 383, 600, 800, 1000];
y = Q_norm1;
y3 = Q_norm3;

% 보간 x 값 생성
x_fine = linspace(min(x), max(x), 100);


y_smooth = interp1(x, y, x_fine);

% y_smooth3 = zeros(length(x_fine),size(y3,2));
for i = 1:size(y3,2)
y_smooth3(:,i) = interp1(x3, y3(:,i), x_fine);
end

% plot([-17 383 600 800 1000], Q_norm1, '-s', 'LineWidth', 0.5); hold on;

% 완속충전 
hBar = bar(x1_adjusted, y1, 'stacked', 'BarWidth', barWidth, 'FaceAlpha', 0.8); hold on;
for i = 1:length(hBar)
    hBar(i).FaceColor = 'flat'; 
    hBar(i).CData =  repmat(colors(i, :), size(hBar(i).YData', 1), 1);
    hBar(i).EdgeColor = [0.301960784313725	0.733333333333333	0.835294117647059];
    hBar(i).LineWidth = 2;
end



% line_alpha = 0.2;
% scatter(x, y, 10, 'o'); 
% scatter(x_fine, y_smooth, 10, 'ob', 'MarkerFaceAlpha', line_alpha);

linestyles = {':',':',':'};
h1 = plot(x_fine, y_smooth,'Color','b','LineWidth',1.5); hold on;
for i = 1:size(y3,2)
h3 = plot(x_fine,y_smooth3(:,i),'Color','b','LineStyle',linestyles{i});
end


% ------------------------------------------
data_C_Q = [56.9 56.6 56.3 55.7 54.8 51.8];
Crate_Q = [56.6 55.9 55.6 55.0 54.1 51.4];

Q_C_max = 56.9;

Q_norm2 = 1 - (abs(data_C_Q) / abs(Q_C_max));
C_Q_norm2 = abs(Crate_Q) / abs(Q_C_max);
Q_norm4 = data_merged3(3).SOH./100;

x = [17 100 200 300 417 500];
y = Q_norm2;
y4 = Q_norm4(1:6);

x_fine = linspace(min(x), max(x), 100);

y_smooth = interp1(x, y, x_fine);
y_smooth4 = interp1(x, y4, x_fine);


hBar = bar(x2_adjusted, y2, 'stacked', 'BarWidth', barWidth, 'FaceAlpha', 0.8);
for i = 1:length(hBar)
    hBar(i).FaceColor = 'flat'; 
    hBar(i).CData =  repmat(colors(i, :), size(hBar(i).YData', 1), 1);
    hBar(i).EdgeColor = [0.933333333333333	0.298039215686275	0.592156862745098];
    hBar(i).LineWidth = 2;
end

h2 = plot(x_fine, y_smooth,'Color','r','LineWidth',1.5); 
h4 = plot(x_fine,y_smooth4,'Color','r','LineStyle',':');

xticks(combined_cycles);
xticklabels(string(combined_cycles))

xlabel('Cycles');
ylabel('$\Delta Q$', 'Interpreter', 'latex');

xlim([-34 1017]);
ylim([0 0.12]);
yticks(0:0.02:0.12);

set(gca, 'YDir', 'reverse');
set(gca, 'XTick', 0:100:1000);
xticklabels(string(0:100:1000))
grid on;
box on;


hLegend(1) = patch(NaN, NaN, [0.937254901960784	0.752941176470588	0], 'EdgeColor', 'none'); 
hLegend(2) = patch(NaN, NaN, [0	0.450980392156863	0.760784313725490], 'EdgeColor', 'none');   
hLegend(3) = patch(NaN, NaN, [ 0.125490196078431	0.521568627450980	0.305882352941177], 'EdgeColor', 'none'); 


h = legend([hLegend, h1, h3, h2, h4],{'Loss by LLI', 'Loss by LAMp', 'Loss by R', '1C Loss','1C Loss', 'QC Loss', 'QC Loss' }, 'Location', 'SouthWest', 'Box', 'on');
h.ItemTokenSize(1) = 30;
h.FontSize = 5;
 
addpath('C:\Users\GSPARK\Documents\GitHub\article_figure');
cd('G:\공유 드라이브\GSP_Data');
savefig('bar_new')
filenames = sprintf('bar_new');
figuresettings_3a(filenames,1200);


