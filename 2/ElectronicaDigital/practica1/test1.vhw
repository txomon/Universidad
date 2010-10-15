--------------------------------------------------------------------------------
-- Copyright (c) 1995-2007 Xilinx, Inc.
-- All Right Reserved.
--------------------------------------------------------------------------------
--   ____  ____ 
--  /   /\/   / 
-- /___/  \  /    Vendor: Xilinx 
-- \   \   \/     Version : 9.2i
--  \   \         Application : ISE
--  /   /         Filename : test1.vhw
-- /___/   /\     Timestamp : Fri Oct 01 15:42:19 2010
-- \   \  /  \ 
--  \___\/\___\ 
--
--Command: 
--Design Name: test1
--Device: Xilinx
--

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.STD_LOGIC_TEXTIO.ALL;
USE STD.TEXTIO.ALL;

ENTITY test1 IS
END test1;

ARCHITECTURE testbench_arch OF test1 IS
    FILE RESULTS: TEXT OPEN WRITE_MODE IS "results.txt";

    COMPONENT practica1
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

    constant PERIOD : time := 200 ns;
    constant DUTY_CYCLE : real := 0.5;
    constant OFFSET : time := 100 ns;

    BEGIN
        UUT : practica1
        PORT MAP (
            mclk => mclk,
            btn => btn,
            swt => swt,
            led => led,
            an => an,
            ssg => ssg
        );

        PROCESS    -- clock process for mclk
        BEGIN
            WAIT for OFFSET;
            CLOCK_LOOP : LOOP
                mclk <= '0';
                WAIT FOR (PERIOD - (PERIOD * DUTY_CYCLE));
                mclk <= '1';
                WAIT FOR (PERIOD * DUTY_CYCLE);
            END LOOP CLOCK_LOOP;
        END PROCESS;

        PROCESS
            BEGIN
                -- -------------  Current Time:  185ns
                WAIT FOR 185 ns;
                btn <= "0001";
                -- -------------------------------------
                -- -------------  Current Time:  385ns
                WAIT FOR 200 ns;
                btn <= "0010";
                -- -------------------------------------
                -- -------------  Current Time:  585ns
                WAIT FOR 200 ns;
                btn <= "0011";
                -- -------------------------------------
                -- -------------  Current Time:  785ns
                WAIT FOR 200 ns;
                btn <= "0100";
                -- -------------------------------------
                -- -------------  Current Time:  985ns
                WAIT FOR 200 ns;
                btn <= "0101";
                -- -------------------------------------
                -- -------------  Current Time:  1185ns
                WAIT FOR 200 ns;
                btn <= "0110";
                -- -------------------------------------
                -- -------------  Current Time:  1385ns
                WAIT FOR 200 ns;
                btn <= "0111";
                -- -------------------------------------
                WAIT FOR 415 ns;

            END PROCESS;

    END testbench_arch;

