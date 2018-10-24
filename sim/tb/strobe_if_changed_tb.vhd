library ieee;
use ieee.std_logic_1164.all;

entity strobe_if_changed_tb is
end entity;

architecture tb of strobe_if_changed_tb is
	constant p: time := 10 ns; -- Clock period.

	signal clk: std_logic := '1';
	signal in_sig: std_logic := '0';
	signal strb: std_logic := '0';
begin
	clk <= not clk after p/2;

	testbench: process
	begin
		wait for 5*p;
		
		in_sig <= '1';
		wait for 5*p;
		
		in_sig <= '0';
		wait for 5*p;
		
		in_sig <= '1';
		wait for p;
		
		in_sig <= '0';
		wait for p;
		
		in_sig <= '1';
		wait for p;
	end process;

	uut: entity work.strobe_if_changed(rtl)
	port map (
		clk => clk, en => '1', reset => '0',
		in_sig => in_sig,
		strb => strb
	);
	
end architecture;
