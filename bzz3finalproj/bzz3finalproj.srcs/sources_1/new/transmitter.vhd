----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/05/2021 08:21:19 PM
-- Design Name: 
-- Module Name: transmitter - Behavioral
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

entity transmitter is
    Port ( CLK : in STD_LOGIC;
           RST : in STD_LOGIC;
           en : in STD_LOGIC;
           gcd_ready : in STD_LOGIC;
           tx_ready : in STD_LOGIC;
           bcd0 : in STD_LOGIC_VECTOR (3 downto 0);
           bcd1 : in STD_LOGIC_VECTOR (3 downto 0);
           bcd2 : in STD_LOGIC_VECTOR (3 downto 0);
           send : out STD_LOGIC;
           char : out STD_LOGIC_VECTOR (7 downto 0));
end transmitter;

architecture Behavioral of transmitter is

    -- state type enumeration and state variable
    type state is (idle, busyA, busyB, busyC);
    signal curr : state := idle;
    signal count : STD_LOGIC_VECTOR (1 downto 0) := (others => '0');
    signal num_to_char0 : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
    signal num_to_char1 : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
    signal num_to_char2 : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
    

begin
    num_to_char0 <= "0000" & bcd0;
    num_to_char1 <= "0000" & bcd1;
    num_to_char2 <= "0000" & bcd2;
    process (CLK) begin
        if rising_edge(CLK) then
            if RST = '1' then
                send <= '0';
                char <= (others => '0');
                count <= (others => '0');
                curr <= idle;
            elsif en = '1' then
                case curr is
                    when idle =>
                        if tx_ready = '1' and gcd_ready = '1' then
                            if unsigned(count) < 3 then
                                send <= '1';
                                case to_integer(unsigned(count)) is
                                    when 0 =>
                                        char <= STD_LOGIC_VECTOR(unsigned(num_to_char0) + 48);
                                    when 1 =>
                                        char <= STD_LOGIC_VECTOR(unsigned(num_to_char1) + 48);
                                    when 2 =>
                                        char <= STD_LOGIC_VECTOR(unsigned(num_to_char2) + 48);
                                    when others =>
                                        curr <= idle;
                                end case;
                                count <= STD_LOGIC_VECTOR(unsigned(count) + 1);
                                curr <= busyA;
                            elsif unsigned(count) >= 3 then
                                count <= (others => '0');
                                curr <= idle;
                            end if;
                        end if;
                    when busyA =>
                        curr <= busyB;
                    when busyB =>
                        send <= '0';
                        curr <= busyC;
                    when busyC =>
                        if tx_ready = '1' and (unsigned(count) < 3 or gcd_ready = '0') then
                            curr <= idle;
                        end if;
                    when others =>
                        curr <= idle;
                end case;
            end if;
        end if;
    end process;

end Behavioral;
