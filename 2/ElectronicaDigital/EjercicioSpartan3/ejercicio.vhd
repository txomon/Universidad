----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:49:46 12/22/2010 
-- Design Name: 
-- Module Name:    ejercicio - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


Library UNISIM;
use UNISIM.vcomponents.all;


---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ejercicio is
Port ( 
	clk : in std_logic;
	input_enable : in std_logic;
	x : in  STD_LOGIC_VECTOR (3 downto 0);
	y : out  STD_LOGIC_VECTOR (12 downto 0);
	rst : in std_logic);
end ejercicio;

architecture Behavioral of ejercicio is

signal Q	: std_logic_vector(3 downto 0);
signal input : std_logic;
signal n : std_logic_vector (10 downto 1);
signal sin : std_logic_vector(15 downto 0);
signal p1, p3 : std_logic_vector(35 downto 0);
signal a,a1,b1,b2 : std_logic_vector(17 downto 0);
signal nulium : std_logic_vector(1 downto 0);
signal ypas,ypasado :  STD_LOGIC_VECTOR (12 downto 0);

begin

process(clk)
begin
if rising_edge(clk) then
	if rst= '0' then
		if input_enable = '1' then
			input<='1';
			n<=n+1;
			ypasado<=ypas;
		else
			input<='0';
		end if;
	else
		n<=x"00"&"00";
	end if;
end if;
end process;

SRL160	:	SRL16

port map (
	Q => Q(0),       -- SRL data output
	A0 => '1',     -- Select[0] input
	A1 => '1',     -- Select[1] input
	A2 => '1',     -- Select[2] input
	A3 => '1',     -- Select[3] input
	CLK => input,   -- Clock input
	D => X(0)     -- SRL data input
);

SRL161	:	SRL16

port map (
	Q => Q(1),       -- SRL data output
	A0 => '1',     -- Select[0] input
	A1 => '1',     -- Select[1] input
	A2 => '1',     -- Select[2] input
	A3 => '1',     -- Select[3] input
	CLK => input,   -- Clock input
	D => X(1)        -- SRL data input
);

SRL162	:	SRL16	

port map (
	Q => Q(2),       -- SRL data output
	A0 => '1',     -- Select[0] input
	A1 => '1',     -- Select[1] input
	A2 => '1',     -- Select[2] input
	A3 => '1',     -- Select[3] input
	CLK => input,   -- Clock input
	D => X(2)        -- SRL data input
);

SRL163	:	SRL16

port map (
	Q => Q(3),       -- SRL data output
	A0 => '1',     -- Select[0] input
	A1 => '1',     -- Select[1] input
	A2 => '1',     -- Select[2] input
	A3 => '1',     -- Select[3] input
	CLK => input,   -- Clock input
	D => X(3)     -- SRL data input
);


