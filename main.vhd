library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

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

        sai        : out std_logic_vector((DATA_WIDTH - 7) downto 0)
    );
end entity main;

architecture behavior of main is

signal pc  : std_logic_vector((DATA_WIDTH - 1) downto 0);
signal acc : std_logic_vector((DATA_WIDTH - 1) downto 0);
signal rdm : std_logic_vector((ADDR_WIDTH - 1) downto 0);

-- --------- SINAIS QUE NÃO TENHO CERTEZA ---------------------------------
signal sel : std_logic_vector((DATA_WIDTH - 2) downto 0); -- seletor do mux
signal mul : std_logic_vector((ADDR_WIDTH - 1) downto 0); -- suporte multip
-- ------------------------------------------------------------------------

signal z   : std_logic;
signal n   : std_logic;

-- ----------------------------MEMORIA-------------------------------------
type mem_dec is array (integer range 0 to 15) of std_logic_vector((ADDR_WIDTH - 1) downto 0);
signal mem  : mem_dec;
signal addr : std_logic_vector((ADDR_WIDTH - 1) downto 0);

begin

    mul <= acc * rdm(3 downto 0); -- MULTIPLICACAO FORA DO PROCESS

    mem(0)  <= "00000000";
    mem(1)  <= "00000000";
    mem(2)  <= "00000000";
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

    process(clk, res)
        begin

            if(res = '1')then
                sai <= (others => '0');
                pc  <= (others => '0');
                acc <= (others => '0');
                rdm <= (others => '0');
                z   <= '0';
                n   <= '0';
            elsif(rising_edge(clk))then
                
                rdm <= mem(pc); --POSSÍVEL FORMA DE COMO O SELECIONAR NA MEMORIA
                sel <= rdm(5 downto 4); -- seletor do mux
                
                -- -------------O QUE SERIA O PC---------------------

                if(z = '1')then
                    pc <= rdm(3 downto 0);
                elsif(n = '1')then
                    pc <= rdm(3 downto 0);
                else
                    pc <= pc + 1;
                end if;
                
                -- -------------O QUE SERIA O MUX -------------------

                case sel is
                    when "00" =>
                        acc <= rdm(3 downto 0);
                    when "01" =>
                        acc <= acc + rdm(3 downto 0);
                    when "10" =>
                        acc <= acc - rdm(3 downto 0);
                    when others =>
                        acc <= mul(3 downto 0);
                end case;

            end if;

    end process;

end architecture behavior;