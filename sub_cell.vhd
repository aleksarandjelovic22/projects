LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY sub_cell IS
    PORT (
        a : IN STD_LOGIC; --prvi bit
        b : IN STD_LOGIC; --drugi bit
        pi : IN STD_LOGIC; --"ulazna" pozajmica
        r : OUT STD_LOGIC; --razlika
        po : OUT STD_LOGIC --"izlazna" pozajmica
    );
END ENTITY sub_cell;

ARCHITECTURE sub_cell OF sub_cell IS
BEGIN
    r <= (a XOR b) XOR pi;
    po <= (NOT(a) AND b) or (not(a) and pi) or (b and pi);
END ARCHITECTURE sub_cell;