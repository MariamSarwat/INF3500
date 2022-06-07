----------------------------------------------------------------------------------
-- TP2
-- Revision: 0.01 - File Created
-- Date: 02/08/2019 11:57:15 AM 
-- Titre: top - structurale
-- Auters: Mariam Sarwat (1928777) et Anastasiya Basanets (1933929)
-- Description: Fichier top qui permet de faire l'implementation de notre machine 
-- d'états.
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Declaration des ports en entree et en sortie du top

entity top is
    port (
        CLK100MHZ : in STD_LOGIC;
        resetTop : in STD_LOGIC;
        entreeTop : in std_logic_vector (15 downto 0);
        sortieTop : out std_logic_vector(15 downto 0)
     );
    
end top;

architecture structurale of top is

--Creation des components pour les 6 fonctions de compression

component machine_etat 
	port (
	    reset, CLK : in STD_LOGIC;         
        entree : in std_logic_vector(31 downto 0);
        sortie : out std_logic_vector(255 downto 0);
        sortie_valid : out std_logic
        );
end component;

--Declaration des signaux d'entree et de sortie utiliser pour faire la liasion entre les fonctions
signal T1: std_logic_vector(31 downto 0);
signal T2: std_logic_vector(255 downto 0);
signal NET1: STD_LOGIC;


begin
	-- Conversion 16 bits (A) en 32 bits (T6)
	T1(15 downto 0) <= entreeTop;

	--Instantiation des 6 modules
 	UUT0: machine_etat port map(reset => resetTop, CLK => CLK100MHZ, entree => T1, sortie => T2, sortie_valid => NET1);
	
	-- Conversion32 bits (T7) en 16 bits (F)
	sortieTop <= T2(15 downto 0);
                                                                
end structurale;
