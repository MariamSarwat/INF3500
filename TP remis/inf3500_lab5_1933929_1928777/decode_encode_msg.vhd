----------------------------------------------------------------------------------
-- TP5
-- Revision: 0.01 - File Created
-- Date: 03/29/2019 12:51:14 PM
-- Titre: decode_encode_msg - arch1
-- Auters: Mariam Sarwat (1928777) et Anastasiya Basanets (1933929)
-- Description: 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
    
entity decode_encode_msg is
  Port (
          clk             : in    std_logic;
          rst             : in    std_logic;
    
          sha256_din_en   : out    std_logic; --quand s'en servir
          sha256_din      : out    std_logic_vector(15 downto 0);
    
          sha256_dout     : in   std_logic_vector(15 downto 0);
          sha256_dout_val : in   std_logic; 
          
          -- UART
         tx_pdata : out std_logic_vector(7 downto 0);
         tx_send_data : out std_logic;
         tx_busy : in std_logic;

         -- RX pins
         rx_pdata  : in std_logic_vector(7 downto 0);
         rx_pdata_valid   : in std_logic );
end decode_encode_msg;

architecture arch1 of decode_encode_msg is

    type type_etat is (INIT, Etat1, Etat2, Etat3,Etat4,Etat5,Etat6,Etat7,Etat8,Etat9,Etat10);
    signal etat: type_etat := INIT;
    signal Data : std_logic_vector (15 downto 0);
    
begin
     
    process (clk, rst) is
        begin
        
            if( rst= '1') then
                etat <=INIT;
                
            elsif(rising_edge(clk)) then
                case etat is
                    when INIT =>
                        Data <= (others => '0');
                        sha256_din_en <= '0';
                        sha256_din <= (others =>'0');
                        tx_pdata <= (others => '0');
                        tx_send_data <= '0';
                        etat <= Etat1;
                     
                    when Etat1 =>
                        if rx_pdata_valid = '1' then
                            if rx_pdata = x"43" then
                                etat<= Etat2;
                            end if;
                        end if;
                        
                    when Etat2=>
                        if rx_pdata_valid = '1' then
                           if rx_pdata = x"45" then
                               etat<= Etat3;
                           else
                               etat<= Etat1;
                           end if;
                        end if;
                       
                    when Etat3 =>
                        if rx_pdata_valid = '1' then
                            Data(15 downto 8)<= rx_pdata;
                            etat <= Etat4;
                        end if;
                        
                    when Etat4 =>
                        if rx_pdata_valid = '1' then
                            Data(7 downto 0)<= rx_pdata;
                            etat <= Etat5;
                        end if;
                    
                    when Etat5 =>
                        sha256_din <= Data;
                        sha256_din_en <= '1';
                        etat <= Etat6;
                        
                    when Etat6 =>
                        if sha256_dout_val = '1' then
                            Data <= sha256_dout;
                            etat <= Etat7;
                        end if;       
                        
                    when Etat7 =>
                        if tx_busy = '0' then
                            tx_pdata <= x"43";
                            tx_send_data <= '1';
                            etat <= Etat8;
                        else 
                            tx_send_data <='0';
                        end if;     
                        
                    when Etat8 =>
                        if tx_busy = '0' then
                            tx_pdata <= x"45";
                            tx_send_data <= '1';
                            etat <= Etat9;
                        else 
                            tx_send_data <='0';
                        end if;  
                        
                    when Etat9 =>
                        if tx_busy = '0' then
                            tx_pdata <= Data(15 downto 8);
                            tx_send_data <= '1';
                            etat <= Etat10;
                        else 
                            tx_send_data <='0';
                        end if;    
                    
                    when Etat10 =>
                        if tx_busy = '0' then
                            tx_pdata <= Data(7 downto 0);
                            tx_send_data <= '1';
                            etat <= Etat1;
                        else 
                            tx_send_data <='0';
                        end if;                  
            end case;
        end if;
    end process;
end arch1;