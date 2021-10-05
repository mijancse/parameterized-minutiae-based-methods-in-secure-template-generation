clear all;
figure(51);
load 'r_Graph_Data___SCP-13_RMMP-2___delta-0_8.mat';
plot(1:1:50,similarity_btn_real_n_secured_with_chaff, 'r', 'LineWidth', 2);
hold on

load 'r_Graph_Data___SCP-13_RMMP-2___delta-2_5.mat';
plot(1:1:50,similarity_btn_real_n_secured_with_chaff, 'g', 'LineWidth', 2);
hold on

load 'r_Graph_Data___SCP-13_RMMP-2___delta-4_1.mat';
plot(1:1:50,similarity_btn_real_n_secured_with_chaff, 'b', 'LineWidth', 2);
hold on

load 'r_Graph_Data___SCP-13_RMMP-2___delta-5_6.mat';
plot(1:1:50,similarity_btn_real_n_secured_with_chaff, 'black', 'LineWidth', 2);
hold on



xlim([1 50])
ylim([0 1])
xlabel('Radius')
ylabel('Match Score')
legend('delta = 0.8', 'delta = 2.5', 'delta = 4.1', 'delta = 5.6' )

set(gcf,'position',[0 50 650 600]);