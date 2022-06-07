----------------------------------------------------------------------------------
-- TP1
-- Revision: 0.01 - File Created
-- Date: 02/01/2019 11:57:15 AM 
-- Titre: banc_essai - Behavioral
-- Auters: Mariam Sarwat (1928777) et Anastasiya Basanets (1933929)
-- Description: Implementation du banc d'essai pour les fonctions de compressions  
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity banc_essai is
end banc_essai;

architecture Behavioral of banc_essai is


--Creation des components pour les 6 fonctions de compression

component Fonction_ch 
	port (x, y, z :in std_logic_vector (31 downto 0); 
	      ch: out std_logic_vector (31 downto 0));
end component;

component Fonction_maj
	port (x, y, z :in std_logic_vector (31 downto 0); 
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


--Declaration des signaux d'entree et de sortie pour le banc d'essai
signal x_1: std_logic_vector (31 downto 0):= (others => '0');
signal y_1: std_logic_vector (31 downto 0):= (others => '0');
signal z_1: std_logic_vector (31 downto 0):= (others => '0');
signal ch, maj, sig_low_0, sig_low_1, sig_upp_0, sig_upp_1 : std_logic_vector (31 downto 0);


begin

	--Instantiation des 6 modules
	UUT0: Fonction_ch port map(x_1, y_1, z_1, ch);
	UUT1: Fonction_maj port map (x_1,y_1,z_1,maj);
	UUT2: Sigma_lower_0 port map (x_1,sig_low_0);
	UUT3: Sigma_lower_1 port map (x_1,sig_low_1);
	UUT4: Sigma_upper_0 port map (x_1,sig_upp_0);
	UUT5: Sigma_upper_1 port map (x_1,sig_upp_1);
    
	process
	begin
		-- for loop qui s'execute 32 fois
		for k in 0 to 31 loop 
			
			-- valeur des entrees x, y et z
			x_1 <= std_logic_vector (to_unsigned(k,x_1'length));
			y_1 <= std_logic_vector (to_unsigned(k,y_1'length));
			z_1 <= std_logic_vector (to_unsigned(k,z_1'length));
		
		wait for 10ns;
        end loop;
         
        report "simulation terminée" severity failure;
         
	end process;
    
end Behavioral;
