clear all;
load 200_fingers_matching_info_v2;
size=200;
figure;
for i=1:size
    max_data(i) = max(Match_Score(i,1:1));
end
plot(max_data(1:size), 'Color', [1 0 1], 'LineWidth', 1);
hold on
for i=1:size
    max_data(i) = max(Match_Score(i,1:2));
end
plot(max_data(1:size), 'Color', [0 1 1], 'LineWidth', 1)
hold on
for i=1:size
    max_data(i) = max(Match_Score(i,1:3));
end
plot(max_data(1:size), 'g', 'LineWidth', 1);
hold on
for i=1:size
    max_data(i) = max(Match_Score(i,1:4));
end
plot(max_data(1:size), 'b', 'LineWidth', 1);
hold on
for i=1:size
    max_data(i) = max(Match_Score(i,1:5));
end
plot(max_data(1:size), 'r', 'LineWidth', 1);
xlim([0 size+1])
ylim([0 1])
xlabel('Fingerprint')
ylabel('Match Score')
legend('1 Impr DB', '2 Imprs DB', '3 Imprs DB', '4 Imprs DB', '5 Imprs DB' )

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure
for i=1:size
    max_data(i) = max(Match_Score(i,1:1));
end
imprs_1_accuracy = max_data;
stem(max_data(1:size), 'Color', [1 0 1]);
xlim([0 size+1])
ylim([0 1])
xlabel('Fingerprint')
ylabel('Match Score')

figure
for i=1:size
    max_data(i) = max(Match_Score(i,1:2));
end
stem(max_data(1:size), 'Color', [0 1 1]);
xlim([0 size+1])
ylim([0 1])
xlabel('Fingerprint')
ylabel('Match Score')

figure
for i=1:size
    max_data(i) = max(Match_Score(i,1:3));
end
stem(max_data(1:size), 'g');
xlim([0 size+1])
ylim([0 1])
xlabel('Fingerprint')
ylabel('Match Score')

figure
for i=1:size
    max_data(i) = max(Match_Score(i,1:4));
end
stem(max_data(1:size), 'b');
xlim([0 size+1])
ylim([0 1])
xlabel('Fingerprint')
ylabel('Match Score')

figure
for i=1:size
    max_data(i) = max(Match_Score(i,1:5));
end
imprs_5_accuracy = max_data;
stem(max_data(1:size), 'r');
xlim([0 size+1])
ylim([0 1])
xlabel('Fingerprint')
ylabel('Match Score')


figure
plot(imprs_5_accuracy-imprs_1_accuracy, 'Color', [0 .5 1], 'LineWidth', 1);
xlim([0 size+1])
ylim([0 1])
xlabel('Fingerprint')
ylabel('Match Score Increased')
title('Accuracy Increased from 1 Impr DB to 5 Imprs DB')
