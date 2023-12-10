library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity controle is 
    generic(
        ADDR_WIDTH : natural := 8;
        DATA_WIDTH : natural := 4
    );
    port(
        clock     : in std_logic;
        reset     : in std_logic;
        z         : in std_logic;
        n         : in std_logic;
        
        op        : in std_logic_vector((ADDR_WIDTH - 1) downto 0);

        sai_op    : out std_logic_vector((DATA_WIDTH - 3) downto 0)
    );
end entity controle;

architecture behavior of controle is 

type control_logic_fsm is (state_anda,
                            state_ula,
                            state_jmp);

signal atual     : control_logic_fsm;
signal proximo   : control_logic_fsm;

signal sinal_ula : std_logic;
signal sinal_jmp : std_logic;
signal sinal_jzn : std_logic;

begin

    sinal_ula <= (op(0) or op(1) or op(2) or op(3));
    sinal_jmp <= op(4);
    sinal_jzn <= (op(5) or op(6));

    process(clock, reset)
    begin

        if(reset = '1')then
            atual <= state_anda;
        elsif(rising_edge(clock))then
            atual <= proximo;
        end if;

    end process;

    -- --------------------------- AQUI ESTA O PRÓXIMO PASSO -----------------------------
    -- JN É DETERMINADO PELO BIT MAIS A ESQUERDA
    -- MAS NÃO NECESSÁRIAMENTE O TORNA NEGATIVO
    -- COMO PROCEDER?
    
    apos : process(atual, sinal_ula, sinal_jmp)
    begin

        case atual is
            when state_anda =>
                if(sinal_ula = '1')then
                    proximo <= state_ula; 
                elsif(((sinal_jzn ='1') and (z = '1' or n = '1')) or (sinal_jmp = '1'))then
                    proximo <= state_jmp;
                else
                    proximo <= state_anda;    
                end if; 

           when state_ula  =>
                if(sinal_jmp = '1')then
                    proximo <= state_jmp; 
                elsif(((sinal_jzn ='1') and (z = '1' or n = '1')) or (sinal_jmp = '1'))then
                    proximo <= state_jmp;
                else
                    proximo <= state_anda;    
                end if;  

            when others => --JMP
                if(sinal_ula = '1')then
                    proximo <= state_ula; 
                elsif(((sinal_jzn ='1') and (z = '1' or n = '1')) or (sinal_jmp = '1'))then
                    proximo <= state_jmp;
                else
                    proximo <= state_anda;    
                end if; 
                
        end case;

    end process;

    -- ----------------- AQUI ESTA A SAIDA QUE VAI PARA A OPERATIVA ----------------------
    saida : process(atual) --RESET????? 
    begin
        
        case atual is 
            when state_anda =>
                sai_op(0) <= '1'; -- count_load
                sai_op(1) <= '0'; -- en_ula
            when state_ula  =>
                sai_op(0) <= '1';
                sai_op(1) <= '1';
            when others     =>  --state_jmp
                sai_op(0) <= '0';
                sai_op(1) <= '0';
        end case;        

    end process saida;

end architecture behavior;