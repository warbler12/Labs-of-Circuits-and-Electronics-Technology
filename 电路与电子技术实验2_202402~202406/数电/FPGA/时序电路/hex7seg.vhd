library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity hex7seg is
port(
	data_in:in std_logic_vector(3 downto 0);--输入0-9
	seg_dis:out std_logic_vector(6 downto 0)--显示码
);
end hex7seg;

architecture behavior of hex7seg is
begin
	process(data_in)		
	begin
		case data_in is
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