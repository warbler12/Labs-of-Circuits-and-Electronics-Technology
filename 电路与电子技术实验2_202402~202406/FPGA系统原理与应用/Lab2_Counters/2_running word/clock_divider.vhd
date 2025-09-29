library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity clock_divider is
    Port ( clk_50MHz : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           clk_1Hz : out  STD_LOGIC);
end clock_divider;

architecture Behavioral of clock_divider is
    signal count : unsigned(25 downto 0) := (others => '0');
begin
    process(clk_50MHz, reset)
    begin
        if reset = '1' then
            count <= (others => '0');
            clk_1Hz <= '0';
        elsif rising_edge(clk_50MHz) then
            if count = 50000000 - 1 then--if count = 100 - 1 then--
                count <= (others => '0');
                clk_1Hz <= '1';
            else
                count <= count + 1;
                if count = 25000000 - 1 then--if count = 50 - 1 then--
					clk_1Hz <= '0';
				end if;
            end if;
        end if;
    end process;
end Behavioral;