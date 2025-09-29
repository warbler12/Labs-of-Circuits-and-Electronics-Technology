library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity bcd_adder_1digit is
    Port ( A : in STD_LOGIC_VECTOR (3 downto 0);
           B : in STD_LOGIC_VECTOR (3 downto 0);
           Cin : in STD_LOGIC;
           Sum : out STD_LOGIC_VECTOR (3 downto 0);
           Cout : out STD_LOGIC);
end bcd_adder_1digit;

architecture Behavioral of bcd_adder_1digit is
    signal temp_sum : unsigned(4 downto 0);
    signal A_trunc, B_trunc : STD_LOGIC_VECTOR (3 downto 0);
begin
-- Ensure inputs are valid BCD (0-9)
    A_trunc <= "1001" when unsigned(A) > 9 else A;
    B_trunc <= "1001" when unsigned(B) > 9 else B;
    -- Add the inputs and the carry-in
    temp_sum <= ('0' & unsigned(A_trunc)) + ('0' & unsigned(B_trunc)) + ("0000" & Cin);

    -- Check if the result needs adjustment
    process(temp_sum)
    begin
        if temp_sum > 9 then
            Sum <= std_logic_vector(temp_sum(3 downto 0) + 6);
            Cout <= '1';
        else
            Sum <= std_logic_vector(temp_sum(3 downto 0));
            Cout <= temp_sum(4);
        end if;
    end process;

end Behavioral;