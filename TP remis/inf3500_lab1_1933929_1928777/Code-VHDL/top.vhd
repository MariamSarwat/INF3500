----------------------------------------------------------------------------------
-- TP1
-- Revision: 0.01 - File Created
-- Date: 02/07/2019 04:01:07 PM
-- Titre: top - structurale
-- Auters: Mariam Sarwat (1928777) et Anastasiya Basanets (1933929)
-- Description: Fichier top qui relie les fonctions de compressions afin de faire
-- l'implementation.
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Declaration des ports en entree et en sortie du top

entity top is
    port (
        A : in std_logic_vector (15 downto 0);
        F : out std_logic_vector(15 downto 0)
    );
    
end top;

architecture structurale of top is

--Creation des components pour les 6 fonctions de compression

component Fonction_ch 
	port (x, y, z :in std_logic_vector (31 downto 0); 
	      ch: out std_logic_vector (31 downto 0));
end component;

component Fonction_maj 
	port (x, y, z :in std_logic_vector (31 downto 0) ; 
	      maj: out std_logic_vector (31 downto 0));
end component;

component Sigma_lower_0 
	port (x :in std_logic_vector (31 downto 0); 
	      sig_low_0: out std_logic_vector (31 downto 0));
end component;

component Sigma_lower_1 
	port (x :in std_logic_vector (31 downto 0); 
	      sig_low_1: out std_logic_vector (31 downto 0));
end component;

component Sigma_upper_0 
	port (x :in std_logic_vector (31 downto 0); 
	      sig_upp_0: out std_logic_vector (31 downto 0));
end component;

component Sigma_upper_1 
	port (x :in std_logic_vector (31 downto 0); 
	      sig_upp_1: out std_logic_vector (31 downto 0));
end component;


--Declaration des signaux d'entree et de sortie utiliser pour faire la liasion entre les fonctions
signal T1, T2, T3, T4, T5, T6, T7: std_logic_vector(31 downto 0);


begin
	-- Conversion 16 bits (A) en 32 bits (T6)
	T6(15 downto 0) <= A;

	--Instantiation des 6 modules
 	U1: Sigma_lower_1 port map(x_1 => T6, sig_low_1 => T1);
 	U2: Sigma_lower_0 port map (x => T1, sig_low_0 => T2);
	U3: Sigma_upper_1 port map (x=> T2, sig_upp_1 => T3);
 	U4: Sigma_upper_0 port map (x=> T3, sig_upp_0 => T4);
 	U5: Fonction_maj port map (x=> T4,y=> T4,z=> T4,maj => T5);
 	U6: Fonction_ch port map (x=> T5, y=> T5, z=> T5, ch => T7);
	
	-- Conversion 32 bits (T7) en 16 bits (F)
	F <= T7(15 downto 0);

end structurale;
