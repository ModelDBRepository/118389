*relative
*cartesian
*asymmetric
*lambda_warn

*set_compt_param ELEAK -0.063000 
*set_compt_param RA 3.000000 
*set_compt_param RM 2.000000 
*set_compt_param CM 0.007000 
*set_compt_param EREST_ACT -0.063000 

*start_cell /library/tert_dend

tert_dend none 30 0 0 0.5 AMPA_channel 1.770683e+01 GABA_channel 2.414228e+01 
tert_dend2 . 30 0 0 0.5 AMPA_channel 1.770683e+01 GABA_channel 2.414228e+01 
tert_dend3 . 30 0 0 0.5 AMPA_channel 1.770683e+01 GABA_channel 2.414228e+01 
tert_dend4 . 30 0 0 0.5 AMPA_channel 1.770683e+01 GABA_channel 2.414228e+01 
tert_dend5 . 30 0 0 0.5 AMPA_channel 1.770683e+01 GABA_channel 2.414228e+01 
tert_dend6 . 30 0 0 0.5 AMPA_channel 1.770683e+01 GABA_channel 2.414228e+01 
tert_dend7 . 30 0 0 0.5 AMPA_channel 1.770683e+01 GABA_channel 2.414228e+01 
tert_dend8 . 30 0 0 0.5 AMPA_channel 1.770683e+01 GABA_channel 2.414228e+01 
*makeproto /library/tert_dend

*start_cell /library/sec_dend

sec_dend none 37 0 0 0.75 AMPA_channel 8.567264e+00 GABA_channel 1.191795e+01 A_channel 0 
sec_dend2 . 37 0 0 0.75 AMPA_channel 8.567264e+00 GABA_channel 1.191795e+01 A_channel 0 
sec_dend3 . 37 0 0 0.75 AMPA_channel 8.567264e+00 GABA_channel 1.191795e+01 A_channel 0 
sec_dend4 . 37 0 0 0.75 AMPA_channel 8.567264e+00 GABA_channel 1.191795e+01 A_channel 0 
*makeproto /library/sec_dend

*start_cell /library/prim_dend

prim_dend none 45 0 0 1 AMPA_channel 4.620414e+00 GABA_channel 8.571460e+00 A_channel 1.046121e+02 Na_channel 0 K3132_channel 0 
prim_dend2 . 45 0 0 1 AMPA_channel 4.620414e+00 GABA_channel 8.571460e+00 A_channel 1.046121e+02 Na_channel 0 K3132_channel 0 
*makeproto /library/prim_dend

*start_cell
soma none 20 0 0 15 Na_channel 1.293085e+03 K3132_channel 4.892449e+02 A_channel 2.850159e+02 K13_channel 1.543388e+00 AMPA_channel 7.680092e-01 GABA_channel 1.282800e+00 

*compt /library/prim_dend
primdend1 soma 45 0 0 1
primdend2 soma 45 0 0 1
primdend3 soma 45 0 0 1

*compt /library/sec_dend
secdend1 primdend1/prim_dend2 37 0 0 0.75
secdend2 primdend1/prim_dend2 37 0 0 0.75
secdend3 primdend2/prim_dend2 37 0 0 0.75
secdend4 primdend2/prim_dend2 37 0 0 0.75
secdend5 primdend3/prim_dend2 37 0 0 0.75
secdend6 primdend3/prim_dend2 37 0 0 0.75

*compt /library/tert_dend
tertdend1 secdend1/sec_dend4 30  0  0  0.5
tertdend2 secdend1/sec_dend4 30  0  0  0.5
tertdend3 secdend2/sec_dend4 30  0  0  0.5
tertdend4 secdend2/sec_dend4 30  0  0  0.5
tertdend5 secdend3/sec_dend4 30  0  0  0.5
tertdend6 secdend3/sec_dend4 30  0  0  0.5
tertdend7 secdend4/sec_dend4 30  0  0  0.5
tertdend8 secdend4/sec_dend4 30  0  0  0.5
tertdend9 secdend5/sec_dend4 30  0  0  0.5
tertdend10 secdend5/sec_dend4 30  0  0  0.5
tertdend11 secdend6/sec_dend4 30  0  0  0.5
tertdend12 secdend6/sec_dend4 30  0  0  0.5
