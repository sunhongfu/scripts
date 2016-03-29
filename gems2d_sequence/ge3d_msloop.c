/*********************************************************
* Time Of Flight Angiography developed from a "ge3d" Varian 
* template
*                                  Amir Eissa
*********************************************************/

/* This file is just the same as NOV18, but after merging it with the new version of GE3D which varies just a bit from the older version*/

/* This file is updated from NOV16 ,
at/2 in many places was replaced by t3 (half or quarter of at) or by (at-t3) 
depending on whether it was used as the te chunk of at or the other chunk

gcomp was replaced by gcomp1 and gcomp2, to unlock the values for RO flow comp
as the second lobe is more effective and needed for applying higher gradient 
value to shorten {te} to the most possible with the specific system's gradient
Duty Cycle
*/

#ifndef LINT
static char SCCSid[] = "@(#)ge3d.c 17.1 04/01/03 Copyright (c) 1991-2001 Varian Inc. All Rights Reserved";
#endif
/* 
 * Varian Inc. All Rights Reserved.
 * This software contains proprietary and confidential
 * information of Varian, Inc. and its contributors.
 * Use, disclosure and reproduction is prohibited without
 * prior consent.
 */
/***********************************************************************
    GE3D.C

    3D Grad-echo fast imaging sequence .                     

*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
        __                                                  __ 
       |                                                      |
  RF   |----- [ p1 ] ----------------------- |** ACQ **| -----|
       |                                                      |
       |<---->   < - - - - - - - te - - - - - - - >           |
       | predelay                                             |
       |             ___                                  ___ |
  GPE  |____________/___\________________________________/___\| nv
       |            \___/                                \___/|
       |            <--> tref                                 |
       |             ___                                  ___ |
  GPE2 |____________/___\________________________________/___\| ni
       |            \___/                                \___/|
       |                 < - tA - >                           |
       |                            ____________________      |
  GRO  |____________     __________/////////////////////\_____|
       |       gror \\\\/                                     |
       |                                                      |
       |< - - - - - - - - - - - tr - - - - - - - - - - - - - >|
       |__                                                  __|

*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*/

#include <standard.h>
#define RFSPOILDELAY 50e-6


