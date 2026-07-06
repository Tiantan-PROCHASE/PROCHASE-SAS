proc import out=WORK.prochase
  datafile = "D:\..\prochase.sav"
  dbms = SAV replace;
  fmtlib = WORK.FORMATS;
run;

data PP; 
set prochase;
where PPS=1;
run; 

data prochase_mixed;
    set prochase;
    

    time=1;
    LYC=F1_BC_LYC;
	BNP=F1_BNP_log;
	NLR=F1_NLR_log;
	LYMPH_B=F1_BC_LYMPH_B;
	LYMPH_NK=F1_BC_LYMPH_NK;
	LYMPH_CD3=F1_BC_LYMPH_CD3;
	LYMPH_CD4=F1_BC_LYMPH_CD4;
	LYMPH_CD8=F1_BC_LYMPH_CD8;

    output;
    
    time=2;
    LYC=F2_BC_LYC;
	BNP=F2_BNP_log;
	NLR=F2_NLR_log;
	LYMPH_B=F2_BC_LYMPH_B;
	LYMPH_NK=F2_BC_LYMPH_NK;
	LYMPH_CD3=F2_BC_LYMPH_CD3;
	LYMPH_CD4=F2_BC_LYMPH_CD4;
	LYMPH_CD8=F2_BC_LYMPH_CD8;
  
    output;
    
    time=3;
    LYC=F3_BC_LYC;
	BNP=F3_BNP_log;
	NLR=F3_NLR_log;
	LYMPH_B=F3_BC_LYMPH_B;
	LYMPH_NK=F3_BC_LYMPH_NK;
	LYMPH_CD3=F3_BC_LYMPH_CD3;
	LYMPH_CD4=F3_BC_LYMPH_CD4;
	LYMPH_CD8=F3_BC_LYMPH_CD8;

    output;
    
    keep CODE time LYC BNP NLR LYMPH_B LYMPH_NK LYMPH_CD3 LYMPH_CD4 LYMPH_CD8  
    group A_AGE F1_NIHSS_SC F1_GCS_SC HMA_VOL1 
    F1_BC_LYC F1_BC_BNP F1_BC_NLR F1_BC_LYMPH_B F1_BC_LYMPH_NK F1_BC_LYMPH_CD3 F1_BC_LYMPH_CD4 F1_BC_LYMPH_CD8;
run;


****Table 1****;
proc means data= prochase n nmiss mean std median p25 p75 min max;
var A_AGE F1_SBP1 F1_NIHSS_SC F1_GCS_SC F1_BC_LYC HMA_VOL1 A_RD_hour A_DG_hour;
class group;
run;

proc freq data=prochase ; 
tables (A_GENDER A_ETHNIC H_SMK01 H_DRINK01  H_HYPT01 H_DIAB01 H_HD_CHD01 I_DYSPHAGIA F1_BLEED_THA  F1_HMA_BV) * group; 
run;




****Table 2****;

proc freq data=prochase ;
tables (SAP MRS_03 F6_MRS_NEW SAE_BRADC_1 SAE_BRADC_2 MCE_DEATH)*group;  
run;

proc genmod data=prochase descending;
 class  group(ref="0")  SAP A_RD_N/param=ref desc;
 model SAP = group   /dist=bin link=log;
 estimate 'rr'  group 1 -1/exp;
run;
proc genmod data=prochase descending;
 class  group(ref="0")  SAP A_RD_N/param=ref desc;
 model SAP = group   /dist=bin link=identity;
 estimate 'rd'  group 1 -1;
run;


proc genmod data=prochase descending;
 class  group(ref="0")  MRS_03 A_RD_N/param=ref desc;
 model MRS_03 = group   /dist=bin link=log;
 estimate 'rr'  group 1 -1/exp;
run;
proc genmod data=prochase descending;
 class  group(ref="0")  MRS_03 A_RD_N/param=ref desc;
 model MRS_03 = group   /dist=bin link=identity;
 estimate 'rd'  group 1 -1;
run;


proc genmod data=prochase descending;
 class  group(ref="0")  SAE_BRADC_1 A_RD_N/param=ref desc;
 model SAE_BRADC_1 = group   /dist=bin link=log;
 estimate 'rr'  group 1 -1/exp;
run;
proc genmod data=prochase descending;
 class  group(ref="0")  SAE_BRADC_1 A_RD_N/param=ref desc;
 model SAE_BRADC_1 = group   /dist=bin link=identity;
 estimate 'rd'  group 1 -1;
run;


proc genmod data=prochase descending;
 class  group(ref="0")  SAE_BRADC_2 A_RD_N/param=ref desc;
 model SAE_BRADC_2 = group   /dist=bin link=log;
 estimate 'rr'  group 1 -1/exp;
run;
proc genmod data=prochase descending;
 class  group(ref="0")  SAE_BRADC_2 A_RD_N/param=ref desc;
 model SAE_BRADC_2 = group   /dist=bin link=identity;
 estimate 'rd'  group 1 -1;
run;

proc phreg data=prochase ; 
class group(ref="0") / param=ref;  
model lastvist*MCE_DEATH(0)= GROUP/ RISKLIMITS ; 
run; 
proc genmod data=prochase descending;
 class  group(ref="0")  MCE_DEATH A_RD_N/param=ref desc;
 model MCE_DEATH = group   /dist=bin link=identity;
 estimate 'rd'  group 1 -1;
run;


proc genmod data=prochase descending;
 class  group(ref="0")  SAP A_RD_N/param=ref desc;
 model SAP = group A_AGE  F1_NIHSS_SC  F1_GCS_SC HMA_VOL1 /dist=poi link=log;
 estimate 'rr'  group 1 -1/exp;
run;
proc genmod data=prochase descending;
 class  group(ref="0")  SAP A_RD_N/param=ref desc;
 model SAP = group A_AGE  F1_NIHSS_SC  F1_GCS_SC HMA_VOL1  /dist=bin link=identity;
 estimate 'rd'  group 1 -1;
run;


proc genmod data=prochase descending;
 class  group(ref="0")  MRS_03 A_RD_N/param=ref desc;
 model MRS_03 = group  A_AGE  F1_NIHSS_SC  F1_GCS_SC HMA_VOL1 /dist=bin link=log;
 estimate 'rr'  group 1 -1/exp;
run;
proc genmod data=prochase descending;
 class  group(ref="0")  MRS_03 A_RD_N/param=ref desc;
 model MRS_03= group A_AGE  F1_NIHSS_SC  F1_GCS_SC HMA_VOL1  /dist=poi link=identity;
 estimate 'rd'  group 1 -1;
run;


proc genmod data=prochase descending;
 class  group(ref="0")  SAE_BRADC_1 A_RD_N/param=ref desc;
 model SAE_BRADC_1 = group  A_AGE  F1_NIHSS_SC  F1_GCS_SC HMA_VOL1 /dist=bin link=log;
 estimate 'rr'  group 1 -1/exp;
run;
proc genmod data=prochase descending;
 class  group(ref="0")  SAE_BRADC_1 A_RD_N/param=ref desc;
 model SAE_BRADC_1= group A_AGE  F1_NIHSS_SC  F1_GCS_SC HMA_VOL1  /dist=bin link=identity;
 estimate 'rd'  group 1 -1;
run;


proc genmod data=prochase descending;
 class  group(ref="0")  SAE_BRADC_2 A_RD_N/param=ref desc;
 model SAE_BRADC_2 = group  A_AGE  F1_NIHSS_SC  F1_GCS_SC HMA_VOL1 /dist=bin link=log;
 estimate 'rr'  group 1 -1/exp;
run;
proc genmod data=prochase descending;
 class  group(ref="0")  SAE_BRADC_2 A_RD_N/param=ref desc;
 model SAE_BRADC_2= group A_AGE  F1_NIHSS_SC  F1_GCS_SC HMA_VOL1  /dist=bin link=identity;
 estimate 'rd'  group 1 -1;
run;


proc phreg data=prochase; 
class group(ref="0") / param=ref;  
model lastvist*MCE_DEATH(0)= GROUP A_AGE  F1_NIHSS_SC  F1_GCS_SC HMA_VOL1 / RISKLIMITS ; 
run; 
proc genmod data=prochase descending;
 class  group(ref="0")  MCE_DEATH A_RD_N/param=ref desc;
 model MCE_DEATH = group A_AGE  F1_NIHSS_SC  F1_GCS_SC HMA_VOL1  /dist=bin link=identity;
 estimate 'rd'  group 1 -1;
run;



****Figur3****;
proc genmod data=prochase   ;
 class  group SAP AGE_cat1 /param=ref desc;
 model SAP = group AGE_cat1 group*AGE_cat1/dist=bin link = log ;
 estimate 'RR' group 1 -1/ exp;  
run;
proc freq data=prochase (where=(AGE_cat1=1)); 
tables SAP * group; 
run;
proc genmod data=prochase (where=(AGE_cat1=1)) descending;
 class  group(ref="0")  SAP A_RD_N/param=ref desc;
 model SAP = group  F1_NIHSS_SC  F1_GCS_SC HMA_VOL1    /dist=bin link=log;
 estimate 'A_AGE<60'  group 1 -1/exp;
run;

proc freq data=prochase (where=(AGE_cat1=2)); 
tables SAP * group; 
run;
proc genmod data=prochase (where=(AGE_cat1=2)) descending;
 class  group(ref="0")  SAP A_RD_N/param=ref desc;
 model SAP = group   F1_NIHSS_SC  F1_GCS_SC HMA_VOL1   /dist=poi link=log;
 estimate 'A_AGE>60'  group 1 -1/exp;
run;


proc genmod data=prochase   ;
 class  group SAP A_GENDER /param=ref desc;
 model SAP = group A_GENDER group*A_GENDER/dist=bin link = log ;
 estimate 'RR' group 1 -1/ exp;  
run;
proc freq data=prochase (where=(A_GENDER=1)); 
tables SAP * group; 
run;
proc genmod data=prochase (where=(A_GENDER=1)) descending;
 class  group(ref="0")  SAP A_RD_N/param=ref desc;
 model SAP = group A_AGE  F1_NIHSS_SC  F1_GCS_SC HMA_VOL1    /dist=bin link=log;
 estimate 'A_GENDER=1'  group 1 -1/exp;
run;

proc freq data=prochase (where=(A_GENDER=2)); 
tables SAP * group; 
run;
proc genmod data=prochase (where=(A_GENDER=2)) descending;
 class  group(ref="0")  SAP A_RD_N/param=ref desc;
 model SAP = group  A_AGE  F1_NIHSS_SC  F1_GCS_SC HMA_VOL1   /dist=poi link=log;
 estimate 'A_GENDER=2'  group 1 -1/exp;
