library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.ALL;

entity datapath_k is 
    port(
        i_clk: in std_logic;
        i_rst: in std_logic;
        i_k: in std_logic_vector(9 downto 0);
        o_end: out std_logic;
        
        r1_sel: in std_logic;
        r1_load: in std_logic
        );
end datapath_k;

architecture datapath_k_arch of datapath_k is
signal o_reg1: std_logic_vector(10 downto 0);
signal mux_reg1: std_logic_vector(10 downto 0);
signal sum: std_logic_vector(10 downto 0);
signal sub: std_logic_vector(10 downto 0);

begin
    sum <= std_logic_vector(signed('0' & i_k) + signed('0' & i_k));
    sub <= std_logic_vector(signed(o_reg1) - 1); 
    o_end <= '1' when (o_reg1 = "00000000000") else '0';
    
    mux_reg1 <= sum when r1_sel = '0' else
                sub when r1_sel = '1' else
                "XXXXXXXXXXX";
    
    process(i_clk, i_rst)
    begin
        if(i_rst = '1')then
            o_reg1 <= "11111111111";
        elsif i_clk'event and i_clk = '1' then 
            if(r1_load = '1') then
            o_reg1 <= mux_reg1;
            end if;                    
        end if;
    end process;
end datapath_k_arch;


library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.ALL;

entity datapath_data is 
    port(
        i_clk: in std_logic;
        i_rst: in std_logic;
        i_mem_data: in std_logic_vector(7 downto 0);
        o_mem_data: out std_logic_vector(7 downto 0);
        c_zero: out std_logic;
        r2_load: in std_logic;
        r3_load: in std_logic
        );
end datapath_data;

architecture datapath_data_arch of datapath_data is
signal o_reg2: std_logic_vector(7 downto 0);
signal o_reg3: std_logic_vector(7 downto 0);

begin
o_mem_data <= o_reg3;
c_zero <= '1' when o_reg2 = "00000000" else '0';

    process(i_clk, i_rst)
    begin
        if(i_rst = '1')then
            o_reg2 <= "11111111";
        elsif i_clk'event and i_clk = '1' then
            if(r2_load = '1') then
                o_reg2 <= i_mem_data;
            else
            --do nothing
            end if;
        end if;
    end process;
    
    process(i_clk, i_rst)
    begin
        if(i_rst = '1')then
            o_reg3 <= "00000000";
        elsif i_clk'event and i_clk = '1' then
            if(r3_load = '1') then
                o_reg3 <= o_reg2;
            else
                --do nothing
            end if;
        end if;
    end process;
    
end datapath_data_arch;



library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.ALL;
entity datapath_address is 
    port(
        i_clk: in std_logic;
        i_rst: in std_logic;
        i_add: in std_logic_vector(15 downto 0);
        o_mem_addr: out std_logic_vector(15 downto 0);
                
        r5_sel: in std_logic;
        r5_load: in std_logic
        );
end datapath_address;
architecture datapath_address_arch of datapath_address is
signal o_reg5: std_logic_vector(15 downto 0);
signal mux_reg5: std_logic_vector(15 downto 0);
signal sum: std_logic_vector(15 downto 0);

begin
sum <= std_logic_vector(signed(o_reg5) + 1);
o_mem_addr <= o_reg5;

mux_reg5 <= i_add when r5_sel = '0' else
            sum when r5_sel = '1' else
            "XXXXXXXXXXXXXXXX";

    process(i_clk, i_rst)
    begin
        if(i_rst = '1')then
            o_reg5 <= "0000000000000000";
        elsif i_clk'event and i_clk = '1' then
            if(r5_load = '1') then
            o_reg5 <= mux_reg5;
            end if;
        end if;
    end process;       
    
end datapath_address_arch;



library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.ALL;
entity datapath_credibility is 
    port(
        i_clk: in std_logic;
        i_rst: in std_logic;
        o_mem_data: out std_logic_vector(7 downto 0);
        c_sel1: in std_logic;
        c_sel2: out std_logic;
                
        r4_sel: in std_logic;
        r4_load: in std_logic
        );
end datapath_credibility;
architecture datapath_credibility_arch of datapath_credibility is
signal mux_c_sel: std_logic_vector(7 downto 0);
signal mux_reg4: std_logic_vector(7 downto 0);
signal o_reg4: std_logic_vector(7 downto 0);
signal sub: std_logic_vector(7 downto 0);

begin
sub <= std_logic_vector(signed(o_reg4) - 1);   
c_sel2 <= '1' when (o_reg4 = "00000000") else '0';
o_mem_data <= o_reg4;

mux_c_sel <= "00011111" when c_sel1 = '0' else
             "00000000" when c_sel1 = '1' else
             "XXXXXXXX";
