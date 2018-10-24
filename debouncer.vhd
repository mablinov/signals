library ieee;
use ieee.std_logic_1164.all;

entity debouncer is
	generic (
		sampling_cycles: positive := 2 ** 8
	);
	port (
		clk, en, reset: in std_logic;
		in_sig: in std_logic;
		out_sig: out std_logic := '0'
	);
end entity;

architecture rtl of debouncer is
	constant sampling_cycles_max: natural := sampling_cycles - 1;

	signal current_sig: std_logic := '0';
	signal counter: natural range 0 to sampling_cycles_max := 0;
	
	-- Helper conditionals
	signal have_new_signal: boolean := false;
	signal counter_overflow: boolean := false;
begin
	-- Drive output signal(s)
	out_sig <= current_sig;

	-- Set helper conditionals
	have_new_signal <= in_sig /= current_sig;
	counter_overflow <= counter = sampling_cycles_max;
	
	increment_counter: process (clk, en, reset, have_new_signal, counter_overflow) is
	begin
		if rising_edge(clk) then
			if reset = '1' then
				counter <= 0;
			
			elsif en = '1' then
			
				if have_new_signal then
					if counter_overflow then
						counter <= 0;
					else
						counter <= counter + 1;
					end if;
				else
					counter <= 0;
				end if;
				
			end if;
		end if;
	end process;

	set_current_signal: process (clk, en, reset, have_new_signal, counter_overflow) is
	begin
		if rising_edge(clk) then
			if reset = '1' then
				current_sig <= '0';
			
			elsif en = '1' then
			
				if have_new_signal and counter_overflow then
					current_sig <= in_sig;
				end if;
			
			end if;
		end if;
	end process;
end architecture;