run;

proc genmod data=prochase   ;
 class  group SAP HMA_VOL_CAT /param=ref desc;
 model SAP = group HMA_VOL_CAT group*HMA_VOL_CAT/dist=bin link = log ;
 estimate 'RR' group 1 -1/ exp;  
run;
proc freq data=prochase (where=(HMA_VOL_CAT=1)); 
tables SAP * group; 
run;
proc genmod data=prochase (where=(HMA_VOL_CAT=1)) descending;
 class  group(ref="0")  SAP A_RD_N/param=ref desc;
 model SAP = group A_AGE  F1_NIHSS_SC  F1_GCS_SC     /dist=poi link=log;
 estimate '10<=HMA_VOL1<=30'  group 1 -1/exp;
run;

proc freq data=prochase (where=(HMA_VOL_CAT=2)); 
tables SAP * group; 
run;
proc genmod data=prochase (where=(HMA_VOL_CAT=2)) descending;
 class  group(ref="0")  SAP A_RD_N/param=ref desc;
 model SAP = group  A_AGE  F1_NIHSS_SC  F1_GCS_SC    /dist=bin link=log;
 estimate 'HMA_VOL1>30'  group 1 -1/exp;
run;


proc genmod data=prochase   ;
 class  group SAP GCS_CAT /param=ref desc;
 model SAP = group GCS_CAT group*GCS_CAT/dist=bin link = log ;
 estimate 'RR' group 1 -1/ exp;  
run;
proc freq data=prochase (where=(GCS_CAT=1)); 
tables SAP * group; 
run;
proc genmod data=prochase (where=(GCS_CAT=1)) descending;
 class  group(ref="0")  SAP A_RD_N/param=ref desc;
 model SAP = group A_AGE  F1_NIHSS_SC   HMA_VOL1    /dist=bin link=log;
 estimate '8<=F1_GCS_SC<=12'  group 1 -1/exp;
run;

proc freq data=prochase (where=(GCS_CAT=2)); 
tables SAP * group; 
run;
proc genmod data=prochase (where=(GCS_CAT=2)) descending;
 class  group(ref="0")  SAP A_RD_N/param=ref desc;
 model SAP = group  A_AGE  F1_NIHSS_SC  HMA_VOL1   /dist=poi link=log;
 estimate '13<=F1_GCS_SC<=15'  group 1 -1/exp;
run;


proc genmod data=prochase   ;
 class  group SAP NIHSS_CAT /param=ref desc;
 model SAP = group NIHSS_CAT group*NIHSS_CAT/dist=bin link = log ;
 estimate 'RR' group 1 -1/ exp;  
run;
proc freq data=prochase (where=(NIHSS_CAT=1)); 
tables SAP * group; 
run;
proc genmod data=prochase (where=(NIHSS_CAT=1)) descending;
 class  group(ref="0")  SAP A_RD_N/param=ref desc;
 model SAP = group A_AGE   F1_GCS_SC HMA_VOL1    /dist=bin link=log;
 estimate '11<=F1_NIHSS_SC<=15'  group 1 -1/exp;
run;

proc freq data=prochase (where=(NIHSS_CAT=2)); 
tables SAP * group; 
run;
proc genmod data=prochase (where=(NIHSS_CAT=2)) descending;
 class  group(ref="0")  SAP A_RD_N/param=ref desc;
 model SAP = group  A_AGE  F1_GCS_SC HMA_VOL1   /dist=poi link=log;
 estimate '16<=F1_NIHSS_SC<=25'  group 1 -1/exp;
run;


proc genmod data=prochase   ;
 class  group SAP I_DYSPHAGIA /param=ref desc;
 model SAP = group I_DYSPHAGIA group*I_DYSPHAGIA/dist=bin link = log ;
 estimate 'RR' group 1 -1/ exp;  
run;
proc freq data=prochase (where=(I_DYSPHAGIA=1)); 
tables SAP * group; 
run;
proc genmod data=prochase (where=(I_DYSPHAGIA=1)) descending;
 class  group(ref="0")  SAP A_RD_N/param=ref desc;
 model SAP = group A_AGE  F1_NIHSS_SC  F1_GCS_SC HMA_VOL1    /dist=poi link=log;
 estimate 'I_DYSPHAGIA=1'  group 1 -1/exp;
run;

proc freq data=prochase (where=(I_DYSPHAGIA=0)); 
tables SAP * group; 
run;
proc genmod data=prochase (where=(I_DYSPHAGIA=0)) descending;
 class  group(ref="0")  SAP A_RD_N/param=ref desc;
 model SAP = group  A_AGE  F1_NIHSS_SC  F1_GCS_SC HMA_VOL1   /dist=poi link=log;
 estimate 'I_DYSPHAGIA=0'  group 1 -1/exp;
run;


proc genmod data=prochase   ;
 class  group SAP RD_hour_cat1 /param=ref desc;
 model SAP = group RD_hour_cat1 group*RD_hour_cat1/dist=bin link = log ;
 estimate 'RR' group 1 -1/ exp;  
run;
proc freq data=prochase (where=(RD_hour_cat1=1)); 
tables SAP * group; 
run;
proc genmod data=prochase (where=(RD_hour_cat1=1)) descending;
 class  group(ref="0")  SAP A_RD_N/param=ref desc;
 model SAP = group A_AGE  F1_NIHSS_SC  F1_GCS_SC HMA_VOL1    /dist=bin link=log;
 estimate '0<=A_RD_hour<=12'  group 1 -1/exp;
run;

proc freq data=prochase (where=(RD_hour_cat1=2)); 
tables SAP * group; 
run;
proc genmod data=prochase (where=(RD_hour_cat1=2)) descending;
 class  group(ref="0")  SAP A_RD_N/param=ref desc;
 model SAP = group  A_AGE  F1_NIHSS_SC  F1_GCS_SC HMA_VOL1   /dist=bin link=log;
 estimate '12<A_RD_hour'  group 1 -1/exp;
run;



proc genmod data=prochase   ;
 class  group SAP H_HYPT01 /param=ref desc;
 model SAP = group H_HYPT01 group*H_HYPT01/dist=bin link = log ;
 estimate 'RR' group 1 -1/ exp;  
run;
proc freq data=prochase (where=(H_HYPT01=1)); 
tables SAP * group; 
run;
proc genmod data=prochase (where=(H_HYPT01=1)) descending;
 class  group(ref="0")  SAP A_RD_N/param=ref desc;
 model SAP = group A_AGE  F1_NIHSS_SC  F1_GCS_SC HMA_VOL1    /dist=bin link=log;
 estimate 'H_HYPT01=1'  group 1 -1/exp;
run;

proc freq data=prochase (where=(H_HYPT01=0)); 
tables SAP * group; 
run;
proc genmod data=prochase (where=(H_HYPT01=0)) descending;
 class  group(ref="0")  SAP A_RD_N/param=ref desc;
 model SAP = group  A_AGE  F1_NIHSS_SC  F1_GCS_SC HMA_VOL1   /dist=bin link=log;
 estimate 'H_HYPT01=0'  group 1 -1/exp;
run;


proc genmod data=prochase   ;
 class  group SAP F1_HMA_BV /param=ref desc;
 model SAP = group F1_HMA_BV group*F1_HMA_BV/dist=bin link = log ;
 estimate 'RR' group 1 -1/ exp;  
run;
proc freq data=prochase (where=(F1_HMA_BV=2)); 
tables SAP * group; 
run;
proc genmod data=prochase (where=(F1_HMA_BV=2)) descending;
 class  group(ref="0")  SAP A_RD_N/param=ref desc;
 model SAP = group A_AGE  F1_NIHSS_SC  F1_GCS_SC HMA_VOL1    /dist=bin link=log;
 estimate 'F1_HMA_BV=2'  group 1 -1/exp;
run;

proc freq data=prochase (where=(F1_HMA_BV=1)); 
tables SAP * group; 
run;
proc genmod data=prochase (where=(F1_HMA_BV=1)) descending;
 class  group(ref="0")  SAP A_RD_N/param=ref desc;
 model SAP = group  A_AGE  F1_NIHSS_SC  F1_GCS_SC HMA_VOL1   /dist=bin link=log;
 estimate 'F1_HMA_BV=1'  group 1 -1/exp;
run;




****Figure S1****;

proc freq data=prochase ; 
tables  F6_MRS_NEW * group; 
run;

proc logisitc data=prochase ;class  group(ref="0")/param=ref ;model F6_MRS_NEW=group;run;



***Table S1****;

proc means data= prochase n nmiss mean std median p25 p75 min max;
var F1_HR  F1_DBP;
class group;
run;

proc freq data=prochase ; 
tables (H_DYPL01 F1_AP F1_AC F1_MRS H_CVD_TIA01 H_CVD_ICH01 H_PAD01 F1_HMA_SAS F1_BLEED_LOBE SAE_VFib H_MD01) * group
; 
run;




****Table S2****;

proc means data= PP n nmiss mean std median p25 p75 min max;
var A_AGE F1_SBP1 F1_NIHSS_SC F1_GCS_SC HMA_VOL1 A_RD_hour A_DG_hour F1_HR F1_BC_LYC F1_DBP;
class group;
run;

proc freq data=PP ; 
tables (A_GENDER A_ETHNIC H_SMK01 H_DRINK01  H_HYPT01 H_DIAB01 H_HD_CHD01 I_DYSPHAGIA F1_BLEED_THA  F1_HMA_BV
        H_DYPL01 F1_AP F1_AC F1_MRS H_CVD_TIA01 H_CVD_ICH01 H_PAD01 F1_HMA_SAS F1_BLEED_LOBE SAE_VFib H_MD01) * group
; 
run;



*****Table S3****;

proc freq data=prochase ; 
tables (I_PRO_ATB I_SURG_ICP I_SURG I_SURG_1 I_SURG_2 I_SURG_3 I_SURG_4 I_SURG_5 NTIOTI MV I_F1_BB I_F2_BB I_AA I_ACEI I_ARB I_ARNI I_CCB I_TT  I_CCB_NIC I_NO I_HGD  I_OSM_CS I_OSM_FM I_OSM_GL I_OSM_Mannitol I_PPI) *group
;  
run;



****TableS5****;

proc freq data=PP ;
tables (SAP MRS_03 F6_MRS_NEW SAE_BRADC_1 SAE_BRADC_2 MCE_DEATH)*group;  
run;

