----------------------------------------------------------------------------------
-- TP2
-- Revision: 0.01 - File Created
-- Date: 02/08/2019 11:57:15 AM 
-- Titre: Fonction_ch - Behavioral
-- Auters: Mariam Sarwat (1928777) et Anastasiya Basanets (1933929)
-- Description: Implementation de la fonction de compression ch(x,y,z)
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


-- Declaration des ports en entree et en sortie de la fonction ch(x,y,z)

entity Fonction_ch is
	port (x, y, z : in std_logic_vector(31 downto 0);
          ch : out std_logic_vector(31 downto 0));
end Fonction_ch;

architecture Behavioral of Fonction_ch is

begin
	ch <= (x and y) xor ((not x) and z);
end Behavioral;
