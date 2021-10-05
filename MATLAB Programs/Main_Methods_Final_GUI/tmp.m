k=1;
for i=1:size(Templates,1)
    a(i)=str2num(Templates{i,2})
    display(Templates{i,2})
end

a=unique(a)
for i=1:size(a,2)
    Information{i,1}=a(i)
end

k=1;
for i=46:1:46+45
    Information{i,1}=InformationNEW{k,1};
    Information{i,2}=InformationNEW{k,2};
    Information{i,3}=InformationNEW{k,3};
    Information{i,4}=InformationNEW{k,4};
    Information{i,5}=InformationNEW{k,5};
    k=k+1;
end

filename = 'tmp 2015-16.xlsx';
[NUM, TEXT, InformationNEW] = xlsread(filename);


%% info index
info_index = find(cell2mat(Information(:,1))==17102030);
name = Information{info_index, 2};