proc genmod data=PP descending;
 class  group(ref="0")  SAP A_RD_N/param=ref desc;
 model SAP = group   /dist=bin link=log;
 estimate 'rr'  group 1 -1/exp;
run;

proc genmod data=PP descending;
 class  group(ref="0")  SAP A_RD_N/param=ref desc;
 model SAP = group   /dist=bin link=identity;
 estimate 'rd'  group 1 -1;
run;


proc genmod data=PP descending;
 class  group(ref="0")  MRS_03 A_RD_N/param=ref desc;
 model MRS_03 = group   /dist=bin link=log;
 estimate 'rr'  group 1 -1/exp;
run;

proc genmod data=PP descending;
 class  group(ref="0")  MRS_03 A_RD_N/param=ref desc;
 model MRS_03 = group   /dist=bin link=identity;
 estimate 'rd'  group 1 -1;
run;


proc genmod data=PP descending;
 class  group(ref="0")  SAE_BRADC_1 A_RD_N/param=ref desc;
 model SAE_BRADC_1 = group   /dist=bin link=log;
 estimate 'rr'  group 1 -1/exp;
run;

proc genmod data=PP descending;
 class  group(ref="0")  SAE_BRADC_1 A_RD_N/param=ref desc;
 model SAE_BRADC_1 = group   /dist=bin link=identity;
 estimate 'rd'  group 1 -1;
run;


proc genmod data=PP descending;
 class  group(ref="0")  SAE_BRADC_2 A_RD_N/param=ref desc;
 model SAE_BRADC_2 = group   /dist=bin link=log;
 estimate 'rr'  group 1 -1/exp;
run;

proc genmod data=PP descending;
 class  group(ref="0")  SAE_BRADC_2 A_RD_N/param=ref desc;
 model SAE_BRADC_2 = group   /dist=bin link=identity;
 estimate 'rd'  group 1 -1;
run;

proc phreg data=PP ; 
class group(ref="0") / param=ref;  
model lastvist*MCE_DEATH(0)= GROUP/ RISKLIMITS ; 
run; 

proc genmod data=PP descending;
 class  group(ref="0")  MCE_DEATH A_RD_N/param=ref desc;
 model MCE_DEATH = group   /dist=bin link=identity;
 estimate 'rd'  group 1 -1;
run;


proc genmod data=PP descending;
 class  group(ref="0")  SAP A_RD_N/param=ref desc;
 model SAP = group A_AGE  F1_NIHSS_SC  F1_GCS_SC HMA_VOL1 /dist=poi link=log;
 estimate 'rr'  group 1 -1/exp;
run;

proc genmod data=PP descending;
 class  group(ref="0")  SAP A_RD_N/param=ref desc;
 model SAP = group A_AGE  F1_NIHSS_SC  F1_GCS_SC HMA_VOL1  /dist=bin link=identity;
 estimate 'rd'  group 1 -1;
run;


proc genmod data=PP descending;
 class  group(ref="0")  MRS_03 A_RD_N/param=ref desc;
 model MRS_03 = group  A_AGE  F1_NIHSS_SC  F1_GCS_SC HMA_VOL1 /dist=bin link=log;
 estimate 'rr'  group 1 -1/exp;
run;

proc genmod data=PP descending;
 class  group(ref="0")  MRS_03 A_RD_N/param=ref desc;
 model MRS_03= group A_AGE  F1_NIHSS_SC  F1_GCS_SC HMA_VOL1  /dist=poi link=identity;
 estimate 'rd'  group 1 -1;
run;


proc genmod data=PP descending;
 class  group(ref="0")  SAE_BRADC_1 A_RD_N/param=ref desc;
 model SAE_BRADC_1 = group  A_AGE  F1_NIHSS_SC  F1_GCS_SC HMA_VOL1 /dist=bin link=log;
 estimate 'rr'  group 1 -1/exp;
run;

proc genmod data=PP descending;
 class  group(ref="0")  SAE_BRADC_1 A_RD_N/param=ref desc;
 model SAE_BRADC_1= group A_AGE  F1_NIHSS_SC  F1_GCS_SC HMA_VOL1  /dist=bin link=identity;
 estimate 'rd'  group 1 -1;
run;


proc genmod data=PP descending;
 class  group(ref="0")  SAE_BRADC_2 A_RD_N/param=ref desc;
 model SAE_BRADC_2 = group  A_AGE  F1_NIHSS_SC  F1_GCS_SC HMA_VOL1 /dist=bin link=log;
 estimate 'rr'  group 1 -1/exp;
run;

proc genmod data=PP descending;
 class  group(ref="0")  SAE_BRADC_2 A_RD_N/param=ref desc;
 model SAE_BRADC_2= group A_AGE  F1_NIHSS_SC  F1_GCS_SC HMA_VOL1  /dist=bin link=identity;
 estimate 'rd'  group 1 -1;
run;


proc phreg data=PP; 
class group(ref="0") / param=ref;  
model lastvist*MCE_DEATH(0)= GROUP A_AGE  F1_NIHSS_SC  F1_GCS_SC HMA_VOL1 / RISKLIMITS ; 
run; 

proc genmod data=PP descending;
 class  group(ref="0")  MCE_DEATH A_RD_N/param=ref desc;
 model MCE_DEATH = group A_AGE  F1_NIHSS_SC  F1_GCS_SC HMA_VOL1  /dist=bin link=identity;
 estimate 'rd'  group 1 -1;
run;



****TableS6****;

proc freq data=prochase ; 
tables (SAE SAE_CD SAE_MI SAE_ConHF SAE_GD SAE_BLEED_GASTROEN SAE_HI SAE_ileus SAE_HD SAE_ANEMIA SAE_PLT SAE_NSD SAE_HEXPAND  SAE_REBLEED SAE_ODEMA SAE_HE SAE_ENCEPHALUS SAE_SEIZURE SAE_CHYPERTHE SAE_INF SAE_INF_CRANIAL SAE_INF_GASTROENTERO SAE_INF_SEPSIS SAE_COVID_19 SAE_UTI_BU SAE_RENAL_FAILURE SAE_RT SAE_RES_FAILURE  SAE_ASTHMA SAE_VD  SAE_HYPOTENSION SAE_PE ) *group/chisq;  
run;



****TableS7****;

proc freq data=prochase ; 
tables (AE AE_HD AE_Hb AE_PLT AE_CD AE_Tachycardia AE_CARDIAL AE_MYOCARDIAL AE_GD AE_HEE AE_Diarrhea AE_VENT AE_BLEED_Gastroen AE_RAUD AE_Renal_Dysfunction AE_BLEED_Urinary AE_VD AE_PICCT AE_VTE AE_others AE_DELIRIUM AE_RASH)* group/chisq;  
run;


****Table S8****;

proc freq data=prochase ; 
tables ( C1_1 C1_2 C2_1 C2_2 C2_3 C3) * group; 
run;

proc genmod data=prochase descending;
 class  group(ref="0")  SAP A_RD_N/param=ref desc;
 model C1_1 = group   /dist=bin link=log;
 estimate 'rr'  group 1 -1/exp;
run;

proc genmod data=prochase descending;
 class  group(ref="0")  SAP A_RD_N/param=ref desc;
 model C1_2 = group   /dist=bin link=log;
 estimate 'rr'  group 1 -1/exp;
run;

proc genmod data=prochase descending;
 class  group(ref="0")  SAP A_RD_N/param=ref desc;
 model C2_1 = group   /dist=bin link=log;
 estimate 'rr'  group 1 -1/exp;
run;

proc genmod data=prochase descending;
 class  group(ref="0")  SAP A_RD_N/param=ref desc;
 model C2_2 = group   /dist=bin link=log;
 estimate 'rr'  group 1 -1/exp;
run;

proc genmod data=prochase descending;
 class  group(ref="0")  SAP A_RD_N/param=ref desc;
 model C2_3 = group   /dist=bin link=log;
 estimate 'rr'  group 1 -1/exp;
run;

proc genmod data=prochase descending;
 class  group(ref="0")  SAP A_RD_N/param=ref desc;
 model C3 = group   /dist=bin link=log;
 estimate 'rr'  group 1 -1/exp;
run;




****Table S9****;

proc genmod data=prochase descending;
 class  group(ref="0")  SAP A_RD_N/param=ref desc;
 model SAP = group   /dist=bin link=log;
 estimate 'rr'  group 1 -1/exp;
run;

proc genmod data=prochase descending;
 class  group(ref="0")  SAP A_RD_N/param=ref desc;
 model SAP = group   /dist=bin link=identity;
 estimate 'rd'  group 1 -1;
run;


data ITT1;
set prochase;
if SAP=0 or SAP=. then SAP_1=0 ; else SAP_1=1;
run;

proc genmod data=ITT1 descending;
 class  group(ref="0")  SAP_1 A_RD_N/param=ref desc;
 model SAP_1 = group   /dist=bin link=log;
 estimate 'rr'  group 1 -1/exp;
run;


data ITT1;
set prochase;
if SAP=0 or SAP=. then SAP_1=0 ; else SAP_1=1;
run;

proc genmod data=ITT1 descending;
 class  group(ref="0")  SAP_1 A_RD_N/param=ref desc;
 model SAP_1 = group   /dist=bin link=log;
 estimate 'rr'  group 1 -1/exp;
run;


data ITT2;
set prochase;
if SAP=0  then SAP_2=0 ; else if or SAP=. and SAP=1 then SAP_2=1;
run;

proc genmod data=ITT2 descending;
 class  group(ref="0")  SAP_2 A_RD_N/param=ref desc;
 model SAP_2 = group   /dist=bin link=log;
 estimate 'rr'  group 1 -1/exp;
run;

proc sort data=prochase;  by group;run;

proc mi data=prochase seed=123456789 nimpute=10 out=prochase_1( 
keep=_Imputation_ SAP group  A_GENDER A_AGE    
 index=(x=(_Imputation_ group ))) noprint;
   by   group;
   mcmc displayinit initial=em(itprint);
   class SAP ;
   fcs logistic( SAP /details) ;
   var SAP  A_GENDER A_AGE ;
run;
proc sort data=prochase_1 force;by _Imputation_ group;run;

proc genmod data= prochase_1   ;
 class   SAP group /param=ref desc;
 model SAP = group /dist=bin link = log ;
 by _Imputation_;
 estimate 'Beta' group 1 -1/ exp;  
ods output ParameterEstimates=_rr_Estimates;
run;

