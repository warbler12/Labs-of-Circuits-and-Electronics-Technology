library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity five_to_one_mux_display is
    Port ( S2, S1, S0 : in  STD_LOGIC;  -- Selection lines
           U, V, W, X, Y : in  STD_LOGIC_VECTOR (2 downto 0);  -- Data inputs
           M : out  STD_LOGIC_VECTOR (2 downto 0);
           LEDR : out STD_LOGIC_VECTOR (17 downto 0));  -- Output data
 end five_to_one_mux_display;

architecture Behavioral of five_to_one_mux_display is
	signal s:STD_LOGIC_VECTOR (2 downto 0);
begin
    process(S2, S1, S0, U, V, W, X, Y)
    begin
		s<=S2 & S1 & S0;
        case s is
            when "000" => M <= U;
            when "001" => M <= V;
            when "010" => M <= W;
            when "011" => M <= X;
            when "100" => M <= Y;
            when others=> M <= "000";
        end case;
    end process;
    
    -- Connect inputs to red LEDs for display
    LEDR(17) <= S2;
    LEDR(16) <= S1;
    LEDR(15) <= S0;
    LEDR(14) <= U(2);
    LEDR(13) <= U(1);
    LEDR(12) <= U(0);
    LEDR(11) <= V(2);
    LEDR(10) <= V(1);
    LEDR(9)  <= V(0);
    LEDR(8)  <= W(2);
    LEDR(7)  <= W(1);
    LEDR(6)  <= W(0);
    LEDR(5)  <= X(2);
    LEDR(4)  <= X(1);
    LEDR(3)  <= X(0);
    LEDR(2)  <= Y(2);
    LEDR(1)  <= Y(1);
    LEDR(0)  <= Y(0);
end Behavioral;