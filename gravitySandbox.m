clear all;
close all;
%% állandók
gamma=(6.67E-11);
dt=86400*15;

masses=[2E30, 4.8E24, 6E24, 6.4E23 1.9E27];    %tömegek
positions=[0 0 ; 110E9 0; 150E9 0; 250E9 0; 750E9 0]'; %pozíciók
velocity=[0 0 ; 0 35E3; 0 30E3; 0 24E3; 0 13E3]';   %sebességek


bodyCount=length(masses);
dim=height(positions);

figure(2);

for t=0:dt:365*86400
    
    diffMatrix=[];
    for incCord=1:dim
        diffMatrix(:,:,incCord)=bsxfun(@minus,positions(incCord,:),positions(incCord,:)');
    end
    
    distMatrix=sqrt(diffMatrix(:,:,1).^2+diffMatrix(:,:,2).^2)+eye(bodyCount);%+diffMatrix(:,:,3).^2);
    normDiffMatrix=bsxfun(@rdivide,diffMatrix,distMatrix);
    massesMatrix=(ones(bodyCount)-eye(bodyCount))*sqrt((masses'*masses).*eye(bodyCount));
    
    accelMatrix=(gamma*massesMatrix./distMatrix.^2).*normDiffMatrix;
    accelVec=[accelMatrix(:,:,1)*ones(bodyCount,1),accelMatrix(:,:,2)*ones(bodyCount,1)]'
    velocity=velocity+accelVec*dt;
    positions=positions+velocity*dt
    %     clf;
    hold on;
    for incBod=1:bodyCount
        scatter(positions(1,incBod)*1E-12,positions(2,incBod)*1E-12,'.','k');
    end
    xlim([-1,1]);
    ylim([-1,1]);
    axis square;
    pause(0.001);
end