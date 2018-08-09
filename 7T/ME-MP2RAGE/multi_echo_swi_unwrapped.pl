#!/usr/bin/env perl

use Utils::MatlabUtils;

$ARGC = @ARGV;

if ($ARGC < 4) {
    print ("ERROR: not enough arguments\n");
    print ("Usage: multi_echo_swi mag_file_base phase_file_base mask_file num_echoes output.mnc [first_echo_index] [weights]");
    die;
}

`rm /tmp/*.mnc`;

$mag_file_base = @ARGV[0];
$phase_file_base = @ARGV[1];
$mask = @ARGV[2];
$num_echoes = @ARGV[3];
$output_file = @ARGV[4];

$first_echo_index = 1;
if ($ARGC > 5) {
	$first_echo_index = @ARGV[5];
}


$sum = 0;
for ($i=0; $i<$num_echoes; $i++) {	
    if ($ARGC > 6) {
	   @weights[$i] = @ARGV[6+$i];
	} else {
	   @weights[$i] = 1;
	}	
	$sum = $sum + @weights[$i];
}

$windowSizeRatio = 0.20;


for ($i=$first_echo_index; $i<($first_echo_index+$num_echoes); $i++) {
    $mag = "${mag_file_base}e${i}_mri.mnc";
    $phase = "${phase_file_base}e${i}_mri.mnc";    
    run_matlab("do_unwrap_swi('$mag', '$phase', '/tmp/swi_echo_${i}_of_${num_echoes}.mnc', '/tmp/phase_echo${i}_of_${num_echoes}.mnc', '$mask',  $windowSizeRatio, 1, 4, 1)");
    $windowSizeRatio = $windowSizeRatio + 0.05;
    
    
#    `minc_nuyl /tmp/swi_echo_${i}_of_${num_echoes}.mnc /tmp/swi_echo_1_of_${num_echoes}.mnc /tmp/swi_echo_${i}_of_${num_echoes}_rescaled.mnc`;
    
    #`VolumeRescale "/tmp/swi_echo_${i}_of_${num_echoes}.mnc" "/tmp/swi_echo_${i}_of_${num_echoes}_rescaled.mnc" 0 1000`;
}

$cmd = "-clob -expression '(";

for ($i=0; $i<$num_echoes; $i++) {
	
	$cmd = "${cmd}A[${i}]*@weights[$i]";
	if ($i != ($num_echoes-1)) {
		$cmd = "${cmd} + ";
	}
}

$cmd = "${cmd})/${sum}' ";
for ($i=$first_echo_index; $i<($first_echo_index+$num_echoes); $i++) {
    $cmd = "${cmd} /tmp/swi_echo_${i}_of_${num_echoes}.mnc ";
}
$cmd = "${cmd} ${output_file}";

`minccalc $cmd`;




