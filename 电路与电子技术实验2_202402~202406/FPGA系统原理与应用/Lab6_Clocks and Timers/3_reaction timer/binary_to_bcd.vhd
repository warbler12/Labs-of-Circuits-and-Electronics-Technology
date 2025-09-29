library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity binary_to_bcd is
    Port ( 
        V : in STD_LOGIC_VECTOR (9 downto 0); -- 10-bit binary input
        H : out STD_LOGIC_VECTOR (3 downto 0); -- Hundreds digit output
        T : out STD_LOGIC_VECTOR (3 downto 0); -- Tens digit output
        U : out STD_LOGIC_VECTOR (3 downto 0)  -- Units digit output
    );
end binary_to_bcd;

architecture Behavioral of binary_to_bcd is
    signal V_int : unsigned(9 downto 0); -- 输入的整数值
begin
    V_int <= unsigned(V); -- 将输入转换为无符号整数

    process(V_int)
        variable hundred, ten, unit : unsigned(3 downto 0) := (others => '0');
        variable temp : unsigned(9 downto 0) := (others => '0');
    begin
        temp := V_int;
        
        if temp >= 100 then
            hundred := resize(temp / 100, hundred'length);
            temp := temp mod 100; 
        else 
			hundred := "0000";
        end if;
                
        -- 计算十位
        if temp >= 10 then
            ten := resize(temp / 10, ten'length);
            temp := temp mod 10; 
        else 
			ten := "0000";
        end if;
        
        -- 剩余个位
        unit := resize(temp, unit'length);

        -- 输出BCD
        H <= std_logic_vector(hundred);
        T <= std_logic_vector(ten);
        U <= std_logic_vector(unit);
    end process;

end Behavioral;