---- He creado este pequeño programilla para calcular los valores del seno. hay que tener en cuenta, que los valores son los almacenados a partir de la
-- coma, ej: 0,1234 --> 04d2
--#define DEBUG
--#define PI 3.141592643141592653589793238
--#include <stdio.h>
--#include <math.h>
--#include <string.h>
--#include <malloc.h>
--
--#ifdef DEBUG
--char deb[]="[DEBUG]: ";
--#endif
--
--int main (int argc, char *args[])
--{
--	int num,actual_int;
--	double from,to,actual_float,distancia;
--	char *output,*temporalarg;
--	int x; /*Counters*/
--	int len; /*mid variables*/
--	FILE *file;
--#ifdef DEBUG
--fprintf(stderr,"%s We arrived to the initialization.\n",deb);
--#endif 
--	if(argc < 8)
--	{
--		fprintf(stderr,"\nYou haven't introduced minimum args: %d:\n",argc);
--		for(x=0;x<=argc;x++)
--			fprintf(stderr,"Arg #%d: %s\n",x,args[x]);
--		printf("The options of the program are:\n");
--		printf("\t-f\n\t\tAngle (specified in radians) from which the program will start (Needed)\n");
--		printf("\t-t\n\t\tAngle (specified in radians) up to the program will calculate (Needed)\n");
--		printf("\t-n\n\t\tNumber of angles you want at output (Needed)\n");
--		printf("\t-o\n\t\tName of the file output (Needed)\n");
--		printf("\t-h\n\t\tTo show this message\n");
--		return 1;
--	}
--	#ifdef DEBUG
--		fprintf(stderr,"%s We arrived to the argument's for loop.\n",deb);
--	#endif
--	for(x=1;x<argc;x++)
--	{
--		len=strlen(args[x]);
--		temporalarg=calloc(len+1,sizeof(char));
--		strcpy(temporalarg,args[x]);
--		#ifdef DEBUG
--			fprintf(stderr,"%s We passed the strcpy for temporal args:%s\n",deb,temporalarg);
--		#endif
--		if(temporalarg[0]!='-')
--		{
--			#ifdef DEBUG
--				fprintf(stderr,"%s We passed are checking if this is an option (with '-')\n",deb);
--			#endif
--			return 2;
--		}
--		switch(temporalarg[1])
--		{
--			case 'o':
--				x++;
--				len=strlen(args[x]);
--				output=calloc(len+1,sizeof(char));
--				strcpy(output,args[x]);
--				#ifdef DEBUG
--					fprintf(stderr,"%s We have stored this string in \"output\": %s\n",deb,output);
--				#endif
--				break;
--			case 't':
--				x++;
--				if(len==2)
--					to=PI;
--				else
--					return 2;
--				#ifdef DEBUG
--					fprintf(stderr,"%s We have stored this string \"%s\" as this number in 'to': %f\n",deb,args[x],to);
--				#endif
--				break;
--			case 'f':
--				x++;
--				len=strlen(args[x]);
--				from=0;
--				#ifdef DEBUG
--					fprintf(stderr,"%s We have stored this string \"%s\" as this number in 'from': %f\n",deb,args[x],from);
--				#endif
--				break;
--			case 'n':
--				x++;
--				num=atoi(args[x]);
--				#ifdef DEBUG
--					fprintf(stderr,"%s We have stored this string \"%s\" as this number in 'num': %d\n",deb,args[x],num);
--				#endif
--				break;
--
--		}
--	}
--	distancia=(to-from)/num;
--	file=fopen(output,"w");
--	for(x=0;x<num;x++)
--	{
--		actual_float=sin(from+x*distancia);
--		actual_int=actual_float*10000;
--		printf("%4.4x ",actual_int);
--		fprintf(file,"%4.4x",actual_int);
--		if(x%16-15==0)
--		{
--			fprintf(file,"\n");
--			printf("\n");
--		}
--	}
--	fclose(file);
--	return 0;
--}


-- Y con ello ha salido esto:


