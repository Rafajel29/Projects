# SynTech
Always the latest version of SynTech Verilog and Matlab Codes

## 12/14/2019

**Post-layout** files are in *par* folder. 

	1. Hold report is in par/timingReports/FLT_postRoute_hold.summary.gz. 
 	2. Setup report is in par/timingReports/FLT_postRoute.summary.gz
 	3. Critical path is shown in par/timingReports/FLT_postRoute_all.tarpt.gz

**Source** files are in *src* folder.

**Synthesis** results are in *syn* folder. You can find reports of different timing constraints there. We are using 120.0ns as our final result.

**Testbench** is is tb folder.

	1. FLT_in/FLT_out.txt are from the tune given in SynTech matlabcode.
 	2. RND_FLT_IN is the random vector input.
 	3. \_FLT_in should be deleted, but my PC just doesn't let me do so... Damn it!

**TestFLT** in matlab folder is used to generate verilog input and output files. Note that *rnd1.mat* is not quantized and will cause several wrong output during simulation.

**Power Consumption** is not included in the report now because I don't where to find it... We should ask someone.



### 12/09/2019

---

The clk constraint now is 120.0ns and the place and route results look more like Synopsys DC topo-mode results. in ~/tb/FLT_POST_TB.v, the input delay is still 0.2ns (same as before) but the output delay has been changed to 150.2 (0.2+1 CLK + propagation delay). Modelsim will not pop up "all match" due to the gliches in 2910ns but the results of our module still match the results in the txt file. Remember to fix the block diagram tomorrow.

### 12/5/2019
---
updated wave.do; add one FF after a2_minus_D; change WrEn_SI in FF_cos_OUT to synchronize a1, b0~b2 without adding FFs; Note that the logic after this FF may cause uncertainty in post simu, we'll figure it out later
