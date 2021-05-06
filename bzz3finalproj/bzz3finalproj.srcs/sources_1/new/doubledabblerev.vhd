----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/05/2021 05:38:34 PM
-- Design Name: 
-- Module Name: doubledabblerev - Behavioral
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

entity doubledabblerev is
    Port ( CLK : in STD_LOGIC;
           bcd0 : in STD_LOGIC_VECTOR (3 downto 0);
           bcd1 : in STD_LOGIC_VECTOR (3 downto 0);
           bcd2 : in STD_LOGIC_VECTOR (3 downto 0);
           ready : out STD_LOGIC;
           binary : out STD_LOGIC_VECTOR (7 downto 0)
    );
end doubledabblerev;

architecture Behavioral of doubledabblerev is
    signal shift_count : STD_LOGIC_VECTOR (3 downto 0) := (others => '0');
    signal shift_reg : STD_LOGIC_VECTOR (19 downto 0) := (others => '0');
    signal bin : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
    signal bcd_one : STD_LOGIC_VECTOR (3 downto 0) := (others => '0');
    signal bcd_ten : STD_LOGIC_VECTOR (3 downto 0) := (others => '0');
    signal bcd_hun : STD_LOGIC_VECTOR (3 downto 0) := (others => '0');
begin
    process (CLK) begin
        if (rising_edge(CLK)) then
            if ((bcd_one /= bcd0 or bcd_ten /= bcd1 or bcd_hun /= bcd2) and unsigned(shift_count) = 0) then
                ready <= '0';
                bcd_one <= bcd0;
                bcd_ten <= bcd1;
                bcd_hun <= bcd2;
                shift_reg <= bcd2 & bcd1 & bcd0 & "00000000";
                bin <= (others => '0');
                shift_count <= STD_LOGIC_VECTOR(unsigned(shift_count) + 1);
            end if;
            if (unsigned(shift_count) > 0 and unsigned(shift_count) < 9) then
                shift_reg (11 downto 8) <= bcd_one;
                shift_reg (15 downto 12) <= bcd_ten;
                shift_reg (19 downto 16) <= bcd_hun;

                shift_reg <= STD_LOGIC_VECTOR(shift_right(unsigned(shift_reg), 1));
                bcd_one <= shift_reg (11 downto 8);
                bcd_ten <= shift_reg (15 downto 12);
                bcd_hun <= shift_reg (19 downto 16);
                
                if (unsigned(bcd_one) >= 8) then
                    bcd_one <= STD_LOGIC_VECTOR(unsigned(bcd_one) - 3);
                end if;
                if (unsigned(bcd_ten) >= 8) then
                    bcd_ten <= STD_LOGIC_VECTOR(unsigned(bcd_ten) - 3);
                end if;
                if (unsigned(bcd_hun) >= 8) then
                    bcd_hun <= STD_LOGIC_VECTOR(unsigned(bcd_hun) - 3);
                end if;
                
                shift_count <= STD_LOGIC_VECTOR(unsigned(shift_count) + 1);
            end if;
            if (unsigned(shift_count) >= 9) then
                shift_count <= (others => '0');
                binary <= bin;
                ready <= '1';
            end if;
        end if;
    end process;
end Behavioral;
