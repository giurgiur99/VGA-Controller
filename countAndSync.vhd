library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

package countAndSync is	  
	procedure Horizontal_position_counter (signal clk25 : in std_logic; signal RST : in std_logic; signal hPos : inout integer; signal vPos : inout integer);
	procedure Vertical_position_counter	 (signal clk25 : in std_logic; signal RST : in std_logic; signal hPos : inout integer; signal vPos : inout integer);
	procedure Horizontal_Synchronisation  (signal clk25 : in std_logic; signal RST : in std_logic; signal hPos : inout integer; signal vPos : inout integer ; signal HSYNC : out std_logic);
	procedure Vertical_Synchronisation	 (signal clk25 : in std_logic; signal RST : in std_logic; signal hPos : inout integer; signal vPos : inout integer; signal VSYNC : out std_logic);
	procedure video_on	(signal clk25 : in std_logic ; signal RST : in std_logic ;  signal hPos : inout integer ; signal vPos : inout integer ; signal videoOn : out std_logic);
	
end countAndSync;

package body countAndSync is 
	
	constant HD : integer := 639;  --  639   Horizontal Display (640)
	constant HFP : integer := 16;         --   16   Right border (front porch)
	constant HSP : integer := 96;       --   96   Sync pulse (Retrace)
	constant HBP : integer := 48;        --   48   Left boarder (back porch)
	
	constant VD : integer := 479;   --  479   Vertical Display (480)
	constant VFP : integer := 10;       	 --   10   Right border (front porch)
	constant VSP : integer := 2;				 --    2   Sync pulse (Retrace)
	constant VBP : integer := 33;       --   33   Left boarder (back porch)	 
	
	procedure Horizontal_position_counter (signal clk25 : in std_logic; signal RST : in std_logic; signal hPos : inout integer; signal vPos : inout integer) is
	begin
	if(clk25'event and clk25 = '1')then
		if (hPos = (HD + HFP + HSP + HBP)) then
			hPos <= 0;
		else
			hPos <= hPos + 1;
		end if;
	end if;
	end procedure;

	procedure Vertical_position_counter	 (signal clk25 : in std_logic; signal RST : in std_logic; signal hPos : inout integer; signal vPos : inout integer) is
	begin 
	if(clk25'event and clk25 = '1')then
		if(hPos = (HD + HFP + HSP + HBP))then
			if (vPos = (VD + VFP + VSP + VBP)) then
				vPos <= 0;
			else
				vPos <= vPos + 1;
			end if;
		end if;	
	end if;
	end procedure;

	procedure Horizontal_Synchronisation  (signal clk25 : in std_logic; signal RST : in std_logic; signal hPos : inout integer; signal vPos : inout integer ; signal HSYNC : out std_logic) is
	begin
	if(clk25'event and clk25 = '1')then
		if((hPos <= (HD + HFP)) OR (hPos > HD + HFP + HSP))then
			HSYNC <= '1';
		else
			HSYNC <= '0';
		end if;
	end if;
	end procedure;

	procedure Vertical_Synchronisation	 (signal clk25 : in std_logic; signal RST : in std_logic; signal hPos : inout integer; signal vPos : inout integer; signal VSYNC : out std_logic) is
	begin
	if(clk25'event and clk25 = '1')then
		if((vPos <= (VD + VFP)) OR (vPos > VD + VFP + VSP))then
			VSYNC <= '1';
		else
			VSYNC <= '0';
		end if;
	end if;
	end procedure;
	
	procedure video_on(signal clk25 : in std_logic ; signal RST : in std_logic ; signal hPos : inout integer ; signal vPos : inout integer ; signal videoOn : out std_logic) is
	begin
	if (clk25'event and clk25 = '1') then
		if(hPos <= HD and vPos <= VD)then
			videoOn <= '1';
		else
			videoOn <= '0';
		end if;
	end if;
	end procedure;
	
end countAndSync;
