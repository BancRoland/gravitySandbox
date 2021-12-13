clear all;
close all;
%% állandók
pow=0; %távolság hatványkitevője (a valóságban -2)
gamma=0.1;
dt=0.1;
T=1000*dt;

masses=[10, 0, 0];    %tömegek
positions=[0 0 ; 1 0 ; 2 0]'; %pozíciók
velocity=[0 0 ; 0 1 ; 0 2]';   %sebességek

bodyCount=length(masses);
dim=height(positions);

figure(2);

for t=0:dt:T
    
    diffMatrix=[];
    for incCord=1:dim
        diffMatrix(:,:,incCord)=bsxfun(@minus,positions(incCord,:),positions(incCord,:)');
    end
    
    distMatrix=sqrt(diffMatrix(:,:,1).^2+diffMatrix(:,:,2).^2)+eye(bodyCount);%+diffMatrix(:,:,3).^2);
    normDiffMatrix=bsxfun(@rdivide,diffMatrix,distMatrix);
    massesMatrix=(ones(bodyCount)-eye(bodyCount))*sqrt((masses'*masses).*eye(bodyCount));
    
    accelMatrix=(gamma*massesMatrix.*distMatrix.^pow).*normDiffMatrix;
    accelVec=[accelMatrix(:,:,1)*ones(bodyCount,1),accelMatrix(:,:,2)*ones(bodyCount,1)]';
    velocity=velocity+accelVec*dt;
    positions=positions+velocity*dt;
    %     clf;
    hold on;
    for incBod=1:bodyCount
        scatter(positions(1,incBod),positions(2,incBod),'.','k');
    end
    xlim([-5,5]);
    ylim([-5,5]);
    axis square;
    pause(0.001);
end