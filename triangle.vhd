library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

package tr is
	procedure triangle(  signal hPos, vPos, hSet, vSet : in integer; signal R,G,B : out std_logic; signal COLOR : in std_logic_vector (1 downto 0));
end tr;

package body tr is
	procedure triangle( signal hPos, vPos, hSet, vSet : in integer; signal R,G,B : out std_logic; signal COLOR : in std_logic_vector (1 downto 0)) is
	begin  		
		if	((hPos > hSet - 5) and (hpos < hSet + 5) and (vPos > vSet - 60) and (vPos < vSet + 10)) or
			((hPos > hSet - 10) and (hpos < hSet + 10) and (vPos > vSet - 50) and (vPos < vSet + 10)) or 
			((hPos > hSet - 15) and (hpos < hSet + 15) and (vPos > vSet - 40) and (vPos < vSet + 10)) or
			((hPos > hSet - 20) and (hpos < hSet + 20) and (vPos > vSet - 30) and (vPos < vSet + 10)) or
			((hPos > hSet - 25) and (hpos < hSet + 25) and (vPos > vSet - 20) and (vPos < vSet + 10)) or
			((hPos > hSet - 30) and (hpos < hSet + 30) and (vPos > vSet - 10) and (vPos < vSet + 10)) or
			((hPos > hSet - 35) and (hpos < hSet + 35) and (vPos > vSet - 0) and (vPos < vSet + 10)) then
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
	end procedure triangle;
end tr;
