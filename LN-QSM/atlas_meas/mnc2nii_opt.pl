#!/usr/bin/env perl

$ARGC = @ARGV;

if ($ARGC < 2) {
    print ("ERROR: not enough arguments\n");
    print ("Usage: mnc2nii_opt input.mnc output.nii");
    die;
}

$input_file = @ARGV[0];
$output_file = @ARGV[1];

# Step 1: reformat the minc file prior to the conversion to nifti file

$reshape_arg = "-clobber +direction -dimsize xspace=-1 -dimsize yspace=-1 -dimsize zspace=-1 -dimorder zspace,yspace,xspace -float $input_file conv_tmp.mnc";
$CalcFlux_arg = "$input_file tmp/image_flux.mnc ${min_radius} ${max_radius}";

`mincreshape ${reshape_arg}`;

`mnc2nii -nii conv_tmp.mnc $output_file`;

#'rm conv_tmp.mnc`;






