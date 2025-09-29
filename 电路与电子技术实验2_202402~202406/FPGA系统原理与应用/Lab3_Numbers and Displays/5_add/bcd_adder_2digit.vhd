library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity bcd_adder_2digit is
    Port ( A1A0 : in STD_LOGIC_VECTOR (7 downto 0);
           B1B0 : in STD_LOGIC_VECTOR (7 downto 0);
           S2S1S0 : out STD_LOGIC_VECTOR (11 downto 0));
end bcd_adder_2digit;

architecture Behavioral of bcd_adder_2digit is
    component bcd_adder_1digit
        Port ( A : in STD_LOGIC_VECTOR (3 downto 0);
               B : in STD_LOGIC_VECTOR (3 downto 0);
               Cin : in STD_LOGIC;
               Sum : out STD_LOGIC_VECTOR (3 downto 0);
               Cout : out STD_LOGIC);
    end component;

    signal Cin1, Cout1, Cout2 : STD_LOGIC;
    signal Sum1, Sum2 : STD_LOGIC_VECTOR (3 downto 0);
    signal A1, A0, B1, B0 : STD_LOGIC_VECTOR (3 downto 0);
begin
    -- Ensure inputs are valid BCD (0-9)
    A1 <= "1001" when unsigned(A1A0(7 downto 4)) > 9 else A1A0(7 downto 4);
    A0 <= "1001" when unsigned(A1A0(3 downto 0)) > 9 else A1A0(3 downto 0);
    B1 <= "1001" when unsigned(B1B0(7 downto 4)) > 9 else B1B0(7 downto 4);
    B0 <= "1001" when unsigned(B1B0(3 downto 0)) > 9 else B1B0(3 downto 0);

    -- First BCD adder for the lower digits
    bcd_adder_1digit_inst1: bcd_adder_1digit
        port map (
            A => A0,
            B => B0,
            Cin => '0',
            Sum => Sum1,
            Cout => Cout1
        );

    -- Second BCD adder for the higher digits
    bcd_adder_1digit_inst2: bcd_adder_1digit
        port map (
            A => A1,
            B => B1,
            Cin => Cout1,
            Sum => Sum2,
            Cout => Cout2
        );

    -- Combine the results
    S2S1S0(3 downto 0) <= Sum1;
    S2S1S0(7 downto 4) <= Sum2;
    S2S1S0(11 downto 8) <=  "000"&Cout2;

end Behavioral;