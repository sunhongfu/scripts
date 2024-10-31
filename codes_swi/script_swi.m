
%% run these in MATLAB
cd /media/data/ME-MP2RAGE/01_VM_H257/QSM_MEMP2RAGE_7T/src
do_unwrap_swi('mag_corr1_n4.mnc', 'ph_corr1.mnc', 'swi_unwrap_echo_1_of_4.mnc', 'phase_unwrap_echo_1_of_4.mnc', '../BET_mask.mnc', 0.1, 1, 4, 1);
do_unwrap_swi('mag_corr2_n4.mnc', 'ph_corr2.mnc', 'swi_unwrap_echo_2_of_4.mnc', 'phase_unwrap_echo_2_of_4.mnc', '../BET_mask.mnc', 0.15, 1, 4, 1);
do_unwrap_swi('mag_corr3_n4.mnc', 'ph_corr3.mnc', 'swi_unwrap_echo_3_of_4.mnc', 'phase_unwrap_echo_3_of_4.mnc', '../BET_mask.mnc', 0.2, 1, 4, 1);
do_unwrap_swi('mag_corr4_n4.mnc', 'ph_corr4.mnc', 'swi_unwrap_echo_4_of_4.mnc', 'phase_unwrap_echo_4_of_4.mnc', '../BET_mask.mnc', 0.25, 1, 4, 1);
unix('./multi_echo_swi_unwrapped.pl mag_corr ph_corr ../BET_mask.mnc 4 combined_unwrap_swi.mnc');

do_swi('mag_corr1_n4.mnc', 'ph_corr1.mnc', 'swi_echo_1_of_4.mnc', 'phase_echo_1_of_4.mnc', 0.1, 1);
do_swi('mag_corr2_n4.mnc', 'ph_corr2.mnc', 'swi_echo_2_of_4.mnc', 'phase_echo_2_of_4.mnc', 0.15, 1);
do_swi('mag_corr3_n4.mnc', 'ph_corr3.mnc', 'swi_echo_3_of_4.mnc', 'phase_echo_3_of_4.mnc', 0.2, 1);
do_swi('mag_corr4_n4.mnc', 'ph_corr4.mnc', 'swi_echo_4_of_4.mnc', 'phase_echo_4_of_4.mnc', 0.25, 1);
unix('./multi_echo_swi.pl mag_corr ph_corr 4 combined_swi.mnc');




cd /media/data/ME-MP2RAGE/02_JF_H446/QSM_MEMP2RAGE_7T/src
do_unwrap_swi('mag_corr1_n4.mnc', 'ph_corr1.mnc', 'swi_unwrap_echo_1_of_4.mnc', 'phase_unwrap_echo_1_of_4.mnc', '../BET_mask.mnc', 0.1, 1, 4, 1);
do_unwrap_swi('mag_corr2_n4.mnc', 'ph_corr2.mnc', 'swi_unwrap_echo_2_of_4.mnc', 'phase_unwrap_echo_2_of_4.mnc', '../BET_mask.mnc', 0.15, 1, 4, 1);
do_unwrap_swi('mag_corr3_n4.mnc', 'ph_corr3.mnc', 'swi_unwrap_echo_3_of_4.mnc', 'phase_unwrap_echo_3_of_4.mnc', '../BET_mask.mnc', 0.2, 1, 4, 1);
do_unwrap_swi('mag_corr4_n4.mnc', 'ph_corr4.mnc', 'swi_unwrap_echo_4_of_4.mnc', 'phase_unwrap_echo_4_of_4.mnc', '../BET_mask.mnc', 0.25, 1, 4, 1);
unix('./multi_echo_swi_unwrapped.pl mag_corr ph_corr ../BET_mask.mnc 4 combined_unwrap_swi.mnc');

do_swi('mag_corr1_n4.mnc', 'ph_corr1.mnc', 'swi_echo_1_of_4.mnc', 'phase_echo_1_of_4.mnc', 0.1, 1);
do_swi('mag_corr2_n4.mnc', 'ph_corr2.mnc', 'swi_echo_2_of_4.mnc', 'phase_echo_2_of_4.mnc', 0.15, 1);
do_swi('mag_corr3_n4.mnc', 'ph_corr3.mnc', 'swi_echo_3_of_4.mnc', 'phase_echo_3_of_4.mnc', 0.2, 1);
do_swi('mag_corr4_n4.mnc', 'ph_corr4.mnc', 'swi_echo_4_of_4.mnc', 'phase_echo_4_of_4.mnc', 0.25, 1);
unix('./multi_echo_swi.pl mag_corr ph_corr 4 combined_swi.mnc');



cd /media/data/ME-MP2RAGE/03_MP_H447/QSM_MEMP2RAGE_7T/src
do_unwrap_swi('mag_corr1_n4.mnc', 'ph_corr1.mnc', 'swi_unwrap_echo_1_of_4.mnc', 'phase_unwrap_echo_1_of_4.mnc', '../BET_mask.mnc', 0.1, 1, 4, 1);
do_unwrap_swi('mag_corr2_n4.mnc', 'ph_corr2.mnc', 'swi_unwrap_echo_2_of_4.mnc', 'phase_unwrap_echo_2_of_4.mnc', '../BET_mask.mnc', 0.15, 1, 4, 1);
do_unwrap_swi('mag_corr3_n4.mnc', 'ph_corr3.mnc', 'swi_unwrap_echo_3_of_4.mnc', 'phase_unwrap_echo_3_of_4.mnc', '../BET_mask.mnc', 0.2, 1, 4, 1);
do_unwrap_swi('mag_corr4_n4.mnc', 'ph_corr4.mnc', 'swi_unwrap_echo_4_of_4.mnc', 'phase_unwrap_echo_4_of_4.mnc', '../BET_mask.mnc', 0.25, 1, 4, 1);
unix('./multi_echo_swi_unwrapped.pl mag_corr ph_corr ../BET_mask.mnc 4 combined_unwrap_swi.mnc');

