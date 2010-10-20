--------------------------------------------------------------------------------
-- Copyright (c) 1995-2007 Xilinx, Inc.
-- All Right Reserved.
--------------------------------------------------------------------------------
--   ____  ____ 
--  /   /\/   / 
-- /___/  \  /    Vendor: Xilinx 
-- \   \   \/     Version : 9.2i
--  \   \         Application : ISE
--  /   /         Filename : testpractica3.vhw
-- /___/   /\     Timestamp : Thu Oct 14 15:07:33 2010
-- \   \  /  \ 
--  \___\/\___\ 
--
--Command: 
--Design Name: testpractica3
--Device: Xilinx
--

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
library ieee;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
USE IEEE.STD_LOGIC_TEXTIO.ALL;
USE STD.TEXTIO.ALL;

ENTITY testpractica3 IS
END testpractica3;

ARCHITECTURE testbench_arch OF testpractica3 IS
    FILE RESULTS: TEXT OPEN WRITE_MODE IS "results.txt";

    COMPONENT entidad
        PORT (
            mclk : In std_logic;
            btn : In std_logic_vector (3 DownTo 0);
            swt : In std_logic_vector (7 DownTo 0);
            led : Out std_logic_vector (7 DownTo 0);
            an : Out std_logic_vector (3 DownTo 0);
            ssg : Out std_logic_vector (7 DownTo 0)
        );
    END COMPONENT;

    SIGNAL mclk : std_logic := '0';
    SIGNAL btn : std_logic_vector (3 DownTo 0) := "0000";
    SIGNAL swt : std_logic_vector (7 DownTo 0) := "00000000";
    SIGNAL led : std_logic_vector (7 DownTo 0) := "00000000";
    SIGNAL an : std_logic_vector (3 DownTo 0) := "0000";
    SIGNAL ssg : std_logic_vector (7 DownTo 0) := "00000000";

    BEGIN
        UUT : entidad
        PORT MAP (
            mclk => mclk,
            btn => btn,
            swt => swt,
            led => led,
            an => an,
            ssg => ssg
        );

        PROCESS
            BEGIN
                -- -------------  Current Time:  100ns
                WAIT FOR 100 ns;
                swt <= "00100010";
                -- -------------------------------------
                WAIT FOR 900 ns;

            END PROCESS;

    END testbench_arch;

