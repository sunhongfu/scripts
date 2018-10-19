TI_null = -T1 * log( 0.5 * (1 + exp(-TR/T1)) )



TR=2800

%WHITE MATTER
T1=800;
TI_null_wm = -T1 * log( 0.5 * (1 + exp(-TR/T1)) )


%GREY MATTER
T1=1400;
TI_null_gm = -T1 * log( 0.5 * (1 + exp(-TR/T1)) )


%CSF
T1=4000;
TI_null_csf = -T1 * log( 0.5 * (1 + exp(-TR/T1)) )


