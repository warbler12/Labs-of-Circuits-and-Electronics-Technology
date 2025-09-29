library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity bin_to_bcd is
    Port ( bin_in : in STD_LOGIC_VECTOR (5 downto 0);
           bcd_out : out STD_LOGIC_VECTOR (7 downto 0));
end bin_to_bcd;

architecture Behavioral of bin_to_bcd is
    signal temp : unsigned(7 downto 0);
begin
    process(bin_in)
        variable bin_value : unsigned(5 downto 0);
        variable bcd_value : unsigned(7 downto 0);
    begin
        bin_value := unsigned(bin_in);
        bcd_value := (others => '0');

        for i in 0 to 5 loop
            bcd_value := bcd_value sll 1; -- Shift left
            bcd_value(0) := bin_value(5-i); -- Add the next bit

            if i < 5 and bcd_value(3 downto 0) > 4 then
                bcd_value(3 downto 0) := bcd_value(3 downto 0) + 3; -- Adjust if necessary
            end if;

            if i < 5 and bcd_value(7 downto 4) > 4 then
                bcd_value(7 downto 4) := bcd_value(7 downto 4) + 3; -- Adjust if necessary
            end if;
        end loop;

        temp <= bcd_value;
    end process;

    bcd_out <= std_logic_vector(temp);
end Behavioral;