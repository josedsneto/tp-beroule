library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

entity tb_Hamming5 is
end tb_Hamming5;

architecture behavior of tb_Hamming5 is

    -- Component declaration for the Unit Under Test (UUT)
    component Hamming5
        Port ( d1, d2   : in STD_LOGIC_VECTOR (7 downto 0);           
               clk, rst : in STD_LOGIC;
               dh       : out STD_LOGIC_VECTOR (3 downto 0);
               start    : in STD_LOGIC;
               ready    : out STD_LOGIC);
    end component;

    -- Signals to connect to UUT
    signal d1, d2 : STD_LOGIC_VECTOR (7 downto 0);
    signal clk, rst : STD_LOGIC;
    signal dh : STD_LOGIC_VECTOR (3 downto 0);
    signal start : STD_LOGIC;
    signal ready : STD_LOGIC;

    -- Clock period definition
    constant clk_period : time := 10 ns;

begin

    -- Instantiate the Unit Under Test (UUT)
    uut: Hamming5 Port map (
        d1 => d1,
        d2 => d2,
        clk => clk,
        rst => rst,
        dh => dh,
        start => start,
        ready => ready
    );

    -- Clock process definitions
    clk_process : process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;

    -- Stimulus process
    stim_proc: process
    begin	
        -- Initialize Inputs
        d1 <= (others => '0');
        d2 <= (others => '0');
        rst <= '1';
        start <= '0';

        -- Wait for global reset to finish
        wait for 20 ns;
        
        -- De-assert reset
        rst <= '0';
        
        -- Apply test 1
        d1 <= "00000000";  -- Test vector d1
        d2 <= "00000000";  -- Test vector d2
        start <= '1';
        wait for 3*clk_period;
        start <= '0';

        -- Wait for the calculation to complete
        wait for 8*clk_period;

        -- Check results
        assert (dh = "0000")  -- Expected Hamming distance = 3
        report "Test 1 failed" severity error;
        
        -- Apply test 2
        d1 <= "11111111";
        d2 <= "00000000";
        start <= '1';
        wait for 0.8*clk_period;
        start <= '0';

        -- Wait for the calculation to complete
        wait for 8*clk_period;

        -- Check results
        assert (dh = "0111")  -- Expected Hamming distance = 7 EG: The number should be with LSB tp the right, don't know why
        report "Test 2 failed" severity error;

        -- Add more test cases as needed...

        -- End simulation
        wait;
    end process;

end behavior;