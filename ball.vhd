library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

package b is	  
	procedure ball( signal hPos, vPos, hSet, vSet : in integer; signal R,G,B : out std_logic; signal COLOR : in std_logic_vector (1 downto 0));
end b;

package body b is
	procedure ball( signal hPos, vPos, hSet, vSet : in integer;  signal R,G,B : out std_logic; signal COLOR : in std_logic_vector (1 downto 0)) is
	begin
		if((hset * 2 * hpos - (hpos * hpos) + vset*2 * vpos - (vpos * vpos)) > 157696) then
			if(COLOR = "00")  then
				R<='1';
				G<='0';
				B<='0';
	     elsif(COLOR = "01")  then
				R<='0';			
				G<='1';
				B<='0';
		elsif(COLOR = "10")  then
				R<='0';			
				G<='0';
				B<='1';
		elsif(COLOR = "11")  then
				R<='1';			
				G<='1';
				B<='1';
		end if;
		  else
			R<='0';			
			G<='0';
			B<='0';
		end if;	  
	end procedure ball;
end b;
