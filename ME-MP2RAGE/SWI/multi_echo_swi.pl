#!/usr/bin/env perl

# use Utils::MatlabUtils;

$ARGC = @ARGV;

if ($ARGC < 4) {
    print ("ERROR: not enough arguments\n");
    print ("Usage: multi_echo_swi mag_file_base phase_file_base num_echoes output.mnc [first_echo_index] [weights]");
    die;
}

# `rm /tmp/*.mnc`;

$mag_file_base = @ARGV[0];
$phase_file_base = @ARGV[1];
$num_echoes = @ARGV[2];
$output_file = @ARGV[3];

$first_echo_index = 1;
if ($ARGC > 4) {
	$first_echo_index = @ARGV[4];
}


$sum = 0;
for ($i=0; $i<$num_echoes; $i++) {	
    if ($ARGC > 5) {
	   @weights[$i] = @ARGV[5+$i];
	} else {
	   @weights[$i] = 1;
	}	
	$sum = $sum + @weights[$i];
}

$windowSizeRatio = 0.20;

# for ($i=$first_echo_index; $i<($first_echo_index+$num_echoes); $i++) {
#     $mag = "${mag_file_base}${i}_n4.mnc";
#     $phase = "${phase_file_base}${i}.mnc";    
#     run_matlab("do_swi('$mag', '$phase', 'swi_echo_${i}_of_${num_echoes}.mnc', 'phase_echo${i}_of_${num_echoes}.mnc', $windowSizeRatio, 1)");
#     $windowSizeRatio = $windowSizeRatio + 0.05;
    
# #    `minc_nuyl /tmp/swi_echo_${i}_of_${num_echoes}.mnc /tmp/swi_echo_1_of_${num_echoes}.mnc /tmp/swi_echo_${i}_of_${num_echoes}_rescaled.mnc`;
    
#     #`VolumeRescale "/tmp/swi_echo_${i}_of_${num_echoes}.mnc" "/tmp/swi_echo_${i}_of_${num_echoes}_rescaled.mnc" 0 1000`;
# }


# # run these in matlab
# do_swi('mag_corr1_n4.mnc', 'ph_corr1.mnc', 'swi_echo_1_of_4.mnc', 'phase_echo_1_of_4.mnc', 0.2, 1);
# do_swi('mag_corr2_n4.mnc', 'ph_corr2.mnc', 'swi_echo_2_of_4.mnc', 'phase_echo_2_of_4.mnc', 0.25, 1);
# do_swi('mag_corr3_n4.mnc', 'ph_corr3.mnc', 'swi_echo_3_of_4.mnc', 'phase_echo_3_of_4.mnc', 0.3, 1);
# do_swi('mag_corr4_n4.mnc', 'ph_corr4.mnc', 'swi_echo_4_of_4.mnc', 'phase_echo_4_of_4.mnc', 0.35, 1);




$cmd = "-clob -expression '(";

for ($i=0; $i<$num_echoes; $i++) {
	
	$cmd = "${cmd}A[${i}]*@weights[$i]";
	if ($i != ($num_echoes-1)) {
		$cmd = "${cmd} + ";
	}
}

$cmd = "${cmd})/${sum}' ";
for ($i=$first_echo_index; $i<($first_echo_index+$num_echoes); $i++) {
    $cmd = "${cmd} swi_echo_${i}_of_${num_echoes}.mnc ";
}
$cmd = "${cmd} ${output_file}";

`minccalc $cmd`;




