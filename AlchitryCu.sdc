# check this: the declaration "clk_0" is here for the purpose
# of time analysis of the gates, registers and wires delay.
# This might have an influence on the logic cells placement
# and wires routing. However, the name "clk_0" is never used
# in the Hardware Description Code (VHDL files). It might be
# that it can be used as a source for other clock declaration.
# this require further investigation.

create_clock -name clk_0 -period 10.0 [get_ports AlCu_CLOCK]
