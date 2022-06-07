----------------------------------------------------------------------------------
-- TP3
-- Revision: 0.01 - File Created
-- Date: 03/14/2019 02:31:59 PM
-- Titre: top_clock_divider - behavioral
-- Auters: Mariam Sarwat (1928777) et Anastasiya Basanets (1933929)
-- Description: Fichier qui implemente la fonction clock_divider configuré pour une
-- fréquence de 1Hz et qui utilise le signal pour clignoter la DEL.
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top_clock_divider is
port(
    clk_in, rst, clken  : in std_logic;
    clk_out : out std_logic
);
end top_clock_divider;

architecture Behavioral of top_clock_divider is

component clock_divider
    generic ( CLK_DIV: integer );
    port ( clk_in, rst, clken : in std_logic; clk_out : out std_logic );
end component;

begin
UUT: clock_divider  generic map (CLK_DIV => 100000000 )
                    port map (clk_in => clk_in, clk_out => clk_out, rst => rst, clken => clken );

end Behavioral;
