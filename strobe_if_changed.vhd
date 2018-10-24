library ieee;
use ieee.std_logic_1164.all;

entity strobe_if_changed is
	port (
		clk, en, reset: in std_logic;
		in_sig: in std_logic;
		strb: out std_logic := '0'
	);
end entity;

architecture rtl of strobe_if_changed is
	signal current_sig: std_logic := '0';	
	signal have_new_signal: boolean := false;
begin
	have_new_signal <= current_sig /= in_sig;

	strb <= '1' when have_new_signal else '0';

	process (clk, en, reset, in_sig, have_new_signal) is
	begin
		if rising_edge(clk) then
		
			if reset = '1' then
				current_sig <= '0';
			
			elsif en = '1' then
				if have_new_signal then
					current_sig <= in_sig;
				end if;
			end if;
			
		end if;
	end process;

end architecture;
