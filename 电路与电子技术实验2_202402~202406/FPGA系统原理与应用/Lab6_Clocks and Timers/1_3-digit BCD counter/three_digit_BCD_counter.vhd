library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity three_digit_bcd_counter is
    Port (
        clk_50MHz : in STD_LOGIC;    -- 50 MHz clock input
        reset : in STD_LOGIC;        -- Reset signal from KEY0
        hex0, hex1, hex2 : out STD_LOGIC_VECTOR(6 downto 0); 	  -- 7-segment displays
        counter : buffer unsigned(9 downto 0) := (others => '0'); -- 10-bit counter for BCD (0 to 999)
        clk_1Hz : buffer STD_LOGIC;
		hundred, ten, unit : buffer STD_LOGIC_VECTOR (3 downto 0) -- Digits for display
    );
end three_digit_bcd_counter;

architecture Behavioral of three_digit_bcd_counter is

    component binary_to_bcd is
        Port ( 
            V : in STD_LOGIC_VECTOR (9 downto 0);
            H : out STD_LOGIC_VECTOR (3 downto 0);
            T : out STD_LOGIC_VECTOR (3 downto 0);
            U : out STD_LOGIC_VECTOR (3 downto 0)
        );
    end component;

    component seven_segment_decoder is
        Port ( 
            bin : in STD_LOGIC_VECTOR(3 downto 0);
            seg : out STD_LOGIC_VECTOR(6 downto 0)
        );
    end component;
    
	component clock_divider is
    Port ( clk_50MHz : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           clk_1Hz : out  STD_LOGIC);
	end component;

begin
    -- Clock Divider to generate a 1Hz clock from the 50MHz clock
	U_clock_divider: clock_divider port map (clk_50MHz, reset, clk_1Hz);
	
    -- BCD Counter
    process(clk_1Hz, reset)
    begin
        if reset = '0' then
            counter <= (others => '0');
        elsif rising_edge(clk_1Hz) then
            if counter = 999 then
                counter <= (others => '0');
            else
                counter <= counter + 1;
            end if;
        end if;
    end process;

    -- Convert 10-bit binary to BCD
    U_binary_to_bcd: binary_to_bcd port map (std_logic_vector(counter), hundred, ten, unit);

    -- Convert BCD to 7-segment display code
    U_seven_segment_decoder_hundreds: seven_segment_decoder port map (hundred, hex2);
    U_seven_segment_decoder_tens: seven_segment_decoder port map (ten, hex1);
    U_seven_segment_decoder_units: seven_segment_decoder port map (unit, hex0);

end Behavioral;