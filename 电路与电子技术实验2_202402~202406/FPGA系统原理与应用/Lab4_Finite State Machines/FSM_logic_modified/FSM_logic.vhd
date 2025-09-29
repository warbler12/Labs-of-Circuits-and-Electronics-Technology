library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FSM_logic_modified is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           w : in STD_LOGIC;
           z : out STD_LOGIC;
           y : buffer STD_LOGIC_VECTOR(8 downto 0) := "000000000";
           LEDR : out STD_LOGIC_VECTOR(8 downto 0));
end FSM_logic_modified;

architecture Behavioral of FSM_logic_modified is
begin
    -- Next state logic
    process(clk)
    begin
        if rising_edge(clk) then
            y(8) <= (y(7) or y(8)) and w and reset; --I
			y(7) <= y(6) and w and reset; --H
			y(6) <= y(5) and w and reset; --G
			y(5) <= (not y(0) or y(1) or y(2) or y(3) or y(4))and w and reset; --F
			y(4) <= (y(3) or y(4)) and not w and reset; --E
			y(3) <= y(2) and not w and reset; --D
			y(2) <= y(1) and not w and reset; --C
			y(1) <= (not y(0) or y(5) or y(6) or y(7) or y(8))and not w and reset; --B
			y(0) <= reset; --A
        end if;
    end process;
     
    -- Output Z logic 
    z <= y(4) or y(8); -- E and I are the accepting states

    -- LED output to show current state
    LEDR <= y;
end Behavioral;