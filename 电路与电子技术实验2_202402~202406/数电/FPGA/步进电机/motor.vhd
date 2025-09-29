library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity motor is
port(
	clk_50mHz:in std_logic;
	key0_up,key1_down:in std_logic;
	sw0_clr,sw1_x:in std_logic;
	a,b,c,f:out std_logic;
	hex0,hex1:out std_logic_vector(6 downto 0)
	);
end motor;

architecture behavior of motor is
signal q1:std_logic_vector(3 downto 0):="0000";
signal q0:std_logic_vector(3 downto 0):="0001";
signal clk_2Hz:std_logic;
signal q2,q3,q4,q5:std_logic_vector(7 downto 0):="00000000";
signal k: integer range 0 to 25000000;
signal freq:std_logic;
signal qa:std_logic:='1';
signal qb,qc:std_logic:='0';

constant m:integer:=12500000;
begin
--0.5s
process(clk_50mHz)
	variable cout:integer:=0;
	begin
		if rising_edge(clk_50mHz) then
			cout:=cout+1;
			if cout<=m then clk_2Hz<='0';
			elsif cout<m*2 then clk_2Hz<='1';
			else cout:=0;
			end if;
		end if;
end process;
--100
process(clk_2Hz)
begin
	if rising_edge(clk_2Hz) then
		if key0_up='0' then						--"+"
			if(q1="1001" and q0="1001") then	--99->01
				q1<="0000";q0<="0001";
			elsif(q0="1001") then
				q1<=q1+1;q0<="0000";
			else q0<=q0+1;
			end if;
		elsif key1_down='0' then				--"-"
			if(q1="0000" and q0="0001") then	--01->99
				q1<="1001";q0<="1001";
			elsif(q0="0000") then
				q1<=q1-1;q0<="1001";
			else q0<=q0-1;
			end if;
		end if;
	end if;
end process;
--freq
process(clk_50mHz)
	variable cout:integer:=0;
	begin
		if rising_edge(clk_50mHz) then
			cout:=cout+1;
			if cout<=k then freq<='0';
			elsif cout<k*2 then freq<='1';
			else cout:=0;
			end if;
		end if;
end process;
--100->16

q2(3 downto 0)<=q0;
q3(4 downto 1)<=q1;
q4(6 downto 3)<=q1;
q5<=q2+q3+q4;
k<=25000000/conv_integer(q5);
--hex
process(q0)
begin
	case q0 is
			when "0000"=>hex0<="1000000";	--0
			when "0001"=>hex0<="1111001";	--1
			when "0010"=>hex0<="0100100";	--2
			when "0011"=>hex0<="0110000";	--3
			when "0100"=>hex0<="0011001";	--4
			when "0101"=>hex0<="0010010";	--5
			when "0110"=>hex0<="0000010";	--6
			when "0111"=>hex0<="1111000";	--7
			when "1000"=>hex0<="0000000";	--8
			when "1001"=>hex0<="0010000";	--9
			when others=>hex0<="1111111";	
	end case;
end process;

process(q1)
begin
	case q1 is
			when "0000"=>hex1<="1000000";	--0
			when "0001"=>hex1<="1111001";	--1
			when "0010"=>hex1<="0100100";	--2
			when "0011"=>hex1<="0110000";	--3
			when "0100"=>hex1<="0011001";	--4
			when "0101"=>hex1<="0010010";	--5
			when "0110"=>hex1<="0000010";	--6
			when "0111"=>hex1<="1111000";	--7
			when "1000"=>hex1<="0000000";	--8
			when "1001"=>hex1<="0010000";	--9
			when others=>hex1<="1111111";	
	end case;
end process;

process(freq)
begin
	if rising_edge(freq) then
		qa<=not((sw1_x and qb) or ((not sw1_x) and qc));
		qb<=not((sw1_x and qc) or ((not sw1_x) and qa));
		qc<=not((sw1_x and qa) or ((not sw1_x) and qb));
	end if;
end process;

f<=freq;
a<=qa and sw0_clr;
b<=qb and sw0_clr;
c<=qc and sw0_clr;

end behavior;