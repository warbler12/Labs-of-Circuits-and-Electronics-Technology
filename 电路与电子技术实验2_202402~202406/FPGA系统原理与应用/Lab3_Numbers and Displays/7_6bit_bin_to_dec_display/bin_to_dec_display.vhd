library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity bin_to_dec_display is
    Port ( SW : in STD_LOGIC_VECTOR (5 downto 0);
           HEX1 : out STD_LOGIC_VECTOR (6 downto 0);
           HEX0 : out STD_LOGIC_VECTOR (6 downto 0);
           bcd_out :buffer STD_LOGIC_VECTOR (7 downto 0));
           
end bin_to_dec_display;

architecture Behavioral of bin_to_dec_display is
    component bin_to_bcd
        Port ( bin_in : in STD_LOGIC_VECTOR (5 downto 0);
               bcd_out : out STD_LOGIC_VECTOR (7 downto 0));
    end component;

    component bcd_to_7seg
        Port ( BCD : in STD_LOGIC_VECTOR (3 downto 0);
               Seg : out STD_LOGIC_VECTOR (6 downto 0));
    end component;

    --signal bcd_out : STD_LOGIC_VECTOR (7 downto 0);
begin
    -- Binary to BCD conversion
    bin_to_bcd_inst: bin_to_bcd
        port map (
            bin_in => SW,
            bcd_out => bcd_out
        );

    -- 7-segment display decoders
    bcd_to_7seg_inst1: bcd_to_7seg
        port map (
            BCD => bcd_out(7 downto 4),
            Seg => HEX1
        );

    bcd_to_7seg_inst2: bcd_to_7seg
        port map (
            BCD => bcd_out(3 downto 0),
            Seg => HEX0
        );
end Behavioral;