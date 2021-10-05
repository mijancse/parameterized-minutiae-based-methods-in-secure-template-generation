clear all
load('CSE_FP_TMP_DB_v2.mat'); 
singleTemplate = Templates{99,1};
x=singleTemplate(:,1);
y=singleTemplate(:,2);
TRI = delaunay(x,y);
trimesh(TRI,x,y); 