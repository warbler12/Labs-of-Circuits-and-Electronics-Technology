library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity two_to_one_mux_display is
    Port ( SW17 : in STD_LOGIC;  -- Select input
           SW7_0 : in STD_LOGIC_VECTOR (7 downto 0);  -- 8-bit input X
           SW15_8 : in STD_LOGIC_VECTOR (7 downto 0);  -- 8-bit input Y
           LEDR7_0 : out STD_LOGIC_VECTOR (7 downto 0);  -- 8-bit input X for display
           LEDR15_8 : out STD_LOGIC_VECTOR (7 downto 0);  -- 8-bit input Y for display
           LEDG7_0 : out STD_LOGIC_VECTOR (7 downto 0)  -- 8-bit output M for display
         );
end two_to_one_mux_display;

architecture Behavioral of two_to_one_mux_display is
    component two_to_one_mux
        Port ( s : in STD_LOGIC;
               X : in STD_LOGIC_VECTOR (7 downto 0);
               Y : in STD_LOGIC_VECTOR (7 downto 0);
               M : out STD_LOGIC_VECTOR (7 downto 0)
             );
    end component;

    signal M : STD_LOGIC_VECTOR (7 downto 0);

begin
    -- Instantiate the 2-to-1 multiplexer
    two_to_one_mux_inst:
		two_to_one_mux port map (
			s => SW17,
			X => SW7_0,
			Y => SW15_8,
			M => M
		);

    -- Connect inputs to red LEDs for display
    LEDR7_0 <= SW7_0;
    LEDR15_8 <= SW15_8;

    -- Connect output to green LEDs for display
    LEDG7_0 <= M;
end Behavioral;