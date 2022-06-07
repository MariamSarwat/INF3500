----------------------------------------------------------------------------------
-- TP2
-- Revision: 0.01 - File Created
-- Date: 02/08/2019 11:57:15 AM 
-- Titre: banc_essai - Behavioral
-- Auters: Mariam Sarwat (1928777) et Anastasiya Basanets (1933929)
-- Description: Implementation du banc d'essai pour la boucle principale de 
-- l'algorithme SHA-256 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity banc_essai is
end banc_essai;

architecture Behavioral of banc_essai is

--Creation d'un component pour la machine d'états

component machine_etat 
	port (
	    reset, CLK : in STD_LOGIC;         
        entree : in std_logic_vector(31 downto 0);
        sortie : out std_logic_vector(255 downto 0);
        sortie_valid: out std_logic
        );
end component;

-- Valeurs d'entrées et de sorties utilisées comme référence
type vector32_t is array (integer range <>) of std_logic_vector(31 downto 0);

 constant entree_ref	: vector32_t(0 to 63) := (
      x"428a2f98", x"71374491", x"b5c0fbcf", x"e9b5dba5", x"3956c25b", x"59f111f1", x"923f82a4", x"ab1c5ed5",
      x"d807aa98", x"12835b01", x"243185be", x"550c7dc3", x"72be5d74", x"80deb1fe", x"9bdc06a7", x"c19bf174",
      x"e49b69c1", x"efbe4786", x"0fc19dc6", x"240ca1cc", x"2de92c6f", x"4a7484aa", x"5cb0a9dc", x"76f988da",
      x"983e5152", x"a831c66d", x"b00327c8", x"bf597fc7", x"c6e00bf3", x"d5a79147", x"06ca6351", x"14292967",
      x"27b70a85", x"2e1b2138", x"4d2c6dfc", x"53380d13", x"650a7354", x"766a0abb", x"81c2c92e", x"92722c85",
      x"a2bfe8a1", x"a81a664b", x"c24b8b70", x"c76c51a3", x"d192e819", x"d6990624", x"f40e3585", x"106aa070",
      x"19a4c116", x"1e376c08", x"2748774c", x"34b0bcb5", x"391c0cb3", x"4ed8aa4a", x"5b9cca4f", x"682e6ff3",
      x"748f82ee", x"78a5636f", x"84c87814", x"8cc70208", x"90befffa", x"a4506ceb", x"bef9a3f7", x"c67178f2");

