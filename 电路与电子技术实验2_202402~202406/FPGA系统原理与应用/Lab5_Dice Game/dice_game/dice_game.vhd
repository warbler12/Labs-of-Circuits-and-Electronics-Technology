library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity dice_game is
    Port ( 
        clk_50MHz : in STD_LOGIC;
        reset : in STD_LOGIC;
        roll_button : in STD_LOGIC;
        win_light : out STD_LOGIC;
        lose_light : out STD_LOGIC;
        dice1_disp : out STD_LOGIC_VECTOR(6 downto 0);
        dice2_disp : out STD_LOGIC_VECTOR(6 downto 0);
        clk : buffer STD_LOGIC;
		dice1, dice2 : buffer unsigned(3 downto 0) := "0001";
		sum : buffer unsigned(3 downto 0);
		Roll, Sp: buffer STD_LOGIC;
		point : buffer unsigned(3 downto 0) := "0000";
		next_state_leds: buffer STD_LOGIC_VECTOR(2 downto 0);
        state_leds : out STD_LOGIC_VECTOR(2 downto 0)
    );
end dice_game;

architecture Behavioral of dice_game is
    type state_type is (IDLE, ROLLING, EVALUATE, WIN, LOSE, POINT_SET);
    signal state, next_state : state_type := IDLE;
    signal pre_roll_button : STD_LOGIC;
    
    component clock_divider is
        Port ( 
            clk_50MHz : in STD_LOGIC;
            reset : in STD_LOGIC;
            clk : out STD_LOGIC
        );
    end component;
        
    component seven_segment_decoder is
        Port ( 
            bin : in STD_LOGIC_VECTOR(3 downto 0);
            seg : out STD_LOGIC_VECTOR(6 downto 0)
        );
    end component;
    
begin
    U_clk_divider: clock_divider port map (clk_50MHz, reset, clk);
    
    process(clk, reset)
    begin
		if reset = '0' then
			state <= IDLE;
		elsif rising_edge(clk) then
			state <= next_state;
			pre_roll_button <= roll_button;
			if Sp= '1' then point <= sum; end if;
        end if;
    end process;
    
    process(state, roll_button, reset, sum)
    begin
		Roll <= '0';
		Sp <= '0';
		win_light <= '0';
		lose_light <= '0';
        case state is
            when IDLE =>
                if roll_button = '0' then
                    next_state <= ROLLING;
                else
                    next_state <= IDLE;
                end if;
                
            when ROLLING =>
                if roll_button = '0' then
					Roll <= '1';
					next_state <= ROLLING;
                elsif sum = 7 or sum = 11 then 
					next_state <= WIN;
				elsif sum = 2 or sum = 3 or sum = 12 then 
					next_state <= LOSE;
				else 
					Sp <= '1';
					next_state <= POINT_SET;
                end if;
                
            when WIN =>
                win_light <= '1';
                if reset = '0' then
					next_state <= IDLE;
				end if;
                
            when LOSE =>
                lose_light <= '1';
				if reset = '0' then
					next_state <= IDLE;				
				end if;
					
            when POINT_SET =>
				if roll_button = '0' then 
					Roll <= '1';
					next_state <= POINT_SET;
				elsif pre_roll_button = '0' and sum = point then 
					next_state <= WIN;
				elsif sum = 7 then 
					next_state <= LOSE;
				else 
					next_state <= POINT_SET;
				end if;                    
                
            when others =>
                next_state <= IDLE;
            end case;
    end process;
            
    process(clk, reset)
        variable temp_dice1 : unsigned(3 downto 0); 
        variable temp_dice2 : unsigned(3 downto 0); 
    begin
        if reset = '0' then
            dice1 <= "0001";
            dice2 <= "0001";
        elsif Roll = '1' and rising_edge(clk) then
            temp_dice1 := dice1 + 1;
            temp_dice2 := dice2;
            if temp_dice1 > 6 then 
				temp_dice1 := "0001"; 
				temp_dice2 := temp_dice2 + 1;
				if temp_dice2 > 6 then 
					temp_dice2 := "0001"; 
				end if;
            end if;
            sum <= temp_dice1 + temp_dice2;
            dice1 <= temp_dice1;
            dice2 <= temp_dice2;
        end if;
    end process;
    
    -- Instantiate the Seven Segment Decoders for both dice
    U_dice1_decoder: seven_segment_decoder port map (bin => std_logic_vector(dice1), seg => dice1_disp);
    U_dice2_decoder: seven_segment_decoder port map (bin => std_logic_vector(dice2), seg => dice2_disp);
    
	process(state, next_state)
    begin
        case state is
            when IDLE => state_leds <= "000";
            when ROLLING => state_leds <= "001";
            when EVALUATE => state_leds <= "011";
            when WIN => state_leds <= "111";
            when LOSE => state_leds <= "100";
            when POINT_SET => state_leds <= "101";
        end case;
        
        case next_state is
            when IDLE => next_state_leds <= "000";
            when ROLLING => next_state_leds <= "001";
            when EVALUATE => next_state_leds <= "011";
            when WIN => next_state_leds <= "111";
            when LOSE => next_state_leds <= "100";
            when POINT_SET => next_state_leds <= "101";
        end case;
    end process;
end Behavioral;