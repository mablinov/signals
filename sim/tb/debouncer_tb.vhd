library ieee;
use ieee.std_logic_1164.all;

entity debouncer_tb is
end entity;

architecture tb of debouncer_tb is
	signal clk: std_logic := '1';
	signal in_sig, out_sig: std_logic := '0';
	
	constant p: time := 10ns; -- clock period
begin
	clk <= not clk after p/2;
	
	testbench: process
	begin
		wait for 5*p;
		
		-- Try a bounce
		in_sig <= '1';
		wait for 120*p;
		in_sig <= '0';
		wait for p;

		-- Now go all the way
		in_sig <= '1';
		wait for 130*p;
		
		-- Now do the same but with '0'.
		wait for 5*p;
		
		in_sig <= '0';
		wait for 120*p;
		in_sig <= '1';
		wait for p;
		
		in_sig <= '0';
		wait for 130*p;
		
		-- End of simulation
		wait;
	end process;

	uut: entity work.debouncer(rtl)
	generic map (
		sampling_cycles => 2 ** 7
	)
	port map (
		clk => clk, en => '1', reset => '0',
		in_sig => in_sig,
		out_sig => out_sig
	);

end architecture;
