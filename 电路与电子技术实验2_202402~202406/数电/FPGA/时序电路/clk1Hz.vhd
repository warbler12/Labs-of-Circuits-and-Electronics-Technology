library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity clk1Hz is
port(
	clk:in std_logic;
	clock1Hz:out std_logic
);
end clk1Hz;

architecture behavior of clk1Hz is
constant m:integer :=25000000;
signal tmp:std_logic;

begin
	process(clk,tmp)		--顺序执行
		variable cout:integer:=0;
		begin
			if rising_edge(clk) then
				cout:=cout+1;
				if cout<=m then tmp<='0';
					elsif cout<m*2 then tmp<='1';
					else cout:=0;
				end if;
			end if;
	end process;
	clock1Hz<=tmp;
end behavior;