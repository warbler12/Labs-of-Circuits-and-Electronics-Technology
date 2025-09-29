library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity add is
    Port ( SW : in STD_LOGIC_VECTOR (15 downto 0);
           HEX7 : out STD_LOGIC_VECTOR (6 downto 0);
           HEX6 : out STD_LOGIC_VECTOR (6 downto 0);
           HEX5 : out STD_LOGIC_VECTOR (6 downto 0);
           HEX4 : out STD_LOGIC_VECTOR (6 downto 0);
           HEX2 : out STD_LOGIC_VECTOR (6 downto 0);
           HEX1 : out STD_LOGIC_VECTOR (6 downto 0);
           HEX0 : out STD_LOGIC_VECTOR (6 downto 0));
           --A1A0, B1B0 :buffer STD_LOGIC_VECTOR (7 downto 0);
           --S2S1S0 : buffer STD_LOGIC_VECTOR (11 downto 0));
end add;

architecture Behavioral of add is
    component bcd_adder_2digit
        Port ( A1A0 : in STD_LOGIC_VECTOR (7 downto 0);
               B1B0 : in STD_LOGIC_VECTOR (7 downto 0);
               S2S1S0 : out STD_LOGIC_VECTOR (11 downto 0));
    end component;

    component bcd_to_7seg
        Port ( BCD : in STD_LOGIC_VECTOR (3 downto 0);
               Seg : out STD_LOGIC_VECTOR (6 downto 0));
    end component;

    signal A1A0, B1B0 : STD_LOGIC_VECTOR (7 downto 0);
    signal S2S1S0 : STD_LOGIC_VECTOR (11 downto 0);
begin
    -- Assign switch values to BCD inputs
    -- Ensure inputs are valid BCD (0-9)
    A1A0(7 downto 4) <= "1001" when unsigned(SW(15 downto 12)) > 9 else SW(15 downto 12);
    A1A0(3 downto 0) <= "1001" when unsigned(SW(11 downto 8)) > 9 else SW(11 downto 8);
    B1B0(7 downto 4) <= "1001" when unsigned(SW(7 downto 4)) > 9 else SW(7 downto 4);
    B1B0(3 downto 0) <= "1001" when unsigned(SW(3 downto 0)) > 9 else SW(3 downto 0);

    -- BCD adder instance
    bcd_adder_2digit_inst: bcd_adder_2digit
        port map (
            A1A0 => A1A0,
            B1B0 => B1B0,
            S2S1S0 => S2S1S0
        );

    -- 7-segment display decoders
    bcd_to_7seg_inst1: bcd_to_7seg
        port map (
            BCD => A1A0(7 downto 4),
            Seg => HEX7
        );

    bcd_to_7seg_inst2: bcd_to_7seg
        port map (
            BCD => A1A0(3 downto 0),
            Seg => HEX6
        );

    bcd_to_7seg_inst3: bcd_to_7seg
        port map (
            BCD => B1B0(7 downto 4),
            Seg => HEX5
        );

    bcd_to_7seg_inst4: bcd_to_7seg
        port map (
            BCD => B1B0(3 downto 0),
            Seg => HEX4
        );

    bcd_to_7seg_inst5: bcd_to_7seg
        port map (
            BCD => S2S1S0(11 downto 8),
            Seg => HEX2
        );

    bcd_to_7seg_inst6: bcd_to_7seg
        port map (
            BCD => S2S1S0(7 downto 4),
            Seg => HEX1
        );

    bcd_to_7seg_inst7: bcd_to_7seg
        port map (
            BCD => S2S1S0(3 downto 0),
            Seg => HEX0
        );

end Behavioral;