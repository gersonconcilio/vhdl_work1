library ieee;
use ieee.std_logic_1164.all;

entity tb_main is
  generic(
        ADDR_WIDTH_EX : natural := 8;
        DATA_WIDTH_EX : natural := 4
    );
end entity tb_main;

architecture behavior of tb_main is
  
component main is
  generic(
        ADDR_WIDTH : natural;
        DATA_WIDTH : natural
    );
  port(
    clk        : in std_logic;
    res        : in std_logic;
    en_ula     : in std_logic;
    count_load : in std_logic;

    OP         : out std_logic_vector((ADDR_WIDTH - 1) downto 0)
  );
end component main;

signal clk_sg        : std_logic := '1';
signal res_sg        : std_logic := '0';
signal en_ula_sg     : std_logic := '1';
signal count_load_sg : std_logic := '1';
signal op_sg        : std_logic_vector((ADDR_WIDTH_EX - 1) downto 0);
  
begin
  
  main_sg : main
    generic map(
      ADDR_WIDTH => ADDR_WIDTH_EX,
      DATA_WIDTH => DATA_WIDTH_EX
    )
    port map(
      clk        => clk_sg,
      res        => res_sg,
      en_ula     => en_ula_sg,
      count_load => count_load_sg,
      op         => op_sg
    );
    
    clk_sg <= not clk_sg after 10 ns;
    
    process
    begin
      wait for 40 ns;
      wait;
    end process;
  
end architecture behavior;