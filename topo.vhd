library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity topo is
    generic(
        ADDR_WIDTH_ex : natural := 8;
        DATA_WIDTH_ex : natural := 4
    );
    port(
        clock : in std_logic;
        reset : in std_logic;

        z     : out std_logic  --APENAS PARA TER UMA SAIDA
    );
end entity topo;

architecture behavior of topo is

signal aux_z  : std_logic;
signal aux_n  : std_logic;
signal aux_entra_op : std_logic_vector((ADDR_WIDTH_ex - 1) downto 0);
signal aux_sai_op : std_logic_vector((DATA_WIDTH_ex - 3) downto 0);


component operativa is
    generic(
        ADDR_WIDTH : natural;
        DATA_WIDTH : natural
    );
    port(
        clk        : in std_logic;
        res        : in std_logic;
        en_ula     : in std_logic;
        count_load : in std_logic;

        z          : out std_logic;
        n          : out std_logic;
        op         : out std_logic_vector((ADDR_WIDTH - 1) downto 0)
    );
end component operativa;

component controle is 
    generic(
        ADDR_WIDTH : natural;
        DATA_WIDTH : natural
    );
    port(
        clk       : in std_logic;
        res       : in std_logic;
        z         : in std_logic;
        n         : in std_logic;
        
        op        : in std_logic_vector((ADDR_WIDTH - 1) downto 0);

        sai_op    : out std_logic_vector((DATA_WIDTH - 3) downto 0)
    );
end component controle;


begin

    inst_operativa : operativa
        generic map(
            ADDR_WIDTH => ADDR_WIDTH_ex,
            DATA_WIDTH => DATA_WIDTH_ex
        )
        port map(
            clk        => clock,
            res        => reset,
            en_ula     => aux_sai_op(1),
            count_load => aux_sai_op(0),    
            z          => aux_z,
            n          => aux_n,
            op         => aux_entra_op
        );
    
    inst_controle : controle
        generic map(
            ADDR_WIDTH => ADDR_WIDTH_ex,
            DATA_WIDTH => DATA_WIDTH_ex
        )
        port map(
            clk        => clock,
            res        => reset,
            z          => aux_z,
            n          => aux_n,            
            op         => aux_entra_op,
            sai_op     => aux_sai_op
        );

end architecture behavior;