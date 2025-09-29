library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity binary_to_decimal is
    Port ( V : in STD_LOGIC_VECTOR (3 downto 0); -- 四位二进制输入
           M : out STD_LOGIC_VECTOR (3 downto 0); -- 四位输出
           Z : buffer STD_LOGIC);                 -- 比较器输出，模式更改为buffer
end binary_to_decimal;

architecture Behavioral of binary_to_decimal is
    signal V_int : unsigned(3 downto 0); -- 输入的整数值
    signal D1, D0 : unsigned(3 downto 0); -- 十位和个位
begin
    V_int <= unsigned(V); -- 将输入转换为无符号整数

    -- 比较器
    Z <= '1' when V_int > 9 else '0';

    -- 当V_int > 9时，计算D1（十位）和D0（个位）
    D1 <= "0001" when V_int > 9 else "0000"; -- 十位总是1
    D0 <= V_int - 10 when V_int > 9 else V_int; -- 个位是V_int - 10 或者 V_int

    -- 多路复用器
    M <= std_logic_vector(D0) when Z = '1' else std_logic_vector(V);

end Behavioral;