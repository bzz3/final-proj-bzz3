----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/25/2021 11:06:36 AM
-- Design Name: 
-- Module Name: clock_div - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity clock_div is
    Port ( clk : in STD_LOGIC;
           div : out STD_LOGIC);
end clock_div;

architecture Behavioral of clock_div is
    signal counter : STD_LOGIC_VECTOR(10 downto 0) := (others => '0');
begin
    process(clk)
    begin
        if rising_edge(clk) then
            -- 125000000 / 115200 = 1085.0694444444444444444444444444
            if unsigned(counter) < 1085 then
                counter <= STD_LOGIC_VECTOR(unsigned(counter) + 1);
            else
                counter <= (others => '0');
            end if;
            if unsigned(counter) < 1085 then
                div <= '0';
            else
                div <= '1';
            end if;
        end if;
    end process;

end Behavioral;
