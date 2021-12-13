clear all;
close all;
%% állandók
ob1=1;
ob2=3;

gamma=0.1;
dt=0.3;
T=500*dt;

masses=[5, 5, 0.01];    %tömegek
positions=[-1 0 ; 1 0; 5 0]'; %pozíciók
velocity=[0 -0.3 ; 0 0.3 ; 0 0.44]';   %sebességek

bodyCount=length(masses);
dim=height(positions);

figure(2);
set(gcf,'units','normalized','outerposition',[0 0 1 1]);

distGraph=[];   %leendő távolsgáfüggvény
angleGraph=[];
intensityGraph=[];
t=0:dt:T;

% subplot(4,1,[1,3]);
% xlim([-5,5]);
% ylim([-5,5]);
% axis square;

% subplot(4,1,4);
% xlim([0,T]);
% ylim([0,1.5]);

for incT=1:length(t)
    
    diffMatrix=[];
    for incCord=1:dim
        diffMatrix(:,:,incCord)=bsxfun(@minus,positions(incCord,:),positions(incCord,:)');
    end
    
    distMatrix=sqrt(diffMatrix(:,:,1).^2+diffMatrix(:,:,2).^2)+eye(bodyCount);%+diffMatrix(:,:,3).^2);
    normDiffMatrix=bsxfun(@rdivide,diffMatrix,distMatrix);
    massesMatrix=(ones(bodyCount)-eye(bodyCount))*sqrt((masses'*masses).*eye(bodyCount));
    
    accelMatrix=(gamma*massesMatrix./distMatrix.^2).*normDiffMatrix;
    accelVec=[accelMatrix(:,:,1)*ones(bodyCount,1),accelMatrix(:,:,2)*ones(bodyCount,1)]';
    velocity=velocity+accelVec*dt;
    positions=positions+velocity*dt;
    
    distGraph=[distGraph distMatrix(ob1,ob2)];  %ábrázolni kívánt távolságfüggvény
    angleGraph=[angleGraph atan2d(diffMatrix(ob1,ob2,2),diffMatrix(ob1,ob2,1))];
    intensityGraph=[intensityGraph 1/distMatrix(ob1,ob2)^2];
    %     clf;
    
    subplot(4,1,[1,2]);
    hold on;
    grid on;
    for incBod=1:bodyCount
        scatter(positions(1,incBod),positions(2,incBod),'.','k');
    end
    axis([-5 5 -5 5]);
    axis square;
    %     subplot(2,1,1);
    %     xlim([-5,5]);
    %     ylim([-5,5]);
    
    %     axis square;
    %
    
    subplot(4,1,3)
    title('Távolság a csillagtól');
    grid on;
    hold on;
    plot(t(1:incT),distGraph,'k')
    axis([0 T 0 (max(distGraph)+0.1)]);
    
    subplot(4,1,4)
    title('Besugárzott teljesítmény');
    grid on;
    hold on;
    plot(t(1:incT),intensityGraph,'k')
    axis([0 T 0 (max(intensityGraph)+0.1)]);

    
    %     subplot(4,1,4)
    %     plot(t(1:incT),angleGraph)
    %     axis([0 T -180 180]);
    
    pause(0.001);
end