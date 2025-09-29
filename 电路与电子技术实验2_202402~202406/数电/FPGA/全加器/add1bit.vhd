library IEEE;
use IEEE.STD_LOGIC_1164.ALL;--使用了IEEE库中的STD_LOGIC_1164包

-- 定义一个实体add1bit，用于实现1位二进制数的加法
entity add1bit1 is
port(
    a:in std_logic; 	-- 输入：1位二进制数a
    b:in std_logic; 	-- 输入：1位二进制数b
    c0:in std_logic;	-- 输入：来自低位的进位
    s:out std_logic;	-- 输出：本位的和
    c1:out std_logic -- 输出：向高位的进位
);
end add1bit1;

architecture behavior of add1bit1 is
begin
	c1<=(a and b)or(a and c0)or(c0 and b);    --当a、b、c0中任意两个或全部为1时，c1为1产生进位
	s<=a xor b xor c0;-- 本位和为三输入的异或
end behavior;