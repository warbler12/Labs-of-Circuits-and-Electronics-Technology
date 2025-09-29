library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity running_word is
    Port ( clk : in  STD_LOGIC;
           Reset : in  STD_LOGIC;
           Enable : in  STD_LOGIC;
           SW : in STD_LOGIC_VECTOR(14 downto 0);
           clk_1Hz : buffer STD_LOGIC;
           M0, M1, M2, M3, M4, M5, M6, M7: buffer STD_LOGIC_VECTOR(2 DOWNTO 0);
           shift_reg: buffer STD_LOGIC_VECTOR(23 downto 0);
           pos: buffer STD_LOGIC_VECTOR(2 DOWNTO 0);
           HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7: out STD_LOGIC_VECTOR(6 downto 0));
end running_word;

architecture Behavioral of running_word is
    component seven_segment_decoder
        Port ( bin : in  STD_LOGIC_VECTOR(2 downto 0);
               seg : out  STD_LOGIC_VECTOR(6 downto 0));
    end component;
    
    component clock_divider
    Port ( clk_50MHz : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           clk_1Hz : out  STD_LOGIC);
    end component;
    
    COMPONENT eight_to_one_mux
        PORT (C, S, T, U, V, W, X, Y, Z : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
              M : OUT STD_LOGIC_VECTOR(2 DOWNTO 0));
    END COMPONENT;
   
begin
    -- 时钟分频器实例
    CLK_DIV: clock_divider port map (clk, Reset, clk_1Hz);

    -- 更新位置
    process(Reset, Enable, clk_1Hz)
    begin
        if reset = '1' then
            pos <= "000";
        elsif Enable = '1' and rising_edge(clk_1Hz) then
            if pos = "000" then
                pos <= "111";  -- 重置位置
            else
                pos <= std_logic_vector(unsigned(pos) - 1);
            end if;
        end if;
    end process;
    
	shift_reg <= "111111111" & SW(14 DOWNTO 0);
    -- 对应位置
    MUX0: eight_to_one_mux PORT MAP (pos, shift_reg(2 DOWNTO 0), shift_reg(5 DOWNTO 3),shift_reg(8 DOWNTO 6), shift_reg(11 DOWNTO 9), 
									 shift_reg(14 DOWNTO 12), shift_reg(17 DOWNTO 15), shift_reg(20 DOWNTO 18), shift_reg(23 DOWNTO 21), M0);
    MUX1: eight_to_one_mux PORT MAP (pos, shift_reg(5 DOWNTO 3),shift_reg(8 DOWNTO 6), shift_reg(11 DOWNTO 9), shift_reg(14 DOWNTO 12), 
									 shift_reg(17 DOWNTO 15), shift_reg(20 DOWNTO 18), shift_reg(23 DOWNTO 21),shift_reg(2 DOWNTO 0),  M1);
    MUX2: eight_to_one_mux PORT MAP (pos, shift_reg(8 DOWNTO 6), shift_reg(11 DOWNTO 9), shift_reg(14 DOWNTO 12), shift_reg(17 DOWNTO 15), 
									 shift_reg(20 DOWNTO 18), shift_reg(23 DOWNTO 21), shift_reg(2 DOWNTO 0), shift_reg(5 DOWNTO 3),M2);
    MUX3: eight_to_one_mux PORT MAP (pos, shift_reg(11 DOWNTO 9), shift_reg(14 DOWNTO 12), shift_reg(17 DOWNTO 15), shift_reg(20 DOWNTO 18), 
									 shift_reg(23 DOWNTO 21), shift_reg(2 DOWNTO 0), shift_reg(5 DOWNTO 3), shift_reg(8 DOWNTO 6), M3);
    MUX4: eight_to_one_mux PORT MAP (pos, shift_reg(14 DOWNTO 12), shift_reg(17 DOWNTO 15), shift_reg(20 DOWNTO 18), shift_reg(23 DOWNTO 21), 
									 shift_reg(2 DOWNTO 0), shift_reg(5 DOWNTO 3),shift_reg(8 DOWNTO 6), shift_reg(11 DOWNTO 9), M4);									 
    MUX5: eight_to_one_mux PORT MAP (pos, shift_reg(17 DOWNTO 15), shift_reg(20 DOWNTO 18), shift_reg(23 DOWNTO 21), shift_reg(2 DOWNTO 0), 
									 shift_reg(5 DOWNTO 3), shift_reg(8 DOWNTO 6), shift_reg(11 DOWNTO 9), shift_reg(14 DOWNTO 12), M5);
    MUX6: eight_to_one_mux PORT MAP (pos, shift_reg(20 DOWNTO 18), shift_reg(23 DOWNTO 21), shift_reg(2 DOWNTO 0), shift_reg(5 DOWNTO 3), 
									 shift_reg(8 DOWNTO 6), shift_reg(11 DOWNTO 9), shift_reg(14 DOWNTO 12), shift_reg(17 DOWNTO 15), M6);									 
    MUX7: eight_to_one_mux PORT MAP (pos, shift_reg(23 DOWNTO 21), shift_reg(2 DOWNTO 0), shift_reg(5 DOWNTO 3), shift_reg(8 DOWNTO 6), 
									 shift_reg(11 DOWNTO 9), shift_reg(14 DOWNTO 12), shift_reg(17 DOWNTO 15), shift_reg(20 DOWNTO 18), M7);	
									 								 								 									
    --解码输出
	CHAR0: seven_segment_decoder PORT MAP (M0, HEX0);
    CHAR1: seven_segment_decoder PORT MAP (M1, HEX1);
    CHAR2: seven_segment_decoder PORT MAP (M2, HEX2);
    CHAR3: seven_segment_decoder PORT MAP (M3, HEX3);
    CHAR4: seven_segment_decoder PORT MAP (M4, HEX4);
    CHAR5: seven_segment_decoder PORT MAP (M5, HEX5);
    CHAR6: seven_segment_decoder PORT MAP (M6, HEX6);
    CHAR7: seven_segment_decoder PORT MAP (M7, HEX7);
end Behavioral;