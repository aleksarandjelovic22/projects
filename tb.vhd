LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY tb IS
    GENERIC (N : NATURAL := 8);
END ENTITY tb;

ARCHITECTURE tb OF tb IS

    COMPONENT delj_bin IS
        GENERIC (N : NATURAL);
        PORT (
            A : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
            B : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
            clk, reset, start : IN STD_LOGIC;
            ready : OUT STD_LOGIC;
            Q : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0)
        );
    END COMPONENT delj_bin;

    SIGNAL a, b, q : STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
    SIGNAL clk, reset, start, ready : STD_LOGIC;
    SIGNAL ENDSIM : BOOLEAN := FALSE;
    CONSTANT clk_period : TIME := 100 ns;
BEGIN
    dut : delj_bin GENERIC MAP(N => N) PORT MAP(A => a, B => b, clk => clk, reset => reset, start => start, ready => ready, Q => q);

    main : PROCESS
    BEGIN
        start <= '0';
        reset <= '1';
        a <= "10001101";
        b <= "00000011";
        WAIT FOR clk_period;
        reset <= '0';
        WAIT FOR clk_period;
        start <= '1';
        WAIT FOR clk_period;
        start <= '0';
        WAIT FOR clk_period * 10;

        a <= "11101111";
        b <= "00000010";
        start <= '1';
        WAIT FOR clk_period;
        start <= '0';
        WAIT FOR clk_period * 10;

        a <= "10101010";
        b <= "10011010";
        start <= '1';
        WAIT FOR clk_period;
        start <= '0';
        WAIT FOR clk_period * 10;

        a <= "11110101";
        b <= "00110000";
        start <= '1';
        WAIT FOR clk_period;
        start <= '0';
        WAIT FOR clk_period * 10;

        a <= "11110000";
        b <= "00001100";
        start <= '1';
        WAIT FOR clk_period;
        start <= '0';
        WAIT FOR clk_period * 10;

        a <= "01000000";
        b <= "01000001";
        start <= '1';
        WAIT FOR clk_period;
        start <= '0';
        WAIT FOR clk_period *10;

        ENDSIM <= TRUE;
        WAIT;
    END PROCESS main;

    clock : PROCESS
    BEGIN
        IF (ENDSIM = FALSE) THEN
            clk <= '0';
            WAIT FOR clk_period/2;
            clk <= '1';
            WAIT FOR clk_period/2;
        ELSE
            WAIT;
        END IF;
    END PROCESS;

END ARCHITECTURE tb;