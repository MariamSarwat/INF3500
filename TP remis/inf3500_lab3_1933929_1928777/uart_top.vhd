----------------------------------------------------------------------------------
-- TP3
-- Revision: 0.01 - File Created
-- Date: 03/14/2019 04:42:50 PM
-- Titre: uart_top - Behavioral
-- Auters: Mariam Sarwat (1928777) et Anastasiya Basanets (1933929)
-- Description: Fichier qui implémente le diagramme d'états d'un UART de réception.
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
library work;
use work.common_pkg.all;
use ieee.numeric_std.all;

entity uart_top is
    Port ( 
        clk: in std_logic;
        --tx_sdata : out std_logic_vector(7 downto 0); 
        rx_sdata: in std_logic; -- donnee
        rx_frame_err : out std_logic; -- pas de stop bit -> allumer del
        rx_parity_err: out std_logic; -- parite pair
        
        display_cathods: out std_logic_vector(6 downto 0);
        display_enable : out std_logic_vector(7 downto 0)
    );
end uart_top;

architecture Behavioral of uart_top is

type type_etat is (INIT, Etat1, Etat2, Etat3, Etat4);
signal etat : type_etat := INIT;

signal reset: std_logic := '1';
constant BAUD_RATE : integer := 57600;
constant FREQUENCE : integer := 100_000_000;
constant clk_div : integer := FREQUENCE / BAUD_RATE; 
signal clk_counter : integer := 0;
signal index : integer range 0 to 7 := 0;  -- 8 Bits Total
signal sortie_message : vector8(7 downto 0) := (others => (others => '0'));
signal erreur_trame, erreur_parite, r_data : std_logic := '0';
signal clk_reg_out : std_logic;
signal par : std_logic;

begin

    UUT0: entity work.reg_clken generic map (CLK_DIV => clk_div)
    port map (clk => clk, rst => reset, clken_in => '1', clken_out => clk_reg_out);
                  
    UUT1 : entity work.display generic map(CLK_FREQUENCY => FREQUENCE, DISPLAY_NUM => 8, DISPLAY_FORMAT => "CHAR")       
    port map (clk => clk, message => sortie_message, cathods => display_cathods, enable => display_enable); 
    
    process(clk) is
        begin
            if (rising_edge(clk)) then
               
                r_data <= rx_sdata;
                case etat is
             
                    when INIT => -- initialisation variables et recherche du start bit
                        clk_counter <= 0;
                        index <= 0;
                        
                        if r_data = '0' then       -- Start bit detected  
                            etat <= Etat1;
                        else
                            etat <= INIT;
                        end if;
                        reset <= '1';

                    when Etat1 => --echantillonage au milieu de chaque bit 
                        if clk_counter = clk_div /2 then
                            reset <= '0';
                            clk_counter <= 0; -- reset counter since we found the middle
                            etat <= Etat2;
                        else
                            clk_counter <= clk_counter + 1;
                            etat <= Etat1;
                        end if;

                    when Etat2 => -- reception du message 8 bit';
                        if clk_reg_out = '1' then
                            sortie_message(0)(index) <= r_data;
                        -- Check if we have sent out all bits
                            if index < 7 then
                                index <= index + 1;
                                etat <= Etat2;
                            else
                                etat <= Etat3;
                            end if;
                        end if;
             
                    when Etat3 => -- verification du bit de parite pour s'assurer d'une parite impaire
                        if clk_reg_out = '1' then
                            par <= (((((((sortie_message(0)(0) xor sortie_message(0)(1)) xor sortie_message(0)(2)) xor sortie_message(0)(3)) xor sortie_message(0)(4))xor sortie_message(0)(5)) xor sortie_message(0)(6)) xor sortie_message(0)(7));
                           --check_parity using xor message and par signal with for loop
                            if (par = r_data) then
                                erreur_parite <= '0';
                            else
                                erreur_parite <= '1';
                            end if;
                            etat <= Etat4;
                        end if;
                        
                    when Etat4 => -- recherche du stop bit sinon erreur
                        if clk_reg_out = '1' then
                            if (r_data = '0') then
                                erreur_trame <= '1';
                            end if;
                            etat <= INIT;
                        end if;
                   
                    when others => 
                        etat <= INIT;
                        
                        
                  end case;
            end if;
    end process;   
    rx_frame_err <= erreur_trame ;
    rx_parity_err <= erreur_parite; 
end Behavioral;
