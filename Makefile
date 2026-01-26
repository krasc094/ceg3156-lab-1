# === VHDL
GHDL = ghdl
R_FLAGS = --vcd=$(WAVE_F).vcd --wave=$(WAVE_F).ghw

# === vhdl components
DEPS = ./vhdl/*.vhdl
TOP_LEVEL =

WAVE_F = wave

# === WAVEFORM
GTKWAVE = gtkwave
GTKWAVE_FLAGS = --nomenus

default: simulate	
	@$(GHDL) -e $(TOP_LEVEL) # elaborate
	@$(GHDL) -r $(TOP_LEVEL) $(R_FLAGS) # run

simulate:
	@$(GHDL) -a $(DEPS)

waveform: default
	@$(GTKWAVE) $(GTKWAVE_FLAGS) -f $(WAVE_F).vcd

clean:
	-rm -f $(WAVE_F).ghw $(WAVE_F).vcd
	-rm -f work-obj93.cf
