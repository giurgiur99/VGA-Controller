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
	
	signal startH : integer := 320;
	signal startV : integer := 240;
	
	signal ballH : integer := 320;
	signal ballV : integer := 240;
	
	signal R1,G1,B1 : std_logic;
	
	signal x : integer :=320;
	signal y : integer :=240;
	signal lastUP, lastDOWN, lastLEFT, lastRIGHT : std_logic :='0';

begin


clk_div:process(CLK)
begin
	if(CLK'event and CLK = '1')then
		clk25 <= not clk25;
	end if;
end process;

Horizontal_position_counter:process(clk25, RST)
begin
	if(RST = '1')then
		hpos <= 0;
	elsif(clk25'event and clk25 = '1')then
		if (hPos = (HD + HFP + HSP + HBP)) then
			hPos <= 0;
		else
			hPos <= hPos + 1;
		end if;
	end if;
end process;

Vertical_position_counter:process(clk25, RST, hPos)
begin
	if(RST = '1')then
		vPos <= 0;
	elsif(clk25'event and clk25 = '1')then
		if(hPos = (HD + HFP + HSP + HBP))then
			if (vPos = (VD + VFP + VSP + VBP)) then
				vPos <= 0;
			else
				vPos <= vPos + 1;
			end if;
		end if;
	end if;
end process;

Horizontal_Synchronisation:process(clk25, RST, hPos)
begin
	if(RST = '1')then
		HSYNC <= '0';
	elsif(clk25'event and clk25 = '1')then
		if((hPos <= (HD + HFP)) OR (hPos > HD + HFP + HSP))then
			HSYNC <= '1';
		else
			HSYNC <= '0';
		end if;
	end if;
end process;

Vertical_Synchronisation:process(clk25, RST, vPos)
begin
	if(RST = '1')then
		VSYNC <= '0';
	elsif(clk25'event and clk25 = '1')then
		if((vPos <= (VD + VFP)) OR (vPos > VD + VFP + VSP))then
			VSYNC <= '1';
		else
			VSYNC <= '0';
		end if;
	end if;
end process;

video_on:process(clk25, RST, hPos, vPos)
begin
	if(RST = '1')then
		videoOn <= '0';
	elsif(clk25'event and clk25 = '1')then
		if(hPos <= HD and vPos <= VD)then
			videoOn <= '1';
		else
			videoOn <= '0';
		end if;
	end if;
end process;


--draw:process(clk25, RST, hPos, vPos, videoOn)
--begin
--	if(RST = '1')then
--		R <= '0';
--		G <= '0';
--		B <= '0';
--	elsif(clk25'event and clk25 = '1')then
--		if(videoOn = '1')then
--			if((hPos >= 10 and hPos <= 60) AND (vPos >= 10 and vPos <= 60))then
--				R <= '1';
--				G <= '1';
--				B <= '1';
--			else
--				R <= '0';
--				G <= '0';
--				B <= '0';
--			end if;
--		else
--			R <= '0';
--			G <= '0';
--			B <= '0';
--		end if;
--	end if;
--end process;

	colorSet : process(clk25, COLOR)	
	begin
	if(clk25'event and clk25 = '1')then
			if(COLOR = "00")  then
				R1<='1';
				G1<='0';
				B1<='0';
			elsif(COLOR = "01")  then
				R1<='0';			
				G1<='1';
				B1<='0';
			elsif(COLOR = "10")  then
				R1<='0';			
				G1<='0';
				B1<='1';
			elsif(COLOR = "11")  then
				R1<='1';			
				G1<='1';
				B1<='1';
			end if;
	end if;
	end process;
		
	position : process(clk25, UP, DOWN, LEFT, RIGHT, X, Y)	
	begin
		if(clk25'event and clk25 = '1')then
	
			if(UP = '1' and lastUP = '0') then 
				X <= X - 5 ;
			elsif (DOWN = '1' and lastDOWN = '0') then
				X <= X + 5 ;
			elsif (LEFT = '1' and lastLEFT = '0') then
				Y <= Y - 5 ;
			elsif(RIGHT = '1' and lastRIGHT = '0') then 
				Y <= Y + 5 ; 
			end if;
			lastUP <= UP;
			lastDOWN <= DOWN;
			lastLEFT <= LEFT;
			lastRIGHT <= RIGHT;
		end if;
	end process;
		

	drawing : process(clk25, RST, hPos, vPos, videoOn, startH, startV, X, Y)	
	begin 	
	
	if(RST = '1') then
		R <= '0';
		G <= '0';
		B <= '0';
	elsif(clk25'event and clk25 = '1')then
			if(videoOn = '1') then
				if( SELECTION = "00") then
					if((hPos >= 10+Y and hPos <= 60+Y) AND (vPos >= 10+X and vPos <= 60+X))then
							R <= R1 ;
							G <= G1 ;
							B <= B1 ;
					else
							R <= '0';
							G <= '0';
							B <= '0';
					end if;
				elsif (SELECTION = "01") then
					if	((hPos > y - 5) and (hpos < y + 5) and (vPos > x - 30) and (vPos < x + 10)) or
					((hPos > y - 20) and (hpos < y + 20) and (vPos > x - 50) and (vPos < x + 10)) or 
					((hPos > y - 30) and (hpos < y + 30) and (vPos > x - 20) and (vPos < x + 10)) then
							R <= R1 ;
							G <= G1 ;
							B <= B1 ;
					else
							R <= '0';
							G <= '0';
							B <= '0';
					end if;
					
				elsif (SELECTION = "10") then
					if((hPos > y - 10) and (hpos < y + 10) and (vPos > x - 70) and (vPos < x + 70)) then
							R <= R1 ;
							G <= G1 ;
							B <= B1 ;
					else
							R <= '0';
							G <= '0';
							B <= '0';
				end if;
				
				elsif (SELECTION = "11") then
					if	((hPos > y - 10) and (hpos < y + 10) and (vPos > x - 70) and (vPos < x + 10)) or
						((hPos > y - 20) and (hpos < y + 20) and (vPos > x - 50) and (vPos < x + 10)) or 
						((hPos > y - 30) and (hpos < y + 30) and (vPos > x -20 ) and (vPos < x + 10)) then
							R <= R1 ;
							G <= G1 ;
							B <= B1 ;
					else
							R <= '0';
							G <= '0';
							B <= '0';
				end if;
				end if;
			end if;
	end if;
	end process; 
	
	
--	--------------------------------------------------------------------------------------------
--
--test :process (clk25)
--    file file_pointer: text is out "write.txt";
--    variable line_el: line;
--begin
--
--    if rising_edge(clk25) then
--
--        -- Write the time
--        write(line_el, now); -- write the line.
--        write(line_el, ":"); -- write the line.
--
--        -- Write the hsync
--        write(line_el, " ");
--        write(line_el, hsync); -- write the line.
--
--        -- Write the vsync
--        write(line_el, " ");
--        write(line_el, vsync); -- write the line.
--
--        -- Write the red
--        write(line_el, " ");
--        write(line_el, R); -- write the line.
--	    write(line_el, 0); -- write the line.
--		write(line_el, 0); -- write the line.
--		  
--
--        -- Write the green
--        write(line_el, " ");
--        write(line_el, G); -- write the line. 
--		write(line_el, 0); -- write the line.
--		write(line_el, 0); -- write the line.
--
--        -- Write the blue
--        write(line_el, " ");
--        write(line_el, B); -- write the line.  
--		write(line_el, 0); -- write the line.
--
--        writeline(file_pointer, line_el); -- write the contents into the file.
--
--    end if;
--end process test;
--
---------------------------------------------------------------------------------------------------
----

end Behavioral;

