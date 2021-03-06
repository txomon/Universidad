--------------------------------------------------------------------------------
-- Copyright (c) 1995-2007 Xilinx, Inc.
-- All Right Reserved.
--------------------------------------------------------------------------------
--   ____  ____ 
--  /   /\/   / 
-- /___/  \  /    Vendor: Xilinx 
-- \   \   \/     Version : 9.2i
--  \   \         Application : ISE
--  /   /         Filename : simulacion.vhw
-- /___/   /\     Timestamp : Thu Nov 04 14:19:51 2010
-- \   \  /  \ 
--  \___\/\___\ 
--
--Command: 
--Design Name: simulacion
--Device: Xilinx
--

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.STD_LOGIC_TEXTIO.ALL;
USE STD.TEXTIO.ALL;

ENTITY simulacion IS
END simulacion;

ARCHITECTURE testbench_arch OF simulacion IS
    FILE RESULTS: TEXT OPEN WRITE_MODE IS "results.txt";

    COMPONENT Placa
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
    constant OFFSET : time := 200 ns;

    BEGIN
        UUT : Placa
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
                -- -------------  Current Time:  200ns
                WAIT FOR 200 ns;
                swt <= "00000001";
                -- -------------------------------------
                -- -------------  Current Time:  285ns
                WAIT FOR 85 ns;
                btn <= "0001";
                -- -------------------------------------
                -- -------------  Current Time:  685ns
                WAIT FOR 400 ns;
                btn <= "0000";
                -- -------------------------------------
                -- -------------  Current Time:  4685ns
                WAIT FOR 4000 ns;
                swt <= "00000011";
                -- -------------------------------------
                -- -------------  Current Time:  76885ns
                WAIT FOR 72200 ns;
                swt <= "00000001";
                -- -------------------------------------
                WAIT FOR 23315 ns;

            END PROCESS;

    END testbench_arch;