mux_reg4 <= mux_c_sel when r4_sel = '0' else
            sub when r4_sel = '1' else
            "XXXXXXXX";                         

    process(i_clk, i_rst)
    begin
        if(i_rst = '1')then
            o_reg4 <= "00010001";
        elsif i_clk'event and i_clk = '1' then
            if(r4_load = '1') then
                o_reg4 <= mux_reg4;
            end if;
        end if;
    end process;
    
end datapath_credibility_arch;



library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.ALL;
use std.textio.ALL;

entity project_reti_logiche is
    port(
        i_clk: in std_logic;
        i_rst: in std_logic;
        i_start: in std_logic;
        i_add: in std_logic_vector(15 downto 0);
        i_k: in std_logic_vector(9 downto 0);
        
        o_done: out std_logic;
        
        o_mem_addr: out std_logic_vector(15 downto 0);
        i_mem_data: in std_logic_vector(7 downto 0);
        o_mem_data: out std_logic_vector(7 downto 0);
        o_mem_we: out std_logic;
        o_mem_en: out std_logic 
        );
end project_reti_logiche;
architecture project_arch of project_reti_logiche is

component datapath_k is
 port(
        i_clk: in std_logic;
        i_rst: in std_logic;
        i_k: in std_logic_vector(9 downto 0);
        o_end: out std_logic;
        
        r1_sel: in std_logic;
        r1_load: in std_logic
        );
end component;

component datapath_data is
    port(
        i_clk: in std_logic;
        i_rst: in std_logic;
        i_mem_data: in std_logic_vector(7 downto 0);
        o_mem_data: out std_logic_vector(7 downto 0);
        c_zero: out std_logic;  
        
        r2_load: in std_logic;
        r3_load: in std_logic
        );
end component;

component datapath_credibility is
    port(
        i_clk: in std_logic;
        i_rst: in std_logic;
        o_mem_data: out std_logic_vector(7 downto 0);
        c_sel1: in std_logic;
        c_sel2: out std_logic;
        
        r4_sel: in std_logic;
        r4_load: in std_logic
        );
end component;

component datapath_address is
    port(
        i_clk: in std_logic;
        i_rst: in std_logic;
        i_add: in std_logic_vector(15 downto 0);
        o_mem_addr: out std_logic_vector(15 downto 0);
        
        r5_sel: in std_logic;
        r5_load: in std_logic
        );
end component;

signal r1_load: std_logic;
signal r2_load: std_logic;
signal r3_load: std_logic;
signal r4_load: std_logic;
signal r5_load: std_logic;
signal r1_sel: std_logic;
signal r4_sel: std_logic;
signal r5_sel: std_logic;
signal o_end: std_logic;
signal c_zero: std_logic;
signal c_sel1: std_logic;
signal c_sel2: std_logic;

signal o_mem_credibility: std_logic_vector(7 downto 0);
signal o_mem_value: std_logic_vector(7 downto 0);

type S is (S0, S1, S2, S3, S4, S5, S6, S7, S8, S9, S10, S11, S12, S13, S14, S15,
S16, S17, S18, S19, S20, S21, S22, S23, S24, S25, S26, S27, S28);
signal curr_state, next_state: S;

begin
DATAPATH1: datapath_k port map(
    i_clk => i_clk,
    i_rst => i_rst,
    i_k => i_k,
    o_end => o_end,
        
    r1_sel => r1_sel,
    r1_load => r1_load
);

DATAPATH2: datapath_data port map(
    i_clk => i_clk,
    i_rst => i_rst,
    i_mem_data => i_mem_data,
    o_mem_data => o_mem_value,
    c_zero => c_zero,  
        
    r2_load => r2_load,
    r3_load => r3_load
);

DATAPATH3: datapath_credibility port map(
    i_clk => i_clk,
    i_rst => i_rst,
    o_mem_data => o_mem_credibility,
    c_sel1 => c_sel1,
    c_sel2 => c_sel2,
        
    r4_sel => r4_sel,
    r4_load => r4_load
);

DATAPATH4: datapath_address port map(
    i_clk => i_clk,
    i_rst => i_rst,
    i_add => i_add,
    o_mem_addr => o_mem_addr,
        
    r5_sel => r5_sel,
    r5_load => r5_load
);

process(i_clk, i_rst)
begin
    if(i_rst = '1') then
        curr_state <= S0;
    elsif i_clk'event and i_clk = '1' then
        curr_state <= next_state;
    end if;
end process;

