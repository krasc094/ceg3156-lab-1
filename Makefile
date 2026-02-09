# === VHDL
GHDL = ghdl
R_FLAGS = --vcd=$(WAVE_F).vcd --wave=$(WAVE_F).ghw

# === vhdl components
DEPS = ./vhdl/dff.vhdl ./vhdl/shiftReg-nbit.vhdl ./vhdl/mux4-1bit.vhdl
TOP_LEVEL_ENTITY = shiftReg_TB
# VHDL_DIR = ./vhdl/

WAVE_F = wave

# === WAVEFORM
GTKWAVE = gtkwave
GTKWAVE_FLAGS = --nomenus

# ===
BDF_DIR = block-diagram

default: simulate	
	@$(GHDL) -e $(TOP_LEVEL_ENTITY) # elaborate
	@$(GHDL) -r $(TOP_LEVEL_ENTITY) $(R_FLAGS) # run

simulate:
	@$(GHDL) -a $(VHDL_DIR)$(DEPS)

waveform: default
	@$(GTKWAVE) $(GTKWAVE_FLAGS) -f $(WAVE_F).vcd


svg: simulate
	-mkdir $(BDF_DIR)
	for en in $(TOP_LEVEL_ENTITY); do \
		yosys -m ghdl -p "ghdl $$en; prep -top $$en; write_json -compat-int svg.json"; \
		netlistsvg svg.json -o $(BDF_DIR)/$$en.svg ; \
	done
	for en in $(TOP_LEVEL_ENTITY); do \
		timg -C --upscale=i $(BDF_DIR)/$$en.svg -b"#ffffff"; \
	done

clean:
	-rm -f $(WAVE_F).ghw $(WAVE_F).vcd
	-rm -f work-obj93.cf