pulsesequence()
{
    /* Internal variable declarations *********************/
    
    double  TE,gcomp1,gcomp2,gcomp,T1,T2,t3;        /* New variables for READ flow compensation parameters */
    double  E1,E2,E3,K1,K2,temin1;
    double  predelay,seqtime,tref,risetref;
    double  trefmin,tpemin,tpe2min,temin,spoil_int;
    double  agss,agss2,agro,sgpe,sgpe2,grate,gpeint,gpe2int;      
    double  reffreq,nextphase,spoilfreqs[1024];
    double  K6,K5,K4,K3,E0,KK,EE;
    double  KK6,KK5,KK4,KK3,KK2;
    double  EE0,EE1,EE2,trise_adjust_1;
    double  TimeLine1[7],XX1,YY1,GradX[7],GradY[7],GradZ[7];
    double  gspoil_sat,dspoil_sat,saturation_2pi_s,delta_Z,sat_gap_1,sat_type_1;
    double  at2 ,Gspoil, dspoil;  /* this variable will be the time duration after (or before if negative),
                                                       the end of tref for the gro spoil gradient       */
    double PE1_CVRD,PE2_CVRD,RO_CVRD,FC_,nvv,nvv2;
    double p_aq_d, trf_mlt;                                                       
    double tpwrf2, tpwrf1;     /* fine power added for both saturation and excitation pulses */
    int     i,k,j;
     double  GG2,GG3,Tss2,Tss3,Tss1;            /* NOV14 */
    double  psss, psss2, Sat_Delay;
    double NS,slab_top,slice_step,top_slice_pos;   /*number of slices is to be used instead of nv2*/
    char  debug[MAXSTR];

    initparms_sis();
    loop_check();
    p_aq_d=getval("p_aq_d");
    trf_mlt=getval("trf_mlt");
    tpwrf1=getval("tpwrf1");
    tpwrf2=getval("tpwrf2");
        PE1_CVRD=getval("PE1_CVRD");
        PE2_CVRD=getval("PE2_CVRD");
        RO_CVRD=getval("RO_CVRD");
        NS=getval("NS");
        FC_= getval("FC_");                                 /*flow comp on/off*/
 
 
	Gspoil=gspoil; /* this is manually defined for the time being ... it is the after read-out spoil gradient*/
 
	at2=at/(NS*RO_CVRD);   /*at2 represents the full Read Out length of time for subsequent calculations*/
     psss=getval("pss");    /*NOV15*/
   psss2=getval("pss2");
   sat_type_1=getval("sat_type1");
  /* getstr("sat_type1",sat_type_1);
*/
   sat_gap_1=getval("sat_gap1");
   saturation_2pi_s=getval("sat_2pi");
   trise_adjust_1=getval("trise_adjust1");

    nvv=floor(nv/PE1_CVRD);
    nvv2=floor(nv2/PE2_CVRD);
    
/*    at=at/NS; */
    nvv2=1;
    nv2=1;


   delta_Z=lpe2/nvv2;  /* delta_Z will be used to calculate the Asp**/

getstrnwarn("debug",debug);
    
    
    
   grate = trise_adjust_1/gmax;
   agro = fabs(gro);
   agss = fabs(gss);
   agss2 = fabs(gss2);
   
    /* GRADIENT*TIME integrals for slice selection and readout */
    if (lpe <= 0.0  ||  lpe2 <= 0.0) {
    abort_message("%s: lpe or lpe2 <= 0.  Please assign them.",seqfil);
    }
   
/* automate later by adding checkboxes with parameter [choose full k-space, or 75% k-space] */

/*    t3=at/2;          /* this value is when using full k-space acquisition */
   
/*
p_aq_d = 0.000150; */     /* add a ~40 microsecond delay before acquiring, so there won't be need to 

                        change trise <as its value should describe the effective slope>

                            and at the same time save the acquisition window from 

                            have the slight time in which the ramp down behaves slower than its 

                            normal straight line trend (as it undergoes an ~exponential decay 

                            at the end)     */

                            

	t3=(RO_CVRD-0.5)*at2+p_aq_d; // preacq delay 

  
    gpeint = B0/(lpe*sfrq*1e6);
    gpe2int = B0/(lpe2*sfrq*1e6);

/* Saturation parameters */
    Sat_Delay= getval("sat_delay1");
    gspoil_sat=getval("gspoil_1");
spoil_int = saturation_2pi_s/((sfrq*1e6/B0)*delta_Z);
dspoil_sat = (spoil_int-1/2*gss2*p2+gss2*gss2*grate-gspoil_sat*gss2*grate)/gspoil_sat;

        if (sat_type_1 == 1)
              psss2=psss-(lpe2/2+lpe2/2+sat_gap_1);  
/* here we assume the saturation slab thickness to equal the excitation slab thickness (effectively FOV_Z <lpe2>)*/
/*we also assumed the patient goes into the magnet with head first <where Z increases towards the legs and where we are doing head/neck imaging> wherean in body areas lower than the heart, the signs should reverse for venous versus arterial saturation*/
        if (sat_type_1 == 2)
            psss2=psss+(lpe2/2+lpe2/2+sat_gap_1); 
        if (sat_type_1 == 3)
            {
            p2=0;
            dspoil_sat=0;
            gspoil_sat=0;
            agss2=0;
            }

    printf("psss2 = %.2f cm\n",psss2);
    printf("lpe2 = %.2f cm\n",lpe2);    
    printf("sat_gap_1 = %.2f cm\n",sat_gap_1);    


   /***********!!!!!!!!!!!!!!!!!!!!!!!!!!!!************************
    *****  READ FLOW COMPENSATION 
    
    
    */

/* RO Flow Comp times and gradients 
(manually entered per case) */
gcomp=gmax;

/* later on, add gcomp1 and gcomp2 as new parameters and incorporate the flow comp. equations in this code */  gcomp1 = getval("gcomp11");
 gcomp2 = getval("gcomp22");

  


/* For the flow compensation calculations, is there any possibility of truncation <due to quantization for instance> in 
                            input arguments (investigate later)*/



T1 =0.5/(12*gcomp1*gcomp1+12*gcomp1*gcomp2)*(-24*grate*gcomp1*gcomp1*gcomp1-36*gcomp1*gcomp1*grate*gcomp2-12*gcomp1*gcomp2*gcomp2*grate+4*sqrt(24*gcomp1*gcomp1*grate*grate*gro*gro*gro*gcomp2+36*gcomp1*gcomp1*gro*gro*gro*t3*grate+18*gcomp1*gcomp1*grate*grate*gcomp2*gcomp2*gro*gro+36*gcomp1*gcomp2*gcomp2*gro*t3*t3+24*gcomp1*gcomp2*gcomp2*grate*grate*gro*gro*gro+36*gcomp1*gcomp2*gro*gro*t3*t3+18*gcomp1*gcomp2*gcomp2*gcomp2*grate*grate*gro*gro+9*gcomp1*gcomp2*grate*grate*gro*gro*gro*gro+36*gcomp1*gcomp1*gro*t3*t3*gcomp2+72*gcomp1*gcomp1*gro*gro*t3*grate*gcomp2+9*grate*grate*gcomp1*gcomp1*gcomp1*gcomp1*gcomp2*gcomp2+18*gcomp1*gcomp1*gcomp1*grate*grate*gcomp2*gcomp2*gcomp2+9*gcomp1*gcomp1*gcomp2*gcomp2*gcomp2*gcomp2*grate*grate+36*gcomp1*gcomp1*gro*gro*t3*t3+9*gcomp1*gcomp1*grate*grate*gro*gro*gro*gro+36*gcomp1*gcomp1*gro*t3*grate*gcomp2*gcomp2+72*gcomp1*gcomp2*gcomp2*gro*gro*t3*grate+36*gcomp1*gcomp2*gro*gro*gro*t3*grate+36*gcomp1*gcomp2*gcomp2*gcomp2*gro*t3*grate));    

T2 =-0.5*(-2*gro*t3-2*grate*gcomp1*gcomp1-gcomp1/(12*gcomp1*gcomp1+12*gcomp1*gcomp2)*(-24*grate*gcomp1*gcomp1*gcomp1-36*gcomp1*gcomp1*grate*gcomp2-12*gcomp1*gcomp2*gcomp2*grate+4*sqrt(24*gcomp1*gcomp1*grate*grate*gro*gro*gro*gcomp2+36*gcomp1*gcomp1*gro*gro*gro*t3*grate+18*gcomp1*gcomp1*grate*grate*gcomp2*gcomp2*gro*gro+36*gcomp1*gcomp2*gcomp2*gro*t3*t3+24*gcomp1*gcomp2*gcomp2*grate*grate*gro*gro*gro+36*gcomp1*gcomp2*gro*gro*t3*t3+18*gcomp1*gcomp2*gcomp2*gcomp2*grate*grate*gro*gro+9*gcomp1*gcomp2*grate*grate*gro*gro*gro*gro+36*gcomp1*gcomp1*gro*t3*t3*gcomp2+72*gcomp1*gcomp1*gro*gro*t3*grate*gcomp2+9*grate*grate*gcomp1*gcomp1*gcomp1*gcomp1*gcomp2*gcomp2+18*gcomp1*gcomp1*gcomp1*grate*grate*gcomp2*gcomp2*gcomp2+9*gcomp1*gcomp1*gcomp2*gcomp2*gcomp2*gcomp2*grate*grate+36*gcomp1*gcomp1*gro*gro*t3*t3+9*gcomp1*gcomp1*grate*grate*gro*gro*gro*gro+36*gcomp1*gcomp1*gro*t3*grate*gcomp2*gcomp2+72*gcomp1*gcomp2*gcomp2*gro*gro*t3*grate+36*gcomp1*gcomp2*gro*gro*gro*t3*grate+36*gcomp1*gcomp2*gcomp2*gcomp2*gro*t3*grate))-grate*gro*gro+2*gcomp2*gcomp2*grate)/gcomp2;

if (FC_>0)
 		{

 		if (T1<0) {
		abort_message("%s: Too large X Flow Comp gradient 1... bring it down. T1 = %f.6",seqfil,T1);
			    }

 		if (T2<0) {
		abort_message("%s: Too large X Flow Comp gradient 2... bring it down. T2 = %f.6",seqfil,T2);
			    }
 		}		 


    if (FC_==0) 
        {
         T1=0;
         gcomp1=0;
         T2=(gro*grate/2+t3)*gro/gcomp2-gcomp2*grate;
         }


    E1=grate*gcomp1+T1;
    E2=grate*(gcomp1+gcomp2)+T2;
    E3=grate*(gcomp2+gro);
    

/*Slice flow compensation*/

    Tss1=p1/2+rof1;         /* NOV14 time from RF MAX point to RF end (varies with pulse shape/symmetry) */

 GG2 = getval("gcompz2");
 GG3 = getval("gcompz3");
  

Tss2=0.5*(grate*gss*gss+GG3/(12*GG3*GG3+12*GG3*GG2)*(-12*GG3*GG2*GG2*grate-36*GG3*GG3*grate*GG2-24*GG3*GG3*GG3*grate+4*sqrt(72*GG3*GG3*Tss1*grate*gss*gss*GG2+72*GG3*GG2*GG2*Tss1*grate*gss*gss+36*GG3*GG2*GG2*GG2*grate*gss*Tss1+9*GG3*GG2*grate*grate*gss*gss*gss*gss+36*GG3*GG2*grate*gss*gss*gss*Tss1+24*GG3*GG2*GG2*gss*gss*gss*grate*grate+36*GG3*GG2*gss*gss*Tss1*Tss1+36*GG3*GG2*GG2*gss*Tss1*Tss1+18*GG3*GG2*GG2*GG2*grate*grate*gss*gss+36*GG3*GG3*GG2*GG2*grate*gss*Tss1+24*GG3*GG3*gss*gss*gss*grate*grate*GG2+18*GG3*GG3*grate*grate*gss*gss*GG2*GG2+36*GG3*GG3*gss*Tss1*Tss1*GG2+36*GG3*GG3*gss*gss*Tss1*Tss1+9*GG3*GG3*grate*grate*gss*gss*gss*gss+9*GG3*GG3*GG2*GG2*GG2*GG2*grate*grate+18*GG3*GG3*GG3*GG2*GG2*GG2*grate*grate+9*GG3*GG3*GG3*GG3*GG2*GG2*grate*grate+36*GG3*GG3*grate*gss*gss*gss*Tss1))-2*GG2*GG2*grate+2*gss*Tss1+2*GG3*GG3*grate)/GG2;

Tss3 = 0.5/(12*GG3*GG3+12*GG3*GG2)*(-12*GG3*GG2*GG2*grate-36*GG3*GG3*grate*GG2-24*GG3*GG3*GG3*grate+4*sqrt(72*GG3*GG3*Tss1*grate*gss*gss*GG2+72*GG3*GG2*GG2*Tss1*grate*gss*gss+36*GG3*GG2*GG2*GG2*grate*gss*Tss1+9*GG3*GG2*grate*grate*gss*gss*gss*gss+36*GG3*GG2*grate*gss*gss*gss*Tss1+24*GG3*GG2*GG2*gss*gss*gss*grate*grate+36*GG3*GG2*gss*gss*Tss1*Tss1+36*GG3*GG2*GG2*gss*Tss1*Tss1+18*GG3*GG2*GG2*GG2*grate*grate*gss*gss+36*GG3*GG3*GG2*GG2*grate*gss*Tss1+24*GG3*GG3*gss*gss*gss*grate*grate*GG2+18*GG3*GG3*grate*grate*gss*gss*GG2*GG2+36*GG3*GG3*gss*Tss1*Tss1*GG2+36*GG3*GG3*gss*gss*Tss1*Tss1+9*GG3*GG3*grate*grate*gss*gss*gss*gss+9*GG3*GG3*GG2*GG2*GG2*GG2*grate*grate+18*GG3*GG3*GG3*GG2*GG2*GG2*grate*grate+9*GG3*GG3*GG3*GG3*GG2*GG2*grate*grate+36*GG3*GG3*grate*gss*gss*gss*Tss1));

if (FC_>0)
 		{
 		if (Tss2<0) {
		abort_message("%s: Too large Z Flow Comp gradient 1... bring it down. Tss2 = %f.6",seqfil,Tss2);
			    			}

 		if (Tss3<0) {
		abort_message("%s: Too large Z Flow Comp gradient 2... bring it down. Tss3 = %f.6",seqfil,Tss3);
			    		       }
 		}		 


    printf("T1 = %.5f us\n",T1*1000000);    
    printf("T2 = %.5f us\n",T2*1000000);    
    printf("Tss3 = %.5f us\n",Tss3*1000000);    
    printf("Tss2 = %.5f us\n",Tss2*1000000);    
    printf("grate = %.5f us\n",grate*1000000);   
    
    if (FC_==0)
        {Tss3=0;
         GG3=0;
         Tss2=(Tss1+gss*grate/2)*gss/GG2-GG2*grate;
         }
    /*******************************************************
    * Calculate minimum time for phase-encoding, slice refocussing
    * and readout prefocussing block.  Trapezoidal if GMAX is exceeded.
    * TSSRMIN does not include the gradient fall time.  RISETREF is
    * the gradient fall time for the PE block.
    *******************************************************/

    if (trise*gmax >= gpeint*nvv/2.0)
        tpemin = sqrt(grate*gpeint*nvv/2.0);
    else
    tpemin = gpeint*nvv/2.0/gmax;

    if (trise*gmax >= gpe2int*nvv2/2.0)
        tpe2min = sqrt(grate*gpe2int*nvv2/2.0);
    else
    tpe2min = gpe2int*nvv2/2.0/gmax;

    /* Minimum refocussing block time is the longest of calculated minima */
    trefmin = (tpemin > tpe2min) ? tpemin : tpe2min;

    /*******************************************************
    * If TREFMIN implies trapezoidal PE block, mimimum RISETREF
    * is RISETIME, otherwise minimum RISETREF is TREFMIN.
    *******************************************************/
    risetref = (trefmin > trise) ? trise : trefmin;


    /*******************************************************
    * TREF is the refocussing block length, not including gradient fall
    * time.  TREF is scaled up to a maximum value consistent with TE
    *******************************************************/
    tref = trefmin*trf_mlt;   
temin = 0.003;   /* arbitrary value for temin to initialize <must be optimized later along with te>*/
    tref += (gradstepsz > 2048) ? 0.5*(te - temin) : 0.2*(te - temin);
    tref = (tref > trf_mlt*trefmin) ? trf_mlt*trefmin : tref;

/*  printf("tref = %.5f us\n",tref*1000000);    
    printf("trefmin = %.5f us\n",trefmin*1000000);    
*/


    /* Calculate GPE, adjusting for integral dac value, then adjust TREF */
    sgpe = gpeint/tref;
    sgpe = gmax/gradstepsz*floor(sgpe*gradstepsz/gmax + 0.5);

    sgpe2 = gpe2int/tref;
    sgpe2 = gmax/gradstepsz*floor(sgpe2*gradstepsz/gmax + 0.5);

    /*******************************************************
    * A single solution for tref is not guaranteed to exist for the two
    * values of sgpe and sgpe2.  A good compromise is the geometric mean.
    * If this tref results in a distortion in either PE direction of more
    * than 1%, issue an advisory message.
    *******************************************************/
    tref = sqrt((gpeint/sgpe)*(gpe2int/sgpe2));
    if (nth2D == 1  &&  (fabs(1.0 - sgpe*tref/gpeint) > 0.01  ||
      fabs(1.0 - sgpe2*tref/gpe2int) > 0.01)) 
    {
    printf("%s:  ADVISORY: lpe distortion =%6.2f%%      lpe2 =%6.2f%%\n",
        seqfil,100.0-sgpe*tref/gpeint*100,100.0-sgpe2*tref/gpe2int*100.0);
    }


    /* Determine PE block gradient fall time with new TREF */
    risetref = fabs(sgpe*nvv/2.0);
    risetref = risetref > fabs(sgpe2*nvv2/2.0) ? risetref : fabs(sgpe2*nvv2/2.0);
    risetref *= grate;

    K1=risetref;
    K2=tref;

/***************************************************************************
* Define New Timing/Delays approach for full sliding capability of all 
* Grad Lobe
*
* This approach is applying a minimum TE, but can get a longer TE defined 
* beforehand and that can be done by equally extending 
* the two "zero gradient" delays (E0, K3)
***************************************************************************/

K6= grate*(gss+GG2)+Tss2;
K5= grate*(GG2+GG3)+Tss3;
K4= grate*GG3;


EE=E1+E2+E3;
KK=K1+K2+K4+K5+K6;

    temin = p1/2.0 + rof1 + EE + t3;          
    temin1 = p1/2.0 + rof1 + KK + t3;         

E0=te-temin;
K3=te-temin1;

    if (temin1 > temin) 
    {
     temin = temin1; 
    }


EE=EE+E0;
KK=KK+K3;

    printf("EE = %.5f us\n",EE*1000000);    
    printf("KK = %.5f us\n",KK*1000000);    

    /* Check minimum TE ***********************************/


    TE=p1/2+rof1+EE+t3;
    printf("TE = %.3f us\n",TE*1000000);    
    if (E0 < 0) {
    abort_message("%s: te too short.  Minimum te = %f ms",seqfil,temin*1e3);
    }
    if (K3 < 0) {
    abort_message("%s: te too short.  Minimum te = %f ms",seqfil,temin*1e3);
    }


/* now we register every time point by its time along the time scale (cumulatively)
** <this defines the end point of the delay with corresponding name!!>           
**  The K parameters are reversed in order (K6 is the first delay)                */

KK6=K6;
KK5= KK6 + K5;          
KK4= KK5 + K4;          
KK3= KK4 + K3;          
KK2= KK3 + K2;          

EE0=E0;
EE1=EE0+E1;
EE2=EE1+E2;

/* initiate the TimeLine1(7) array and do the bubble sort loop                  */

TimeLine1[0]= EE0;
TimeLine1[1]= EE1;
TimeLine1[2]= EE2;
TimeLine1[3]= KK6;
TimeLine1[4]= KK5;
TimeLine1[5]= KK3;
TimeLine1[6]= KK2;



for (k= 0; k<6 ; k++)
{
    for (j =0 ; j<6 ; j++)
    {
        XX1=TimeLine1[j];
        YY1=TimeLine1[j+1];
        if (XX1>YY1)
        {
            TimeLine1[j]=YY1;
            TimeLine1[j+1]=XX1;
        }
    }   
}   

for (k=0; k<7; k++)
{
    if (TimeLine1[k]<EE0)
        GradX[k]=0;
    else if (TimeLine1[k]<EE1)
        GradX[k]=gcomp1;
    else if (TimeLine1[k]<EE2)
        GradX[k]=-gcomp2;
    else
    {
        GradX[k]=gro;
    }   

    GradY[k]=0;
}




for (k=0; k<7; k++)
{
    if (TimeLine1[k]<KK6)
        GradZ[k]=-GG2;
    else if (TimeLine1[k]<KK5)
        GradZ[k]=GG3;
    else if (TimeLine1[k]<KK3)
        GradZ[k]=0;
    else if (TimeLine1[k]<KK2)
    {
        GradZ[k]=500;
        GradY[k]=500;
    }
    else
        GradZ[k]=0;
/*  printf("k= %d, GradX= %lf, GradY= %lf, GradZ= %lf\n------------------------------\n", k, GradX[k], GradY[k], GradZ[k]);
*/

}


Sat_Delay=Sat_Delay - (p2/2 + rof1 + dspoil_sat + gspoil_sat*grate + gss*grate + rof1 + p1/2.0); 


/*may be later just make Sat_Delay go down to a zero and issue an advisory 
message saying that Sat_Delay is now increased to the value of (Sat_Delay from 
way above + Sat_Delay_NewVariable <<<look after the word *?*>>> (has to be in 
another if statement to add them up if the new one is negative)
*?* <may be a better idea then to give the one in the above statement a new
name so the Sat_Delay variable keeps its value>*/

if (Sat_Delay < 0) {
        abort_message("%s: Requested Saturation delay too short.  increase it by %f ms",
                       seqfil,fabs(Sat_Delay)*1e3);
    }
    
    
            if (sat_type_1 == 3)
            {
                Sat_Delay=0;
            }
    
    
    
    
    
/*  dspoil=t3-gro*grate/2-tref;*/    /* 1x 2PI spoiler without hiking spoiling gradient above gro (possibility for time savine later on if needed and also 
                                      to check whether we'll need a higher than 2PI spoiler) 
                                      The tref term here is merely a programming twist to set order, where the spoiling is not only happening while 
                                      the "dspoil" long delay is on   This might need revisit  */


if (Gspoil<gro)
{
abort_message("%s: gspoil can not be smaller than gro",seqfil);
}

dspoil = (gro*at2/2 - gro*(Gspoil*grate) - gro*(gro*grate)/2)/(Gspoil+gro);
if (dspoil < 0) {
dspoil = (gro*at2*3/2 - gro*(Gspoil*grate) - gro*(gro*grate)/2)/(Gspoil+gro);
    printf("%s:  ADVISORY: dspoil adjusted for 2 pi spoiling",
        seqfil);
                }
if (dspoil < 0) {
dspoil = (gro*at2*5/2 - gro*(Gspoil*grate) - gro*(gro*grate)/2)/(Gspoil+gro);
    printf("%s:  ADVISORY: dspoil adjusted for 3 pi spoiling",
        seqfil);
                }
if (dspoil < 0) {
dspoil = (gro*at2*7/2 - gro*(Gspoil*grate) - gro*(gro*grate)/2)/(Gspoil+gro);
    printf("%s:  ADVISORY: dspoil adjusted for 4 pi spoiling",
        seqfil);
                }
if (dspoil < 0) {
dspoil = (gro*at2*9/2 - gro*(Gspoil*grate) - gro*(gro*grate)/2)/(Gspoil+gro);
    printf("%s:  ADVISORY: dspoil adjusted for 5 pi spoiling",
        seqfil);
                }
if (dspoil < 0) {
dspoil = (gro*at2*11/2 - gro*(Gspoil*grate) - gro*(gro*grate)/2)/(Gspoil+gro);
    printf("%s:  ADVISORY: dspoil adjusted for 6 pi spoiling",
        seqfil);
                }

if (dspoil < 0) {
abort_message("%s: dspoil below zero (%f.6) , Gspoil might be too large",seqfil,dspoil);
                }


    
dspoil=dspoil-tref;
    /* Relaxation delay ****************************Double check later*******/
    seqtime = agss2*grate + rof1 + p2 + rof1 + dspoil_sat + gspoil_sat*grate + Sat_Delay + rof1 + p1/2.0 + TE + (at2-t3) + tref + dspoil + Gspoil*grate;                              
if (risetref-dspoil>= Gspoil*grate)
    seqtime = agss2*grate + rof1 + p2 + rof1 + dspoil_sat + gspoil_sat*grate + Sat_Delay + rof1 + p1/2.0 + TE + (at2-t3) + tref + dspoil + risetref-dspoil;    
    if (dspoil < 0)
{
    /* Relaxation delay ****************************Double check later*******/
    seqtime = agss2*grate + rof1 + p2 + rof1 + dspoil_sat + gspoil_sat*grate + Sat_Delay + rof1 + p1/2.0 + TE + (at2-t3) + tref + risetref;                              
		if (risetref-dspoil<Gspoil*grate)     
		{       seqtime=seqtime+Gspoil*grate+dspoil-risetref;        }
}



    
/* (at/4-gro*grate/2-tref) section is a weak point, should be watched for later on possible -ve values    (adjust the logic here later)*/

/* ~ DONE   */

 /*GEMS addition*/
 tr=tr/NS;
 slice_step=lpe2/NS;
 slab_top=psss-lpe2/2;
 top_slice_pos=slab_top+slice_step/2;

    if (rfspoil[0] == 'y'  ||  rfspoil[0] == 'Y')
    seqtime += RFSPOILDELAY;
    if (tr*1e3 < seqtime) {
//      abort_message("%s:error123 Requested tr too short. Min tr = %f ms",
//                       seqfil,seqtime*1e3*NS);
    }
	printf("tr is %f\n", tr);
	printf("seqtime is %f\n", seqtime);
    predelay = tr - seqtime;
        printf("predelay = %.2f cm\n",predelay);    


    /*******************************************************
    * Calculation of frequencies to get phase shifts for optional
    * RF spoiling.  Phase shifts are obtained by hopping to variable
    * frequency for fixed time.
    * Ref:  Zur, Y., Magn. Res. Med., 21, 251, (1991).
    *******************************************************/
    if (nth2D == 1  && (rfspoil[0] == 'y'  ||  rfspoil[0] == 'Y')) {
    reffreq = resto + sfrq*1e6/B0*gro*pro;
        for (i=1; i<= (int)(nvv+0.5); i++) {
        nextphase = i*rfphase;
        nextphase = nextphase - 360.0*floor(nextphase/360.0);
        spoilfreqs[i] = reffreq + nextphase/RFSPOILDELAY/360.0;
        }
        create_offset_list(spoilfreqs,nvv,OBSch,0);
    }

    /* check duty cycle limits */     



/************************************************************/
/************************************************************/
/************************************************************/
/*work on this later by entering the new situation for gradients
    trlimit = ( ((agror*agror)+(sgpe*nvv*sgpe*nvv)+(sgpe2*nvv2*sgpe2*nvv2)+(gspoil*gspoil))*tref
              +(agro*agro)*(at2+(grate*agro)) )/400.0;

    if(debug[0] == 'y') 
       printf("%s: trlimit = %f, dutycycle factor = %3.2f \n",seqfil,trlimit,trlimit/tr);
    if (tr <= (trlimit)) {
        abort_message("%s: error345 Requested tr too short. Min trlimit = %f ms",
                      seqfil,trlimit*1e3);
    }    */
/************************************************************/
/************************************************************/
/************************************************************/




    /* PULSE SEQUENCE *************************************/

    /* Phase cycle ****************************************/
    mod2(ct,v3);          /* v3: 0  1  0  1  0  1  0  1 */
    dbl(v3,v3);           /* v3: 0  2  0  2  0  2  0  2 */
    hlv(ct,v4);           /* v4: 0  0  1  1  2  2  3  3 */
    mod2(v4,v4);          /* v4: 0  0  1  1  0  0  1  1 */
    add(v3,v4,v1);        /* v1: 0  2  1  3  0  2  1  3 */
    assign(v1,oph);      /* oph: 0  2  1  3  0  2  1  3 */
rcvroff();    

// create an position list for multislices
double pss_list[(int)NS];
for(i=0;i<NS;i++){
	pss_list[i] = top_slice_pos+i*slice_step;
}

msloop(seqcon[1],NS,v7,v8);


//    peloop(seqcon[3],nv2,v7,v8);
      peloop(seqcon[2],nv,v5,v6);
//for (ikj= 1; ikj<NS+1 ; ikj++)
//{




rcvroff();    

/* Saturation Pulse */
        poffset(psss2,gss2);    
        status(A);
        obspower(tpwr2);
        obspwrf(tpwrf2);             
        obsoffset(resto);
        delay(predelay);
        xgate(ticks);
        rotate();
        
        /* RF pulse ( Saturation )*****************************/ 
        obl_gradient(0.0,0.0,gss2);
        delay(grate*agss2);
        shapedpulse(p2pat,p2,v1,rof1,rof1);
        obl_gradient(0.0,0.0,gspoil_sat);
        delay(dspoil_sat);
        zero_all_gradients();
        delay(gspoil_sat*grate);
        
        
        /* Relaxation delay ***********************************/       
        
        status(A);           /* stated for 2nd time, is that ok ???  */
        obspower(tpwr1);     /* could that live here inside the loops ??? */
        obspwrf(tpwrf1);
        obsoffset(resto);
//        poffset(top_slice_pos+slice_step*(ikj-1),gss);  /*NOV14*/   /*NOV15*/   /*now with gems addition*/
		poffset_list(pss_list,gss,NS,v8);
        delay(Sat_Delay);
        xgate(ticks);
        rotate();
       
        /* RF pulse *******************************************/ 
        obl_gradient(0.0,0.0,gss);
        delay(grate*agss);
        shapedpulse(p1pat,p1,v1,rof1,rof1);
    
    
        /* Read & Slice refocus/FlowComp and phase encode pulse ********/
        
obl_gradient(0,0,-GG2);
delay(TimeLine1[0]);
obl_gradient(GradX[0],GradY[0],GradZ[0]);

for (i=1; i<7; i++)    /* This loop start from the 2nd element of the arrays*/
{   
    delay(TimeLine1[i]-TimeLine1[i-1]);
    if (GradZ[i]>10)
        pe_gradient(GradX[i],sgpe*nv/2.0,0.0,-sgpe,v6);
    else
        obl_gradient(GradX[i],GradY[i],GradZ[i]);
}

/************************************************************/
/****               Get Ready to Acquire                  ***/
/************************************************************/

rcvron();    

poffset(pro,gro);
/* more investigation is needed on the function and appropriate time position for this above line*/
obl_gradient(gro,0,0);
delay(EE-TimeLine1[6]);
        
/************************************************************/
/****                 ACQUIRE                             ***/
/************************************************************/

delay(p_aq_d);
        acquire(np/NS,1.0/sw);


      pe_gradient(Gspoil,-sgpe*nv/2.0,0.0,sgpe,v6);

     if (dspoil >= 0)
    /* more optimization could be done with this case for risetref delay 
                    but doing it would be a waste of time for this stage
                    <the potential would be saving ~ fabs(risetref-grate*gro) from
                    seqtime>                                                       */
{
        delay(tref);
        obl_gradient(Gspoil,0.0,0.0);
        delay(dspoil);
        zero_all_gradients();
        if (risetref-dspoil>= Gspoil*grate)
              	delay(risetref-dspoil);
        if (risetref-dspoil< Gspoil*grate)
        	delay(Gspoil*grate);
}
     if (dspoil < 0)
{
        delay(tref+dspoil);
    pe_gradient(0,-sgpe*nv/2.0,0.0,sgpe,v6);

    delay(-dspoil);
        zero_all_gradients();
        delay(risetref);
        if (risetref<Gspoil*grate+dspoil)
        	delay(Gspoil*grate+dspoil-risetref);

}
       

        /*******************************************************
        * Optional RF spoiling.  REMINDER: Do not place any events
        * after this block or before poffset at the start of peloop.
        *******************************************************/
        if (rfspoil[0] == 'y'  ||  rfspoil[0] == 'Y') {
          voffset(0,v6);
          delay(RFSPOILDELAY - OFFSET_DELAY);
        }
//} /*for loop for gems ends here (ikj counter)*/
      endpeloop(seqcon[2],v6);
endmsloop(seqcon[1],v8);

//    endpeloop(seqcon[3],v8);
rcvroff();             
}

/**************************************************************************
                   Modification History

981027(ss) - Duty cycle checks added. debug flag added.
990624(ss) - Transmitter freq changed from tof to resto.

HS:
1. delete 3rd dimension peloop
2. replace manually 'for loop' for multislices with 'msloop'
3. create and use 'poffsetlist' instead of 'poffset'
***************************************************************************/