process(curr_state, i_start, i_rst, o_end)
begin
    next_state <= curr_state;
    case curr_state is
        when S0 =>
            if (i_rst = '0' and i_start = '1') then
            next_state <= S1;
            end if;
        when S1 =>
            next_state <= S2;
        when S2 =>
            if o_end = '0' then
            next_state <= S4;
            else
            next_state <= S3;
            end if;
        when S3 =>
            if i_start = '0' then
            next_state <= S0;
            else
            -- do nothing
            end if;
        when S4 =>
            next_state <= S5;
        when S5 =>
            next_state <= S6;
        when S6 =>
            next_state <= S7;
        when S7 =>
            next_state <= S8;
        when S8 =>
            next_state <= S9;
        when S9 =>
            next_state <= S10;
        when S10 =>
            if c_zero = '0' then
            next_state <= S11;
            else
            next_state <= S12;
            end if;
        when S11 =>
            next_state <= S13;
        when S12 =>
            next_state <= S13;        
        when S13 =>
            next_state <= S14;
        when S14 =>
            next_state <= S15;    
        when S15 =>
            if o_end = '1' then
            next_state <= S3;
            else
            next_state <= S16;
            end if;
        when S16 =>
            next_state <= S17;
        when S17 =>
            next_state <= S18;
        when S18 =>
            next_state <= S19;
        when S19 =>
            next_state <= S20;
        when S20 =>
        if c_zero = '1' then
            next_state <= S22;
            else
            next_state <= S21;
            end if;
        when S21 =>
            next_state <= S6;
        when S22 =>
            next_state <= S23;
        when S23 =>
            next_state <= S24;
        when S24 =>
            next_state <= S25;
        when S25 =>
            if c_sel2 = '1' then
            next_state <= S27;
            else
            next_state <= S26;
            end if;
        when S26 =>
            next_state <= S28;
        when S27 =>
            next_state <= S28;
        when S28 =>
            next_state <= S14;            
                                                                                            
    end case;
end process;


process (curr_state)
begin
r1_load <= '0';
r2_load <= '0';
r3_load <= '0';
r4_load <= '0';
r5_load <= '0';
r1_sel <= '0';
r4_sel <= '0';
r5_sel <= '0';
c_sel1 <= '0';
o_done <= '0';
o_mem_we <= '0';
o_mem_en <= '0';

o_mem_data <= (others => '0');                                                    

        
case curr_state is
    when S0 =>
        o_done <= '0';
    when S1 =>
        r1_sel <= '0';
        r1_load <= '1';
        r5_sel <= '0';
        r5_load <= '1';
    when S2 =>
    when S3 =>
        o_done <= '1';
    when S4 =>
        o_mem_en <= '1';
        o_mem_we <= '0';
    when S5 =>
        r2_load <= '1';
    when S6 =>
        r3_load <= '1';
    when S7 =>
        -- o_mem_en <= '1';
        -- o_mem_we <= '1';
        r1_sel <= '1';
        r1_load <= '1';
    when S8 =>
        o_mem_data <= o_mem_value;
        o_mem_en <= '1';
        o_mem_we <= '1';
    when S9 =>
        r5_sel <= '1';
        r5_load <= '1';
    when S10 =>
        o_mem_en <= '1';
        o_mem_we <= '0';
    when S11 =>
        c_sel1 <= '0';
        r4_sel <= '0';
        r4_load <= '1';
    when S12 =>
        c_sel1 <= '1';
        r4_sel <= '0';
        r4_load <= '1';
    when S13 =>
        r1_sel <= '1';
        r1_load <= '1';
    when S14 =>
        o_mem_data <= o_mem_credibility;
        o_mem_en <= '1';
        o_mem_we <= '1';
    when S15 =>
    when S16 =>
        r5_sel <= '1';
        r5_load <= '1';
    when S17 =>
        o_mem_en <= '1';
        o_mem_we <= '0';
    when S18 =>
        r2_load <= '1';
    when S19 =>
    when S20 =>
    when S21 =>
    when S22 =>
        r1_sel <= '1';
        r1_load <= '1';
    when S23 =>
        o_mem_data <= o_mem_value;
        o_mem_en <= '1';
        o_mem_we <= '1';
    when S24 =>
        r5_sel <= '1';
        r5_load <= '1';
    when S25 =>
        o_mem_en <= '1';
        o_mem_we <= '0';
    when S26 =>
        r4_sel <= '1';
        r4_load <= '1';
    when S27 =>
        c_sel1 <= '1';
        r4_sel <= '0';
        r4_load <= '1';
    when S28 =>
        r1_sel <= '1';
        r1_load <= '1';
        
        
    when others =>
            -- Default case to avoid latches
            r1_load <= '0';
            r2_load <= '0';
            r3_load <= '0';
            r4_load <= '0';
            r5_load <= '0';
            r1_sel <= '0';
            r4_sel <= '0';
            r5_sel <= '0';
            c_sel1 <= '0';
            o_done <= '0';
            o_mem_we <= '0';
            o_mem_en <= '0';
            o_mem_data <= (others => '0');                                                    
        
                                                                     
 end case;
 end process;
 
end project_arch;





        