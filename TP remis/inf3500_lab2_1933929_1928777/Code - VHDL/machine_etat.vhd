----------------------------------------------------------------------------------
-- TP2
-- Revision: 0.01 - File Created
-- Date: 02/08/2019 02:54:40 PM
-- Titre: machine_etat - arch
-- Auters: Mariam Sarwat (1928777) et Anastasiya Basanets (1933929)
-- Description: Machine d'états boucle principal de l’algorithme SHA-256.
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity machine_etat is
    port(
        reset, CLK : in STD_LOGIC;         
        entree : in std_logic_vector(31 downto 0);
        sortie : out std_logic_vector(255 downto 0);
        sortie_valid : out std_logic
    );
   
end machine_etat;

architecture arch of machine_etat is

component Fonction_ch 
	port (x, y, z :in std_logic_vector (31 downto 0); 
	      ch: out std_logic_vector (31 downto 0));
end component;

component Fonction_maj
	port (x, y, z :in std_logic_vector (31 downto 0); 
	      maj: out std_logic_vector (31 downto 0));
end component;

component Sigma_upper_0 
	port (x :in std_logic_vector (31 downto 0); 
	      sig_upp_0: out std_logic_vector (31 downto 0));
end component;

component Sigma_upper_1 
	port (x :in std_logic_vector (31 downto 0); 
	      sig_upp_1: out std_logic_vector (31 downto 0));
end component;


type type_etat is (INIT, Etat1, Etat2, Etat3, Etat4, Etat5, Etat6);
signal etat : type_etat := INIT;

constant K : std_logic_vector(31 downto 0) := X"428a2f98";

signal H0, H1, H2, H3, H4, H5, H6, H7 : std_logic_vector (31 downto 0);
signal H0_prev, H1_prev, H2_prev, H3_prev, H4_prev, H5_prev, H6_prev, H7_prev : std_logic_vector (31 downto 0);
signal W, a, b, c, d, e, f, g, h, T1, T2, ch, maj, sig_upp_0, sig_upp_1: std_logic_vector (31 downto 0);

--signal sortie_valid : integer;


begin
    UUT0: Fonction_ch port map(e, f, g, ch);
	UUT1: Fonction_maj port map (a, b, c, maj);
	UUT4: Sigma_upper_0 port map (a, sig_upp_0);
	UUT5: Sigma_upper_1 port map (e, sig_upp_1);
	
    process(CLK, reset) is
    
    variable W : std_logic_vector (31 downto 0);
    variable sortie_temp : std_logic_vector (255 downto 0);
    
    begin
         if (reset = '0') then
             etat <= INIT;
         
         elsif (rising_edge(CLK) and CLK'event) then
            case etat is
                when INIT =>
                    H0_prev <= x"6a09e667";
                    H1_prev <= x"bb67ae85";
                    H2_prev <= x"3c6ef372";
                    H3_prev <= x"a54ff53a";
                    H4_prev <= x"510e527f";
                    H5_prev <= x"9b05688c";
                    H6_prev <= x"1f83d9ab";
                    H7_prev <= x"5be0cd19";
                    W := x"00000000";
                    etat <= Etat1;
                
                when Etat1 =>
                    if (W/= entree) then
                        a <= H0_prev;
                        b <= H1_prev;
                        c <= H2_prev;
                        d <= H3_prev;
                        e <= H4_prev;
                        f <= H5_prev;
                        g <= H6_prev;
                        h <= H7_prev;
                        W := entree;
                        sortie_valid <= '0';
                        etat <= Etat2;
                    end if;
                    
                when Etat2 =>
                    T1 <= std_logic_vector(unsigned(h) + unsigned(ch) + unsigned(sig_upp_1) + unsigned( K) +unsigned( W));
                    T2 <= std_logic_vector(unsigned(sig_upp_0) +  unsigned(maj));
                    h <= g;
                    g <= f;
                    f <= e;
                    etat <= Etat3;
                
                when Etat3 =>
                    e <= std_logic_vector(unsigned(d) + unsigned(T1));
                    etat <= Etat4;
               
                when Etat4 =>
                    d <= c;
                    c <= b;
                    b <= a;
                    a <= std_logic_vector(unsigned(T1) + unsigned(T2));
                    etat <= Etat5;
                    
                when Etat5 =>
                    H0 <= std_logic_vector(unsigned(a) + unsigned(H0_prev));
                    H1 <= std_logic_vector(unsigned(b) + unsigned(H1_prev));
                    H2 <= std_logic_vector(unsigned(c) + unsigned(H2_prev));
                    H3 <= std_logic_vector(unsigned(d) + unsigned(H3_prev));
                    H4 <= std_logic_vector(unsigned(e) + unsigned(H4_prev));
                    H5 <= std_logic_vector(unsigned(f) + unsigned(H5_prev));
                    H6 <= std_logic_vector(unsigned(g) + unsigned(H6_prev));
                    H7 <= std_logic_vector(unsigned(h) + unsigned(H7_prev));
                    etat <= Etat6;

                when Etat6 =>
                    sortie_valid <= '1';
                    sortie_temp := H0 & H1 & H2 & H3 & H4 & H5 & H6 & H7; -- concaténation des valeurs de H dans une sortie temporaire
                    sortie <= sortie_temp;
                    H0_prev <= H0;
                    H1_prev <= H1;
                    H2_prev <= H2;
                    H3_prev <= H3;
                    H4_prev <= H4;
                    H5_prev <= H5;
                    H6_prev <= H6;
                    H7_prev <= H7;
                    etat <= Etat1;  
            end case;
           
        end if;
    end process;
    
end arch;
