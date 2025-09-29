library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity sixteen_bit_synchronous_counter is
    Port ( Clock : in  STD_LOGIC;
           Enable : in  STD_LOGIC;
           Reset : in  STD_LOGIC;
           Count : buffer  STD_LOGIC_VECTOR(15 downto 0);
           HEX0,HEX1,HEX2,HEX3: out STD_LOGIC_VECTOR(6 downto 0));
end sixteen_bit_synchronous_counter;

architecture Behavioral of sixteen_bit_synchronous_counter is
    signal count_int : unsigned(15 downto 0) := (others => '0');
    component seven_segment_decoder
        Port ( bin : in  STD_LOGIC_VECTOR(3 downto 0);
               seg : out  STD_LOGIC_VECTOR(6 downto 0));
    end component;
begin
    process(Clock, Reset)
    begin
        if Reset = '1' then
            count_int <= (others => '0');
        elsif rising_edge(Clock) then
            if Enable = '1' then
                count_int <= count_int + 1;
            end if;
        end if;
    end process;

    Count <= std_logic_vector(count_int);
    
    M_HEX3: seven_segment_decoder port map (std_logic_vector(count_int(15 downto 12)), HEX3);
    M_HEX2: seven_segment_decoder port map (std_logic_vector(count_int(11 downto 8)), HEX2);
    M_HEX1: seven_segment_decoder port map (std_logic_vector(count_int(7 downto 4)), HEX1);
    M_HEX0: seven_segment_decoder port map (std_logic_vector(count_int(3 downto 0)), HEX0);
end Behavioral;