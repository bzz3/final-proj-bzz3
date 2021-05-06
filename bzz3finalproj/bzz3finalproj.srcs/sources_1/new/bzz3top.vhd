----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/05/2021 08:59:49 PM
-- Design Name: 
-- Module Name: bzz3top - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity bzz3top is
    Port ( CLK : in STD_LOGIC;
           RST : in STD_LOGIC;
           RTS : inout STD_LOGIC;
           RXD : inout STD_LOGIC;
           TXD : inout STD_LOGIC;
           CTS : inout STD_LOGIC);
end bzz3top;

architecture Behavioral of bzz3top is
    component clock_div
       Port ( clk : in STD_LOGIC;
              div : out STD_LOGIC);
    end component;
    component uart
       Port ( clk, en, send, rx, rst : in STD_LOGIC;
              charSend : in STD_LOGIC_VECTOR (7 downto 0);
              ready, tx, newChar : out STD_LOGIC;
              charRec : out STD_LOGIC_VECTOR (7 downto 0));
    end component;
    component receiver
        Port ( CLK : in STD_LOGIC;
               RST : in STD_LOGIC;
               en : in STD_LOGIC;
               newChar : in STD_LOGIC;
               char : in STD_LOGIC_VECTOR (7 downto 0);
               ready : out STD_LOGIC;
               bcd0 : out STD_LOGIC_VECTOR (3 downto 0);
               bcd1 : out STD_LOGIC_VECTOR (3 downto 0);
               bcd2 : out STD_LOGIC_VECTOR (3 downto 0));
    end component;
    component doubledabblerev
        Port ( CLK : in STD_LOGIC;
               bcd0 : in STD_LOGIC_VECTOR (3 downto 0);
               bcd1 : in STD_LOGIC_VECTOR (3 downto 0);
               bcd2 : in STD_LOGIC_VECTOR (3 downto 0);
               ready : out STD_LOGIC;
               binary : out STD_LOGIC_VECTOR (7 downto 0));
    end component;
    component gcd_div
        Port ( CLK : in STD_LOGIC;
               rx_ready : in STD_LOGIC;
               ddr_ready : in STD_LOGIC;
               binary : in STD_LOGIC_VECTOR (7 downto 0);
               a : out STD_LOGIC_VECTOR (7 downto 0);
               b : out STD_LOGIC_VECTOR (7 downto 0));
    end component;
    component gcd
        Port ( CLK : in STD_LOGIC;
               a : in STD_LOGIC_VECTOR (7 downto 0);
               b : in STD_LOGIC_VECTOR (7 downto 0);
               ready : out STD_LOGIC;
               gcd : out STD_LOGIC_VECTOR (7 downto 0));
    end component;
    component doubledabble
        Port ( CLK : in STD_LOGIC;
               binary : in STD_LOGIC_VECTOR (7 downto 0);
               ready : out STD_LOGIC;
               bcd0 : out STD_LOGIC_VECTOR (3 downto 0);
               bcd1 : out STD_LOGIC_VECTOR (3 downto 0);
               bcd2 : out STD_LOGIC_VECTOR (3 downto 0));
    end component;
    component transmitter
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
    end component;
signal clk_div : STD_LOGIC := '0';
signal rx_new : STD_LOGIC := '0';
signal rx_ready : STD_LOGIC := '0';
signal rx_char : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
signal rx_bcd0 : STD_LOGIC_VECTOR (3 downto 0) := (others => '0');
signal rx_bcd1 : STD_LOGIC_VECTOR (3 downto 0) := (others => '0');
signal rx_bcd2 : STD_LOGIC_VECTOR (3 downto 0) := (others => '0');

signal ddr_ready : STD_LOGIC := '0';
signal ddr_bin : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');

signal gcd_a : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
signal gcd_b : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
signal gcd_ready : STD_LOGIC := '0';
signal gcd_val : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');

signal tx_ready : STD_LOGIC := '0';
signal tx_bcd0 : STD_LOGIC_VECTOR (3 downto 0) := (others => '0');
signal tx_bcd1 : STD_LOGIC_VECTOR (3 downto 0) := (others => '0');
signal tx_bcd2 : STD_LOGIC_VECTOR (3 downto 0) := (others => '0');
signal tx_send : STD_LOGIC := '0';
signal tx_char : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
    
begin
    clk_divider: clock_div
    Port map ( clk => CLK,
               div => clk_div);
    uart_m: uart
    Port map ( clk => CLK,
               en => clk_div,
               send => tx_send,
               rx => TXD,
               rst => RST,
               charSend => tx_char,
               ready => tx_ready,
               tx => RXD,
               newChar => rx_new,
               charRec => rx_char);
    rx: receiver
    Port map ( CLK => CLK,
               RST => RST,
               en => clk_div,
               newChar => rx_new,
               char => rx_char,
               ready => rx_ready,
               bcd0 => rx_bcd0,
               bcd1 => rx_bcd1,
               bcd2 => rx_bcd2);
    ddr: doubledabblerev
    Port map ( CLK => CLK,
               bcd0 => rx_bcd0,
               bcd1 => rx_bcd1,
               bcd2 => rx_bcd2,
               ready => ddr_ready,
               binary => ddr_bin);
    gcd_d: gcd_div
    Port map ( CLK => CLK,
               rx_ready => rx_ready,
               ddr_ready => ddr_ready,
               binary => ddr_bin,
               a => gcd_a,
               b => gcd_b);
    gcd_m: gcd
    Port map ( CLK => CLK,
               a => gcd_a,
               b => gcd_b,
               ready => gcd_ready,-- not necessary
               gcd => gcd_val);
    dd: doubledabble
    Port map ( CLK => CLK,
               binary => gcd_val,
               ready => tx_ready,
               bcd0 => tx_bcd0,
               bcd1 => tx_bcd1,
               bcd2 => tx_bcd2);
    tx: transmitter
    Port map ( CLK => CLK,
               RST => RST,
               en => clk_div,
               gcd_ready => gcd_ready,
               tx_ready => tx_ready,
               bcd0 => tx_bcd0,
               bcd1 => tx_bcd1,
               bcd2 => tx_bcd2,
               send => tx_send,
               char => tx_char);
end Behavioral;
