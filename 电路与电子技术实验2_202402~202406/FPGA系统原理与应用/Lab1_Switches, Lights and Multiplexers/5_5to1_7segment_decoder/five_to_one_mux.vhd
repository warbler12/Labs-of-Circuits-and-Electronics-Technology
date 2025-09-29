library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity five_to_one_mux is
    Port ( S: in  STD_LOGIC_VECTOR(2 downto 0);  -- Selection lines
           U, V, W, X, Y : in  STD_LOGIC_VECTOR (2 downto 0);  -- Data inputs
           M : out  STD_LOGIC_VECTOR (2 downto 0);
           LEDR : out STD_LOGIC_VECTOR (17 downto 0));  -- Output data
 end five_to_one_mux;

architecture Behavioral of five_to_one_mux is
begin
    process(S, U, V, W, X, Y)
    begin
        case S is
            when "000" => M <= U;
            when "001" => M <= V;
            when "010" => M <= W;
            when "011" => M <= X;
            when "100" => M <= Y;
            when others=> M <= "111";
        end case;
    end process;
    
end Behavioral;