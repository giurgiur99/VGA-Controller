library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

package movement is 
	 procedure  position (signal clk25 : in std_logic; signal UP, DOWN, LEFT, RIGHT : in std_logic ; signal x,y : inout integer);
end movement;

package body movement is 
	
	procedure  position (signal clk25 : in std_logic; signal UP, DOWN, LEFT, RIGHT : in std_logic ; signal x,y : inout integer) is 
	begin
	
	if(UP'event and UP = '1') then 
		x <= x - 5 ;
	elsif (DOWN'event and DOWN = '1') then
		x <= x + 5 ;
	elsif (LEFT'event and LEFT = '1') then
		y <= y - 5 ;
	elsif(RIGHT'event and RIGHT = '1') then 
		y <= y + 5 ;  
	end if;	 
	end procedure;
	
end movement;