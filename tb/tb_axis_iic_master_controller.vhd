library IEEE;
    use IEEE.STD_LOGIC_1164.ALL;
    use ieee.std_Logic_unsigned.all;
    use ieee.std_logic_arith.all;


library UNISIM;
    use UNISIM.VComponents.all;



entity tb_axis_iic_master_controller is
end tb_axis_iic_master_controller;



architecture Behavioral of tb_axis_iic_master_controller is

    constant  CLK_FREQUENCY               :   integer         :=  100000000        ;
    constant  CLK_IIC_FREQUENCY           :   integer         :=  400000           ;
    constant  FIFO_DEPTH                  :   integer         :=  64 ;


    component axis_iic_master_controller
        generic(
            CLK_FREQUENCY               :   integer         :=  100000000       ;
            CLK_IIC_FREQUENCY           :   integer         :=  400000          ;
            FIFO_DEPTH                  :   integer         :=  64 
        );
        port(
            CLK                         :   in      std_logic                   ;
            RESET                       :   in      std_logic                   ;
            -- SLave AXI-Stream 
            S_AXIS_TDATA                :   in      std_logic_Vector ( 7 downto 0 )     ;
            S_AXIS_TDEST                :   in      std_logic_Vector ( 7 downto 0 )     ;
            S_AXIS_TVALID               :   in      std_logic                           ;
            S_AXIS_TLAST                :   in      std_logic                           ;
            S_AXIS_TREADY               :   out     std_logic                           ;   

            M_AXIS_TDATA                :   out     std_logic_Vector ( 7 downto 0 )     ;
            M_AXIS_TDEST                :   out     std_logic_Vector ( 7 downto 0 )     ;
            M_AXIS_TVALID               :   out     std_logic                           ;
            M_AXIS_TLAST                :   out     std_logic                           ;
            M_AXIS_TREADY               :   in      std_logic                           ;

            SCL_I                       :   in      std_logic                           ;
            SCL_T                       :   out     std_logic                           ;
            SDA_I                       :   in      std_logic                           ;
            SDA_T                       :   out     std_logic                            

        );
    end component;


    signal  CLK                         :           std_logic                       := '0'              ;
    signal  RESET                       :           std_logic                       := '0'              ;
    -- SLave AXI-Stream 
    signal  S_AXIS_TDATA                :           std_logic_Vector ( 7 downto 0 ) := (others => '0')  ;
    signal  S_AXIS_TDEST                :           std_logic_Vector ( 7 downto 0 ) := (others => '0')  ;
    signal  S_AXIS_TVALID               :           std_logic                       := '0'              ;
    signal  S_AXIS_TLAST                :           std_logic                       := '0'              ;
    signal  S_AXIS_TREADY               :           std_logic                                           ;   

    signal  M_AXIS_TDATA                :           std_logic_Vector ( 7 downto 0 )                     ;
    signal  M_AXIS_TDEST                :           std_logic_Vector ( 7 downto 0 )                     ;
    signal  M_AXIS_TVALID               :           std_logic                                           ;
    signal  M_AXIS_TLAST                :           std_logic                                           ;
    signal  M_AXIS_TREADY               :           std_logic                       := '0'              ;

    signal  SCL_I                       :           std_logic                       := '1'              ;
    signal  SCL_O                       :           std_logic                                           ;
    signal  SCL_T                       :           std_logic                                           ;
    signal  SDA_I                       :           std_logic                       := '1'              ;
    signal  SDA_O                       :           std_logic                                           ;
    signal  SDA_T                       :           std_logic                                           ;


    signal  SCL_IO                      :           std_logic                                           ;
    signal  SDA_IO                      :           std_logic                                           ;

    signal  i : integer := 0;

    constant CLK_PERIOD : time := 10 ns;


    component device_imitation_slave
        port(
            SCL_IO  :   inout      std_logic                           ;
            SDA_IO  :   inout     std_logic                             
        );
    end component;


