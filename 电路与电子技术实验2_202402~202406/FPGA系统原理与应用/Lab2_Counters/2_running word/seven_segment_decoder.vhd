library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity seven_segment_decoder is
    Port ( bin : in  STD_LOGIC_VECTOR(2 downto 0);
           seg : out  STD_LOGIC_VECTOR(6 downto 0));
end seven_segment_decoder;

architecture Behavioral of seven_segment_decoder is
begin
    process(bin)
    begin
        case bin is
            when "000" => seg <= "0001001"; -- H
            when "001" => seg <= "0000110"; -- E
            when "010" => seg <= "1000111"; -- L
            when "011" => seg <= "1000000"; -- O
            when others => seg <= "1111111"; -- black
        end case;
    end process;
end Behavioral;