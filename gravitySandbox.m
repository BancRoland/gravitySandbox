clear all;
close all;
%% állandók
gamma=0.1;
dt=0.1;


masses=[10, 0.01, 0.0001];    %tömegek
positions=[0 0 ; 1 0 ; 1 1]'; %pozíciók
velocity=[0 0 ; 1 0 ; 1 1]';   %sebességek

bodyCount=length(masses);
dim=height(positions);

%% vektorkülönbség mátrix (egyik égitestrő a másikba milyen vektor mutat)

diffMatrix=[];
    for incCord=1:dim
        diffMatrix(:,:,incCord)=bsxfun(@minus,positions(incCord,:),positions(incCord,:)');
    end


%% távolság mátrix (egyik égites többitől mért távolsága)
distMatrix=sqrt(diffMatrix(:,:,1).^2+diffMatrix(:,:,2).^2)+eye(bodyCount);%+diffMatrix(:,:,3).^2);
normDiffMatrix=bsxfun(@rdivide,diffMatrix,distMatrix);
massesMatrix=(ones(bodyCount)-eye(bodyCount))*sqrt((masses'*masses).*eye(bodyCount));
    
%% gyorsulásmátrix (egyik égitest többi fele mérhető gyorsulása)
accelMatrix=(gamma*massesMatrix./distMatrix.^2).*normDiffMatrix;
accelVec=[accelMatrix(:,:,1)*ones(bodyCount,1),accelMatrix(:,:,2)*ones(bodyCount,1)]'


%%  kirajzolása a kezdeti pozícióknak

figure;
xlim([-2,2]);
ylim([-2,2]);
hold on;
for incBod=1:bodyCount %pozíciók kirajzolása
    scatter(positions(1,incBod),positions(2,incBod));
end

for inc=2:bodyCount %erők kirajzolása
    scatter(accelMatrix(1,inc,1),accelMatrix(1,inc,2),'x');
end