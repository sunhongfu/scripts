use strict;
use warnings;
use List::Util qw[min max];
use File::Basename;


my @all_subjects=('2015-11-26 RR-001', '2015-12-04 RR-004', '2015-12-11 RR-008', '2015-12-15 RR-007', '2016-01-04 RR-009', '2016-01-14 RR-010', '2016-01-22 RR-012', '2016-01-28 RR-013', '2016-02-02 RR-015', '2016-02-10 RR-018', '2016-02-16 RR-019', '2016-02-19 RR-016', '2016-03-04 RR-020', '2016-03-10 RR-021', '2016-03-14 RR-032', '2016-03-22 RR-029', '2016-03-22 RR-030', '2016-04-05 RR-039', '2016-04-13 RR-034', '2016-04-18 RR-033', '2016-04-19 RR-031', '2016-04-19 RR-038', '2016-04-20 RR-035', '2016-04-29 RR-026', '2016-05-03 RR-036', '2016-05-10 RR-037', '2016-05-27 RR-042', '2016-05-30 RR-040', '2016-05-31 RR-047', '2016-06-01 RR-045', '2016-06-03 RR-041', '2016-06-03 RR-049', '2016-06-06 RR-018', '2016-06-07 RR-048', '2016-06-09 RR-044', '2016-06-20 RR-046', '2016-06-30 RR-057', '2016-07-05 RR-050', '2016-07-05 RR-060', '2016-07-06 RR-061', '2016-07-08 RR-051', '2016-07-08 RR-056', '2016-07-21 RR-058', '2016-07-26 RR-059', '2016-07-26 RR-062', '2016-07-29 RR-053', '2016-08-02 RR-066', '2016-08-02 RR-071', '2016-08-03 RR-055', '2016-08-04 RR-065', '2016-08-04 RR-067', '2016-08-05 RR-063', '2016-08-09 RR-064', '2016-08-10 RR-074', '2016-08-12 RR-073', '2016-08-23 RR-069', '2016-08-24 RR-076', '2016-08-25 RR-078', '2016-09-02 RR-077', '2016-09-06 RR-084', '2016-09-08 RR-083', '2016-09-09 RR-075', '2016-09-12 RR-080', '2016-09-12 RR-086', '2016-09-13 RR-079', '2016-09-13 RR-091', '2016-09-15 RR-088', '2016-09-15 RR-101', '2016-09-16 RR-090', '2016-09-20 RR-099', '2016-09-23 RR-085', '2016-09-27 RR-081', '2016-09-28 RR-018', '2016-09-29 RR-089', '2016-09-29 RR-110', '2016-10-05 RR-102', '2016-10-06 RR-096', '2016-10-11 RR-094', '2016-10-12 RR-092', '2016-10-12 RR-100', '2016-10-17 RR-093', '2016-10-18 RR-095', '2016-10-31 RR-106', '2016-11-02 RR-104', '2016-11-04 RR-105', '2016-11-07 RR-113', '2016-11-08 RR-116', '2016-11-10 RR-108', '2016-11-15 RR-114', '2016-11-17 RR-112', '2016-11-23 RR-117', '2016-11-29 RR-115', '2016-12-01 RR-126', '2016-12-05 RR-119', '2016-12-12 RR-120', '2016-12-13 RR-124', '2016-12-13 RR-128', '2016-12-16 RR-118', '2016-12-19 RR-125', '2017-01-03 RR-129', '2017-01-05 RR-136', '2017-01-10 RR-131', '2017-01-11 RR-130', '2017-01-16 RR-132', '2017-01-17 RR-133', '2017-01-19 RR-134', '2017-01-20 RR-135', '2017-01-23 RR-081', '2017-02-08 RR-092', '2017-02-15 RR-137', '2017-02-23 RR-139', '2017-02-24 RR-145', '2017-02-27 RR-142', '2017-02-27 RR-143', '2017-02-28 RR-140', '2017-03-02 RR-144', '2017-03-03 RR-138', '2017-03-08 RR-152', '2017-03-15 RR-151', '2017-03-23 RR-148', '2017-03-27 RR-146', '2017-03-27 RR-153', '2017-03-28 RR-150', '2017-03-30 RR-149', '2017-03-31 RR-147', '2017-04-19 RR-155', '2017-04-25 RR-154', '2017-04-25 RR-156', '2017-04-28 RR-157', '2017-05-01 RR-158', '2017-05-02 RR-159', '2017-05-02 RR-160', '2017-05-03 RR-162', '2017-05-09 RR-161', '2017-05-10 RR-164', '2017-05-11 RR-163', '2017-05-15 RR-166', '2017-05-17 RR-081', '2017-05-18 RR-169', '2017-05-19 RR-165', '2017-06-01 RR-168', '2017-06-01 RR-174', '2017-06-02 RR-167', '2017-06-02 RR-170', '2017-06-05 RR-176', '2017-06-06 RR-092', '2017-06-08 RR-175', '2017-06-12 RR-172', '2017-06-16 RR-173', '2017-06-29 RR-177', '2017-07-10 RR-181', '2017-07-12 RR-178', '2017-07-12 RR-179', '2017-07-13 RR-183', '2017-07-14 RR-145', '2017-07-20 RR-182', '2017-07-21 RR-184', '2017-07-27 RR-186', '2017-07-28 RR-187', '2017-08-02 RR-193', '2017-08-08 RR-190', '2017-08-09 RR-195', '2017-08-10 RR-191', '2017-08-11 RR-189', '2017-08-18 RR-188', '2017-08-24 RR-162', '2017-08-25 RR-158', '2017-08-28 RR-159', '2017-08-28 RR-194', '2017-09-13 RR-198', '2017-09-14 RR-196', '2017-09-28 RR-180', '2017-09-29 RR-197', '2017-09-29 RR-200', '2017-10-06 RR-176', '2017-11-03 RR-205', '2017-11-08 RR-207', '2017-11-09 RR-209', '2017-11-10 RR-145', '2017-11-16 RR-206', '2017-11-17 RR-208', '2017-11-22 RR-187', '2017-11-22 RR-210', '2017-12-07 RR-212', '2017-12-14 RR-162', '2017-12-15 RR-159', '2017-12-21 RR-213', '2017-12-22 RR-158', '2017-12-22 RR-194', '2018-01-09 RR-214', '2018-01-12 RR-217', '2018-01-17 RR-211', '2018-01-19 RR-176', '2018-01-19 RR-216', '2018-01-22 RR-218', '2018-01-26 RR-215');

# generate a .pbs file for each subject
# extract the subject number. e.g. Ps16_075_PRESCHOOL__PS16_075.pbs
foreach my $sub_no (@all_subjects) {


        my $script =
"#!/bin/bash
#
#PBS -A UQ-EAIT-ITEE
#
#PBS -l select=1:ncpus=1:mem=32GB
#PBS -l walltime=08:00:00

module load matlab 

cd /QRISdata/Q1041/samiha/MS/QSM_recon
matlab  -nodisplay -nojvm -nosplash -singleCompThread -r \"recon_R2_star(\'$sub_no\')\" 
";


        $sub_no=~s/ /-/g;

        # print "$fields[0]\n";
        open(my $fileHandle, '>', "/home/uqhsun8/MS_R2_star/$sub_no.pbs");
        print $fileHandle $script;
        close $fileHandle
}

