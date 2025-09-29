library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity seven_segment_decoder is
    Port ( C : in  STD_LOGIC_VECTOR(2 downto 0);
           Display : out  STD_LOGIC_VECTOR (6 downto 0));
end seven_segment_decoder;

architecture Behavioral of seven_segment_decoder is
begin
    process(C)
    begin
        case C is
            when "000" => Display <= "0001001";  -- H
			when "001" => Display <= "0000110";  -- E
			when "010" => Display <= "1000111";  -- L
			when "011" => Display <= "1000000";  -- O
            when others=> Display <= "1111111";  -- Blank
        end case;
    end process;
end Behavioral;