----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/05/2021 08:21:19 PM
-- Design Name: 
-- Module Name: receiver - Behavioral
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

entity receiver is
    Port ( CLK : in STD_LOGIC;
           RST : in STD_LOGIC;
           en : in STD_LOGIC;
           newChar : in STD_LOGIC;
           char : in STD_LOGIC_VECTOR (7 downto 0);
           ready : out STD_LOGIC;
           bcd0 : out STD_LOGIC_VECTOR (3 downto 0);
           bcd1 : out STD_LOGIC_VECTOR (3 downto 0);
           bcd2 : out STD_LOGIC_VECTOR (3 downto 0));
end receiver;

architecture Behavioral of receiver is

    -- state type enumeration and state variable
    type state is (idle, busyA, busyB, busyC);
    signal curr : state := idle;
    signal count : STD_LOGIC_VECTOR (1 downto 0) := (others => '0');
    signal char_to_num : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');

begin
    char_to_num <= STD_LOGIC_VECTOR(unsigned(char) - 48);
    process (CLK) begin
        if rising_edge(CLK) then
            if RST = '1' then
                ready <= '0';
                bcd0 <= (others => '0');
                bcd1 <= (others => '0');
                bcd2 <= (others => '0');
                count <= (others => '1');
                curr <= idle;
            elsif en = '1' then
                case curr is
                    when idle =>
                        if newChar = '1' then
                            if (unsigned(count) = 3) then
                                ready <= '0';
                                count <= STD_LOGIC_VECTOR(unsigned(count) - 1);
                                case to_integer(unsigned(count)) is
                                    when 2 =>
                                        bcd2 <= char_to_num(3 downto 0);
                                    when 1 =>
                                        bcd1 <= char_to_num(3 downto 0);
                                    when 0 =>
                                        bcd0 <= char_to_num(3 downto 0);
                                    when others =>
                                        curr <= idle;
                                end case;
                                curr <= busyA;
                            elsif unsigned(count) >= 3 then
                                ready <= '1';
                                count <= (others => '1');
                                curr <= idle;
                            end if;
                        end if;
                    when busyA =>
                        curr <= busyB;
                    when busyB =>
                        curr <= busyC;
                    when busyC =>
                        if newChar = '1' then
                            curr <= idle;
                        end if;
                    when others =>
                        curr <= idle;
                end case;
            end if;
        end if;
    end process;
end Behavioral;
