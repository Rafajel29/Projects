- You can put these files within the "modelsim" directory

- First, you execute "bash compile_gate.sh" to compile your post-layout Verilog files, then "bash sim_postlayout.sh" to run Modelsim.

- In compile_gate.sh, do not forget to change the names to your Verilog and testbench files.

- In sim_postlayout.sh, do not forget to change the name of the SDF file and the module name of your testbench.

- For the postlayout testbench file, you might have to change the name of your module to whatever name you used for it during synthesis. You can check such name in the ./par/out/*.v file.