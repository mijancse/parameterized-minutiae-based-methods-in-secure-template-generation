clear all;
figure(52);
load 'Delta_Graph_Data___SCP-13_RMMP-2____r_10.mat';
plot(0.1:0.1:6.2,similarity_btn_real_n_secured_with_chaff, 'r', 'LineWidth', 2);
hold on

load 'Delta_Graph_Data___SCP-13_RMMP-2____r_20.mat';
plot(0.1:0.1:6.2,similarity_btn_real_n_secured_with_chaff, 'g', 'LineWidth', 2);
hold on

load 'Delta_Graph_Data___SCP-13_RMMP-2____r_30.mat';
plot(0.1:0.1:6.2,similarity_btn_real_n_secured_with_chaff, 'b', 'LineWidth', 2);
hold on


load 'Delta_Graph_Data___SCP-13_RMMP-2____r_40.mat';
plot(0.1:0.1:6.2,similarity_btn_real_n_secured_with_chaff, 'black', 'LineWidth', 2);
hold on

xlim([0.1 6.2])
ylim([0 1])
xlabel('Delta')
ylabel('Match Score')
legend('r = 10', 'r = 20', 'r = 30', 'r = 40' )

set(gcf,'position',[700 50 650 600]);