do_swi('mag_corr1_n4.mnc', 'ph_corr1.mnc', 'swi_echo_1_of_4.mnc', 'phase_echo_1_of_4.mnc', 0.1, 1);
do_swi('mag_corr2_n4.mnc', 'ph_corr2.mnc', 'swi_echo_2_of_4.mnc', 'phase_echo_2_of_4.mnc', 0.15, 1);
do_swi('mag_corr3_n4.mnc', 'ph_corr3.mnc', 'swi_echo_3_of_4.mnc', 'phase_echo_3_of_4.mnc', 0.2, 1);
do_swi('mag_corr4_n4.mnc', 'ph_corr4.mnc', 'swi_echo_4_of_4.mnc', 'phase_echo_4_of_4.mnc', 0.25, 1);
unix('./multi_echo_swi.pl mag_corr ph_corr 4 combined_swi.mnc');



cd /media/data/ME-MP2RAGE/04_BH_451/QSM_MEMP2RAGE_7T/src
do_unwrap_swi('mag_corr1_n4.mnc', 'ph_corr1.mnc', 'swi_unwrap_echo_1_of_4.mnc', 'phase_unwrap_echo_1_of_4.mnc', '../BET_mask.mnc', 0.1, 1, 4, 1);
do_unwrap_swi('mag_corr2_n4.mnc', 'ph_corr2.mnc', 'swi_unwrap_echo_2_of_4.mnc', 'phase_unwrap_echo_2_of_4.mnc', '../BET_mask.mnc', 0.15, 1, 4, 1);
do_unwrap_swi('mag_corr3_n4.mnc', 'ph_corr3.mnc', 'swi_unwrap_echo_3_of_4.mnc', 'phase_unwrap_echo_3_of_4.mnc', '../BET_mask.mnc', 0.2, 1, 4, 1);
do_unwrap_swi('mag_corr4_n4.mnc', 'ph_corr4.mnc', 'swi_unwrap_echo_4_of_4.mnc', 'phase_unwrap_echo_4_of_4.mnc', '../BET_mask.mnc', 0.25, 1, 4, 1);
unix('./multi_echo_swi_unwrapped.pl mag_corr ph_corr ../BET_mask.mnc 4 combined_unwrap_swi.mnc');

do_swi('mag_corr1_n4.mnc', 'ph_corr1.mnc', 'swi_echo_1_of_4.mnc', 'phase_echo_1_of_4.mnc', 0.1, 1);
do_swi('mag_corr2_n4.mnc', 'ph_corr2.mnc', 'swi_echo_2_of_4.mnc', 'phase_echo_2_of_4.mnc', 0.15, 1);
do_swi('mag_corr3_n4.mnc', 'ph_corr3.mnc', 'swi_echo_3_of_4.mnc', 'phase_echo_3_of_4.mnc', 0.2, 1);
do_swi('mag_corr4_n4.mnc', 'ph_corr4.mnc', 'swi_echo_4_of_4.mnc', 'phase_echo_4_of_4.mnc', 0.25, 1);
unix('./multi_echo_swi.pl mag_corr ph_corr 4 combined_swi.mnc');



cd /media/data/ME-MP2RAGE/05_JON_H476/QSM_MEMP2RAGE_7T/src
do_unwrap_swi('mag_corr1_n4.mnc', 'ph_corr1.mnc', 'swi_unwrap_echo_1_of_4.mnc', 'phase_unwrap_echo_1_of_4.mnc', '../BET_mask.mnc', 0.1, 1, 4, 1);
do_unwrap_swi('mag_corr2_n4.mnc', 'ph_corr2.mnc', 'swi_unwrap_echo_2_of_4.mnc', 'phase_unwrap_echo_2_of_4.mnc', '../BET_mask.mnc', 0.15, 1, 4, 1);
do_unwrap_swi('mag_corr3_n4.mnc', 'ph_corr3.mnc', 'swi_unwrap_echo_3_of_4.mnc', 'phase_unwrap_echo_3_of_4.mnc', '../BET_mask.mnc', 0.2, 1, 4, 1);
do_unwrap_swi('mag_corr4_n4.mnc', 'ph_corr4.mnc', 'swi_unwrap_echo_4_of_4.mnc', 'phase_unwrap_echo_4_of_4.mnc', '../BET_mask.mnc', 0.25, 1, 4, 1);
unix('./multi_echo_swi_unwrapped.pl mag_corr ph_corr ../BET_mask.mnc 4 combined_unwrap_swi.mnc');

do_swi('mag_corr1_n4.mnc', 'ph_corr1.mnc', 'swi_echo_1_of_4.mnc', 'phase_echo_1_of_4.mnc', 0.1, 1);
do_swi('mag_corr2_n4.mnc', 'ph_corr2.mnc', 'swi_echo_2_of_4.mnc', 'phase_echo_2_of_4.mnc', 0.15, 1);
do_swi('mag_corr3_n4.mnc', 'ph_corr3.mnc', 'swi_echo_3_of_4.mnc', 'phase_echo_3_of_4.mnc', 0.2, 1);
do_swi('mag_corr4_n4.mnc', 'ph_corr4.mnc', 'swi_echo_4_of_4.mnc', 'phase_echo_4_of_4.mnc', 0.25, 1);
unix('./multi_echo_swi.pl mag_corr ph_corr 4 combined_swi.mnc');



