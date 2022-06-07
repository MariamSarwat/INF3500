----------------------------------------------------------------------------------
-- TP1
-- Revision: 0.01 - File Created
-- Date: 01/25/2019 02:57:10 PM
-- Titre: Sigma_lower_0 - Behavioral
-- Auters: Mariam Sarwat (1928777) et Anastasiya Basanets (1933929)
-- Description: Implementation de la fonction de compression sigma_lower_0(
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

-- Declaration des ports en entree et en sortie de la fonction Sigma_lower_0(x)

entity Sigma_lower_0 is
	port (x : in std_logic_vector(31 downto 0);
          sig_low_0 : out std_logic_vector(31 downto 0));
end Sigma_lower_0;

architecture Behavioral of Sigma_lower_0 is

begin
	
	sig_low_0 <= std_logic_vector(rotate_right(unsigned(x),7) xor rotate_right(unsigned(x),18) xor shift_right(unsigned(x),3));

end Behavioral;
