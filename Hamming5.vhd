library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity Hamming5 is
    Port ( d1, d2   : in STD_LOGIC_VECTOR (7 downto 0);           
           clk, rst : in STD_LOGIC;
           dh       : out STD_LOGIC_VECTOR (3 downto 0); --Little endian, LSB on the left
           start    : in STD_LOGIC;
           ready    : out STD_LOGIC);
end Hamming5;



-- EG: Behavior seems undefined when start = '1' and ps = OPERATION
architecture rtl_mealy of Hamming5 is
    Type STATE is (IDLE,OPERATION);
    signal ps, ns: STATE;
    signal i_reg, i_next   : integer := 0;
    --signal r_reg, r_next: STD_LOGIC := '0';
    signal dh_reg, dh_next : unsigned ( 3 downto 0) := "0000";
    
begin
    process(clk, rst)
    begin
        if (clk'event and clk='1') then
            if rst='1' then
                ps <= IDLE;
                i_reg <= 0;
                --r_reg <= '0';
                dh_reg <= ( others => '0');
            else
                ps <= ns;
                --r_reg <= r_next;
                i_reg <= i_next;
                dh_reg <= dh_next;
            end if;
        end if;
    end process;
    
    process (ps, ns, start, d1, d2, i_reg)
    begin
        ns <= ps;
        dh_next <= dh_reg;
        --r_next <= r_reg;
        i_next <= i_reg;
        dh <= std_logic_vector(dh_next);
        case ps is
        
            when IDLE => 
                --ready <= '1';
                --i_next <= 0;
                --dh_next <= "0000";
                if start = '0' then
                    ns <= IDLE;
                    ready <= '1';  
                    i_next <= 0;    
                    dh_next <= "0000";
                    --r_next <= ( d1(i_reg) xor d2(i_reg) );            
                else
                    ns <= OPERATION;
                    ready <= '0';
                    i_next <= 0;
                    dh_next <= "0000";
                    --r_next <= ( d1(i_reg) xor d2(i_reg) );  
                end if;
                
            when OPERATION => 
                
                if i_reg < 7 and d1(i_reg) /= d2(i_reg) then
                    ready <= '0';
                    i_next <= i_reg + 1;
                    dh_next <= dh_reg + 1;
                    ns <= OPERATION;
                 elsif i_reg < 7 and d1(i_reg) = d2(i_reg) then
                    ready <= '0';
                    i_next <= i_reg + 1;
                    dh_next <= dh_reg;
                    ns <= OPERATION;
                 elsif i_reg = 7 and d1(i_reg) /= d2(i_reg) then
                    ready <= '0'; -- perhaps this could be set to '1'
                    i_next <= i_reg;
                    dh_next <= dh_reg + 1;                 
                    ns <= IDLE;
                  else
                    ready <= '0';
                    i_next <= i_reg;
                    dh_next <= dh_reg;                 
                    ns <= IDLE;
                  end if;
                 
                    
                -- code pour decrementer             
            end case;
    end process;
end rtl_mealy;
