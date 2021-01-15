function [niiA, niiP] = export_to_nii(img, ARG)

    fnA = [ARG.FileName(1:(end-4)), '_A.nii'];
    fnP = [ARG.FileName(1:(end-4)), '_P.nii'];
    niiA = make_nii(single(abs  (img)));
    niiP = make_nii(single(angle(img)));
    save_nii(niiA,fnA);
    save_nii(niiP,fnP);

end