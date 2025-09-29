library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
entity counterb is
port(
	clk50m:in std_logic;	--输入50MHZ时钟
	clr:in std_logic;		--输入清零
	seg_dis:out std_logic_vector(6 downto 0)--输出七位显示码
);
end counterb;

architecture behavior of counterb is
--1Hz信号子程序
component clk1Hz	
port(
	clk:in std_logic;
	clock1Hz:out std_logic
);
end component;

signal clock1Hz:std_logic;--1Hz信号
signal q:std_logic_vector(3 downto 0);--四位二进制计数器
begin
--底层设计=>顶层设计
u0: clk1Hz port map(clk=>clk50m,clock1Hz=>clock1Hz);
	process(clock1Hz,clr)					--0-9计数
		begin
			if(clr='0')then q<="0000";		--手动清零
				elsif rising_edge(clock1Hz) then 
					if(q="1001")then q<="0000";--9->0
					else q<=q+1;				--计数器+1
					end if;
			end if;
	end process;
	process(q)									--二进制转换为显示码
	begin
		case q is
			when "0000"=>seg_dis<="1000000";	--0
			when "0001"=>seg_dis<="1111001";	--1
			when "0010"=>seg_dis<="0100100";	--2
			when "0011"=>seg_dis<="0110000";	--3
			when "0100"=>seg_dis<="0011001";	--4
			when "0101"=>seg_dis<="0010010";	--5
			when "0110"=>seg_dis<="0000010";	--6
			when "0111"=>seg_dis<="1111000";	--7
			when "1000"=>seg_dis<="0000000";	--8
			when "1001"=>seg_dis<="0010000";	--9
			when "1010"=>seg_dis<="0001000";	--A
			when "1011"=>seg_dis<="0000011";	--B
			when "1100"=>seg_dis<="1000110";	--C
			when "1101"=>seg_dis<="0100001";	--D
			when "1110"=>seg_dis<="0000110";	--E
			when "1111"=>seg_dis<="0001110";	--F
			when others=>seg_dis<="1111111";	
			end case;
	end process;
end behavior;