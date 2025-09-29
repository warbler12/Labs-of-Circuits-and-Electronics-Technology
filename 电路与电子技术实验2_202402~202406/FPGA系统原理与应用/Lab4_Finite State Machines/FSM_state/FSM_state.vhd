library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FSM_state is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           w : in STD_LOGIC;
           z : out STD_LOGIC;
           next_state_leds: buffer STD_LOGIC_VECTOR(8 downto 0);
           state_leds : out STD_LOGIC_VECTOR(8 downto 0));
end FSM_state;

architecture Behavioral of FSM_state is
    type state_type is (A, B, C, D, E, F, G, H, I);
    signal state : state_type := A;
    signal next_state : state_type;
begin
    -- State register
    process(clk, reset)
    begin
        if rising_edge(clk) then
			if reset = '0' then
				state <= A;
            else
				state <= next_state;
			end if;
        end if;
    end process;

    -- Next state logic
    process(state, w)
    begin
        case state is
            when A =>
                if w = '0' then next_state <= B; else next_state <= F; end if;
                z <= '0';
            when B =>
                if w = '0' then next_state <= C; else next_state <= F; end if;
                z <= '0';
            when C =>
                if w = '0' then next_state <= D; else next_state <= F; end if;
                z <= '0';
            when D =>
                if w = '0' then next_state <= E; else next_state <= F; end if;
                z <= '0';
            when E =>
                if w = '0' then next_state <= E; else next_state <= F; end if;
                z <= '1';
            when F =>
                if w = '1' then next_state <= G; else next_state <= B; end if;
                z <= '0';
            when G =>
                if w = '1' then next_state <= H; else next_state <= B; end if;
                z <= '0';
            when H =>
                if w = '1' then next_state <= I; else next_state <= B; end if;
                z <= '0';
            when I =>
                if w = '1' then next_state <= I; else next_state <= B; end if;
                z <= '1';
        end case;
    end process;

    -- State LEDs
    process(state, next_state)
    begin
        case state is
            when A => state_leds <= "000000000";
            when B => state_leds <= "000000011";
            when C => state_leds <= "000000101";
            when D => state_leds <= "000001001";
            when E => state_leds <= "000010001";
            when F => state_leds <= "000100001";
            when G => state_leds <= "001000001";
            when H => state_leds <= "010000001";
            when I => state_leds <= "100000001";
        end case;
        
        case next_state is
            when A => next_state_leds <= "000000000";
            when B => next_state_leds <= "000000011";
            when C => next_state_leds <= "000000101";
            when D => next_state_leds <= "000001001";
            when E => next_state_leds <= "000010001";
            when F => next_state_leds <= "000100001";
            when G => next_state_leds <= "001000001";
            when H => next_state_leds <= "010000001";
            when I => next_state_leds <= "100000001";
        end case;
    end process;

end Behavioral;