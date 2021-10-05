clear all;

load('FVC_2002_DB1_B_Fuzzy_Ultimate_v17_Ter&Bif.mat'); 

[ChaffRemovedTemplate, Chaffs] = RemoveChaff_Ultimate_TER_BIF(Templates{11,1});

Draw_Figure(Templates{11,1}, 'Minutiae Got from Template DB')

Draw_Figure_Combined(ChaffRemovedTemplate,Chaffs, 'Real Minutiae Moved & Chaff Minutiae Detected')

Draw_Figure_Real_Only(ChaffRemovedTemplate, 'Remained Real Minutiae for Matching')
        
display(['Minutiae Imbalance : ' num2str(Templates{1,6} - size(Chaffs,1)) ' || Chaff In Tmp : ' num2str(Templates{1,6}) ' || Chaff Removed : ' num2str(size(Chaffs,1)) ])
        
