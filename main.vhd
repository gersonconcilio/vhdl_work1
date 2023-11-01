library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all; 

entity main is
    generic(
        ADDR_WIDTH : natural := 8;
        DATA_WIDTH : natural := 4
    );
    port(
        clk        : in std_logic;
        res        : in std_logic;
        en_ula     : in std_logic;
        count_load : in std_logic;

        op         : out std_logic_vector((ADDR_WIDTH - 1) downto 0)
    );
end entity main;

architecture behavior of main is

signal pc  : std_logic_vector((DATA_WIDTH - 1) downto 0);
signal acc : std_logic_vector((DATA_WIDTH - 1) downto 0);
signal rdm : std_logic_vector((ADDR_WIDTH - 1) downto 0);

-- -------------------------------SINAIS JMP--------------------------------
signal z     : std_logic;
signal n     : std_logic;
signal sup_z : std_logic;
signal sup_n : std_logic;

-- ----------------------SINAIS PARA A ULA --------------------------------
signal ula : std_logic_vector((DATA_WIDTH - 1) downto 0);
signal sel : std_logic_vector((DATA_WIDTH - 2) downto 0); -- seletor do mux


signal mul : std_logic_vector((ADDR_WIDTH - 1) downto 0); -- suporte multip
signal sub : std_logic_vector((ADDR_WIDTH - 1) downto 0); -- suporte subtra
signal som : std_logic_vector((ADDR_WIDTH - 1) downto 0); -- suporte soma

-- ----------------------------MEMORIA--------------------------------------
type mem_dec is array (integer range 0 to 15) of std_logic_vector((ADDR_WIDTH - 1) downto 0);
signal mem  : mem_dec;
signal addr : std_logic_vector((ADDR_WIDTH - 1) downto 0);


-- ------------------------------DECODER -----------------------------------
signal dec : std_logic_vector((DATA_WIDTH - 1) downto 0);



begin

    -- -------------SINAIS PARA AS OPERAÇÕES--------------------
    mul <= acc * rdm(3 downto 0);
    som <= acc + rdm(3 downto 0);
    sub <= acc - rdm(3 downto 0);
    
    -- --------------------------ULA----------------------------
    sel <= rdm(5 downto 4); -- seletor do mux
    
    ula <= rdm(3 downto 0) when sel = 2D"0" else
                       som when sel = 2D"1" else
                       sub when sel = 2D"2" else
                       mul(3 downto 0);
    
    sup_z <= '1' when ula = 4D"0";
    sup_n <= '1' when ula(3) = '1';
        
    -- ------------------------DECODER---------------------------   
    -- dec é o "seletor" e precisa ter todas as opções op irá ligar APENAS UM BIT para indicar a operação
    dec <= rdm(7 downto 4);
    
    op  <= 8D"0"  when dec = 4D"0" else  -- load
           8D"2"  when dec = 4D"1" else  -- soma
           8D"4"  when dec = 4D"2" else  -- subt
           8D"8"  when dec = 4D"3" else  -- mult
           8D"16" when dec = 4D"4" else  -- jmp
           8D"32" when dec = 4D"5" else  -- jmp
           (others => '0');       
           
    -- ------------------------MEMORIA---------------------------
    mem(0)  <= "00000010";
    mem(1)  <= "00000000";
    mem(2)  <= "00110100";
    mem(3)  <= "00000000";
    mem(4)  <= "00000000";
    mem(5)  <= "00000000";
    mem(6)  <= "00000000";
    mem(7)  <= "00000000";
    mem(8)  <= "00000000";
    mem(9)  <= "00000000";
    mem(10) <= "00000000";
    mem(11) <= "00000000";
    mem(12) <= "00000000";
    mem(13) <= "00000000";
    mem(14) <= "00000000";
    mem(15) <= "00000000";
    
    

    process(clk, res)
        begin

            if(res = '1')then
                pc  <= (others => '0');
                acc <= (others => '0');
                rdm <= (others => '0');
                z   <= '0';
                n   <= '0';        
            elsif(rising_edge(clk))then     
            
                -- -------------O QUE SERIA O PC---------------------
                rdm <= mem(to_integer(signed(pc))); 
                
                if(count_load = '1')then
                    pc <= pc + 1;
                else
                    pc <= rdm(3 downto 0);
                end if; 
                  
                -- -------------O QUE SERIA A ULA--------------------
                if(en_ula = '1')then
                    acc <= ula;
                    z <= sup_z;
                    n <= sup_n;
                end if;                 
          
            end if;

    end process;

end architecture behavior;