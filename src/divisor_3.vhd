--Raul Garcia & Alejandro Molero
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity divisor_3 is
    port(
        clk         : in  std_logic;
        ena         : in  std_logic;  -- Reset asíncrono (activo en '0')
        f_div_2_5   : out std_logic;  -- Salida de 2.5MHz 
        f_div_1_25  : out std_logic;  -- Salida de 1.25MHz 
        f_div_500   : out std_logic   -- Salida de 500KHz 
    );
end entity divisor_3;

architecture Behavioral of divisor_3 is
    -- Contadores ajustados según la indicación
    signal count2 : unsigned(4 downto 0) := (others => '0'); -- Modulo 19
    signal count4 : unsigned(5 downto 0) := (others => '0'); -- Modulo 39
    signal count5 : unsigned(6 downto 0) := (others => '0'); -- Modulo 99

    signal pulse_2 : std_logic := '0';
    signal pulse_4 : std_logic := '0';
    signal pulse_5 : std_logic := '0';

begin
    -- Contador de módulo 19 (cada 19 ciclos de clk)
    process(clk, ena)
    begin
        if ena = '0' then
            count2 <= (others => '0');
            pulse_2 <= '1';
        elsif rising_edge(clk) then
            if count2 = "10011" then  -- 19 ciclos
                count2 <= (others => '0');
                pulse_2 <= '1';
            else
                count2 <= count2 + 1;
                pulse_2 <= '0';
            end if;
        end if;
    end process;

    f_div_2_5 <= pulse_2;

    -- Contador de módulo 39 (cada 39 ciclos de pulse_2)
    process(clk, ena)
    begin
        if ena = '0' then
            count4 <= (others => '0');
            pulse_4 <= '1';
        elsif rising_edge(clk) then
         
                if count4 = "100111" then  -- 39 ciclos
                    count4 <= (others => '0');
                    pulse_4 <= '1';
                else
                    count4 <= count4 + 1;
                    pulse_4 <= '0';
                end if;
           
        end if;
    end process;

    f_div_1_25 <= pulse_4;

    -- Contador de módulo 99 (cada 99 ciclos de pulse_2)
    process(clk, ena)
    begin
        if ena = '0' then
            count5 <= (others => '0');
            pulse_5 <= '1';
        elsif rising_edge(clk) then
           
                if count5 = "1100011" then  -- 99 ciclos
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
