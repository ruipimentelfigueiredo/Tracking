function [ K, RT, ks, ps ] = readCamParamsCI()

%Nao tenho paciencia
FocalLengthX = 2696.35888671875000000000;
FocalLengthY = 2696.35888671875000000000;
PrincipalPointX = 959.50000000000000000000;
PrincipalPointY = 539.50000000000000000000;
Skew = 0.00000000000000000000;
TranslationX = -0.05988363921642303467;
TranslationY = 3.83331298828125000000;
TranslationZ = 12.39112186431884765625;
RotationX = 0.69724917918208628720;
RotationY = -0.43029624469563848566;
RotationZ = 0.28876888503799524877;
RotationW = 0.49527896681027261394;
DistortionK1 = -0.60150605440139770508;
DistortionK2 = 4.70203733444213867188;
DistortionP1 = -0.00047452122089453042;
DistortionP2 = -0.00782289821654558182;


ks = [DistortionK1, DistortionK2];
ps = [DistortionP1, DistortionP2];

K = [FocalLengthX, 0 , PrincipalPointX;
    0, FocalLengthY, PrincipalPointY;
    0, 0, 1];

quat = [RotationW, RotationX, RotationY, RotationZ];
R = quat2rotm(quat);
T = [TranslationX; TranslationY; TranslationZ];
RT = [R T];

end