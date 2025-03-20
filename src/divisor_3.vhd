library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity divisor_3 is
    port(
        clk         : in  std_logic;
        ena         : in  std_logic;  -- Reset asíncrono (activo en '0')
        f_div_2_5   : out std_logic;  -- Salida de 2.5MHz (10MHz/4)
        f_div_1_25  : out std_logic;  -- Salida de 1.25MHz (10MHz/8)
        f_div_500   : out std_logic   -- Salida de 500KHz (10MHz/20)
    );
end entity divisor_3;

architecture Behavioral of divisor_3 is
    -- Contadores ajustados según la indicación
    signal count2 : unsigned(1 downto 0) := (others => '0'); -- Modulo 4
    signal count4 : unsigned(2 downto 0) := (others => '0'); -- Modulo 7
    signal count5 : unsigned(4 downto 0) := (others => '0'); -- Modulo 19

    signal pulse_2 : std_logic := '0';
    signal pulse_4 : std_logic := '0';
    signal pulse_5 : std_logic := '0';

begin
    -- Contador de módulo 4 (cada 4 ciclos de clk)
    process(clk, ena)
    begin
        if ena = '0' then
            count2 <= (others => '0');
            pulse_2 <= '1';
        elsif rising_edge(clk) then
            if count2 = "11" then  -- 4 ciclos
                count2 <= (others => '0');
                pulse_2 <= '1';
            else
                count2 <= count2 + 1;
                pulse_2 <= '0';
            end if;
        end if;
    end process;

    f_div_2_5 <= pulse_2;

    -- Contador de módulo 7 (cada 7 ciclos de pulse_2)
    process(clk, ena)
    begin
        if ena = '0' then
            count4 <= (others => '0');
            pulse_4 <= '1';
        elsif rising_edge(clk) then
         
                if count4 = "111" then  -- 7 ciclos
                    count4 <= (others => '0');
                    pulse_4 <= '1';
                else
                    count4 <= count4 + 1;
                    pulse_4 <= '0';
                end if;
           
        end if;
    end process;

    f_div_1_25 <= pulse_4;

    -- Contador de módulo 19 (cada 19 ciclos de pulse_2)
    process(clk, ena)
    begin
        if ena = '0' then
            count5 <= (others => '0');
            pulse_5 <= '1';
        elsif rising_edge(clk) then
           
                if count5 = "10011" then  -- 19 ciclos
                    count5 <= (others => '0');
                    pulse_5 <= '1';
                else
                    count5 <= count5 + 1;
                    pulse_5 <= '0';
                end if;
         
        end if;
    end process;

    f_div_500 <= pulse_5;

end Behavioral;
