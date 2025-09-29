library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity time_of_day_clock is
    Port ( 
        clk_50MHz : in STD_LOGIC; -- 50MHz clock input
        reset : in STD_LOGIC; -- Reset signal
        preset : in STD_LOGIC; -- Preset signal
        SW : in STD_LOGIC_VECTOR(15 downto 0); -- Switch inputs for presetting time
        HEX7, HEX6, HEX5, HEX4, HEX3, HEX2 : out STD_LOGIC_VECTOR(6 downto 0); -- 7-segment displays
        clk_1Hz : buffer STD_LOGIC;
		sec, min, hr : buffer unsigned(7 downto 0) := (others => '0')
    );
end time_of_day_clock;

architecture Behavioral of time_of_day_clock is
    component clock_divider is
        Port (
            clk_50MHz : in STD_LOGIC;
            reset : in STD_LOGIC;
            clk_1Hz : out STD_LOGIC
        );
    end component;

    component seven_segment_decoder is
        Port (
            bin : in STD_LOGIC_VECTOR(3 downto 0);
            seg : out STD_LOGIC_VECTOR(6 downto 0)
        );
    end component;
    
    component binary_to_bcd is
        Port ( 
            V : in STD_LOGIC_VECTOR (7 downto 0); -- 6-bit binary input
            T : out STD_LOGIC_VECTOR (3 downto 0); -- Tens digit output
            U : out STD_LOGIC_VECTOR (3 downto 0)  -- Units digit output
        );
    end component;
    
    signal hr_tens, hr_units, min_tens, min_units, sec_tens, sec_units : STD_LOGIC_VECTOR(3 downto 0);
    signal hr_bcd_preset, min_bcd_preset: STD_LOGIC_VECTOR (7 downto 0);
begin

    -- Instantiate the clock divider
    U_clock_divider: clock_divider port map (clk_50MHz,reset,clk_1Hz);
   
    -- preset
    process(preset)
    begin
		--hour
		if unsigned(SW(15 downto 12)) > 2 then 
			hr_bcd_preset(7 downto 4) <= "0010";
		else
			hr_bcd_preset(7 downto 4) <= SW(15 downto 12);
		end if;
		
		if hr_bcd_preset(7 downto 4) = "0010" and unsigned(SW(11 downto 8)) > 3 then 
			hr_bcd_preset(3 downto 0) <= "0011";
		elsif unsigned(SW(11 downto 8)) > 9 then
			hr_bcd_preset(3 downto 0) <= "1001";
		else
			hr_bcd_preset(3 downto 0) <= SW(11 downto 8);
		end if;
		
		--min
		if unsigned(SW(7 downto 4)) > 5 then 
			min_bcd_preset(7 downto 4) <= "0101";
		else
			min_bcd_preset(7 downto 4) <= SW(7 downto 4);
		end if;
		
		if unsigned(SW(3 downto 0)) > 9 then
			min_bcd_preset(3 downto 0) <= "1001";
		else
			min_bcd_preset(3 downto 0) <= SW(3 downto 0);
		end if;
    end process;
    
    -- Time counter process
    process(clk_1Hz, reset, preset)
    begin
        if reset = '0' then
            sec <= (others => '0');
            min <= (others => '0');
            hr <= (others => '0');
        elsif preset = '0' then
            hr <= unsigned(hr_bcd_preset(7 downto 4))*10 + unsigned(hr_bcd_preset(3 downto 0));
            min <=  unsigned(min_bcd_preset(7 downto 4))*10 + unsigned(min_bcd_preset(3 downto 0));
            sec <= (others => '0');
        elsif rising_edge(clk_1Hz) then
            if sec = 59 then
                sec <= (others => '0');
                if min = 59 then
                    min <= (others => '0');
                    if hr = 23 then
                        hr <= (others => '0');
                    else
                        hr <= hr + 1;
                    end if;
                else
                    min <= min + 1;
                end if;
            else
                sec <= sec + 1;
            end if;
        end if;
    end process;

    -- Decompose time into tens and units
    U_hr_bcd: binary_to_bcd port map (std_logic_vector(hr), hr_tens, hr_units);
    U_min_bcd: binary_to_bcd port map (std_logic_vector(min), min_tens, min_units);
    U_sec_bcd: binary_to_bcd port map (std_logic_vector(sec), sec_tens, sec_units);

    -- Instantiate the seven segment decoders
    U_hr_tens: seven_segment_decoder port map (hr_tens, HEX7);
    U_hr_units: seven_segment_decoder port map (hr_units, HEX6);
    U_min_tens: seven_segment_decoder port map (min_tens, HEX5);
    U_min_units: seven_segment_decoder port map (min_units, HEX4);
    U_sec_tens: seven_segment_decoder port map (sec_tens, HEX3);
    U_sec_units: seven_segment_decoder port map (sec_units, HEX2);

end Behavioral;