library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity reaction_timer is
    Port ( 
        clk_50MHz : in STD_LOGIC; -- 50MHz clock input
        reset : in STD_LOGIC; -- Reset button KEY0
        start : out STD_LOGIC; -- LEDR0 output
        stop : in STD_LOGIC; -- Stop button KEY3
        sw : in STD_LOGIC_VECTOR(7 downto 0); -- Switches for delay setting
        hex2, hex1, hex0 : out STD_LOGIC_VECTOR(6 downto 0);
        clk_1kHz : buffer STD_LOGIC; 
		delay_counter : buffer unsigned(23 downto 0) := (others => '0'); 
		hundred, ten, unit : buffer STD_LOGIC_VECTOR(3 downto 0);
		ms_counter : buffer unsigned(9 downto 0) := (others => '0');
		delay_time : buffer unsigned(23 downto 0); 
		start_signal : buffer STD_LOGIC := '0'; 
		frozen : buffer STD_LOGIC := '0'
    );
end reaction_timer;

architecture Behavioral of reaction_timer is
    component clock_divider is
    Port ( clk_50MHz : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           clk_1kHz : out  STD_LOGIC);
    end component;

    component seven_segment_decoder is
        Port (
            bin : in STD_LOGIC_VECTOR(3 downto 0);
            seg : out STD_LOGIC_VECTOR(6 downto 0)
        );
    end component;

	component binary_to_bcd is
		Port ( 
			V : in STD_LOGIC_VECTOR (9 downto 0);
			H : out STD_LOGIC_VECTOR (3 downto 0); 
			T : out STD_LOGIC_VECTOR (3 downto 0);
			U : out STD_LOGIC_VECTOR (3 downto 0)  
		);
	end component;
begin
    -- Instantiate the clock divider to get a 1kHz clock from 50MHz
    U_clock_divider: clock_divider port map (clk_50MHz, reset, clk_1kHz);

    -- Calculate delay time based on switch settings
    process(sw)
		variable delay_temp : unsigned(35 downto 0); 
	begin
            delay_temp := resize(unsigned(sw), delay_time'length) * to_unsigned(1000, 12); -- 12 bits for 1000
            delay_time <= resize(delay_temp, delay_time'length);
	end process;
    -- Process to handle timing and counting
    process(clk_1kHz, reset)
    begin
        if reset = '0' then
            delay_counter <= (others => '0');
            ms_counter <= (others => '0');
            start_signal <= '0';
            frozen <= '0';
            start <= '0';
        elsif rising_edge(clk_1kHz) then
            if frozen = '0' then
                if delay_counter < delay_time then
                    delay_counter <= delay_counter + 1;
                    start <= '0';
                else
                    start <= '1';
                    ms_counter <= ms_counter + 1;
					if stop = '0' then
						frozen <= '1';
						start <= '0';
					end if;                
				end if;
            end if;
        end if;
    end process;
	
	--bcd conversion
	U_bcd: binary_to_bcd port map (std_logic_vector(ms_counter), hundred, ten, unit);

    -- Decode BCD to 7-segment display
    U_hundreds: seven_segment_decoder port map (hundred, hex2);
    U_tens: seven_segment_decoder port map (ten, hex1);
    U_units: seven_segment_decoder port map (unit, hex0);

end Behavioral;