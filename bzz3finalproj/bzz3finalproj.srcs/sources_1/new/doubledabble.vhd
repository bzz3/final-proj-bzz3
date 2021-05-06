----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/05/2021 05:38:34 PM
-- Design Name: 
-- Module Name: doubledabble - Behavioral
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

entity doubledabble is
    Port ( CLK : in STD_LOGIC;
           binary : in STD_LOGIC_VECTOR (7 downto 0);
           ready : out STD_LOGIC;
           bcd0 : out STD_LOGIC_VECTOR (3 downto 0);
           bcd1 : out STD_LOGIC_VECTOR (3 downto 0);
           bcd2 : out STD_LOGIC_VECTOR (3 downto 0)
    );
end doubledabble;

architecture Behavioral of doubledabble is
    signal shift_count : STD_LOGIC_VECTOR (3 downto 0) := (others => '0');
    signal shift_reg : STD_LOGIC_VECTOR (19 downto 0) := (others => '0');
    signal bin : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
    signal bcd_one : STD_LOGIC_VECTOR (3 downto 0) := (others => '0');
    signal bcd_ten : STD_LOGIC_VECTOR (3 downto 0) := (others => '0');
    signal bcd_hun : STD_LOGIC_VECTOR (3 downto 0) := (others => '0');
begin
    process (CLK) begin
        if (rising_edge(CLK)) then
            if (bin /= binary and unsigned(shift_count) = 0) then
                ready <= '0';
                bin <= binary;
                shift_reg <= "000000000000" & binary;
                bcd_one <= (others => '0');
                bcd_ten <= (others => '0');
                bcd_hun <= (others => '0');
                shift_count <= STD_LOGIC_VECTOR(unsigned(shift_count) + 1);
            end if;
            if (unsigned(shift_count) > 0 and unsigned(shift_count) < 9) then
                if (unsigned(bcd_one) >= 5) then
                    bcd_one <= STD_LOGIC_VECTOR(unsigned(bcd_one) + 3);
                end if;
                if (unsigned(bcd_ten) >= 5) then
                    bcd_ten <= STD_LOGIC_VECTOR(unsigned(bcd_ten) + 3);
                end if;
                if (unsigned(bcd_hun) >= 5) then
                    bcd_hun <= STD_LOGIC_VECTOR(unsigned(bcd_hun) + 3);
                end if;
                
                shift_reg (11 downto 8) <= bcd_one;
                shift_reg (15 downto 12) <= bcd_ten;
                shift_reg (19 downto 16) <= bcd_hun;
                shift_reg <= STD_LOGIC_VECTOR(shift_left(unsigned(shift_reg), 1));
                
                bcd_one <= shift_reg (11 downto 8);
                bcd_ten <= shift_reg (15 downto 12);
                bcd_hun <= shift_reg (19 downto 16);
                
                shift_count <= STD_LOGIC_VECTOR(unsigned(shift_count) + 1);
            end if;
            if (unsigned(shift_count) >= 9) then
                shift_count <= (others => '0');
                bcd0 <= bcd_one;
                bcd1 <= bcd_ten;
                bcd2 <= bcd_hun;
                ready <= '1';
            end if;
        end if;
    end process;
end Behavioral;
