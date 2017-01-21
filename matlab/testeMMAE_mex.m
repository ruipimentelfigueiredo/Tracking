loadData;
%Transform the -1 into Inf

noisyPerson1XY(noisyPerson1XY==-1) = Inf;

T = 1/15;

%% Constant position model

filterBank(1).modelName='Constant Position';
filterBank(1).stateTransitionModel = [1 0; 0 1];
filterBank(1).observationModel = [1 0; 0 1];
filterBank(1).processNoiseCov = [T^2 0; 0 T^2];
filterBank(1).observationNoiseCov = [0.9299 0; 0 0.9299];
filterBank(1).initialState = [1; 1];
filterBank(1).initialCov = 1000*eye(2);


%% Constant velocity model
filterBank(2).modelName='Constant Velocity';
filterBank(2).stateTransitionModel = [1 0 T 0; 0 1 0 T; 0 0 1 0; 0 0 0 1];
filterBank(2).observationModel = [1 0 0 0; 0 1 0 0];
filterBank(2).processNoiseCov = [T^4/4 0 T^3/2 0; 0 T^4/4 0 T^3/2; T^3/2 0 T^2 0; 0 T^3/2 0 T^2];
filterBank(2).observationNoiseCov = [0.9299 0; 0 0.9299];
filterBank(2).initialState = [1; 1; 0; 0];
filterBank(2).initialCov = 1000*eye(4);



%% Constant acceleration model
filterBank(3).modelName='Constant Acceleration';
filterBank(3).stateTransitionModel = [1 0 T 0 T^2/2 0;
                                       0 1 0 T 0 T^2/2;
                                       0 0 1 0 T 0;
                                       0 0 0 1 0 T;
                                       0 0 0 0 1 0;
                                       0 0 0 0 0 1];                               
filterBank(3).observationModel = [1 0 0 0 0 0; 0 1 0 0 0 0];
filterBank(3).processNoiseCov = [T^5/20 0 T^4/8 0 T^3/6 0;
                                0 T^5/20 0 T^4/8 0 T^3/6;
                                T^4/8 0 T^3/3 0 T^2/2 0;
                                0 T^4/8 0 T^3/3 0 T^2/2;
                                T^3/6 0 T^2/2 0 T 0;
                                0 T^3/6 0 T^2/2 0 T];
filterBank(3).observationNoiseCov = [0.9299 0; 0 0.9299];
filterBank(3).initialState = [1; 1; 0; 0; 1; 2];
filterBank(3).initialCov = 1000*eye(6);


mmaEstimator = MMAE_kalman('new', filterBank);


disp('-------- MMAE ----------')
tic
for k=1:numel(noisyPerson1XY(:, 1))
    
    location = [noisyPerson1XY(k, 1) noisyPerson1XY(k, 2)];
    
    MMAE_kalman('predict', mmaEstimator);
    state = MMAE_kalman('getStatePrediction', mmaEstimator);
    stateCov = MMAE_kalman('getStateCovariancePrediction', mmaEstimator);

    covHistoryPred{k} = stateCov;
    
    if location(1) == Inf || location(2) == Inf
    %[state, stateCov] = BiermanKF('update_empty', kfBIERMAN);
    else
    MMAE_kalman('update', mmaEstimator, location);
    end
    state = MMAE_kalman('getStatePosterior', mmaEstimator);
    stateCov = MMAE_kalman('getStateCovariancePosterior', mmaEstimator);
    
    stateMMAEHist{k} = state;
    trackedLocationMMAE(k,1) = state(1);
    trackedLocationMMAE(k,2) = state(2);
    covHistoryPostMMAE{k} = stateCov;
    conditionNumberMMAE(k) = cond(stateCov);
    
    probsVect = MMAE_kalman('getAllModelProbabilities', mmaEstimator);
    
    probPos(k) = probsVect(1);
    probVel(k) = probsVect(2);
    probAccel(k) = probsVect(3);
    
end
toc
MMAE_kalman('delete', mmaEstimator);

disp('-----------------------------------------')