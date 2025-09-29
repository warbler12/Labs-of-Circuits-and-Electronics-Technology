library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity eight_to_one_mux is
    Port ( C: in  STD_LOGIC_VECTOR(2 downto 0);  -- Selection lines
           S, T, U, V, W, X, Y, Z : in  STD_LOGIC_VECTOR (2 downto 0);  -- Data inputs
           M : out  STD_LOGIC_VECTOR (2 downto 0));  -- Output data
 end eight_to_one_mux;

architecture Behavioral of eight_to_one_mux is
begin
    process(C, S, T, U, V, W, X, Y, Z)
    begin
        case C  is
            when "000" => M <= S;
            when "001" => M <= T;
            when "010" => M <= U;
            when "011" => M <= V;
            when "100" => M <= W;
            when "101" => M <= X;
            when "110" => M <= Y;
            when "111" => M <= Z;
            when others=> M <= "111";
        end case;
    end process;
end Behavioral;