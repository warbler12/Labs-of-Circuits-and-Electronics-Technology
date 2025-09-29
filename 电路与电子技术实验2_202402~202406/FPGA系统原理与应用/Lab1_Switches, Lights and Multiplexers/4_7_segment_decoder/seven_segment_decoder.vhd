library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity seven_segment_decoder is
    Port ( C2, C1, C0 : in  STD_LOGIC;
           HEX0 : out  STD_LOGIC_VECTOR (6 downto 0));
end seven_segment_decoder;

architecture Behavioral of seven_segment_decoder is
	signal c :STD_LOGIC_VECTOR (2 downto 0);
begin
    process(C2, C1, C0)
    begin
    c <= C2 & C1 & C0;
        case c is
            when "000" => HEX0 <= "0001001";  -- H
			when "001" => HEX0 <= "0000110";  -- E
			when "010" => HEX0 <= "1000111";  -- L
			when "011" => HEX0 <= "1000000";  -- O
            when others=> HEX0 <= "1111111";  -- Blank
        end case;
    end process;
end Behavioral;