-- INIT_00 => X"0000001e003d005c007a009900b800d600f50114013201510170018e01ad01cc",
-- INIT_01 => X"01ea0209022702460265028302a202c102df02fe031c033b03590378039703b5",
-- INIT_02 => X"03d403f20411042f044e046c048b04a904c804e60504052305410560057e059c",
-- INIT_03 => X"05bb05d905f70616063406520671068f06ad06cb06ea07080726074407620780",
-- INIT_04 => X"079e07bc07db07f90817083508530871088f08ac08ca08e80906092409420960",
-- INIT_05 => X"097d099b09b909d609f40a120a2f0a4d0a6b0a880aa60ac30ae10afe0b1c0b39",
-- INIT_06 => X"0b560b740b910bae0bcc0be90c060c230c400c5d0c7b0c980cb50cd20cef0d0b",
-- INIT_07 => X"0d280d450d620d7f0d9c0db80dd50df20e0e0e2b0e480e640e810e9d0eba0ed6",
-- INIT_08 => X"0ef20f0f0f2b0f470f630f800f9c0fb80fd40ff0100c102810441060107c1097",
-- INIT_09 => X"10b310cf10ea11061122113d11591174119011ab11c611e211fd12181233124e",
-- INIT_0a => X"12691285129f12ba12d512f0130b13261340135b1376139013ab13c513e013fa",
-- INIT_0b => X"1415142f14491463147d149714b214cc14e514ff15191533154d15661580159a",
-- INIT_0c => X"15b315cd15e615ff16191632164b1664167e169716b016c916e116fa1713172c",
-- INIT_0d => X"1744175d1776178e17a717bf17d717f0180818201838185018681880189818b0",
-- INIT_0e => X"18c718df18f7190e1926193d1955196c1983199a19b219c919e019f71a0d1a24",
-- INIT_0f => X"1a3b1a521a681a7f1a961aac1ac21ad91aef1b051b1b1b311b471b5d1b731b89",
-- INIT_10 => X"1b9f1bb41bca1bdf1bf51c0a1c201c351c4a1c5f1c741c891c9e1cb31cc81cdc",
-- INIT_11 => X"1cf11d061d1a1d2f1d431d571d6b1d801d941da81dbc1dcf1de31df71e0b1e1e",
-- INIT_12 => X"1e321e451e581e6c1e7f1e921ea51eb81ecb1ede1ef11f031f161f281f3b1f4d",
-- INIT_13 => X"1f601f721f841f961fa81fba1fcc1fde1fef2001201320242035204720582069",
-- INIT_14 => X"207a208b209c20ad20be20ce20df20f021002110212121312141215121612171",
-- INIT_15 => X"2181219121a021b021bf21cf21de21ed21fc220b221a22292238224722562264",
-- INIT_16 => X"22732281228f229e22ac22ba22c822d622e422f122ff230d231a232823352342",
-- INIT_17 => X"234f235c2369237623832390239d23a923b623c223ce23db23e723f323ff240b",
-- INIT_18 => X"24162422242e243924452450245b24662471247c24872492249d24a824b224bd",
-- INIT_19 => X"24c724d124db24e624f024fa2503250d25172520252a2533253d2546254f2558",
-- INIT_1a => X"2561256a2573257b2584258c2595259d25a525ad25b525bd25c525cd25d525dc",
-- INIT_1b => X"25e425eb25f325fa26012608260f2616261d2623262a26302637263d26432649",
-- INIT_1c => X"264f2655265b26612667266c26722677267c26812687268c26912695269a269f",
-- INIT_1d => X"26a326a826ac26b026b526b926bd26c026c426c826cc26cf26d326d626d926dc",
-- INIT_1e => X"26df26e226e526e826eb26ed26f026f226f426f726f926fb26fd26ff27002702",
-- INIT_1f => X"27032705270627082709270a270b270c270c270d270e270e270f270f270f270f",
-- INIT_20 => X"2710270f270f270f270f270e270e270d270c270c270b270a2709270827062705",
-- INIT_21 => X"27032702270026ff26fd26fb26f926f726f426f226f026ed26eb26e826e526e2",
-- INIT_22 => X"26df26dc26d926d626d326cf26cc26c826c426c026bd26b926b526b026ac26a8",
-- INIT_23 => X"26a3269f269a26952691268c26872681267c26772672266c26672661265b2655",
-- INIT_24 => X"264f26492643263d26372630262a2623261d2616260f2608260125fa25f325eb",
-- INIT_25 => X"25e425dc25d525cd25c525bd25b525ad25a5259d2595258c2584257b2573256a",
-- INIT_26 => X"25612558254f2546253d2533252a25202517250d250324fa24f024e624db24d1",
-- INIT_27 => X"24c724bd24b224a8249d24922487247c24712466245b245024452439242e2422",
-- INIT_28 => X"2416240b23ff23f323e723db23ce23c223b623a9239d2390238323762369235c",
-- INIT_29 => X"234f234223352328231a230d22ff22f122e422d622c822ba22ac229e228f2281",
-- INIT_2a => X"227322642256224722382229221a220b21fc21ed21de21cf21bf21b021a02191",
-- INIT_2b => X"21812171216121512141213121212110210020f020df20ce20be20ad209c208b",
-- INIT_2c => X"207a20692058204720352024201320011fef1fde1fcc1fba1fa81f961f841f72",
-- INIT_2d => X"1f601f4d1f3b1f281f161f031ef11ede1ecb1eb81ea51e921e7f1e6c1e581e45",
-- INIT_2e => X"1e321e1e1e0b1df71de31dcf1dbc1da81d941d801d6b1d571d431d2f1d1a1d06",
-- INIT_2f => X"1cf11cdc1cc81cb31c9e1c891c741c5f1c4a1c351c201c0a1bf51bdf1bca1bb4",
-- INIT_30 => X"1b9f1b891b731b5d1b471b311b1b1b051aef1ad91ac21aac1a961a7f1a681a52",
-- INIT_31 => X"1a3b1a241a0d19f719e019c919b2199a1983196c1955193d1926190e18f718df",
-- INIT_32 => X"18c718b0189818801868185018381820180817f017d717bf17a7178e1776175d",
-- INIT_33 => X"1744172c171316fa16e116c916b01697167e1664164b1632161915ff15e615cd",
-- INIT_34 => X"15b3159a15801566154d1533151914ff14e514cc14b21497147d14631449142f",
-- INIT_35 => X"141513fa13e013c513ab13901376135b13401326130b12f012d512ba129f1285",
-- INIT_36 => X"1269124e1233121811fd11e211c611ab119011741159113d1122110610ea10cf",
-- INIT_37 => X"10b31097107c106010441028100c0ff00fd40fb80f9c0f800f630f470f2b0f0f",
-- INIT_38 => X"0ef20ed60eba0e9d0e810e640e480e2b0e0e0df20dd50db80d9c0d7f0d620d45",
-- INIT_39 => X"0d280d0b0cef0cd20cb50c980c7b0c5d0c400c230c060be90bcc0bae0b910b74",
-- INIT_3a => X"0b560b390b1c0afe0ae10ac30aa60a880a6b0a4d0a2f0a1209f409d609b9099b",
-- INIT_3b => X"097d096009420924090608e808ca08ac088f087108530835081707f907db07bc",
-- INIT_3c => X"079e0780076207440726070806ea06cb06ad068f067106520634061605f705d9",
-- INIT_3d => X"05bb059c057e056005410523050404e604c804a9048b046c044e042f041103f2",
-- INIT_3e => X"03d403b5039703780359033b031c02fe02df02c102a202830265024602270209",
-- INIT_3f => X"01ea01cc01ad018e017001510132011400f500d600b80099007a005c003d001e",