proc mianalyze data=_rr_Estimates;
  where Parameter="group" and Level1="1"; 
  modeleffects Estimate;
  stderr StdErr;
  ods output ParameterEstimates=main_parms;
run;


DATA main_parms_t; SET main_parms;
  format RR LCL_RR UCL_RR 10.3;
RR = EXP(ESTIMATE);
LCL_RR=RR*EXP(-1.96*StdErr);
UCL_RR=RR*EXP(+1.96*StdErr); 
RUN;

proc print data=main_parms_t;
var Parm RR LCL_RR UCL_RR ;
run;


proc genmod data=PP descending;
 class  group(ref="0")  SAP A_RD_N/param=ref desc;
 model SAP = group   /dist=bin link=log;
 estimate 'rr'  group 1 -1/exp;
run;

proc genmod data=PP descending;
 class  group(ref="0")  SAP A_RD_N/param=ref desc;
 model SAP = group   /dist=bin link=identity;
 estimate 'rd'  group 1 -1;
run;


data PP1;
set PP;
if SAP=0 or SAP=. then SAP_1=0 ; else SAP_1=1;
run;

proc genmod data=PP1 descending;
 class  group(ref="0")  SAP_1 A_RD_N/param=ref desc;
 model SAP_1 = group   /dist=bin link=log;
 estimate 'rr'  group 1 -1/exp;
run;


data PP1;
set PP;
if SAP=0 or SAP=. then SAP_1=0 ; else SAP_1=1;
run;

proc genmod data=PP1 descending;
 class  group(ref="0")  SAP_1 A_RD_N/param=ref desc;
 model SAP_1 = group   /dist=bin link=log;
 estimate 'rr'  group 1 -1/exp;
run;


data PP2;
set PP;
if SAP=0 then SAP_2=0 ; else if  SAP=. or SAP=1 then SAP_2=1;
run;

proc genmod data=PP2 descending;
 class  group(ref="0")  A_RD_N/param=ref desc;
 model SAP_2 = group /dist=bin link=log;
 estimate 'rr'  group 1 -1/exp;
run;


proc mi data=PP seed=123456789 nimpute=20 out=PP_1( 
keep=_Imputation_ SAP group A_AGE A_GENDER F1_NIHSS_SC  F1_GCS_SC HMA_VOL1  
 index=(x=(_Imputation_ group ))) noprint;
   mcmc displayinit initial=em(itprint);
   class SAP ;
   fcs logistic( SAP /details) ;
   var SAP A_AGE A_GENDER;
run;
proc sort data=PP_1 force;by _Imputation_ group;run;


proc genmod data= PP_1  desc ;
 class  group(ref="0") /param=ref ;
 model SAP = group /dist=bin link = log ;
 by _Imputation_;
 estimate 'Beta' group 1 -1/ ;  
ods output ParameterEstimates=_rr_Estimates;
run;

proc mianalyze data=_rr_Estimates;
  where Parameter="group" ;
  modeleffects Estimate;
  stderr StdErr;
  ods output ParameterEstimates=main_parms;
run;

DATA main_parms_t; SET main_parms;
  format RR LCL_RR UCL_RR 10.3;
RR = EXP(ESTIMATE); 
LCL_RR=EXP(LCLMean); 
UCL_RR=EXP(UCLMean); 
RUN;

proc print data=main_parms_t;
var Parm RR LCL_RR UCL_RR ;
run;


ods excel close;




****Table S10****;

proc freq data=prochase; 
tables I_PRO_ATB * group; 
run;

proc genmod data=prochase descending;
 class  group(ref="0")  SAP A_RD_N/param=ref desc;
 model SAP = group A_AGE  F1_NIHSS_SC  F1_GCS_SC HMA_VOL1  I_PRO_ATB  /dist=poi link=log;
 estimate 'RR'  group 1 -1/exp;
run;

proc genmod data=prochase  descending;
 class  group(ref="0")  SAP A_RD_N/param=ref desc;
 model SAP = group  A_AGE  F1_NIHSS_SC  F1_GCS_SC HMA_VOL1  I_PRO_ATB /dist=bin link=identity;
 estimate 'rd'  group 1 -1;
run;


proc freq data=prochase ; 
tables I_SURG * group; 
run;

proc genmod data=prochase  descending;
 class  group(ref="0")  SAP A_RD_N/param=ref desc;
 model SAP = group A_AGE  F1_NIHSS_SC  F1_GCS_SC HMA_VOL1  I_SURG  /dist=poi link=log;
 estimate 'RR'  group 1 -1/exp;
run;

proc genmod data=prochase  descending;
 class  group(ref="0")  SAP A_RD_N/param=ref desc;
 model SAP = group  A_AGE  F1_NIHSS_SC  F1_GCS_SC HMA_VOL1  I_SURG /dist=bin link=identity;
 estimate 'rd'  group 1 -1;
run;


proc freq data=prochase; 
tables NTIOTI * group; 
run;

proc genmod data=prochase  descending;
 class  group(ref="0")  SAP A_RD_N/param=ref desc;
 model SAP = group A_AGE  F1_NIHSS_SC  F1_GCS_SC HMA_VOL1  NTIOTI  /dist=poi link=log;
 estimate 'RR'  group 1 -1/exp;
run;

proc genmod data=prochase  descending;
 class  group(ref="0")  SAP A_RD_N/param=ref desc;
 model SAP = group  A_AGE  F1_NIHSS_SC  F1_GCS_SC HMA_VOL1  NTIOTI  /dist=bin link=identity;
 estimate 'rd'  group 1 -1;
run;


proc freq data=prochase ; 
tables MV * group; 
run;

proc genmod data=prochase  descending;
 class  group(ref="0")  SAP A_RD_N/param=ref desc;
 model SAP = group A_AGE  F1_NIHSS_SC  F1_GCS_SC HMA_VOL1 MV   /dist=poi link=log;
 estimate 'RR'  group 1 -1/exp;
run;

proc genmod data=prochase  descending;
 class  group(ref="0")  SAP A_RD_N/param=ref desc;
 model SAP = group  A_AGE  F1_NIHSS_SC  F1_GCS_SC HMA_VOL1 MV  /dist=bin link=identity;
 estimate 'rd'  group 1 -1;
run;


proc freq data=prochase ; 
tables I_F1_BB * group; 
run;

proc genmod data=prochase descending;
 class  group(ref="0")  SAP A_RD_N/param=ref desc;
 model SAP = group A_AGE  F1_NIHSS_SC  F1_GCS_SC HMA_VOL1  I_F1_BB  /dist=poi link=log;
 estimate 'RR'  group 1 -1/exp;
run;

proc genmod data=prochase  descending;
 class  group(ref="0")  SAP A_RD_N/param=ref desc;
 model SAP = group A_AGE  F1_NIHSS_SC  F1_GCS_SC HMA_VOL1  I_F1_BB   /dist=bin link=identity;
 estimate 'rd'  group 1 -1;
run;


proc genmod data=prochase descending;
 class  group(ref="0")  SAP A_RD_N/param=ref desc;
 model SAP = group A_AGE  F1_NIHSS_SC  F1_GCS_SC HMA_VOL1 I_PRO_ATB I_SURG NTIOTI MV I_F1_BB  /dist=poi link=log;
 estimate 'RR'  group 1 -1/exp;
run;

proc genmod data=prochase  descending;
 class  group(ref="0")  SAP A_RD_N/param=ref desc;
 model SAP = group A_AGE  F1_NIHSS_SC  F1_GCS_SC HMA_VOL1 I_PRO_ATB I_SURG NTIOTI MV I_F1_BB   /dist=bin link=identity;
 estimate 'rd'  group 1 -1;
run;


proc genmod data=prochase descending;
 class  group(ref="0")  SAP Hospital_N/param=ref desc;
 model SAP = group A_AGE  F1_NIHSS_SC  F1_GCS_SC HMA_VOL1    /dist=poi link=log;
 repeated subject=Hospital_N / type=ind;
 estimate 'RR'  group 1 -1/exp;
run;

proc genmod data=prochase descending;
    class group(ref="0") Hospital_N ;
    model SAP = group A_AGE F1_NIHSS_SC F1_GCS_SC HMA_VOL1  / dist=bin link=logit;
    repeated subject=Hospital_N / type=cs;
    
    lsmeans group / e cl;
    ods output coef=my_coef;
    
    store out=my_model;
run;
%NLMeans(instore=my_model,
         coef=my_coef,
         link=logit,
         diff=all);


proc freq data=prochase (where=(I_SURG=0)); 
tables SAP * group; 
run;

proc genmod data=prochase (where=(I_SURG=0)) descending;
 class  group(ref="0")  SAP A_RD_N/param=ref desc;
 model SAP = group A_AGE  F1_NIHSS_SC  F1_GCS_SC HMA_VOL1  /dist=poi link=log;
 estimate 'RR'  group 1 -1/exp;
run;

proc genmod data=prochase (where=(I_SURG=0)) descending;
 class  group(ref="0")  SAP A_RD_N/param=ref desc;
 model SAP = group  A_AGE  F1_NIHSS_SC  F1_GCS_SC HMA_VOL1 /dist=bin link=identity;
 estimate 'rd'  group 1 -1;
run;


proc freq data=prochase (where=(NTIOTI=0)); 
tables SAP * group; 
run;

proc genmod data=prochase (where=(NTIOTI=0)) descending;
 class  group(ref="0")  SAP A_RD_N/param=ref desc;
 model SAP = group A_AGE  F1_NIHSS_SC  F1_GCS_SC HMA_VOL1  /dist=poi link=log;
 estimate 'RR'  group 1 -1/exp;
run;

proc genmod data=prochase (where=(NTIOTI=0)) descending;
 class  group(ref="0")  SAP A_RD_N/param=ref desc;
 model SAP = group  A_AGE  F1_NIHSS_SC  F1_GCS_SC HMA_VOL1 /dist=bin link=identity;
 estimate 'rd'  group 1 -1;
run;


proc freq data=prochase (where=(MV=0)); 
tables SAP * group; 
run;

proc genmod data=prochase (where=(MV=0)) descending;
 class  group(ref="0")  SAP A_RD_N/param=ref desc;
 model SAP = group A_AGE  F1_NIHSS_SC  F1_GCS_SC HMA_VOL1  /dist=poi link=log;
 estimate 'RR'  group 1 -1/exp;
run;

