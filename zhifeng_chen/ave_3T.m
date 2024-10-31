nii = load_nii('/Volumes/LaCie_Bottom/collaborators/Zhifeng_Chen/Recon_Results_3T_TR72ms_TE36ms/img_pocs/pocs1/src/mag.nii');
mag1 = double(nii.img);

nii =  load_nii('/Volumes/LaCie_Bottom/collaborators/Zhifeng_Chen/Recon_Results_3T_TR72ms_TE36ms/img_pocs/pocs1/iQSM_wholehead/iQSM_plus.nii');
iQSM_wholehead1 = double(nii.img);

nii = load_nii('/Volumes/LaCie_Bottom/collaborators/Zhifeng_Chen/Recon_Results_3T_TR72ms_TE36ms/img_pocs/pocs2/src/mag.nii');
mag2 = double(nii.img);

nii =  load_nii('/Volumes/LaCie_Bottom/collaborators/Zhifeng_Chen/Recon_Results_3T_TR72ms_TE36ms/img_pocs/pocs2/iQSM_wholehead/iQSM_plus.nii');
iQSM_wholehead2 = double(nii.img);

mag_ave = (mag1 + mag2)/2;
iQSM_wholehead_ave = (iQSM_wholehead1 + iQSM_wholehead2)/2;

mkdir /Volumes/LaCie_Bottom/collaborators/Zhifeng_Chen/Recon_Results_3T_TR72ms_TE36ms/img_pocs/ave
cd /Volumes/LaCie_Bottom/collaborators/Zhifeng_Chen/Recon_Results_3T_TR72ms_TE36ms/img_pocs/ave

nii = make_nii(mag_ave, [1 1 1]);
save_nii(nii, 'mag_ave.nii');

nii = make_nii(iQSM_wholehead_ave, [1 1 1]);
save_nii(nii, 'iQSM_wholehead_ave.nii');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

nii = load_nii('/Volumes/LaCie_Bottom/collaborators/Zhifeng_Chen/Recon_Results_3T_TR72ms_TE36ms/img_buda/buda1/src/mag.nii');
mag1 = double(nii.img);

nii =  load_nii('/Volumes/LaCie_Bottom/collaborators/Zhifeng_Chen/Recon_Results_3T_TR72ms_TE36ms/img_buda/buda1/iQSM_wholehead/iQSM_plus.nii');
iQSM_wholehead1 = double(nii.img);

nii = load_nii('/Volumes/LaCie_Bottom/collaborators/Zhifeng_Chen/Recon_Results_3T_TR72ms_TE36ms/img_buda/buda2/src/mag.nii');
mag2 = double(nii.img);

nii =  load_nii('/Volumes/LaCie_Bottom/collaborators/Zhifeng_Chen/Recon_Results_3T_TR72ms_TE36ms/img_buda/buda2/iQSM_wholehead/iQSM_plus.nii');
iQSM_wholehead2 = double(nii.img);

mag_ave = (mag1 + mag2)/2;
iQSM_wholehead_ave = (iQSM_wholehead1 + iQSM_wholehead2)/2;

mkdir /Volumes/LaCie_Bottom/collaborators/Zhifeng_Chen/Recon_Results_3T_TR72ms_TE36ms/img_buda/ave
cd /Volumes/LaCie_Bottom/collaborators/Zhifeng_Chen/Recon_Results_3T_TR72ms_TE36ms/img_buda/ave

nii = make_nii(mag_ave, [1 1 1]);
save_nii(nii, 'mag_ave.nii');

nii = make_nii(iQSM_wholehead_ave, [1 1 1]);
save_nii(nii, 'iQSM_wholehead_ave.nii');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

nii = load_nii('/Volumes/LaCie_Bottom/collaborators/Zhifeng_Chen/Recon_Results_7T_TR50ms_TE25ms/img_pocs/pocs1/src/mag.nii');
mag1 = double(nii.img);

nii =  load_nii('/Volumes/LaCie_Bottom/collaborators/Zhifeng_Chen/Recon_Results_7T_TR50ms_TE25ms/img_pocs/pocs1/iQSM_wholehead/iQSM_plus.nii');
iQSM_wholehead1 = double(nii.img);

nii = load_nii('/Volumes/LaCie_Bottom/collaborators/Zhifeng_Chen/Recon_Results_7T_TR50ms_TE25ms/img_pocs/pocs2/src/mag.nii');
mag2 = double(nii.img);

nii =  load_nii('/Volumes/LaCie_Bottom/collaborators/Zhifeng_Chen/Recon_Results_7T_TR50ms_TE25ms/img_pocs/pocs2/iQSM_wholehead/iQSM_plus.nii');
iQSM_wholehead2 = double(nii.img);

mag_ave = (mag1 + mag2)/2;
iQSM_wholehead_ave = (iQSM_wholehead1 + iQSM_wholehead2)/2;

mkdir /Volumes/LaCie_Bottom/collaborators/Zhifeng_Chen/Recon_Results_7T_TR50ms_TE25ms/img_pocs/ave
cd /Volumes/LaCie_Bottom/collaborators/Zhifeng_Chen/Recon_Results_7T_TR50ms_TE25ms/img_pocs/ave

nii = make_nii(mag_ave, [1 1 1]);
save_nii(nii, 'mag_ave.nii');

nii = make_nii(iQSM_wholehead_ave, [1 1 1]);
save_nii(nii, 'iQSM_wholehead_ave.nii');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

nii = load_nii('/Volumes/LaCie_Bottom/collaborators/Zhifeng_Chen/Recon_Results_7T_TR50ms_TE25ms/img_buda/buda1/src/mag.nii');
mag1 = double(nii.img);

nii =  load_nii('/Volumes/LaCie_Bottom/collaborators/Zhifeng_Chen/Recon_Results_7T_TR50ms_TE25ms/img_buda/buda1/iQSM_wholehead/iQSM_plus.nii');
iQSM_wholehead1 = double(nii.img);

nii = load_nii('/Volumes/LaCie_Bottom/collaborators/Zhifeng_Chen/Recon_Results_7T_TR50ms_TE25ms/img_buda/buda2/src/mag.nii');
mag2 = double(nii.img);

nii =  load_nii('/Volumes/LaCie_Bottom/collaborators/Zhifeng_Chen/Recon_Results_7T_TR50ms_TE25ms/img_buda/buda2/iQSM_wholehead/iQSM_plus.nii');
iQSM_wholehead2 = double(nii.img);

mag_ave = (mag1 + mag2)/2;
iQSM_wholehead_ave = (iQSM_wholehead1 + iQSM_wholehead2)/2;

mkdir /Volumes/LaCie_Bottom/collaborators/Zhifeng_Chen/Recon_Results_7T_TR50ms_TE25ms/img_buda/ave
cd /Volumes/LaCie_Bottom/collaborators/Zhifeng_Chen/Recon_Results_7T_TR50ms_TE25ms/img_buda/ave

nii = make_nii(mag_ave, [1 1 1]);
save_nii(nii, 'mag_ave.nii');

nii = make_nii(iQSM_wholehead_ave, [1 1 1]);
save_nii(nii, 'iQSM_wholehead_ave.nii');