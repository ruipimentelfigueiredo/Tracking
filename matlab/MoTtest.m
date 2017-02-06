% 	//Comparison mode consts
% 	static const int COMP_POSITION = 1;
% 	static const int COMP_COLORS = 2;
% 	static const int COMP_COLORSANDPOSITION = 3;
% 	static const int COMP_FORMFEATURES = 4;
% 	static const int COMP_ALL = 5;

% 	//Metric consts
% 	static const int METRIC_MAHALANOBIS = 0;
% 	static const int METRIC_EUCLIDEAN = 1;
% 	static const int METRIC_CORRELATION = 2;
% 	static const int METRIC_INTERSECTION = 3;
% 	static const int METRIC_CHISQUARED = 4;
% 	static const int METRIC_HELLINGER = 5;
% 	static const int METRIC_EARTHMOVERSDISTANCE = 6;

clear
tic
 
%% PARAMS
 MAXIMUM_HEIGHT = 2.9;
 MINIMUM_HEIGHT = 0.9;
 
 median_window = 3;
 numberOfFramesBeforeDestruction = 5;
 numberOfFramesBeforeDestructionLocked = 3;
 creation_threshold = 0.7;
 validation_gate = 9.22;
 metric_weight = 1; %How to weight colors and positions
 recognition_threshold = 0.7;
 c_learning_rate = 0.3;
 detection_confidence = 0;
 const_pos_var = 5;
 const_vel_var = 10;
 const_accel_var = 1;
 
 UNIT_CONVERSION = 0.001;
 
 
 %% FILES STUFF
 EVALMODE = 'test';                    %test or train
 DATASET = 'AVG-TownCentre';           %test: AVG-TownCentre | PETS09-S2L2; train: PETS09-S2L1 | TUD-Stadtmitte
 ROOTDIR = 'C:\MOT_Datasets\3DMOT2015';
 
 imgDir = [ROOTDIR '\' EVALMODE '\' DATASET '\img1\'];
 
 [K, RT] = readCameraParameters([ROOTDIR '\' EVALMODE '\' DATASET '\maps\View_001.xml']);
 
 invertedK = inv(K);
 
 image_files = dir([imgDir '*.jpg']);
 nfiles = length(image_files);
 
 %Load detections
 detections = csvread([ROOTDIR '\' EVALMODE '\' DATASET 'det\det.txt']);
 
 %% Detection loop
 results = [];
for frame=1:nfiles
clear imagePoints;
clear pointsOnWorld;
clear TF1;
clear bbs;
clear TF2;
clear rects;
clear histogramList;
clear trackingPoints;
clear probabilities;
clear boundinBoxesReprojected;


%Load image
imagem = imread([imgDir image_files(frame).name]);

clear preBBS;
preBBS = detections(detections(:,1) == frame,:);

%Filter bad detections
preBBS = preBBS(preBBS(:,7) > detection_confidence,:);

bbs = [preBBS(:, 3), preBBS(:, 4), preBBS(:, 5), preBBS(:, 6), preBBS(:,7)];

imagePoints(:,1) = bbs(:,1)+bbs(:, 3)/2;
imagePoints(:,2) = bbs(:,2)+bbs(:, 4);

% This is not taking radial distortion into account. Sad. Tremendous error.
[ pointsOnWorld ] = calculatePointsOnWorldFrame( imagePoints, RT, K, invertedK,  bbs);

%Convert to meters... the camera parameters are in mm

pointsOnWorld = pointsOnWorld * UNIT_CONVERSION;

%Filter stupid detections

TF1 = pointsOnWorld(3,:) > MAXIMUM_HEIGHT;
TF2 = pointsOnWorld(3, :) < MINIMUM_HEIGHT;


toDelete = TF1 | TF2;

pointsOnWorld(:,toDelete) = [];
imagePoints(toDelete, :) = [];
bbs(toDelete,:) = [];
rects = int32(bbs(:,1:4));


[linsRect colsRect] = size(rects);
% Get Dario's color features ---------------------------

histogramList = zeros(linsRect, 444);

for i=1:linsRect
    %Each line is a BVT histogram
    beginX = rects(i,2);
    endX = rects(i,2)+rects(i,4);
    beginY = rects(i,1);
    endY = rects(i,1)+rects(i,3);
    
    if endX > size(imagem, 1)
        endX = size(imagem, 1);
    end
    if beginX <1;
       beginX = 1; 
    end
    if endY > size(imagem, 2)
        endY = size(imagem, 2);
    end
    if beginY < 1;
        beginY = 1;
    end
    
    pessoa = imagem(beginX:endX,beginY:endY,:);
    histogramList(i, :) = extractBVT_interface(pessoa, 10);
end
% ------------------------------------------------------

[ means, covariances ] = computeMeasurementStatistics( K, RT, imagePoints, rects);

%%%%%%%% 
%   Build the detections' struct array
%   Call the mex
%
%%%%%%%%

trackingPoints(:,1:3) = trackingPoints(:,1:3)/UNIT_CONVERSION;

boundinBoxesReprojected = reprojectPointsAndDraw(trackingPoints, imagem, RT, K);


pause(0.01);

[linsBBrep, colsBBrep] = size(boundinBoxesReprojected);

for ii=1:linsBBrep
   clear preResults;
   id = boundinBoxesReprojected(ii, 5);
   bb_left = boundinBoxesReprojected(ii, 1);%top left x?
   bb_top = boundinBoxesReprojected(ii, 2);%top left y?
   bb_width = boundinBoxesReprojected(ii, 3);
   bb_height = boundinBoxesReprojected(ii, 4);
   conf = 1;
   x = trackingPoints(ii, 1)/1000;
   y = trackingPoints(ii, 2)/1000;
   z = 0;
   preResults = [frame, id, bb_left, bb_top, bb_width, bb_height, conf, x, y, z];
   results = [results; preResults];
   
end

%% The results must be writen in the MoTChallenge res/data/[datasetname.txt] for evaluation

csvwrite([ROOTDIR '\' '\res\data\' DATASET '.txt'], results);
delete(personList);

%% The benchmarkDir is the train directory of the downloaded challenge, containing all the training datasets
benchmarkDir = '3DMOT2015/train/';

%% The evaluation script has 3 arguments:
%   1 - A txt that is a list of the datasets to be evaluated (file in the
%  seqmaps folder).
%   2 - A directory containing the results
%   3 - The benchmark directory
allMets = evaluateTracking('c2-train.txt', 'MoTChallenge/res/data/', benchmarkDir);

end