proc genmod data=prochase (where=(MV=0)) descending;
 class  group(ref="0")  SAP A_RD_N/param=ref desc;
 model SAP = group  A_AGE  F1_NIHSS_SC  F1_GCS_SC HMA_VOL1 /dist=bin link=identity;
 estimate 'rd'  group 1 -1;
run;



proc freq data=prochase (where=(I_F1_BB=0)); 
tables SAP * group; 
run;

proc genmod data=prochase (where=(I_F1_BB=0)) descending;
 class  group(ref="0")  SAP A_RD_N/param=ref desc;
 model SAP = group A_AGE  F1_NIHSS_SC  F1_GCS_SC HMA_VOL1  /dist=poi link=log;
 estimate 'RR'  group 1 -1/exp;
run;

proc genmod data=prochase (where=(I_F1_BB=0)) descending;
 class  group(ref="0")  SAP A_RD_N/param=ref desc;
 model SAP = group  A_AGE  F1_NIHSS_SC  F1_GCS_SC HMA_VOL1 /dist=bin link=identity;
 estimate 'rd'  group 1 -1;
run;



****Table S11****;

proc freq data=pp; 
tables I_PRO_ATB * group; 
run;
proc genmod data=pp descending;
 class  group(ref="0")  SAP A_RD_N/param=ref desc;
 model SAP = group A_AGE  F1_NIHSS_SC  F1_GCS_SC HMA_VOL1  I_PRO_ATB  /dist=poi link=log;
 estimate 'RR'  group 1 -1/exp;
run;
proc genmod data=pp  descending;
 class  group(ref="0")  SAP A_RD_N/param=ref desc;
 model SAP = group  A_AGE  F1_NIHSS_SC  F1_GCS_SC HMA_VOL1  I_PRO_ATB /dist=bin link=identity;
 estimate 'rd'  group 1 -1;
run;

proc freq data=pp ; 
tables I_SURG * group; 
run;
proc genmod data=pp  descending;
 class  group(ref="0")  SAP A_RD_N/param=ref desc;
 model SAP = group A_AGE  F1_NIHSS_SC  F1_GCS_SC HMA_VOL1  I_SURG  /dist=poi link=log;
 estimate 'RR'  group 1 -1/exp;
run;
proc genmod data=pp  descending;
 class  group(ref="0")  SAP A_RD_N/param=ref desc;
 model SAP = group  A_AGE  F1_NIHSS_SC  F1_GCS_SC HMA_VOL1  I_SURG /dist=bin link=identity;
 estimate 'rd'  group 1 -1;
run;


proc freq data=pp; 
tables NTIOTI * group; 
run;
proc genmod data=pp  descending;
 class  group(ref="0")  SAP A_RD_N/param=ref desc;
 model SAP = group A_AGE  F1_NIHSS_SC  F1_GCS_SC HMA_VOL1  NTIOTI  /dist=poi link=log;
 estimate 'RR'  group 1 -1/exp;
run;
proc genmod data=pp  descending;
 class  group(ref="0")  SAP A_RD_N/param=ref desc;
 model SAP = group  A_AGE  F1_NIHSS_SC  F1_GCS_SC HMA_VOL1  NTIOTI  /dist=bin link=identity;
 estimate 'rd'  group 1 -1;
run;


proc freq data=pp ; 
tables MV * group; 
run;
proc genmod data=pp  descending;
 class  group(ref="0")  SAP A_RD_N/param=ref desc;
 model SAP = group A_AGE  F1_NIHSS_SC  F1_GCS_SC HMA_VOL1 MV   /dist=poi link=log;
 estimate 'RR'  group 1 -1/exp;
run;
proc genmod data=pp  descending;
 class  group(ref="0")  SAP A_RD_N/param=ref desc;
 model SAP = group  A_AGE  F1_NIHSS_SC  F1_GCS_SC HMA_VOL1 MV  /dist=bin link=identity;
 estimate 'rd'  group 1 -1;
run;


proc freq data=pp ; 
tables I_F1_BB * group; 
run;
proc genmod data=pp descending;
 class  group(ref="0")  SAP A_RD_N/param=ref desc;
 model SAP = group A_AGE  F1_NIHSS_SC  F1_GCS_SC HMA_VOL1  I_F1_BB  /dist=poi link=log;
 estimate 'RR'  group 1 -1/exp;
run;
proc genmod data=pp  descending;
 class  group(ref="0")  SAP A_RD_N/param=ref desc;
 model SAP = group A_AGE  F1_NIHSS_SC  F1_GCS_SC HMA_VOL1  I_F1_BB   /dist=bin link=identity;
 estimate 'rd'  group 1 -1;
run;


proc genmod data=pp descending;
 class  group(ref="0")  SAP A_RD_N/param=ref desc;
 model SAP = group A_AGE  F1_NIHSS_SC  F1_GCS_SC HMA_VOL1 I_PRO_ATB I_SURG NTIOTI MV I_F1_BB  /dist=poi link=log;
 estimate 'RR'  group 1 -1/exp;
run;
proc genmod data=pp  descending;
 class  group(ref="0")  SAP A_RD_N/param=ref desc;
 model SAP = group A_AGE  F1_NIHSS_SC  F1_GCS_SC HMA_VOL1 I_PRO_ATB I_SURG NTIOTI MV I_F1_BB   /dist=bin link=identity;
 estimate 'rd'  group 1 -1;
run;


proc freq data=pp;table Hospital_N*group;run;
proc genmod data=pp descending;
 class  group(ref="0")  SAP Hospital_N/param=ref desc;
 model SAP = group A_AGE  F1_NIHSS_SC  F1_GCS_SC HMA_VOL1    /dist=poi link=log;
 repeated subject=Hospital_N / type=ind;
 estimate 'RR'  group 1 -1/exp;
run;
proc genmod data=pp descending;
    class group(ref="0") Hospital_N ;
    model SAP = group A_AGE F1_NIHSS_SC F1_GCS_SC HMA_VOL1  / dist=bin link=logit;
    repeated subject=Hospital_N / type=ind;
    lsmeans group / e cl;
run;
data rd_Hospital_N_pp;
    /* data from LSMean */
    L0 = -0.8497;  se_L0 = 0.2130;
    L1 = -1.2039;  se_L1 = 0.1259;
    
    p0 = exp(L0)/(1+exp(L0));
    p1 = exp(L1)/(1+exp(L1));
    RD = p1 - p0;
    
    var_RD = (p0*(1-p0))**2 * se_L0**2 + (p1*(1-p1))**2 * se_L1**2;
    se_RD = sqrt(var_RD);
    
    RD_lcl = RD - 1.96*se_RD;
    RD_ucl = RD + 1.96*se_RD;
    
    Z = RD / se_RD;
    P = 2*(1-probnorm(abs(Z)));
    
    format RD se_RD RD_lcl RD_ucl 6.4 P 6.4;
    put "RD = " RD;
    put "SE(RD) = " se_RD;
    put "95% CI = (" RD_lcl ", " RD_ucl ")";
    put "P = " P;

	keep RD  se_RD RD_lcl RD_ucl Z P ;
run;

proc print data=rd_Hospital_N_pp;run;


proc freq data=pp (where=(I_SURG=0)); 
tables SAP * group; 
run;
proc genmod data=pp (where=(I_SURG=0)) descending;
 class  group(ref="0")  SAP A_RD_N/param=ref desc;
 model SAP = group A_AGE  F1_NIHSS_SC  F1_GCS_SC HMA_VOL1  /dist=poi link=log;
 estimate 'RR'  group 1 -1/exp;
run;
proc genmod data=pp (where=(I_SURG=0)) descending;
 class  group(ref="0")  SAP A_RD_N/param=ref desc;
 model SAP = group  A_AGE  F1_NIHSS_SC  F1_GCS_SC HMA_VOL1 /dist=bin link=identity;
 estimate 'rd'  group 1 -1;
run;


proc freq data=pp (where=(NTIOTI=0)); 
tables SAP * group; 
run;
proc genmod data=pp (where=(NTIOTI=0)) descending;
 class  group(ref="0")  SAP A_RD_N/param=ref desc;
 model SAP = group A_AGE  F1_NIHSS_SC  F1_GCS_SC HMA_VOL1  /dist=poi link=log;
 estimate 'RR'  group 1 -1/exp;
run;
proc genmod data=pp (where=(NTIOTI=0)) descending;
 class  group(ref="0")  SAP A_RD_N/param=ref desc;
 model SAP = group  A_AGE  F1_NIHSS_SC  F1_GCS_SC HMA_VOL1 /dist=bin link=identity;
 estimate 'rd'  group 1 -1;
run;


proc freq data=pp (where=(MV=0)); 
tables SAP * group; 
run;
proc genmod data=pp (where=(MV=0)) descending;
 class  group(ref="0")  SAP A_RD_N/param=ref desc;
 model SAP = group A_AGE  F1_NIHSS_SC  F1_GCS_SC HMA_VOL1  /dist=poi link=log;
 estimate 'RR'  group 1 -1/exp;
run;
proc genmod data=pp (where=(MV=0)) descending;
 class  group(ref="0")  SAP A_RD_N/param=ref desc;
 model SAP = group  A_AGE  F1_NIHSS_SC  F1_GCS_SC HMA_VOL1 /dist=bin link=identity;
 estimate 'rd'  group 1 -1;
run;


proc freq data=pp (where=(I_F1_BB=0)); 
tables SAP * group; 
run;
proc genmod data=pp (where=(I_F1_BB=0)) descending;
 class  group(ref="0")  SAP A_RD_N/param=ref desc;
 model SAP = group A_AGE  F1_NIHSS_SC  F1_GCS_SC HMA_VOL1  /dist=poi link=log;
 estimate 'RR'  group 1 -1/exp;
run;
proc genmod data=pp (where=(I_F1_BB=0)) descending;
 class  group(ref="0")  SAP A_RD_N/param=ref desc;
 model SAP = group  A_AGE  F1_NIHSS_SC  F1_GCS_SC HMA_VOL1 /dist=bin link=identity;
 estimate 'rd'  group 1 -1;
run;




****Table S12***;

proc freq data=prochase ; 
tables C3 * group; 
run;

proc genmod data=prochase  descending;
 class  group(ref="0")   A_RD_N/param=ref desc;
 model C3 = group  /dist=bin link=log;
 estimate 'RR'  group 1 -1/exp;
run;

proc genmod data=prochase descending;
 class  group(ref="0")   A_RD_N/param=ref desc;
 model C3 = group   /dist=bin link=identity;
 estimate 'rd'  group 1 -1;
run;

