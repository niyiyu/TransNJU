Xmin = 400000;
Xmax = 400200;
Ymin = 3554400;
Ymax = 3554600;
Zmin = 0;
Zmax = -880;
load('./vel.mat');
%%
vel_pad = vel;
vel_pad = padarray(vel_pad,[64,0,0],'replicate','pre');
vel_pad = padarray(vel_pad,[14,0,0],'replicate','post');

vel_pad = padarray(vel_pad,[0,80,0],'replicate','pre');
vel_pad = padarray(vel_pad,[0,93,0],'replicate','post');

% vel_pad = padarray(vel_pad,[64,0,0],'replicate','pre');
% vel_pad = padarray(vel_pad,[0,0,0],'replicate','post');
L = 3500*ones(size(vel_pad(:,:,1)));
for i = 1:234
    i
    vel_pad = cat(3,vel_pad,L);
end