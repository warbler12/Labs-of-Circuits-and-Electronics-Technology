LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY five_to_one_7segment_decoder IS
    PORT ( SW : IN STD_LOGIC_VECTOR(17 DOWNTO 0);
           shift_reg : buffer STD_LOGIC_VECTOR(14 DOWNTO 0);
           M0,M1,M2,M3,M4 : buffer STD_LOGIC_VECTOR(2 DOWNTO 0);
           HEX0, HEX1, HEX2, HEX3, HEX4 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0));
END five_to_one_7segment_decoder;

ARCHITECTURE Behavior OF five_to_one_7segment_decoder IS
    COMPONENT five_to_one_mux
        PORT (S, U, V, W, X, Y : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
              M : OUT STD_LOGIC_VECTOR(2 DOWNTO 0));
    END COMPONENT;

    COMPONENT seven_segment_decoder
        PORT (C : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
              Display : OUT STD_LOGIC_VECTOR(6 DOWNTO 0));
    END COMPONENT;
    
BEGIN
	shift_reg <= SW(14 DOWNTO 0);
    -- Instantiate the multiplexers
    MUX0: five_to_one_mux PORT MAP (SW(17 DOWNTO 15), shift_reg(14 DOWNTO 12), shift_reg(11 DOWNTO 9),
									shift_reg(8 DOWNTO 6), shift_reg(5 DOWNTO 3), shift_reg(2 DOWNTO 0), M0);
    MUX1: five_to_one_mux PORT MAP (SW(17 DOWNTO 15), shift_reg(11 DOWNTO 9), shift_reg(8 DOWNTO 6),
									shift_reg(5 DOWNTO 3), shift_reg(2 DOWNTO 0), shift_reg(14 DOWNTO 12), M1);
    MUX2: five_to_one_mux PORT MAP (SW(17 DOWNTO 15),shift_reg(8 DOWNTO 6), shift_reg(5 DOWNTO 3), 
									shift_reg(2 DOWNTO 0),shift_reg(14 DOWNTO 12), shift_reg(11 DOWNTO 9), M2);
    MUX3: five_to_one_mux PORT MAP (SW(17 DOWNTO 15), shift_reg(5 DOWNTO 3), shift_reg(2 DOWNTO 0),
									shift_reg(14 DOWNTO 12), shift_reg(11 DOWNTO 9),shift_reg(8 DOWNTO 6),  M3);
    MUX4: five_to_one_mux PORT MAP (SW(17 DOWNTO 15), shift_reg(2 DOWNTO 0),shift_reg(14 DOWNTO 12), 
									shift_reg(11 DOWNTO 9),shift_reg(8 DOWNTO 6), shift_reg(5 DOWNTO 3),  M4);
    
    -- Instantiate the decoders
    CHAR0: seven_segment_decoder PORT MAP (M0, HEX4);
    CHAR1: seven_segment_decoder PORT MAP (M1, HEX3);
    CHAR2: seven_segment_decoder PORT MAP (M2, HEX2);
    CHAR3: seven_segment_decoder PORT MAP (M3, HEX1);
    CHAR4: seven_segment_decoder PORT MAP (M4, HEX0);
END Behavior;