LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY delj_bin IS
    GENERIC (N : NATURAL);
    PORT (
        A : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
        B : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
        clk, reset, start : IN STD_LOGIC;
        ready : OUT STD_LOGIC;
        Q : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0)
    );
END ENTITY delj_bin;

ARCHITECTURE delj_bin OF delj_bin IS

    COMPONENT subtractor IS
        GENERIC (N : NATURAL);
        PORT (
            a : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
            b : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
            r : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0)
        );
    END COMPONENT subtractor;

    SIGNAL msb, en, sig2 : STD_LOGIC;
    SIGNAL sh_reg1, sh_reg2 : STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
    SIGNAL cnt : NATURAL;
    SIGNAL diff, mux_out, acc, sig, sig3 : STD_LOGIC_VECTOR(N DOWNTO 0); --ulaz mux-a i oduzimaca
  
BEGIN
    sig <= acc(N - 1 DOWNTO 0) & msb;
    sig3 <= '0' & B;
    oduzimac : subtractor GENERIC MAP(N => N + 1) PORT MAP(a => sig, b => sig3, r => diff); --b => B

    mux_out <= diff WHEN diff(N) = '0' ELSE
        sig;

    akumulator : PROCESS (clk, reset)
    BEGIN
        IF (reset = '1') THEN --reset 1-com
            acc <= (OTHERS => '0');
        ELSIF (rising_edge(clk)) THEN
            IF (start = '1') THEN
                acc <= (OTHERS => '0');
            ELSIF (en = '1') THEN
                acc <= mux_out;
            END IF;
        END IF;
    END PROCESS akumulator;

    Shift_reg1 : PROCESS (clk, reset)
    BEGIN
        IF (reset = '1') THEN --reset 1-com
            sh_reg1 <= (OTHERS => '0');
        ELSIF (rising_edge(clk)) THEN
            IF (start = '1') THEN
                sh_reg1 <= A;
            ELSIF (en = '1') THEN
                sh_reg1 <= sh_reg1(N - 2 DOWNTO 0) & '0';
            END IF;
        END IF;
    END PROCESS Shift_reg1;
    msb <= sh_reg1(N - 1);

    Shift_reg2 : PROCESS (clk, reset)
    BEGIN
        IF (reset = '1') THEN
            sh_reg2 <= (OTHERS => '0');
        ELSIF (rising_edge(clk)) THEN
            IF (start = '1') THEN
                sh_reg2 <= (OTHERS => '0');
            ELSIF (en = '1') THEN
                sh_reg2 <= sh_reg2(N - 2 DOWNTO 0) & NOT(diff(N));
            END IF;
        END IF;
    END PROCESS Shift_reg2;
    Q <= sh_reg2;

    counter : PROCESS (clk, reset)
    BEGIN
        IF (reset = '1') THEN
            cnt <= 0;
        ELSIF (rising_edge(clk)) THEN
            IF (start = '1') THEN
                cnt <= 0;
            ELSIF (cnt < N) THEN
                cnt <= cnt + 1;
            END IF;
        END IF;
    END PROCESS counter;

    cnt_logic : sig2 <= '1' WHEN cnt = N ELSE
    '0';
    ready <= sig2;
    en <= NOT(sig2);

END ARCHITECTURE delj_bin;