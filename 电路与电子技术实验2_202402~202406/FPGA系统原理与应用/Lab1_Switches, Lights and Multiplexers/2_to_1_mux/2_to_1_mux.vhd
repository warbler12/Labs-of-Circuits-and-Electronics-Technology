library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity two_to_one_mux is
    Port ( s : in STD_LOGIC;  -- Select input
           X : in STD_LOGIC_VECTOR (7 downto 0);  -- 8-bit input X
           Y : in STD_LOGIC_VECTOR (7 downto 0);  -- 8-bit input Y
           M : out STD_LOGIC_VECTOR (7 downto 0)  -- 8-bit output M
         );
end two_to_one_mux;

architecture Behavioral of two_to_one_mux is
begin
    -- 8-bit wide 2-to-1 multiplexer
    M(0) <= (NOT s AND X(0)) OR (s AND Y(0));
    M(1) <= (NOT s AND X(1)) OR (s AND Y(1));
    M(2) <= (NOT s AND X(2)) OR (s AND Y(2));
    M(3) <= (NOT s AND X(3)) OR (s AND Y(3));
    M(4) <= (NOT s AND X(4)) OR (s AND Y(4));
    M(5) <= (NOT s AND X(5)) OR (s AND Y(5));
    M(6) <= (NOT s AND X(6)) OR (s AND Y(6));
    M(7) <= (NOT s AND X(7)) OR (s AND Y(7));
end Behavioral;