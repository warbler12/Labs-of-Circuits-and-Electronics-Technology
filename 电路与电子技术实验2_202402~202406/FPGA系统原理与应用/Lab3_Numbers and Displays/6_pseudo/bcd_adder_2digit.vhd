library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use ieee.std_logic_unsigned.all;

entity bcd_adder_2digit is
    Port ( A1A0 : in STD_LOGIC_VECTOR (7 downto 0);
           B1B0 : in STD_LOGIC_VECTOR (7 downto 0);
           S2S1S0 : out STD_LOGIC_VECTOR (11 downto 0));
end bcd_adder_2digit;

architecture Behavioral of bcd_adder_2digit is
    signal T0, T1, S0, S1 : STD_LOGIC_VECTOR (4 downto 0);
    signal c1, c2 : STD_LOGIC;
    signal Z0, Z1 : STD_LOGIC_VECTOR (4 downto 0);
    signal c1_tmp: STD_LOGIC_VECTOR(4 downto 0);
begin
    -- Calculate T0 = A0 + B0
    T0 <= std_logic_vector(unsigned('0' & A1A0(3 downto 0)) + unsigned('0' & B1B0(3 downto 0)));

    -- Check if T0 > 9
    process(T0)
    begin
        if unsigned(T0) > 9 then
            Z0 <= "01010"; -- 10 in binary
            c1 <= '1';
        else
            Z0 <= "00000";
            c1 <= '0';
        end if;
    end process;

    -- Calculate S0 = T0 - Z0
    S0 <= std_logic_vector(unsigned(T0) - unsigned(Z0));

    -- Calculate T1 = A1 + B1 + c1
    c1_tmp<="0000"&c1;
 T1 <= std_logic_vector(unsigned('0' &A1A0(7 downto 4)) + unsigned('0' &B1B0(7 downto 4))+unsigned(c1_tmp)) ;
     -- Check if T1 > 9
    process(T1)
    begin
        if unsigned(T1) > 9 then
            Z1 <= "01010"; -- 10 in binary
            c2 <= '1';
        else
            Z1 <= "00000";
            c2 <= '0';
        end if;
    end process;

    -- Calculate S1 = T1 - Z1
    S1 <= std_logic_vector(unsigned(T1) - unsigned(Z1));

    -- Combine the results
    S2S1S0(3 downto 0) <= S0(3 downto 0);
    S2S1S0(7 downto 4) <= S1(3 downto 0);
    S2S1S0(11 downto 8) <= "000" & c2;

end Behavioral;