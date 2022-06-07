----------------------------------------------------------------------------------
-- TP1
-- Revision: 0.01 - File Created
-- Date: 01/25/2019 02:40:46 PM
-- Titre: Sigma_upper_1 - Behavioral
-- Auters: Mariam Sarwat (1928777) et Anastasiya Basanets (1933929)
-- Description: Implementation de la fonction de compression sigma_upper_1(x) 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

-- Declaration des ports en entree et en sortie de la fonction Sigma_upper_1(x)

entity Sigma_upper_1 is
	port (x : in std_logic_vector(31 downto 0);
          sig_upp_1 : out std_logic_vector(31 downto 0));
end Sigma_upper_1;

architecture Behavioral of Sigma_upper_1 is

begin

	sig_upp_1 <= std_logic_vector(rotate_right(unsigned(x),6) xor rotate_right(unsigned(x),11) xor rotate_right(unsigned(x),25));

end Behavioral;
