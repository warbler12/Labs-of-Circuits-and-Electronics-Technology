library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity add4bit is
port(
	a:in std_logic_vector(3 downto 0);
	b:in std_logic_vector(3 downto 0);
	c0:in std_logic;
	s:out std_logic_vector(3 downto 0);
	c4:out std_logic
);
end add4bit;

architecture behavior of add4bit is
component add1bit
port(
	a:in std_logic;
	b:in std_logic;
	c0:in std_logic;
	s:out std_logic;
	c1:out std_logic	
);
end component;

signal ss:std_logic_vector(3 downto 0);
signal c1,c2,c3,cc4:std_logic;

begin
u0:add1bit port map(a=>a(0),b=>b(0),c0=>c0,s=>ss(0),c1=>c1);
u1:add1bit port map(a=>a(1),b=>b(1),c0=>c1,s=>ss(1),c1=>c2);
u2:add1bit port map(a=>a(2),b=>b(2),c0=>c2,s=>ss(2),c1=>c3);
u4:add1bit port map(a=>a(3),b=>b(3),c0=>c3,s=>ss(3),c1=>cc4);
s<=ss;
c4<=cc4;

end behavior;