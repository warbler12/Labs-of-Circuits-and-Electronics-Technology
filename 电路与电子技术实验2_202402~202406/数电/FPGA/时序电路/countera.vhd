library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity countera is
port(
	clk50m:in std_logic;						--输入50Hz时钟
	clr:in std_logic;							--清零
	qout:out std_logic_vector(3 downto 0)--四位二进制输出
);
end countera;

architecture behavior of countera is
--1Hz信号发生器子程序
component clk1Hz						
port(
	clk:in std_logic;
	clock1Hz:out std_logic
);
end component;

signal clock1Hz:std_logic;					--1Hz时钟
signal q:std_logic_vector(3 downto 0);	--输出暂存

begin
--底层设计=>顶层设计（连接）
u0: clk1Hz port map(clk=>clk50m,clock1Hz=>clock1Hz);

	process(clock1Hz,clr)		
		begin
			if(clr='0')then q<="0000";				--手动清零
			elsif rising_edge(clock1Hz) then 	--1Hz上升沿
					if(q="1001")then q<="0000";	--9->0
					else q<=q+1;						--计数加一
					end if;
			end if;
	end process;
	qout<=q;
end behavior;