proc genmod data=prochase  descending;
 class  group(ref="0")   A_RD_N/param=ref desc;
 model C3 = group A_AGE  F1_NIHSS_SC  F1_GCS_SC HMA_VOL1    /dist=bin link=log;
 estimate 'RR'  group 1 -1/exp;
run;

proc genmod data=prochase descending;
 class  group(ref="0")   A_RD_N/param=ref desc;
 model C3 = group A_AGE  F1_NIHSS_SC  F1_GCS_SC HMA_VOL1   /dist=bin link=identity;
 estimate 'rd'  group 1 -1;
run;


proc freq data=prochase ; 
tables C1_obj_bin  * group; 
run;

proc genmod data=prochase  descending;
 class  group(ref="0")   A_RD_N/param=ref desc;
 model C1_obj_bin = group  /dist=bin link=log;
 estimate 'RR'  group 1 -1/exp;
run;

proc genmod data=prochase descending;
 class  group(ref="0")   A_RD_N/param=ref desc;
 model C1_obj_bin = group   /dist=bin link=identity;
 estimate 'rd'  group 1 -1;
run;

proc genmod data=prochase  descending;
 class  group(ref="0")   A_RD_N/param=ref desc;
 model C1_obj_bin = group A_AGE  F1_NIHSS_SC  F1_GCS_SC HMA_VOL1    /dist=bin link=log;
 estimate 'RR'  group 1 -1/exp;
run;

proc genmod data=prochase descending;
 class  group(ref="0")   A_RD_N/param=ref desc;
 model C1_obj_bin = group A_AGE  F1_NIHSS_SC  F1_GCS_SC HMA_VOL1   /dist=poi link=identity;
 estimate 'rd'  group 1 -1;
run;


proc freq data=prochase ; 
tables C13_bin  * group; 
run;

proc genmod data=prochase  descending;
 class  group(ref="0")   A_RD_N/param=ref desc;
 model C13_bin = group  /dist=bin link=log;
 estimate 'RR'  group 1 -1/exp;
run;

proc genmod data=prochase descending;
 class  group(ref="0")   A_RD_N/param=ref desc;
 model C13_bin = group   /dist=bin link=identity;
 estimate 'rd'  group 1 -1;
run;

proc genmod data=prochase  descending;
 class  group(ref="0")   A_RD_N/param=ref desc;
 model C13_bin = group A_AGE  F1_NIHSS_SC  F1_GCS_SC HMA_VOL1    /dist=bin link=log;
 estimate 'RR'  group 1 -1/exp;
run;

proc genmod data=prochase descending;
 class  group(ref="0")   A_RD_N/param=ref desc;
 model C13_bin = group A_AGE  F1_NIHSS_SC  F1_GCS_SC HMA_VOL1   /dist=bin link=identity;
 estimate 'rd'  group 1 -1;
run;





****Table S13A****;
proc freq data=prochase ; 
tables Hospital_N; 
run;

proc freq data=prochase ; 
tables Hospital_N*SAP * group; 
run;

proc sort data=prochase;by Hospital_N;run;

proc genmod data=prochase descending;
 class  group(ref="0")  SAP A_RD_N/param=ref desc;
 model SAP = group   /dist=poi link=log;
 estimate 'RR'  group 1 -1/exp;
 by Hospital_N;
run;

proc genmod data=prochase descending;
 class  group(ref="0")  SAP A_RD_N/param=ref desc;
 model SAP = group A_AGE  F1_NIHSS_SC  F1_GCS_SC HMA_VOL1    /dist=poi link=log;
 estimate 'RR'  group 1 -1/exp;
 by Hospital_N;
run;

title "Overall center-adjusted model";
proc genmod data=pp descending;
 class  group(ref="0")  SAP Hospital_N/param=ref desc;
 model SAP = group A_AGE  F1_NIHSS_SC  F1_GCS_SC HMA_VOL1    /dist=poi link=log;
 repeated subject=Hospital_N / type=ind;
 estimate 'RR'  group 1 -1/exp;
run;



****Table S13B****;

proc freq data=prochase ; 
tables Hospital_HIGH; 
run;

proc freq data=prochase ; 
tables Hospital_HIGH*SAP * group; 
run;

proc sort data=prochase;by Hospital_HIGH;run;

proc genmod data=prochase descending;
 class  group(ref="0")  SAP A_RD_N/param=ref desc;
 model SAP = group   /dist=poi link=log;
 estimate 'RR'  group 1 -1/exp;
 by Hospital_HIGH;
run;

proc genmod data=prochase descending;
 class  group(ref="0")  SAP A_RD_N/param=ref desc;
 model SAP = group  Hospital_HIGH group*Hospital_HIGH/dist=poi link=log;
run;

proc genmod data=prochase descending;
 class  group(ref="0")  SAP A_RD_N/param=ref desc;
 model SAP = group A_AGE  F1_NIHSS_SC  F1_GCS_SC HMA_VOL1    /dist=poi link=log;
 estimate 'RR'  group 1 -1/exp;
 by Hospital_HIGH;
run;

proc genmod data=prochase descending;
 class  group(ref="0")  SAP A_RD_N/param=ref desc;
 model SAP = group Hospital_HIGH group*Hospital_HIGH A_AGE  F1_NIHSS_SC  F1_GCS_SC HMA_VOL1    /dist=poi link=log;
run;


****Table S13C****;

proc sort data=prochase ;by Hospital_N;run;
proc freq data=prochase ;by Hospital_N; table SAP;run;

proc freq data=prochase ; 
tables Hospital_N * (SAP I_PRO_ATB I_SURG  F2_NTI F2_OTI F3_NTI F3_OTI NTIOTI F2_MV F3_MV MV I_F1_BB); 
run;

ods excel close;


*****Table S14****;

%let markers = LYMPH_B LYMPH_NK LYMPH_CD3 LYMPH_CD4 LYMPH_CD8  ;

%macro loop_markers;
    %local i marker;
    %do i = 1 %to %sysfunc(countw(&markers));
        %let marker = %scan(&markers, &i);

proc mixed data=prochase_mixed method=ml covtest;
    class  time group(ref='0') CODE;
    model  &marker = time group group*time / solution ddfm=kr;
    repeated  / subject=CODE type=cs ;
	lsmeans time*group / cl pdiff ;

	estimate 'stantard: жд72б└12h' time -1 1 0   time*group 0 -1 0 1 0 0 / cl ;
    estimate 'stantard: жд7б└1d' time -1 0 1   time*group 0 -1 0 0 0 1 / cl ;

    estimate 'propranolol: жд72б└12h'   time -1 1 0   time*group -1 0 1 0 0 0 / cl ;
    estimate 'propranolol: жд7б└1d'  time -1 0 1   time*group -1 0 0 0 1 0 / cl ;
    
	estimate 'жд72б└12h: propranolol vs stantard'   time 0 0 0   time*group -1 1 1 -1 0 0 / cl ;
    estimate 'жд7б└1d: propranolol vs stantard'  time 0 0 0   time*group -1 1 0 0 1 -1 / cl ;

	ods output diffs=diffs_&marker._crude lsmeans=lsmeans_&marker._crude estimates=estimates_&marker._crude;
	run;

data diff_final_&marker._crude;
set diffs_&marker._crude;
if time=_time ;
keep Effect Estimate group time _group _time StdErr DF tValue Probt Lower Upper;
run;

proc mixed data=prochase_mixed method=ml covtest;
    class  time group(ref='0') CODE;
    model  &marker = time group group*time A_AGE  F1_NIHSS_SC  F1_GCS_SC HMA_VOL1 F1_BC_&marker/ solution ddfm=kr;
    repeated  / subject=CODE type=cs ;
	lsmeans time*group / cl pdiff ;

	estimate 'stantard: жд72б└12h' time -1 1 0   time*group 0 -1 0 1 0 0 / cl ;
    estimate 'stantard: жд7б└1d' time -1 0 1   time*group 0 -1 0 0 0 1 / cl ;

    estimate 'propranolol: жд72б└12h'   time -1 1 0   time*group -1 0 1 0 0 0 / cl ;
    estimate 'propranolol: жд7б└1d'  time -1 0 1   time*group -1 0 0 0 1 0 / cl ;
    
	estimate 'жд72б└12h: propranolol vs stantard'   time 0 0 0   time*group -1 1 1 -1 0 0 / cl ;
    estimate 'жд7б└1d: propranolol vs stantard'  time 0 0 0   time*group -1 1 0 0 1 -1 / cl ;

	ods output diffs=diffs_&marker._adjusted lsmeans=lsmeans_&marker._adjusted estimates=estimates_&marker._adjusted;
	run;

data diff_final_&marker._adjusted;
set diffs_&marker._adjusted;
if time=_time ;
keep Effect Estimate group time _group _time StdErr DF tValue Probt Lower Upper;
run;

 %end;
%mend;

%loop_markers;


proc print data=diff_final_LYMPH_B_crude;title'LYMPH_B crude';run;
proc print data=lsmeans_LYMPH_B_crude;title'LYMPH_B crude';run;
proc print data=estimates_LYMPH_B_crude;title'LYMPH_B crude';run;
title'LYMPH_B crude p for interaction';
proc mixed data=prochase_mixed method=ml covtest;
    class  CODE;
    model  LYMPH_B = time group group*time / solution ddfm=kr;
    repeated  / subject=CODE type=cs ;
	run;
proc print data=diff_final_LYMPH_B_adjusted;title'LYMPH_B adjusted';run;
proc print data=lsmeans_LYMPH_B_adjusted;title'LYMPH_B adjusted';run;
proc print data=estimates_LYMPH_B_adjusted;title'LYMPH_B adjusted';run;
title'LYMPH_B adjusted p for interaction';
proc mixed data=prochase_mixed method=ml covtest;
    class  CODE;
    model  LYMPH_B = time group group*time A_AGE  F1_NIHSS_SC  F1_GCS_SC HMA_VOL1 F1_BC_LYMPH_B/ solution ddfm=kr;
    repeated  / subject=CODE type=cs ;
	run;


proc print data=diff_final_LYMPH_NK_crude;title'LYMPH_NK crude';run;
proc print data=lsmeans_LYMPH_NK_crude;title'LYMPH_NK crude';run;
proc print data=estimates_LYMPH_NK_crude;title'LYMPH_NK crude';run;
title'LYMPH_NK crude p for interaction';
proc mixed data=prochase_mixed method=ml covtest;
    class  CODE;
    model  LYMPH_NK = time group group*time / solution ddfm=kr;
    repeated  / subject=CODE type=cs ;
	run;