type vector256_t is array (integer range <>) of std_logic_vector(255 downto 0);     
constant sortie_ref : vector256_t(0 to 63) := (
    x"a89c9e4c257194ecf7d6a1f7e1bee8ac2c6064b9ec13bb0bba8942377b64a6c4",
    x"2a021311ce0e33381d4836e3d9958aa33f74db6918741fc4a69cfd4235ede8fb",
    x"4d3eb3cbf8104649eb566a1bf6ddc18653f7431957e8fb2dbf111d06dc8ae63d",
    x"f49f7e1f454efa14e366b064e2342ba151448475abe03e4616fa18339b9c0343",
    x"63328e8639ee783328b5aa78c59adc054c9cc1bbfd24c2bbc2da5679b2961b76",
    x"65424da39d2106b962a422abee50867dc3cb0ef249c18476bfff1934757071ef",
    x"40deef190263545cffc5296450f4a9286b1afb4b0d8c936809c09daa356f8b23",
    x"cd8393264342437502287dc050b9d28cb2ab02f278a78eb3174d31123f3028cd",
    x"8566b14e10c5d69b456ac13552e2504c542b8c5f2b5291a58ff4bfc5567d59df",
    x"5793dcc7962c87e9563097d0984d1181c1eb79927f7e1e04bb47516ae67219a4",
    x"7ff10cc4edc064b0ec5d1fb9ee7da951afb7cc5e416997963ac56f6ea1b96b0e",
    x"a0ed8cf86db17174da1d8469dadac90a13743bedf12163f47c2f0704dc7eda7c",
    x"065d708e0e9efe6c47cef5ddb4f84d737133dd4404959fe16d506af858ade180",
    x"c66e8a6f14fc6efa566df449fcc743506f38f8fb75c97d2571e60ad9c5fe4c78",
    x"be881df3db6af9696b6a634353353799f4e0b26ee5027620e7af87fe37e45751",
    x"83a8aece99f3175c46d55cacbe9f9adcf183c3b9d9e3288eccb1fe1e1f93df4f",
    x"f14573561d9bc62ae0c874080574f78825a9f759cb66ec47a69526acec45dd6d",
    x"13476e7c0ee13980fe643a32e63d6b90282be6c2f110e3a071fc12f392db0419",
    x"b847eab02228a7fc0d4573b2e4a1a5c22a7be26d193cca62630cf69304d7170c",
    x"be751e94da7092ac2f6e1baef1e7197488c5ddf143b8accf7c49c0f567e40d9f",
    x"f4090da798e5b14009deae5a21553522e289e4d8cc7e8ac0c0026dc4e42dce94",
    x"2e7d5f528ceebee7a2c45f9a2b33e37cf17a4172af086f988c80f884a4303c58",
    x"ab8cba40bb6c1e392fb31e81cdf84316665db383a082b10a3b89681c30b134dc",
    x"982aabd366f8d879eb1f3cbafdab6197ab3859d006e0648ddc0c19266c3a9cf8",
    x"165b5750ff23844c52181533e8ca9e512aa08828b218be5de2ec7db34846b61e",
    x"49fcffd9157edb9c513b997f3ae2b3841ea6925bdcb9468595053c102b3333d1",
    x"2a780d325f7bdb7566ba751b8c1e4d03893b6225fb5fd8e071be8295c0386fe1",
    x"a70eba9a89f3e8a7c6365090f2d8c21e203a6738849b3b056d1e5b7531f6f276",
    x"19798b813102a341502a3937b90f12aeb64a055ca4d5a23df1b9967a9f154deb",
    x"c0a2d3e14a7c2ec2812cdc7809394be508df08205b1fa799968f38b790cee465",
    x"492209570b1f02a3cba90b3a8a66285d760173af63feafb9f1aee050275e1d1c",
    x"cf73d75a54410bfad6c80ddd560f33972ab6c87bda00236855ad9009190cfd6c",
    x"070fc50723b4e3542b0919d72cd741741bc8f47004b6ebe32fadb3716eba8d75",
    x"af297fe92ac4a85b4ebdfd2b57e05b4bf6bc5a4c207fe05334649f549e6840e6",
    x"8254a1c4d9ee28447982a586a69e5876c1a159fa173c3a9f54e47fa7d2cce03a",
    x"5b3714155c42ca085370cdca2020fdfceb255a20d8dd94996c20ba4627b15fe1",
    x"d149beb7b779de1dafb397d27391cbc6fbaeece5c402eeb944fe4edf93d21a27",
    x"9d1a97bb88c39cd4672d75ef234563985c81b873bfb1db9e09013d98d8d06906",
    x"994f7fe625de348feff112c38a72d987be2bcae91c339411c8b31936e1d1a69e",
    x"ad72f8f3bf2db47515cf47527a63ec4a4a4a56cfda5f5efae4e6ad47aa84bfd4",
    x"92ade80f6ca0ad68d4fcfbc79033339c055722a424a9b5c9bf460c418f6b6d1b",
    x"21e876afff4e9577419da92f65302f633ca02a6b2a00d86de3efc20a4eb1795c",
    x"50e5f84c21370c2640ec3ea6a6cdd892922777cd66a102d80df09a7732a13b66",
    x"fc508484721d047262234acce7ba173861bfd7f2f8c87aa574919d4f4091d5dd",
    x"78dbd36c6e6d88f6d4404f3e49dd6204fad268fa5a8852976d5a17f4b523732c",
    x"aa8d91e1e7495c6242add8341e1db1420fff3a0f555abb91c7e26a8b227d8b20",
    x"01b8904591d6ee4329f7349660cb8976ced05a976559f5a01d3d261cea5ff5ab",
    x"1c788d20938f7e88bbce22d98ac2be0c285deece342a503782971bbc079d1bc7",
    x"1a5a7562b0080ba84f5da1614690e0e5890a25975c883f05b6c16bf38a343783",
    x"0c8d6342ca62810aff65ad0995ee824663220b1ae592649c1349aaf840f5a376",
    x"3f8a8583d6efe44cc9c82e1395542f4fb0e9da0e48b46fb6f8dc0f94543f4e6e",
    x"0d69c2ac167a69cfa0b8125f5f1c5d626a6550b9f99e49c441907f4a4d1b5e02",
    x"b59540b723e42c7bb7327c2effd46fc1bc043d8764039a7d3b2ec90e8eabdd4c",
    x"1e76b231d9796d32db16a8a9b706ebefaf2b90322007d8049f32638bc9daa65a",
    x"f801dbd1f7f01f63b49015db921d949857696250cf336836bf3a3b8f690d09e5",
    x"5752705beff1fb34ac80353e46adaa73ac667a85269cca868e6da3c528474574",
    x"e09a492247446b8f9c723072f32ddfb16dbc40a9d303450bb50a6e4bb6b4e939",
    x"eea3cc2327deb4b1e3b69c018fa01023128c1d2140bf85b4880db3566bbf5784",
    x"0de80a14168280d40b9550b27356ac24c432c568534ba2d5c8cd390af3cd0ada",
    x"34b33685246a8ae82217d1867eebfcd65ae25f77177e683d1c18dbdfbc9a43e4",
    x"77d3f0c1591dc16d46825c6ea103ce5cc2dc071b7260c7b43397441cd8b31fc3",
    x"78e5b275d0f1b22e9fa01ddbe7862aca79217f4e353ccecfa5f80bd00c4a63df",
    x"b17d708149d764a37091d009872648a565023752ae5e4e1ddb34da9fb2426faf",
    x"dd1b9a8ffb54d524ba6934acf7b818ae886068761360856f899328bc8d774a4e");
     

--Declaration des signaux d'entree et de sortie pour le banc d'essai
signal entree: std_logic_vector (31 downto 0);
signal sortie : std_logic_vector (255 downto 0);
signal reset, CLK : std_logic := '0';
constant period : time := 10 ns;

begin
    
    CLK <= not CLK after period ;
    
    reset <= 
        '0' after 0 ns,     
        '1' after 5*period;   
    
	--Instantiation du module
	UUT0: machine_etat port map(reset, CLK, entree, sortie);
    
	process (CLK)
	variable compteur : integer := 1;
    variable k : integer := 0;
	begin
	   if(rising_edge(CLK)) then
	       if (k < 64) then 
	           if(compteur = 1) then --prendre une nouvelle entrée lorsque on dépasse 6 rising edge
	               entree <= entree_ref(k);
	           elsif (compteur = 6) then -- comparer la valeur de sortie de la machine d'états avec celle en référence et réinitialiser compteur
	               assert( sortie /= sortie_ref(k )) 
	                   report "erreur pour l'entree" & integer'image(k) severity warning;
                   compteur := 0;
                   k := k + 1;
               end if;
               compteur := compteur +1;
	       end if;
        end if;
            if (k = 64) then
	           report "simulation terminée" severity failure;
	        end if;
    end process;
    
end Behavioral;
