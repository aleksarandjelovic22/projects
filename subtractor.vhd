LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY subtractor IS
    GENERIC (N : NATURAL);
    PORT (
        a : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
        b : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
        r : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0)
    );
END ENTITY subtractor;

ARCHITECTURE subtractor OF subtractor IS

    COMPONENT sub_cell IS
        PORT (
            a : IN STD_LOGIC;
            b : IN STD_LOGIC;
            pi : IN STD_LOGIC;
            r : OUT STD_LOGIC;
            po : OUT STD_LOGIC
        );
    END COMPONENT sub_cell;

    SIGNAL p : STD_LOGIC_VECTOR(N DOWNTO 0);
BEGIN
    p(0) <= '0';
    l0 : FOR i IN 0 TO N - 1 GENERATE
        l1 : sub_cell PORT MAP(a => a(i), b => b(i), pi => p(i), r => r(i), po => p(i + 1));
    END GENERATE;
END ARCHITECTURE subtractor;