proc print data=diff_final_LYMPH_NK_adjusted;title'LYMPH_NK adjusted';run;
proc print data=lsmeans_LYMPH_NK_adjusted;title'LYMPH_NK adjusted';run;
proc print data=estimates_LYMPH_NK_adjusted;title'LYMPH_NK adjusted';run;
title'LYMPH_NK adjusted p for interaction';
proc mixed data=prochase_mixed method=ml covtest;
    class  CODE;
    model  LYMPH_NK = time group group*time A_AGE  F1_NIHSS_SC  F1_GCS_SC HMA_VOL1 F1_BC_LYMPH_NK/ solution ddfm=kr;
    repeated  / subject=CODE type=cs ;
	run;


proc print data=diff_final_LYMPH_CD3_crude;title'LYMPH_CD3 crude';run;
proc print data=lsmeans_LYMPH_CD3_crude;title'LYMPH_CD3 crude';run;
proc print data=estimates_LYMPH_CD3_crude;title'LYMPH_CD3 crude';run;
title'LYMPH_CD3 crude p for interaction';
proc mixed data=prochase_mixed method=ml covtest;
    class  CODE;
    model  LYMPH_CD3 = time group group*time / solution ddfm=kr;
    repeated  / subject=CODE type=cs ;
	run;
proc print data=diff_final_LYMPH_CD3_adjusted;title'LYMPH_CD3 adjusted';run;
proc print data=lsmeans_LYMPH_CD3_adjusted;title'LYMPH_CD3 adjusted';run;
proc print data=estimates_LYMPH_CD3_adjusted;title'LYMPH_CD3 adjusted';run;
title'LYMPH_CD3 adjusted p for interaction';
proc mixed data=prochase_mixed method=ml covtest;
    class  CODE;
    model  LYMPH_CD3 = time group group*time A_AGE  F1_NIHSS_SC  F1_GCS_SC HMA_VOL1 F1_BC_LYMPH_CD3/ solution ddfm=kr;
    repeated  / subject=CODE type=cs ;
	run;


proc print data=diff_final_LYMPH_CD4_crude;title'LYMPH_CD4 crude';run;
proc print data=lsmeans_LYMPH_CD4_crude;title'LYMPH_CD4 crude';run;
proc print data=estimates_LYMPH_CD4_crude;title'LYMPH_CD4 crude';run;
title'LYMPH_CD4 crude p for interaction';
proc mixed data=prochase_mixed method=ml covtest;
    class  CODE;
    model  LYMPH_CD4 = time group group*time / solution ddfm=kr;
    repeated  / subject=CODE type=cs ;
	run;
proc print data=diff_final_LYMPH_CD4_adjusted;title'LYMPH_CD4 adjusted';run;
proc print data=lsmeans_LYMPH_CD4_adjusted;title'LYMPH_CD4 adjusted';run;
proc print data=estimates_LYMPH_CD4_adjusted;title'LYMPH_CD4 adjusted';run;
title'LYMPH_CD4 adjusted p for interaction';
proc mixed data=prochase_mixed method=ml covtest;
    class  CODE;
    model  LYMPH_CD4 = time group group*time A_AGE  F1_NIHSS_SC  F1_GCS_SC HMA_VOL1 F1_BC_LYMPH_CD4/ solution ddfm=kr;
    repeated  / subject=CODE type=cs ;
	run;


proc print data=diff_final_LYMPH_CD8_crude;title'LYMPH_CD8 crude';run;
proc print data=lsmeans_LYMPH_CD8_crude;title'LYMPH_CD8 crude';run;
proc print data=estimates_LYMPH_CD8_crude;title'LYMPH_CD8 crude';run;
title'LYMPH_CD8 crude p for interaction';
proc mixed data=prochase_mixed method=ml covtest;
    class  CODE;
    model  LYMPH_CD8 = time group group*time / solution ddfm=kr;
    repeated  / subject=CODE type=cs ;
	run;
proc print data=diff_final_LYMPH_CD8_adjusted;title'LYMPH_CD8 adjusted';run;
proc print data=lsmeans_LYMPH_CD8_adjusted;title'LYMPH_CD8 adjusted';run;
proc print data=estimates_LYMPH_CD8_adjusted;title'LYMPH_CD8 adjusted';run;
title'LYMPH_CD8 adjusted p for interaction';
proc mixed data=prochase_mixed method=ml covtest;
    class  CODE;
    model  LYMPH_CD8 = time group group*time A_AGE  F1_NIHSS_SC  F1_GCS_SC HMA_VOL1 F1_BC_LYMPH_CD8/ solution ddfm=kr;
    repeated  / subject=CODE type=cs ;
	run;




****Table S15****;
proc mixed data=prochase_mixed method=ml covtest;
    class  time group(ref='0') CODE;
    model  LYC = time group group*time / solution ddfm=kr;
    repeated  / subject=CODE type=cs ;
	lsmeans time*group / cl pdiff ;

	estimate 'stantard: жд72б└12h' time -1 1 0   time*group 0 -1 0 1 0 0 / cl ;
    estimate 'stantard: жд7б└1d' time -1 0 1   time*group 0 -1 0 0 0 1 / cl ;

    estimate 'propranolol: жд72б└12h'   time -1 1 0   time*group -1 0 1 0 0 0 / cl ;
    estimate 'propranolol: жд7б└1d'  time -1 0 1   time*group -1 0 0 0 1 0 / cl ;
    
	estimate 'жд72б└12h: propranolol vs stantard'   time 0 0 0   time*group -1 1 1 -1 0 0 / cl ;
    estimate 'жд7б└1d: propranolol vs stantard'  time 0 0 0   time*group -1 1 0 0 1 -1 / cl ;

	ods output diffs=diffs_LYC_unadjusted lsmeans=lsmeans_LYC_unadjusted estimates=estimates_LYC_unadjusted;
	run;

data diff_final_LYC_unadjusted;
set diffs_LYC_unadjusted;
if time=_time ;
keep Effect Estimate group time _group _time StdErr DF tValue Probt Lower Upper;
run;

proc mixed data=prochase_mixed method=ml covtest;
    class  time group(ref='0') CODE;
    model  LYC = time group group*time A_AGE  F1_NIHSS_SC  F1_GCS_SC HMA_VOL1 F1_BC_LYC/ solution ddfm=kr;
    repeated  / subject=CODE type=cs ;
	lsmeans time*group / cl pdiff ;

	estimate 'stantard: жд72б└12h' time -1 1 0   time*group 0 -1 0 1 0 0 / cl ;
    estimate 'stantard: жд7б└1d' time -1 0 1   time*group 0 -1 0 0 0 1 / cl ;

    estimate 'propranolol: жд72б└12h'   time -1 1 0   time*group -1 0 1 0 0 0 / cl ;
    estimate 'propranolol: жд7б└1d'  time -1 0 1   time*group -1 0 0 0 1 0 / cl ;
    
	estimate 'жд72б└12h: propranolol vs stantard'   time 0 0 0   time*group -1 1 1 -1 0 0 / cl ;
    estimate 'жд7б└1d: propranolol vs stantard'  time 0 0 0   time*group -1 1 0 0 1 -1 / cl ;

	ods output diffs=diffs_LYC_adjusted lsmeans=lsmeans_LYC_adjusted estimates=estimates_LYC_adjusted;
	run;

data diff_final_LYC_adjusted;
set diffs_LYC_adjusted;
if time=_time ;
keep Effect Estimate group time _group _time StdErr DF tValue Probt Lower Upper;
run;


proc print data=diff_final_LYC_unadjusted;title'unadjusted';run;
proc print data=lsmeans_LYC_unadjusted;title'unadjusted';run;
proc print data=estimates_LYC_unadjusted;title'unadjusted';run;
title'unadjusted p for interaction';
proc mixed data=prochase_mixed method=ml covtest;
    class  CODE;
    model  LYC = time group group*time / solution ddfm=kr;
    repeated  / subject=CODE type=cs ;
	run;

proc print data=diff_final_LYC_adjusted;title'adjusted';run;
proc print data=lsmeans_LYC_adjusted;title'adjusted';run;
proc print data=estimates_LYC_adjusted;title'adjusted';run;

title'adjusted p for interaction';
proc mixed data=prochase_mixed method=ml covtest;
    class  CODE;
    model  LYC = time group group*time A_AGE  F1_NIHSS_SC  F1_GCS_SC HMA_VOL1 F1_BC_LYC/ solution ddfm=kr;
    repeated  / subject=CODE type=cs ;
	run;




****Table S16A***;
proc mixed data=prochase_mixed method=ml covtest;
    class  time group(ref='0') CODE;
    model  BNP = time group group*time / solution ddfm=kr;
    repeated  / subject=CODE type=cs ;
	lsmeans time*group / cl pdiff ;

	estimate 'stantard: жд72б└12h' time -1 1 0   time*group 0 -1 0 1 0 0 / cl ;
    estimate 'stantard: жд7б└1d' time -1 0 1   time*group 0 -1 0 0 0 1 / cl ;

    estimate 'propranolol: жд72б└12h'   time -1 1 0   time*group -1 0 1 0 0 0 / cl ;
    estimate 'propranolol: жд7б└1d'  time -1 0 1   time*group -1 0 0 0 1 0 / cl ;
    
	estimate 'жд72б└12h: propranolol vs stantard'   time 0 0 0   time*group -1 1 1 -1 0 0 / cl ;
    estimate 'жд7б└1d: propranolol vs stantard'  time 0 0 0   time*group -1 1 0 0 1 -1 / cl ;

	ods output diffs=diffs_BNP_unadjusted lsmeans=lsmeans_BNP_unadjusted estimates=estimates_BNP_unadjusted;
	run;

data diff_final_BNP_unadjusted;
set diffs_BNP_unadjusted;
if time=_time ;
keep Effect Estimate group time _group _time StdErr DF tValue Probt Lower Upper;
run;

data lsmeans_BNP_unadjusted_GMR;
set lsmeans_BNP_unadjusted;
    GMR = exp(estimate);
    GMR_CI_lower = exp(lower);
    GMR_CI_upper = exp(upper);
    
    format GMR GMR_CI_lower GMR_CI_upper 6.3;
	keep Effect group time GMR GMR_CI_lower GMR_CI_upper Probt;
	run;
data diff_final_BNP_unadjusted_GMR;
set diff_final_BNP_unadjusted;
    GMR = exp(estimate);
    GMR_CI_lower = exp(lower);
    GMR_CI_upper = exp(upper);
    
    format GMR GMR_CI_lower GMR_CI_upper 6.3;
	keep Effect group time _group _time GMR GMR_CI_lower GMR_CI_upper Probt;
	run;
