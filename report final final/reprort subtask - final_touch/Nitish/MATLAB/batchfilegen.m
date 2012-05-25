qmr_cond(1,3,50);
qmr_cond(1,3,100);
steepcg_cond(1,3,50);
steepcg_cond(1,3,100);
steepcg_cond(2,3,20);
steepcg_cond(2,3,50);
qmr_cond(2,3,50);
qmr_cond(2,3,100);


qmr_dim(1,20);
qmr_dim(1,50);
steepcg_dim(1,20);
steepcg_dim(1,40);
qmr_dim(2,10);
qmr_dim(2,20);
steepcg_dim(2,10);
steepcg_dim(2,15);


disp('PHASE 2');
steepcg_dim(1,500);
steepcg_cond(1,3,500);
qmr_dim(1,500);
qmr_cond(1,3,500);
