library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity clocka is
port(
	clk50m:in std_logic;		--时钟信号输入
	clr:in std_logic;			--复位信号
	inc_min:in std_logic;	--分调整增加
	dec_min:in std_logic;	--分调整减小
	inc_hour:in std_logic;	--时调整增加
	dec_hour:in std_logic;	--时调整减小
	seg_dis_hour0:out std_logic_vector(6 downto 0);	--小时个位
	seg_dis_hour1:out std_logic_vector(6 downto 0);	--小时十位
	seg_dis_min0:out std_logic_vector(6 downto 0);	--分钟个位
	seg_dis_min1:out std_logic_vector(6 downto 0);	--分钟十位
	seg_dis_sec0:out std_logic_vector(6 downto 0);	--秒个位
	seg_dis_sec1:out std_logic_vector(6 downto 0)	--秒十位
);
end clocka;

architecture behavior of clocka is

--秒信号
component hex7seg
port(
	data_in:in std_logic_vector(3 downto 0);
	seg_dis:out std_logic_vector(6 downto 0)
);
end component;

--数码管译码
component clk1Hz
port(
	clk:in std_logic;
	clock1Hz:out std_logic
);
end component;

signal clock1Hz:std_logic;
signal qhour0:std_logic_vector(3 downto 0);	--小时个位
signal qhour1:std_logic_vector(3 downto 0);	--小时十位
signal qmin0:std_logic_vector(3 downto 0);	--分钟个位
signal qmin1:std_logic_vector(3 downto 0);	--分钟十位
signal qsec0:std_logic_vector(3 downto 0);	--秒个位
signal qsec1:std_logic_vector(3 downto 0);	--秒十位

begin
u0: clk1Hz port map(clk=>clk50m,clock1Hz=>clock1Hz);
u1: hex7seg port map(data_in=>qhour0,seg_dis=>seg_dis_hour0);
u2: hex7seg port map(data_in=>qhour1,seg_dis=>seg_dis_hour1);
u3: hex7seg port map(data_in=>qmin0,seg_dis=>seg_dis_min0);
u4: hex7seg port map(data_in=>qmin1,seg_dis=>seg_dis_min1);
u5: hex7seg port map(data_in=>qsec0,seg_dis=>seg_dis_sec0);
u6: hex7seg port map(data_in=>qsec1,seg_dis=>seg_dis_sec1);

	process(clock1Hz,clr)		
		begin
			if(clr='0')then 
				qhour1<="0000";qhour0<="0000";
				qmin1<="0000";qmin0<="0000";
				qsec1<="0000";qsec0<="0000";					--复位清零
				elsif rising_edge(clock1Hz) then 
				----分调整增加
					if(inc_min='1') then
						if(qmin1="0101" and qmin0="1001") then
							qmin1<="0000";qmin0<="0000";		--??:59:??=>??:00:??
						elsif(qmin0="1001") then
							qmin1<=qmin1+1;qmin0<="0000";		--??:?9:??=>??:?0:??
						else	qmin0<=qmin0+1;
						end if;
				--分调整减小
					elsif(dec_min='1') then
						if(qmin1="0000" and qmin0="0000") then
							qmin1<="0101";qmin0<="1001";		--??:00:??=>??:59:??
						elsif(qmin0="0000") then
							qmin1<=qmin1-1;qmin0<="1001";		--??:?0:??=>??:?9:??
						else	qmin0<=qmin0-1;
						end if;
				--时调整增加
					elsif(inc_hour='1') then
						if(qhour1="0010" and qhour0="0011") then
							qhour1<="0000";qhour0<="0000";		--23:??:??=>00:??:??
						elsif(qhour0="1001") then
							qhour1<=qhour1+1;qhour0<="0000";		--?9:??:??=>?0:??:?0
						else	qhour0<=qhour0+1;
						end if;
				--秒调整减小
					elsif(dec_hour='1') then
						if(qhour1="0000" and qhour0="0000") then
							qhour1<="0010";qhour0<="0011";		--00:??:??=>23:??:??
						elsif(qhour0="0000") then
							qhour1<=qhour1-1;qhour0<="1001";		--?0:??:??=>?9:??:??
						else	qhour0<=qhour0-1;
						end if;
						
					elsif(qhour1="0010" and qhour0="0011" and qmin1="0101" and 
						qmin0="1001"  and qsec1="0101"  and qsec0="1001") then 
							qhour1<="0000";qhour0<="0000";
							qmin1<="0000";qmin0<="0000";
							qsec1<="0000";qsec0<="0000";		--23:59:59清零
					elsif(qhour0="1001" and qmin1="0101" and 
							qmin0="1001"  and qsec1="0101"  and qsec0="1001") then 
								qhour1<=qhour1+1;qhour0<="0000";
								qmin1<="0000";qmin0<="0000";
								qsec1<="0000";qsec0<="0000";	--?9:59:59=>?0:00:00
					elsif(qmin1="0101" and qmin0="1001" and 
							qsec1="0101"  and qsec0="1001") then 
								qhour0<=qhour0+1;
								qmin1<="0000";qmin0<="0000";
								qsec1<="0000";qsec0<="0000";	--??:59:59=>??:00:00
					elsif(qmin0="1001" and qsec1="0101"  and qsec0="1001") then 
								qmin1<=qmin1+1;qmin0<="0000";
								qsec1<="0000";qsec0<="0000";	--??:?9:59=>??:?0:00
					elsif(qsec1="0101" and qsec0="1001") then 
								qmin0<=qmin0+1;
								qsec1<="0000";qsec0<="0000";	--??:??:59=>??:??:00
					elsif(qsec0="1001") then 
								qsec1<=qsec1+1;qsec0<="0000";	--??:??:?9=>??:??:?0			
					else	qsec0<=qsec0+1;
					end if;
			end if;
	end process;
	
end behavior;