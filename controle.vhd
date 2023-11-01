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
        cont_load : in std_logic;
        en_ula    : in std_logic;

        sai_op    : in std_logic
    );
end entity controle;

architecture behavior of controle is 

type t_contro_logic_fsm is (state_load,
                            state_ula,
                            state_jm);

begin
end architecture behavior;