begin
    
    CLK <= not CLK after CLK_PERIOD/2;

    RESET <= '1' when i < 10 else '0';

    i_processing : process(CLK)
    begin 
        if CLK'event and clk = '1' then 
            i <= i + 1;
        end if;
    end process;


    -- DEST : A6 - операция записи
    -- DEST : A7 - операция чтения

    s_axis_processing : process(CLK)
    begin 
        if CLK'event AND CLK = '1' then 
            case i is 
                --when 100    => S_AXIS_TDATA <= x"02"; S_AXIS_TDEST(7 downto 0) <= x"A6"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0';
                --when 101    => S_AXIS_TDATA <= x"01"; S_AXIS_TDEST(7 downto 0) <= x"A6"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0';
                --when 102    => S_AXIS_TDATA <= x"02"; S_AXIS_TDEST(7 downto 0) <= x"A6"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '1';

                --when 104    => S_AXIS_TDATA <= x"04"; S_AXIS_TDEST(7 downto 0) <= x"A6"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0';
                --when 105    => S_AXIS_TDATA <= x"01"; S_AXIS_TDEST(7 downto 0) <= x"A6"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0';
                --when 106    => S_AXIS_TDATA <= x"02"; S_AXIS_TDEST(7 downto 0) <= x"A6"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0';
                --when 107    => S_AXIS_TDATA <= x"03"; S_AXIS_TDEST(7 downto 0) <= x"A6"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0';
                --when 108    => S_AXIS_TDATA <= x"04"; S_AXIS_TDEST(7 downto 0) <= x"A6"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '1';

                -- Данная команда просто установит указатьелуказатель на регистр  устройства в указанное значение
                when 110    => S_AXIS_TDATA <= x"01"; S_AXIS_TDEST(7 downto 0) <= x"A6"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0';
                when 111    => S_AXIS_TDATA <= x"00"; S_AXIS_TDEST(7 downto 0) <= x"A6"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '1';
                ---- Попытка чтения данных
                when 113000 => S_AXIS_TDATA <= x"01"; S_AXIS_TDEST(7 downto 0) <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '1';
                




                when others => S_AXIS_TDATA <= S_AXIS_TDATA; S_AXIS_TDEST <= S_AXIS_TDEST; S_AXIS_TVALID <= '0'; S_AXIS_TLAST <= S_AXIS_TLAST;
            end case;
        end if;
    end process;

    axis_iic_master_controller_inst : axis_iic_master_controller
        generic map (
            CLK_FREQUENCY               =>  CLK_FREQUENCY                       ,
            CLK_IIC_FREQUENCY           =>  CLK_IIC_FREQUENCY                   ,
            FIFO_DEPTH                  =>  FIFO_DEPTH                           
        )
        port map (
            CLK                         =>  CLK                                 ,
            RESET                       =>  RESET                               ,
            -- SLave AXI-Stream 
            S_AXIS_TDATA                =>  S_AXIS_TDATA                        ,
            S_AXIS_TDEST                =>  S_AXIS_TDEST                        ,
            S_AXIS_TVALID               =>  S_AXIS_TVALID                       ,
            S_AXIS_TLAST                =>  S_AXIS_TLAST                        ,
            S_AXIS_TREADY               =>  S_AXIS_TREADY                       ,

            M_AXIS_TDATA                =>  M_AXIS_TDATA                        ,
            M_AXIS_TDEST                =>  M_AXIS_TDEST                        ,
            M_AXIS_TVALID               =>  M_AXIS_TVALID                       ,
            M_AXIS_TLAST                =>  M_AXIS_TLAST                        ,
            M_AXIS_TREADY               =>  M_AXIS_TREADY                       ,

            SCL_I                       =>  SCL_I                               ,
            SCL_T                       =>  SCL_T                               ,
            SDA_I                       =>  SDA_I                               ,
            SDA_T                       =>  SDA_T                                
        );

    SCL_I <= SCL_T;

    M_AXIS_TREADY <= '1';


    sda_i_processing : process(CLK)
    begin 
        if CLK'event AND CLK = '1' then 
            case (i)  is 
                when (  10*250) => SDA_I <= '0';
                when (  11*250) => SDA_I <= '1';

                when (  19*250) => SDA_I <= '0';
                when (  20*250) => SDA_I <= '1';

                when (  28*250) => SDA_I <= '0';
                when (  29*250) => SDA_I <= '1';

                when (  40*250) => SDA_I <= '0';
                when (  41*250) => SDA_I <= '1';

                when (  49*250) => SDA_I <= '0';
                when (  50*250) => SDA_I <= '1';

                when (  58*250) => SDA_I <= '0';
                when (  59*250) => SDA_I <= '1';

                when (  67*250) => SDA_I <= '0';
                when (  68*250) => SDA_I <= '1';

                when (  76*250) => SDA_I <= '0';
                when (  77*250) => SDA_I <= '1';


                when (  88*250) => SDA_I <= '0';
                when (  89*250) => SDA_I <= '1';

                when (  97*250) => SDA_I <= '0';
                when (  98*250) => SDA_I <= '1';
                when (  99*250) => SDA_I <= '1';
                when ( 100*250) => SDA_I <= '0';
                when ( 101*250) => SDA_I <= '0'; 
                when ( 102*250) => SDA_I <= '1';
                when ( 103*250) => SDA_I <= '1';
                when ( 104*250) => SDA_I <= '0';
                when ( 105*250) => SDA_I <= '1'; 
                when ( 106*250) => SDA_I <= '0';
                when ( 107*250) => SDA_I <= '0';
                when ( 108*250) => SDA_I <= '1';

                --when ( 109*250) => SDA_I <= '0';

                --when ( 110*250) => SDA_I <= '0';
                --when ( 111*250) => SDA_I <= '1';
                --when ( 112*250) => SDA_I <= '0';
                --when ( 113*250) => SDA_I <= '1';
                --when ( 114*250) => SDA_I <= '0';
                --when ( 115*250) => SDA_I <= '1';
                --when ( 116*250) => SDA_I <= '0';
                --when ( 117*250) => SDA_I <= '1'; -- "01010101" = x"55" 

                --when ( 118*250) => SDA_I <= '0';

                --when ( 119*250) => SDA_I <= '1';
                --when ( 120*250) => SDA_I <= '0';
                --when ( 121*250) => SDA_I <= '1';
                --when ( 122*250) => SDA_I <= '0';
                --when ( 123*250) => SDA_I <= '1';
                --when ( 124*250) => SDA_I <= '0';
                --when ( 125*250) => SDA_I <= '1';
                --when ( 126*250) => SDA_I <= '1'; -- "10101011" = x"AB"
                --when ( 127*250) => SDA_I <= '0';
                --when ( 128*250) => SDA_I <= '0';
                --when ( 129*250) => SDA_I <= '1';



                when ( 462*250) => SDA_I <= '0';

                when ( 463*250) => SDA_I <= '1';
                when ( 464*250) => SDA_I <= '1';
                when ( 465*250) => SDA_I <= '1';
                when ( 466*250) => SDA_I <= '0';
                when ( 467*250) => SDA_I <= '0';
                when ( 468*250) => SDA_I <= '1';
                when ( 469*250) => SDA_I <= '1';
                when ( 470*250) => SDA_I <= '1'; -- "10101011" = x"AB"
                when ( 471*250) => SDA_I <= '0';
                when ( 472*250) => SDA_I <= '0';
                when ( 473*250) => SDA_I <= '1';





                when others =>  SDA_I <=  SDA_I;
            end case;
        end if;
    end process;







end Behavioral;
