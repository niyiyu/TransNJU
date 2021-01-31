% Interpolate the topography with elevation data from reveivers and profile
% . Various methods have been tested with griddata function.
% In order to implement a buffer area, padarray is used, which replicates
% the boundaries. Finally, these topography datas are written in a SEM
% interface format.
% 
% Yiyu Ni
% Jan 26, 2021



close all
load('./Elevation/GPS2.mat');
load('./Elevation/Profile.mat');
profile = [S0;S1;S2;S3;S4;S5;S6;S7;S8;S9];

[xx_pad, yy_pad] = meshgrid(3554000:10:3557000, 400000:10:402500);
[xx, yy] = meshgrid(3554500:10:3556500, 400400:10:402100);
% v4
% nearest
% natural
% cubic
% linear
method = 'v4';
topo = griddata([GPS2(:,1);profile(:,1)],[GPS2(:,2);profile(:,2)],[GPS2(:,3);profile(:,3)],xx,yy,method);

topo_pad = padarray(topo,[40,50],'replicate','both');
topo_grad = gradient(topo_pad);
% figure()

% surf(xx,yy,topo);
% axis equal
% figure()
subplot(2,2,1)
contourf(yy_pad,xx_pad,topo_pad, 20);hold on
plot(GPS2(:,2), GPS2(:,1),'r.');
plot(profile(:,2), profile(:,1),'r.');
xlabel('UTM Axis Y [m]', 'FontSize', 20);
ylabel('UTM Axis X [m]', 'FontSize', 20);
title(['NJU Topography (', method, ' interpolation)'], 'FontSize', 20)
colorbar
axis equal
ylabel(colorbar,'Elevation [m]', 'FontSize', 20);

subplot(2,2,2)
contourf(yy_pad,xx_pad,topo_grad, 20);hold on
% plot(GPS2(:,2), GPS2(:,1),'r*');
xlabel('UTM Axis Y [m]', 'FontSize', 20);
ylabel('UTM Axis X [m]', 'FontSize', 20);
title('NJU Topography Gradient', 'FontSize', 20)
colorbar
axis equal
ylabel(colorbar,'Elevation Gradient [1]', 'FontSize', 20);
%
%smoothing
N = 10;
filter = ones(N,N)/N^2;
topo_smooth = imfilter(topo_pad, filter,'replicate');
subplot(2,2,3)
contourf(yy_pad,xx_pad,topo_smooth, 20);hold on
xlabel('UTM Axis Y [m]', 'FontSize', 20);
ylabel('UTM Axis X [m]', 'FontSize', 20);
title('NJU Topography Gradient (smoothing)', 'FontSize', 20)
colorbar
axis equal

subplot(2,2,4)
topo_grad_smooth = gradient(topo_smooth);
contourf(yy_pad,xx_pad,topo_grad_smooth, 20);hold on
xlabel('UTM Axis Y [m]', 'FontSize', 20);
ylabel('UTM Axis X [m]', 'FontSize', 20);
title('NJU Topography Gradient (smoothing)', 'FontSize', 20)
colorbar
axis equal



%%
contour(yy_pad,xx_pad,topo_pad, 20);hold on
% plot(GPS2(:,2), GPS2(:,1),'r^');
% xlabel('UTM Axis Y [m]', 'FontSize', 20);
% ylabel('UTM Axis X [m]', 'FontSize', 20);
% title('NJU Topography (linear interpolation)', 'FontSize', 20)
colorbar
axis equal
ylabel(colorbar,'Elevation [m]', 'FontSize', 20);
set(gcf,'color','none');
set(gca,'color','none'); 
set(gcf,'InvertHardCopy','off');
%%
path = '/Volumes/YiyuNiWDC/TransNJU/DATA/meshfem3D_files';
%write top interface
fid = fopen([path, '/interface4.dat'],'w');
for i = 1:251
    for j = 1:301
        fprintf(fid, '%6.2f \n', topo_smooth(i,j));
    end
end
fclose(fid);

%%
%write middle interface
fid = fopen([path, '/interface3.dat'],'w');
for i = 1:251
    for j = 1:301
        fprintf(fid, '%6.2f \n', -100.);
    end
end
fclose(fid);
%write middle interface
fid = fopen([path, '/interface2.dat'],'w');
for i = 1:251
    for j = 1:301
        fprintf(fid, '%6.2f \n', -500.);
    end
end
fclose(fid);
%write bottom interface
fid = fopen([path, '/interface1.dat'],'w');
for i = 1:251
    for j = 1:301
        fprintf(fid, '%6.2f \n', -800.);
    end
end
fclose(fid);
