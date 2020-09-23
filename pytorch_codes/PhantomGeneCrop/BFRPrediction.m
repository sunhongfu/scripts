char_V = ['tfs1.nii'];
char_Prediction = ['lfs1_Oct.nii'];
nii_V = load_untouch_nii(char_V); img = nii_V.img;

%% predict
zeroA = zeros(256,256,128);
zeroA(57:200, 33:224, :) = img;
V = zeroA;
[Q_pre] = MyPredict(V);

msk = V ~= 0;
pre = Q_pre .* msk;

pre = pre(57:200, 33,224,:);
nii_Prediction = make_nii(double(pre));
save_nii(nii_Prediction, char_Prediction);