data estimates_BNP_unadjusted_GMR;
set estimates_BNP_unadjusted;
    GMR = exp(estimate);
    GMR_CI_lower = exp(lower);
    GMR_CI_upper = exp(upper);
    
    format GMR GMR_CI_lower GMR_CI_upper 6.3;
	keep label GMR GMR_CI_lower GMR_CI_upper Probt;
	run;
proc mixed data=prochase_mixed method=ml covtest;
    class  time group(ref='0') CODE;
    model  BNP = time group group*time A_AGE  F1_NIHSS_SC  F1_GCS_SC HMA_VOL1 F1_BC_BNP/ solution ddfm=kr;
    repeated  / subject=CODE type=cs ;
	lsmeans time*group / cl pdiff ;

	estimate 'stantard: жд72б└12h' time -1 1 0   time*group 0 -1 0 1 0 0 / cl ;
    estimate 'stantard: жд7б└1d' time -1 0 1   time*group 0 -1 0 0 0 1 / cl ;

    estimate 'propranolol: жд72б└12h'   time -1 1 0   time*group -1 0 1 0 0 0 / cl ;
    estimate 'propranolol: жд7б└1d'  time -1 0 1   time*group -1 0 0 0 1 0 / cl ;
    
	estimate 'жд72б└12h: propranolol vs stantard'   time 0 0 0   time*group -1 1 1 -1 0 0 / cl ;
    estimate 'жд7б└1d: propranolol vs stantard'  time 0 0 0   time*group -1 1 0 0 1 -1 / cl ;

	ods output diffs=diffs_BNP_adjusted lsmeans=lsmeans_BNP_adjusted estimates=estimates_BNP_adjusted;
	run;

data diff_final_BNP_adjusted;
set diffs_BNP_adjusted;
if time=_time ;
keep Effect Estimate group time _group _time StdErr DF tValue Probt Lower Upper;
run;


data lsmeans_BNP_adjusted_GMR;
set lsmeans_BNP_adjusted;
    GMR = exp(estimate);
    GMR_CI_lower = exp(lower);
    GMR_CI_upper = exp(upper);
    
    format GMR GMR_CI_lower GMR_CI_upper 6.3;
	keep Effect group time GMR GMR_CI_lower GMR_CI_upper Probt;
	run;
data diff_final_BNP_adjusted_GMR;
set diff_final_BNP_adjusted;
    GMR = exp(estimate);
    GMR_CI_lower = exp(lower);
    GMR_CI_upper = exp(upper);
    
    format GMR GMR_CI_lower GMR_CI_upper 6.3;
	keep Effect group time _group _time GMR GMR_CI_lower GMR_CI_upper Probt;
	run;
data estimates_BNP_adjusted_GMR;
set estimates_BNP_adjusted;
    GMR = exp(estimate);
    GMR_CI_lower = exp(lower);
    GMR_CI_upper = exp(upper);
    
    format GMR GMR_CI_lower GMR_CI_upper 6.3;
	keep label GMR GMR_CI_lower GMR_CI_upper Probt;
	run;


****Table S16B****;
proc mixed data=prochase_mixed method=ml covtest;
    class  time group(ref='0') CODE;
    model  NLR = time group group*time / solution ddfm=kr;
    repeated  / subject=CODE type=cs ;
	lsmeans time*group / cl pdiff ;

	estimate 'stantard: жд72б└12h' time -1 1 0   time*group 0 -1 0 1 0 0 / cl ;
    estimate 'stantard: жд7б└1d' time -1 0 1   time*group 0 -1 0 0 0 1 / cl ;

    estimate 'propranolol: жд72б└12h'   time -1 1 0   time*group -1 0 1 0 0 0 / cl ;
    estimate 'propranolol: жд7б└1d'  time -1 0 1   time*group -1 0 0 0 1 0 / cl ;
    
	estimate 'жд72б└12h: propranolol vs stantard'   time 0 0 0   time*group -1 1 1 -1 0 0 / cl ;
    estimate 'жд7б└1d: propranolol vs stantard'  time 0 0 0   time*group -1 1 0 0 1 -1 / cl ;

	ods output diffs=diffs_NLR_unadjusted lsmeans=lsmeans_NLR_unadjusted estimates=estimates_NLR_unadjusted;
	run;

data diff_final_NLR_unadjusted;
set diffs_NLR_unadjusted;
if time=_time ;
keep Effect Estimate group time _group _time StdErr DF tValue Probt Lower Upper;
run;

data lsmeans_NLR_unadjusted_GMR;
set lsmeans_NLR_unadjusted;
    GMR = exp(estimate);
    GMR_CI_lower = exp(lower);
    GMR_CI_upper = exp(upper);
    
    format GMR GMR_CI_lower GMR_CI_upper 6.3;
	keep Effect group time GMR GMR_CI_lower GMR_CI_upper Probt;
	run;
data diff_final_NLR_unadjusted_GMR;
set diff_final_NLR_unadjusted;
    GMR = exp(estimate);
    GMR_CI_lower = exp(lower);
    GMR_CI_upper = exp(upper);
    
    format GMR GMR_CI_lower GMR_CI_upper 6.3;
	keep Effect group time _group _time GMR GMR_CI_lower GMR_CI_upper Probt;
	run;
data estimates_NLR_unadjusted_GMR;
set estimates_NLR_unadjusted;
    GMR = exp(estimate);
    GMR_CI_lower = exp(lower);
    GMR_CI_upper = exp(upper);
    
    format GMR GMR_CI_lower GMR_CI_upper 6.3;
	keep label GMR GMR_CI_lower GMR_CI_upper Probt;
	run;
proc mixed data=prochase_mixed method=ml covtest;
    class  time group(ref='0') CODE;
    model  NLR = time group group*time A_AGE  F1_NIHSS_SC  F1_GCS_SC HMA_VOL1 F1_BC_NLR/ solution ddfm=kr;
    repeated  / subject=CODE type=cs ;
	lsmeans time*group / cl pdiff ;

	estimate 'stantard: жд72б└12h' time -1 1 0   time*group 0 -1 0 1 0 0 / cl ;
    estimate 'stantard: жд7б└1d' time -1 0 1   time*group 0 -1 0 0 0 1 / cl ;

    estimate 'propranolol: жд72б└12h'   time -1 1 0   time*group -1 0 1 0 0 0 / cl ;
    estimate 'propranolol: жд7б└1d'  time -1 0 1   time*group -1 0 0 0 1 0 / cl ;
    
	estimate 'жд72б└12h: propranolol vs stantard'   time 0 0 0   time*group -1 1 1 -1 0 0 / cl ;
    estimate 'жд7б└1d: propranolol vs stantard'  time 0 0 0   time*group -1 1 0 0 1 -1 / cl ;

	ods output diffs=diffs_NLR_adjusted lsmeans=lsmeans_NLR_adjusted estimates=estimates_NLR_adjusted;
	run;

data diff_final_NLR_adjusted;
set diffs_NLR_adjusted;
if time=_time ;
keep Effect Estimate group time _group _time StdErr DF tValue Probt Lower Upper;
run;

data lsmeans_NLR_adjusted_GMR;
set lsmeans_NLR_adjusted;
    GMR = exp(estimate);
    GMR_CI_lower = exp(lower);
    GMR_CI_upper = exp(upper);
    
    format GMR GMR_CI_lower GMR_CI_upper 6.3;
	keep Effect group time GMR GMR_CI_lower GMR_CI_upper Probt;
	run;
data diff_final_NLR_adjusted_GMR;
set diff_final_NLR_adjusted;
    GMR = exp(estimate);
    GMR_CI_lower = exp(lower);
    GMR_CI_upper = exp(upper);
    
    format GMR GMR_CI_lower GMR_CI_upper 6.3;
	keep Effect group time _group _time GMR GMR_CI_lower GMR_CI_upper Probt;
	run;
data estimates_NLR_adjusted_GMR;
set estimates_NLR_adjusted;
    GMR = exp(estimate);
    GMR_CI_lower = exp(lower);
    GMR_CI_upper = exp(upper);
    
    format GMR GMR_CI_lower GMR_CI_upper 6.3;
	keep label GMR GMR_CI_lower GMR_CI_upper Probt;
	run;


proc print data=diff_final_BNP_unadjusted_GMR;title'unadjusted';run;
proc print data=lsmeans_BNP_unadjusted_GMR;title'unadjusted';run;
proc print data=estimates_BNP_unadjusted_GMR;title'unadjusted';run;
title'unadjusted p for interaction';
proc mixed data=prochase_mixed method=ml covtest;
    class  CODE;
    model  BNP = time group group*time / solution ddfm=kr;
    repeated  / subject=CODE type=cs;
	run;

proc print data=diff_final_BNP_adjusted_GMR;title'adjusted';run;
proc print data=lsmeans_BNP_adjusted_GMR;title'adjusted';run;
proc print data=estimates_BNP_adjusted_GMR;title'adjusted';run;

title'adjusted p for interaction';
proc mixed data=prochase_mixed method=ml covtest;
    class  CODE;
    model  BNP = time group group*time A_AGE  F1_NIHSS_SC  F1_GCS_SC HMA_VOL1 F1_BC_BNP/ solution ddfm=kr;
    repeated  / subject=CODE type=cs ;
	run;



proc print data=diff_final_NLR_unadjusted_GMR;title'unadjusted';run;
proc print data=lsmeans_NLR_unadjusted_GMR;title'unadjusted';run;
proc print data=estimates_NLR_unadjusted_GMR;title'unadjusted';run;
title'unadjusted p for interaction';
proc mixed data=prochase_mixed method=ml covtest;
    class  CODE;
    model  NLR = time group group*time / solution ddfm=kr;
    repeated  / subject=CODE type=cs;
	run;

proc print data=diff_final_NLR_adjusted_GMR;title'adjusted';run;
proc print data=lsmeans_NLR_adjusted_GMR;title'adjusted';run;
proc print data=estimates_NLR_adjusted_GMR;title'adjusted';run;

title'adjusted p for interaction';
proc mixed data=prochase_mixed method=ml covtest;
    class  CODE;
    model  NLR = time group group*time A_AGE  F1_NIHSS_SC  F1_GCS_SC HMA_VOL1 F1_BC_NLR/ solution ddfm=kr;
    repeated  / subject=CODE type=cs ;
	run;