-- Que está listo para ser metido aqui:
RAMB16_S18_inst : RAMB16_S18
   generic map (
      INIT => X"00000", --  Value of output RAM registers at startup
      SRVAL => X"00000", --  Ouput value upon SSR assertion
      WRITE_MODE => "WRITE_FIRST", --  WRITE_FIRST, READ_FIRST or NO_CHANGE
      -- The following INIT_xx declarations specify the intial contents of the RAM
      -- Address 0 to 255
     INIT_00 => X"0000001e003d005c007a009900b800d600f50114013201510170018e01ad01cc",
 INIT_01 => X"01ea0209022702460265028302a202c102df02fe031c033b03590378039703b5",
 INIT_02 => X"03d403f20411042f044e046c048b04a904c804e60504052305410560057e059c",
 INIT_03 => X"05bb05d905f70616063406520671068f06ad06cb06ea07080726074407620780",
 INIT_04 => X"079e07bc07db07f90817083508530871088f08ac08ca08e80906092409420960",
 INIT_05 => X"097d099b09b909d609f40a120a2f0a4d0a6b0a880aa60ac30ae10afe0b1c0b39",
 INIT_06 => X"0b560b740b910bae0bcc0be90c060c230c400c5d0c7b0c980cb50cd20cef0d0b",
 INIT_07 => X"0d280d450d620d7f0d9c0db80dd50df20e0e0e2b0e480e640e810e9d0eba0ed6",
 INIT_08 => X"0ef20f0f0f2b0f470f630f800f9c0fb80fd40ff0100c102810441060107c1097",
 INIT_09 => X"10b310cf10ea11061122113d11591174119011ab11c611e211fd12181233124e",
 INIT_0a => X"12691285129f12ba12d512f0130b13261340135b1376139013ab13c513e013fa",
 INIT_0b => X"1415142f14491463147d149714b214cc14e514ff15191533154d15661580159a",
 INIT_0c => X"15b315cd15e615ff16191632164b1664167e169716b016c916e116fa1713172c",
 INIT_0d => X"1744175d1776178e17a717bf17d717f0180818201838185018681880189818b0",
 INIT_0e => X"18c718df18f7190e1926193d1955196c1983199a19b219c919e019f71a0d1a24",
 INIT_0f => X"1a3b1a521a681a7f1a961aac1ac21ad91aef1b051b1b1b311b471b5d1b731b89",
 INIT_10 => X"1b9f1bb41bca1bdf1bf51c0a1c201c351c4a1c5f1c741c891c9e1cb31cc81cdc",
 INIT_11 => X"1cf11d061d1a1d2f1d431d571d6b1d801d941da81dbc1dcf1de31df71e0b1e1e",
 INIT_12 => X"1e321e451e581e6c1e7f1e921ea51eb81ecb1ede1ef11f031f161f281f3b1f4d",
 INIT_13 => X"1f601f721f841f961fa81fba1fcc1fde1fef2001201320242035204720582069",
 INIT_14 => X"207a208b209c20ad20be20ce20df20f021002110212121312141215121612171",
 INIT_15 => X"2181219121a021b021bf21cf21de21ed21fc220b221a22292238224722562264",
 INIT_16 => X"22732281228f229e22ac22ba22c822d622e422f122ff230d231a232823352342",
 INIT_17 => X"234f235c2369237623832390239d23a923b623c223ce23db23e723f323ff240b",
 INIT_18 => X"24162422242e243924452450245b24662471247c24872492249d24a824b224bd",
 INIT_19 => X"24c724d124db24e624f024fa2503250d25172520252a2533253d2546254f2558",
 INIT_1a => X"2561256a2573257b2584258c2595259d25a525ad25b525bd25c525cd25d525dc",
 INIT_1b => X"25e425eb25f325fa26012608260f2616261d2623262a26302637263d26432649",
 INIT_1c => X"264f2655265b26612667266c26722677267c26812687268c26912695269a269f",
 INIT_1d => X"26a326a826ac26b026b526b926bd26c026c426c826cc26cf26d326d626d926dc",
 INIT_1e => X"26df26e226e526e826eb26ed26f026f226f426f726f926fb26fd26ff27002702",
 INIT_1f => X"27032705270627082709270a270b270c270c270d270e270e270f270f270f270f",
 INIT_20 => X"2710270f270f270f270f270e270e270d270c270c270b270a2709270827062705",
 INIT_21 => X"27032702270026ff26fd26fb26f926f726f426f226f026ed26eb26e826e526e2",
 INIT_22 => X"26df26dc26d926d626d326cf26cc26c826c426c026bd26b926b526b026ac26a8",
 INIT_23 => X"26a3269f269a26952691268c26872681267c26772672266c26672661265b2655",
 INIT_24 => X"264f26492643263d26372630262a2623261d2616260f2608260125fa25f325eb",
 INIT_25 => X"25e425dc25d525cd25c525bd25b525ad25a5259d2595258c2584257b2573256a",
 INIT_26 => X"25612558254f2546253d2533252a25202517250d250324fa24f024e624db24d1",
 INIT_27 => X"24c724bd24b224a8249d24922487247c24712466245b245024452439242e2422",
 INIT_28 => X"2416240b23ff23f323e723db23ce23c223b623a9239d2390238323762369235c",
 INIT_29 => X"234f234223352328231a230d22ff22f122e422d622c822ba22ac229e228f2281",
 INIT_2a => X"227322642256224722382229221a220b21fc21ed21de21cf21bf21b021a02191",
 INIT_2b => X"21812171216121512141213121212110210020f020df20ce20be20ad209c208b",
 INIT_2c => X"207a20692058204720352024201320011fef1fde1fcc1fba1fa81f961f841f72",
 INIT_2d => X"1f601f4d1f3b1f281f161f031ef11ede1ecb1eb81ea51e921e7f1e6c1e581e45",
 INIT_2e => X"1e321e1e1e0b1df71de31dcf1dbc1da81d941d801d6b1d571d431d2f1d1a1d06",
 INIT_2f => X"1cf11cdc1cc81cb31c9e1c891c741c5f1c4a1c351c201c0a1bf51bdf1bca1bb4",
 INIT_30 => X"1b9f1b891b731b5d1b471b311b1b1b051aef1ad91ac21aac1a961a7f1a681a52",
 INIT_31 => X"1a3b1a241a0d19f719e019c919b2199a1983196c1955193d1926190e18f718df",
 INIT_32 => X"18c718b0189818801868185018381820180817f017d717bf17a7178e1776175d",
 INIT_33 => X"1744172c171316fa16e116c916b01697167e1664164b1632161915ff15e615cd",
 INIT_34 => X"15b3159a15801566154d1533151914ff14e514cc14b21497147d14631449142f",
 INIT_35 => X"141513fa13e013c513ab13901376135b13401326130b12f012d512ba129f1285",
 INIT_36 => X"1269124e1233121811fd11e211c611ab119011741159113d1122110610ea10cf",
 INIT_37 => X"10b31097107c106010441028100c0ff00fd40fb80f9c0f800f630f470f2b0f0f",
 INIT_38 => X"0ef20ed60eba0e9d0e810e640e480e2b0e0e0df20dd50db80d9c0d7f0d620d45",
 INIT_39 => X"0d280d0b0cef0cd20cb50c980c7b0c5d0c400c230c060be90bcc0bae0b910b74",
 INIT_3a => X"0b560b390b1c0afe0ae10ac30aa60a880a6b0a4d0a2f0a1209f409d609b9099b",
 INIT_3b => X"097d096009420924090608e808ca08ac088f087108530835081707f907db07bc",
 INIT_3c => X"079e0780076207440726070806ea06cb06ad068f067106520634061605f705d9",
 INIT_3d => X"05bb059c057e056005410523050404e604c804a9048b046c044e042f041103f2",
 INIT_3e => X"03d403b5039703780359033b031c02fe02df02c102a202830265024602270209",
 INIT_3f => X"01ea01cc01ad018e017001510132011400f500d600b80099007a005c003d001e",
 
      -- The next set of INITP_xx are for the parity bits
      -- Address 0 to 255
      INITP_00 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INITP_01 => X"0000000000000000000000000000000000000000000000000000000000000000",
      -- Address 256 to 511
      INITP_02 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INITP_03 => X"0000000000000000000000000000000000000000000000000000000000000000",
      -- Address 512 to 767
      INITP_04 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INITP_05 => X"0000000000000000000000000000000000000000000000000000000000000000",
      -- Address 768 to 1023
      INITP_06 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INITP_07 => X"0000000000000000000000000000000000000000000000000000000000000000")
   port map (
      DO => sin,      -- 16-bit Data Output
      DOP => nulium,    -- 2-bit parity Output
      ADDR => n,  -- 10-bit Address Input
      CLK => input,    -- Clock
      DI => X"0000",      -- 16-bit Data Input
      DIP => "00",    -- 2-bit parity Input
      EN => '0',      -- RAM Enable Input
      SSR => '0',    -- Synchronous Set/Reset Input
      WE => '0'       -- Write Enable Input
   );

a1<="00"&sin;
b1<="00000000000000"&x;


------------------------------------------------------------------



   sin_por_xn : MULT18X18S
   port map (
      P => p1,    -- 36-bit multiplier output
      A => a1,    -- 18-bit multiplier input
      B => b1,    -- 18-bit multiplier input
      C => clk,    -- Clock input
      CE => input,  -- Clock enable input
      R => rst     -- Synchronous reset input
   );
	
	A<= p1(17 downto 0);
	b2<="00000000000000"&Q;
	
	casito_por_xn_16 : MULT18X18S
   port map (
      P => P3,    -- 36-bit multiplier output
      A => A,    -- 18-bit multiplier input
      B => b2,    -- 18-bit multiplier input
      C => clk,    -- Clock input
      CE => input,  -- Clock enable input
      R => rst     -- Synchronous reset input
   );
	
	ypas<=p3(22 downto 10);
	
	
	y<=ypas+ypasado;
	
end Behavioral;

