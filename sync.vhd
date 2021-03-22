library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity sync is
	port (CLK : in std_logic;  
	HSYNC, VSYNC : out std_logic;
	R, G, B : out std_logic_vector ( 3 downto 0 ));
end sync;

architecture main of sync is	   
signal HPOS : integer range 0 to 1688:=0;
signal VPOS : integer range 0 to 1066:=0;
begin
process(CLK)	
begin
	if(CLK = '1') AND (CLK'EVENT) then	
		
		if ( HPOS > 1048) or ( VPOS <554) then	
			R<=(others=>'1'); 
			G<=(others=>'1');
			B<=(others=>'1');
		else
			R<=(others=>'0');
			R<=(others=>'0');
			R<=(others=>'0');
		end if;
		
		
		
		if( HPOS < 1688 ) then
			HPOS <= HPOS + 1;
		else  
			HPOS<=0;
			if( VPOS < 1066 ) then
				VPOS <= VPOS + 1;
			else
				VPOS <= 0;
			end if;
		end if;	 	 
		
		
		if ( HPOS > 48 ) and ( HPOS < 160 ) then
			HSYNC <= '0';
		else
			HSYNC <= '1';
		end if;		
		
		
		if ( VPOS > 0 ) and ( VPOS < 4 ) then
			VSYNC <= '0';
		else
			VSYNC <= '1';
		end if;	
		
		
		if(( HPOS > 0 ) and ( HPOS < 408 )) or ((VPOS > 0 ) and ( VPOS < 42)) then
			R <= (OTHERS=>'0');	   
			G <= (OTHERS=>'0');
			B <= (OTHERS=>'0');
		end if;
			
	end if;		
end process;
end main;
