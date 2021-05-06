----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/05/2021 05:39:16 PM
-- Design Name: 
-- Module Name: gcd - Behavioral
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

entity gcd is
    Port ( CLK : in STD_LOGIC;
           a : in STD_LOGIC_VECTOR (7 downto 0);
           b : in STD_LOGIC_VECTOR (7 downto 0);
           ready : out STD_LOGIC;
           gcd : out STD_LOGIC_VECTOR (7 downto 0));
end gcd;

architecture Behavioral of gcd is
    signal a_reg : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
    signal b_reg : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
    signal dividend : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
    signal divisor : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
begin
    process (CLK) begin
        if (rising_edge(CLK)) then
            if ((a /= a_reg or b /= b_reg) and unsigned(divisor) = 0) then
                a_reg <= a;
                b_reg <= b;
                if (unsigned(a_reg) = 0 or unsigned(b_reg) = 0) then
                    gcd <= (others => '0');
                    ready <= '1';
                elsif (unsigned(a_reg) = unsigned(b_reg)) then
                    gcd <= a_reg;
                    ready <= '1';
                else
                    ready <= '0';
                    if (unsigned(a_reg) < unsigned(b_reg)) then
                        dividend <= b_reg;
                        divisor <= a_reg;
                    else
                        dividend <= a_reg;
                        divisor <= b_reg;
                    end if;
                end if;
            end if;
            if (unsigned(divisor) > 0) then
                if (unsigned(dividend) mod unsigned(divisor) = 0) then
                    gcd <= divisor;
                    ready <= '1';
                    divisor <= (others => '0');
                else
                    divisor <= STD_LOGIC_VECTOR(unsigned(divisor) - 1);
                end if;
            end if;
        end if;
    end process;


end Behavioral;
