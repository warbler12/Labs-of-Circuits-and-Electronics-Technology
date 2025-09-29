LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY switch_to_led IS
    PORT (
        SW : IN STD_LOGIC_VECTOR(17 DOWNTO 0);  -- Input switches
        LEDR : OUT STD_LOGIC_VECTOR(17 DOWNTO 0)  -- Output LEDs
    );
END switch_to_led;

ARCHITECTURE Behavior OF switch_to_led IS
BEGIN
    LEDR <= SW;  -- Connect all switches to their respective LEDs
END Behavior;