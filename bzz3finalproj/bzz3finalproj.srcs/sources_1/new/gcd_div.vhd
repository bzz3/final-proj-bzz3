----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/05/2021 09:42:46 PM
-- Design Name: 
-- Module Name: gcd_div - Behavioral
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

entity gcd_div is
    Port ( CLK : in STD_LOGIC;
           rx_ready : in STD_LOGIC;
           ddr_ready : in STD_LOGIC;
           binary : in STD_LOGIC_VECTOR (7 downto 0);
           a : out STD_LOGIC_VECTOR (7 downto 0);
           b : out STD_LOGIC_VECTOR (7 downto 0));
end gcd_div;

architecture Behavioral of gcd_div is
    signal ready_rise : STD_LOGIC := '0';
    signal a_or_b : STD_LOGIC := '0';
begin
    process (CLK) begin
        if (rising_edge(CLK)) then
            if (rx_ready = '1') then
                if (ddr_ready = '1') then
                    if (ready_rise = '0') then
                        if (a_or_b = '0') then
                            a <= binary;
                        else
                            b <= binary;
                        end if;
                        a_or_b <= not a_or_b;
                        ready_rise <= '1';
                    end if;
                else
                    ready_rise <= '0';
                end if;
            end if;
        end if;
    end process;
end Behavioral;
