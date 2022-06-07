----------------------------------------------------------------------------------
-- TP1
-- Revision: 0.01 - File Created
-- Date: 01/25/2019 02:38:22 PM
-- Titre: Fonction_maj - Behavioral
-- Auters: Mariam Sarwat (1928777) et Anastasiya Basanets (1933929)
-- Description: Implementation de la fonction de compression maj(x,y,z)
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Declaration des ports en entree et en sortie de la fonction maj(x,y,z)

entity Fonction_maj is
    Port ( x : in std_logic_vector(31 downto 0);
           y : in std_logic_vector(31 downto 0);
           z : in std_logic_vector(31 downto 0);
           maj : out std_logic_vector(31 downto 0));
end Fonction_maj;

architecture Behavioral of Fonction_maj is

begin
maj <= (x and y) xor (x and z) xor (y and z);

end Behavioral;
