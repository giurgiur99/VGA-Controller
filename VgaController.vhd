library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;
use ieee.std_logic_textio.all;
use std.textio.all;	 
use work.sq.all;
use work.line.all;
use work.b.all;
use work.tr.all;
use work.countAndSync.all; 
use work.movement.all;

entity vga_driver is
    Port ( CLK : in  STD_LOGIC;
           RST : in  STD_LOGIC;
           HSYNC : inout  STD_LOGIC;
           VSYNC : inout  STD_LOGIC;
		   UP : in STD_LOGIC;
		   DOWN : in STD_LOGIC;
		   LEFT : in STD_LOGIC;
		   RIGHT : in STD_LOGIC;
		   SELECTION : in STD_LOGIC_VECTOR ( 1 downto 0);
		   COLOR : in STD_LOGIC_VECTOR ( 1 downto 0);
			R : inout STD_LOGIC ; 
			G : inout STD_LOGIC ; 
			B : inout STD_LOGIC); 
end vga_driver;

architecture Behavioral of vga_driver is

	signal clk25 : std_logic := '0';
	
	constant HD : integer := 639;  --  639   Horizontal Display (640)
	constant HFP : integer := 16;         --   16   Right border (front porch)
	constant HSP : integer := 96;       --   96   Sync pulse (Retrace)
	constant HBP : integer := 48;        --   48   Left boarder (back porch)
	
	constant VD : integer := 479;   --  479   Vertical Display (480)
	constant VFP : integer := 10;       	 --   10   Right border (front porch)
	constant VSP : integer := 2;				 --    2   Sync pulse (Retrace)
	constant VBP : integer := 33;       --   33   Left boarder (back porch)	  
	
	signal hPos : integer := 0;
	signal vPos : integer := 0;
	
	signal videoOn : std_logic := '0';
	
	signal startH : integer := HD/2;
	signal startV : integer := VD/2;
	
	signal ballH : integer := HD/2;
	signal ballV : integer := VD/2;
	
	begin

	clk_div:process(CLK)
	begin
		if(CLK'event and CLK = '1')then
			clk25 <= not clk25;
		end if;
	end process; 

	sync : process(clk25,RST,hPos,vPos,HSYNC,VSYNC, videoOn)
	begin
		Horizontal_position_counter (clk25,RST,hPos,vPos);
		Vertical_position_counter(clk25, RST, hPos, vPos);	 
		Horizontal_Synchronisation  (clk25, RST, hPos, vPos, HSYNC);
		Vertical_Synchronisation(clk25, RST, hPos, vPos, VSYNC);
		video_on(clk25, RST, hPos, vPos, videoOn);
	end process;

	drawing : process(clk25, RST, hPos, vPos, videoOn, UP, DOWN, LEFT, RIGHT, startH, startV)	
	begin 	
	position (clk25, UP, DOWN, LEFT, RIGHT, startV,startH);
	if(RST = '1') then
	    R<='0';
		G<='0';
		B<='0';
	 elsif(clk25'event and clk25 = '1')then
		if(videoOn = '1') then 
			if(SELECTION = "00") then 
				square(hPos, vPos, startH, startV,R,G,B,COLOR);
			elsif (SELECTION = "01") then
				lines(hPos, vPos, startH, startV, R, G, B, COLOR);
			elsif (SELECTION = "10") then
				ball(hPos, vPos, startH, startV, R, G, B, COLOR);
			elsif (SELECTION = "11") then	 
				triangle(hPos, vPos, startH, startV, R, G, B, COLOR);
			end if;
		end if;
	end if;
	end process; 
	
	
	--------------------------------------------------------------------------------------------

test :process (clk25)
    file file_pointer: text is out "write.txt";
    variable line_el: line;
begin

    if rising_edge(clk25) then

        -- Write the time
        write(line_el, now); -- write the line.
        write(line_el, ":"); -- write the line.

        -- Write the hsync
        write(line_el, " ");
        write(line_el, hsync); -- write the line.

        -- Write the vsync
        write(line_el, " ");
        write(line_el, vsync); -- write the line.

        -- Write the red
        write(line_el, " ");
        write(line_el, R); -- write the line.
	    write(line_el, 0); -- write the line.
		write(line_el, 0); -- write the line.
		  

        -- Write the green
        write(line_el, " ");
        write(line_el, G); -- write the line. 
		write(line_el, 0); -- write the line.
		write(line_el, 0); -- write the line.

        -- Write the blue
        write(line_el, " ");
        write(line_el, B); -- write the line.  
		write(line_el, 0); -- write the line.

        writeline(file_pointer, line_el); -- write the contents into the file.

    end if;
end process test;

-------------------------------------------------------------------------------------------------
--

end Behavioral;

