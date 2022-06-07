----------------------------------------------------------------------------------
-- TP4
-- Revision: 0.01 - File Created
-- Date: 03/29/2019 12:51:14 PM
-- Titre: sha256 - behavioral
-- Auters: Mariam Sarwat (1928777) et Anastasiya Basanets (1933929)
-- Description: 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

library work;
use work.functions_sha256_pkg.all;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity sha256 is
  Port (
          clk             : in    std_logic;
          rst             : in    std_logic;
    
          sha256_din_en   : in    std_logic; --quand s'en servir
          sha256_din      : in    std_logic_vector(511 downto 0);
    
          sha256_dout     : out   std_logic_vector(255 downto 0);
          sha256_dout_val : out   std_logic );
end sha256;

architecture arch1 of sha256 is

type type_etat is (INIT, Etat1, Etat2, Etat3, Etat4, Etat5, Etat6, Etat7);
signal etat : type_etat := INIT;

signal H0, H1, H2, H3, H4, H5, H6, H7 : unsigned (31 downto 0);
signal H0_prev, H1_prev, H2_prev, H3_prev, H4_prev, H5_prev, H6_prev, H7_prev : unsigned (31 downto 0);
signal a, b, c, d, e, f, g, h, T1, T2 : unsigned(31 downto 0);
signal counter : integer range 0 to 63;

begin

--boucle infinie
    process(clk, rst) is
    variable W  : vector32u_t(0 to 63);
    variable sortieTemp : unsigned(255 downto 0);
    variable entree : std_logic_vector(31 downto 0);
   
    
    begin
        if (rst = '1' or etat = INIT) then
            H0_prev <= H_INI(0);
            H1_prev <= H_INI(1);
            H2_prev <= H_INI(2);
            H3_prev <= H_INI(3);
            H4_prev <= H_INI(4);
            H5_prev <= H_INI(5);
            H6_prev <= H_INI(6);
            H7_prev <= H_INI(7);
            W := (others =>  x"00000000");
            etat <= Etat1;
       
        elsif (rising_edge(clk)) then
            case etat is   
                when Etat1 =>
                    if (sha256_din_en = '1') then
                        a <= H0_prev;
                        b <= H1_prev;
                        c <= H2_prev;
                        d <= H3_prev;
                        e <= H4_prev;
                        f <= H5_prev;
                        g <= H6_prev;
                        h <= H7_prev;
                        etat <= Etat2;
                        sha256_dout_val <= '0';
                        counter <= 0;
                    end if;
                    
                when Etat2 =>
                    if(counter < 16) then
                        W(counter) := unsigned(sha256_din(511 - 32*counter downto 512 - 32*(counter+1)));
                    else
                        W(counter) := sigma_lower_1(W(counter - 2)) + W(counter - 7) + sigma_lower_0(W(counter - 15)) + W(counter - 16) ;
                    end if;
                    etat <= Etat3;
                    
                when Etat3 =>
                   T1 <= h + sigma_upper_1(e) + ch(e,f,g) + K(counter) + W(counter);
                   T2 <= sigma_upper_0(a)+ maj(a,b,c);
                   etat <= Etat4;
                
                when Etat4 =>
                    h <= g;
                    g <= f;
                    f <= e;
                    e <= d + T1;
                    d <= c;
                    c <= b;
                    b <= a;
                    a <= T1 + T2;
                    counter <= counter + 1;
                    
                    if(counter < 63) then
                        etat <= Etat2;
                    else 
                        etat <= Etat5;
                        counter <= 0;
                    
                    end if;
                        
                when Etat5 =>
                   H0 <= a + H0_prev;
                   H1 <= b + H1_prev;
                   H2 <= c + H2_prev;
                   H3 <= d + H3_prev;
                   H4 <= e + H4_prev;
                   H5 <= f + H5_prev;
                   H6 <= g + H6_prev;
                   H7 <= h + H7_prev;
                   etat <= Etat6;
                    
                when Etat6 =>
                    H0_prev <= H0;
                    H1_prev <= H1;
                    H2_prev <= H2;
                    H3_prev <= H3;
                    H4_prev <= H4;
                    H5_prev <= H5;
                    H6_prev <= H6;
                    H7_prev <= H7;
                    etat <= Etat7;
                   
                when Etat7 =>
                   sortieTemp := H0_prev & H1_prev & H2_prev & H3_prev & H4_prev & H5_prev & H6_prev & H7_prev;
                   sha256_dout_val <= '1';
                   sha256_dout <= std_logic_vector(sortieTemp);
                   etat <= INIT;
                   
                when others =>
                    etat <= INIT;
           
            end case;
         end if;
    end process;


end arch1;
