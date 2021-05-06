----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/24/2021 03:13:58 PM
-- Design Name: 
-- Module Name: uart_tx - fsm
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

entity uart_tx is
    Port ( clk : in STD_LOGIC;
           en : in STD_LOGIC;
           send : in STD_LOGIC;
           rst : in STD_LOGIC;
           char : in STD_LOGIC_VECTOR (7 downto 0);
           ready : out STD_LOGIC;
           tx : out STD_LOGIC
           );
end uart_tx;

architecture fsm of uart_tx is

    -- state type enumeration and state variable
    type state is (idle, data);
    signal curr : state := idle;

    -- counter for data state
    signal count : STD_LOGIC_VECTOR (3 downto 0) := (others => '0');
    
    signal charReg : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');

begin

    -- FSM process (single process implementation)
    process(clk) begin
        if rising_edge(clk) then
    
            -- resets the state machine and its outputs
            if rst = '1' then
    
                charReg <= (others => '0');
                count <= (others => '0');
                ready <= '1';
                tx <= '1';
                curr <= idle;
    
            -- usual operation
            elsif en = '1' then
                case curr is
    
                    when idle =>
                        if send = '1' then
                            ready <= '0';
                            tx <= '0';
                            count <= (others => '0');
                            charReg <= char;
                            curr <= data;
                        end if;
    
                    when data =>
                        if unsigned(count) < 8 then
                            ready <= '0';
                            tx <= charReg(to_integer(unsigned(count)));
                            count <= STD_LOGIC_VECTOR(unsigned(count) + 1);
                        else
                            ready <= '1';
                            tx <= '1';
                            charReg <= (others => '0');
                            curr <= idle;
                        end if;
    
                    when others =>
                        curr <= idle;
    
                end case;
            end if;
    
        end if;
    end process;

end fsm;
