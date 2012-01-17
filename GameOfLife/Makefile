CC=vcs

GFLAGS=-sverilog -debug -R -assert filter -assert enable_diag
RFLAGS=-sverilog -R -assert filter
FLAGS=-sverilog -assert filter

TEXTFILES=TEXT_OBJECT/stats_object.sv TEXT_OBJECT/text_object.sv TEXT_OBJECT/title_object.sv
GOLFILES=GOL_OBJECT/gol_object.sv GOL_OBJECT/gol_logic.sv GOL_OBJECT/gol_ctrl.sv GOL_OBJECT/comb_div.sv GOL_OBJECT/win_and_curs.sv GOL_OBJECT/gol_display_gfx.sv GOL_OBJECT/gol_minimap_gfx.sv
MAINFILES=MAIN_CTRL/defines.svh MAIN_CTRL/gol_top.sv MAIN_CTRL/main_ctrl.sv
PS2FILES=PS2/ps2_parse.sv

ALLFILES= $(TB) $(MAINFILES) $(PS2FILES) $(GOLFILES) $(TEXTFILES)

default: $(ALLFILES)
	$(CC) $(FLAGS) $(ALLFILES)
	make clean

run: $(ALLFILES)
	$(CC) $(RFLAGS) $(ALLFILES)

inter: $(ALLFILES)
	$(CC) $(GFLAGS) $(ALLFILES)


clean:
	rm -rf simv
	rm -rf simv.daidir
	rm -rf csrc
	rm -rf ucli.key
	rm -rf simv.vdb
	rm -rf DVEfiles
	rm -rf inter.vpd
