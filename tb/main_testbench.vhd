library IEEE;
    use IEEE.STD_LOGIC_1164.ALL;
    use ieee.std_logic_unsigned.all;
    use ieee.std_Logic_arith.all;


entity main_testbench is
end main_testbench;



architecture Behavioral of main_testbench is


    constant  S_AXI_LITE_DEV_DATA_WIDTH     :           integer                                                         := 32                   ;
    constant  S_AXI_LITE_DEV_ADDR_WIDTH     :           integer                                                         := 32                   ;
    constant  DEFAULT_DEVICE_ADDRESS        :           std_logic_vector ( 6 downto 0 )                                 := "1010011"            ;
    constant  DEFAULT_REQUESTION_INTERVAL   :           integer                                                         := 1000                 ;
    constant  DEFAULT_CALIBRATION_MODE      :           integer                                                         := 8                    ;
    constant  S_AXI_LITE_CFG_DATA_WIDTH     :           integer                                                         := 32                   ;
    constant  S_AXI_LITE_CFG_ADDR_WIDTH     :           integer                                                         := 32                   ;
    constant  CLK_PERIOD                    :           integer                                                         := 100000000            ;
    constant  RESET_DURATION                :           integer                                                         := 100                  ;


    component axi_adxl345 
        generic (
            S_AXI_LITE_DEV_DATA_WIDTH       :           integer                                                         := 32                   ;
            S_AXI_LITE_DEV_ADDR_WIDTH       :           integer                                                         := 32                   ;
            DEFAULT_DEVICE_ADDRESS          :           std_logic_vector ( 6 downto 0 )                                 := "1010011"            ;
            DEFAULT_REQUESTION_INTERVAL     :           integer                                                         := 1000                 ;
            S_AXI_LITE_CFG_DATA_WIDTH       :           integer                                                         := 32                   ;
            S_AXI_LITE_CFG_ADDR_WIDTH       :           integer                                                         := 32                   ;
            CLK_PERIOD                      :           integer                                                         := 100000000            ;
            RESET_DURATION                  :           integer                                                         := 1000
        );
        port (
            CLK                             :   in      std_logic                                                                               ;
            RESET                           :   in      std_logic                                                                               ;
            
            S_AXI_LITE_CFG_AWADDR           :   in      std_logic_vector (    S_AXI_LITE_CFG_ADDR_WIDTH-1 downto 0 )                            ;
            S_AXI_LITE_CFG_AWPROT           :   in      std_logic_vector (                              2 downto 0 )                            ;
            S_AXI_LITE_CFG_AWVALID          :   in      std_logic                                                                               ;
            S_AXI_LITE_CFG_AWREADY          :   out     std_logic                                                                               ;
            S_AXI_LITE_CFG_WDATA            :   in      std_logic_vector (    S_AXI_LITE_CFG_DATA_WIDTH-1 downto 0 )                            ;
            S_AXI_LITE_CFG_WSTRB            :   in      std_logic_vector ((S_AXI_LITE_CFG_DATA_WIDTH/8)-1 downto 0 )                            ;
            S_AXI_LITE_CFG_WVALID           :   in      std_logic                                                                               ;
            S_AXI_LITE_CFG_WREADY           :   out     std_logic                                                                               ;
            S_AXI_LITE_CFG_BRESP            :   out     std_logic_vector (                              1 downto 0 )                            ;
            S_AXI_LITE_CFG_BVALID           :   out     std_logic                                                                               ;
            S_AXI_LITE_CFG_BREADY           :   in      std_logic                                                                               ;
            S_AXI_LITE_CFG_ARADDR           :   in      std_logic_vector (    S_AXI_LITE_CFG_ADDR_WIDTH-1 downto 0 )                            ;
            S_AXI_LITE_CFG_ARPROT           :   in      std_logic_vector (                              2 downto 0 )                            ;
            S_AXI_LITE_CFG_ARVALID          :   in      std_logic                                                                               ;
            S_AXI_LITE_CFG_ARREADY          :   out     std_logic                                                                               ;
            S_AXI_LITE_CFG_RDATA            :   out     std_logic_vector (    S_AXI_LITE_CFG_DATA_WIDTH-1 downto 0 )                            ;
            S_AXI_LITE_CFG_RRESP            :   out     std_logic_vector (                              1 downto 0 )                            ;
            S_AXI_LITE_CFG_RVALID           :   out     std_logic                                                                               ;
            S_AXI_LITE_CFG_RREADY           :   in      std_logic                                                                               ;
            
            S_AXI_LITE_DEV_AWADDR           :   in      std_logic_vector (    S_AXI_LITE_DEV_ADDR_WIDTH-1 downto 0 )                            ;
            S_AXI_LITE_DEV_AWPROT           :   in      std_logic_vector (                              2 downto 0 )                            ;
            S_AXI_LITE_DEV_AWVALID          :   in      std_logic                                                                               ;
            S_AXI_LITE_DEV_AWREADY          :   out     std_logic                                                                               ;
            S_AXI_LITE_DEV_WDATA            :   in      std_logic_vector (    S_AXI_LITE_DEV_DATA_WIDTH-1 downto 0 )                            ;
            S_AXI_LITE_DEV_WSTRB            :   in      std_logic_vector ((S_AXI_LITE_DEV_DATA_WIDTH/8)-1 downto 0 )                            ;
            S_AXI_LITE_DEV_WVALID           :   in      std_logic                                                                               ;
            S_AXI_LITE_DEV_WREADY           :   out     std_logic                                                                               ;
            S_AXI_LITE_DEV_BRESP            :   out     std_logic_vector (                              1 downto 0 )                            ;
            S_AXI_LITE_DEV_BVALID           :   out     std_logic                                                                               ;
            S_AXI_LITE_DEV_BREADY           :   in      std_logic                                                                               ;
            S_AXI_LITE_DEV_ARADDR           :   in      std_logic_vector (    S_AXI_LITE_DEV_ADDR_WIDTH-1 downto 0 )                            ;
            S_AXI_LITE_DEV_ARPROT           :   in      std_logic_vector (                              2 downto 0 )                            ;
            S_AXI_LITE_DEV_ARVALID          :   in      std_logic                                                                               ;
            S_AXI_LITE_DEV_ARREADY          :   out     std_logic                                                                               ;
            S_AXI_LITE_DEV_RDATA            :   out     std_logic_vector (    S_AXI_LITE_DEV_DATA_WIDTH-1 downto 0 )                            ;
            S_AXI_LITE_DEV_RRESP            :   out     std_logic_vector (                              1 downto 0 )                            ;
            S_AXI_LITE_DEV_RVALID           :   out     std_logic                                                                               ;
            S_AXI_LITE_DEV_RREADY           :   in      std_logic                                                                               ;
            
            M_AXIS_TDATA                    :   out     std_logic_vector (                              7 downto 0 )                            ;
            M_AXIS_TKEEP                    :   out     std_logic_vector (                              0 downto 0 )                            ;
            M_AXIS_TUSER                    :   out     std_logic_vector (                              7 downto 0 )                            ;
            M_AXIS_TVALID                   :   out     std_logic                                                                               ;
            M_AXIS_TLAST                    :   out     std_logic                                                                               ;
            M_AXIS_TREADY                   :   in      std_logic                                                                               ;
            
            S_AXIS_TDATA                    :   in      std_logic_vector (                              7 downto 0 )                            ;
            S_AXIS_TKEEP                    :   in      std_logic_vector (                              0 downto 0 )                            ;
            S_AXIS_TUSER                    :   in      std_logic_vector (                              7 downto 0 )                            ;
            S_AXIS_TVALID                   :   in      std_logic                                                                               ;
            S_AXIS_TLAST                    :   in      std_logic                                                                               ;
            S_AXIS_TREADY                   :   out     std_logic                                                                               ;
            ADXL_INTERRUPT                  :   in      std_logic                                                                               ;
            ADXL_IRQ                        :   out     std_logic                                                                                
        );
    end component;

    signal  CLK                             :           std_logic                                                    := '0'                     ;
    signal  RESET                           :           std_logic                                                    := '0'                     ;

    signal  CFG_AWADDR                      :           std_logic_vector (    S_AXI_LITE_CFG_ADDR_WIDTH-1 downto 0 ) := (others => '0')         ;
    signal  CFG_AWPROT                      :           std_logic_vector (                              2 downto 0 ) := (others => '0')         ;
    signal  CFG_AWVALID                     :           std_logic                                                    := '0'                     ;
    signal  CFG_AWREADY                     :           std_logic                                                                               ;
    signal  CFG_WDATA                       :           std_logic_vector (    S_AXI_LITE_CFG_DATA_WIDTH-1 downto 0 ) := (others => '0')         ;
    signal  CFG_WSTRB                       :           std_logic_vector ((S_AXI_LITE_CFG_DATA_WIDTH/8)-1 downto 0 ) := (others => '0')         ;
    signal  CFG_WVALID                      :           std_logic                                                    := '0'                     ;
    signal  CFG_WREADY                      :           std_logic                                                                               ;
    signal  CFG_BRESP                       :           std_logic_vector (                              1 downto 0 )                            ;
    signal  CFG_BVALID                      :           std_logic                                                                               ;
    signal  CFG_BREADY                      :           std_logic                                                    := '0'                     ;
    signal  CFG_ARADDR                      :           std_logic_vector (    S_AXI_LITE_CFG_ADDR_WIDTH-1 downto 0 ) := (others => '0')         ;
    signal  CFG_ARPROT                      :           std_logic_vector (                              2 downto 0 ) := (others => '0')         ;
    signal  CFG_ARVALID                     :           std_logic                                                    := '0'                     ;
    signal  CFG_ARREADY                     :           std_logic                                                                               ;
    signal  CFG_RDATA                       :           std_logic_vector (    S_AXI_LITE_CFG_DATA_WIDTH-1 downto 0 )                            ;
    signal  CFG_RRESP                       :           std_logic_vector (                              1 downto 0 )                            ;
    signal  CFG_RVALID                      :           std_logic                                                                               ;
    signal  CFG_RREADY                      :           std_logic                                                    := '0'                     ;

    signal  DEV_AWADDR                      :           std_logic_vector (    S_AXI_LITE_DEV_ADDR_WIDTH-1 downto 0 ) := (others => '0')         ;
    signal  DEV_AWPROT                      :           std_logic_vector (                              2 downto 0 ) := (others => '0')         ;
    signal  DEV_AWVALID                     :           std_logic                                                    := '0'                     ;
    signal  DEV_AWREADY                     :           std_logic                                                                               ;
    signal  DEV_WDATA                       :           std_logic_vector (    S_AXI_LITE_DEV_DATA_WIDTH-1 downto 0 ) := (others => '0')         ;
    signal  DEV_WSTRB                       :           std_logic_vector ((S_AXI_LITE_DEV_DATA_WIDTH/8)-1 downto 0 ) := (others => '0')         ;
    signal  DEV_WVALID                      :           std_logic                                                    := '0'                     ;
    signal  DEV_WREADY                      :           std_logic                                                                               ;
    signal  DEV_BRESP                       :           std_logic_vector (                              1 downto 0 )                            ;
    signal  DEV_BVALID                      :           std_logic                                                                               ;
    signal  DEV_BREADY                      :           std_logic                                                    := '0'                     ;
    signal  DEV_ARADDR                      :           std_logic_vector (    S_AXI_LITE_DEV_ADDR_WIDTH-1 downto 0 ) := (others => '0')         ;
    signal  DEV_ARPROT                      :           std_logic_vector (                              2 downto 0 ) := (others => '0')         ;
    signal  DEV_ARVALID                     :           std_logic                                                    := '0'                     ;
    signal  DEV_ARREADY                     :           std_logic                                                                               ;
    signal  DEV_RDATA                       :           std_logic_vector (    S_AXI_LITE_DEV_DATA_WIDTH-1 downto 0 )                            ;
    signal  DEV_RRESP                       :           std_logic_vector (                              1 downto 0 )                            ;
    signal  DEV_RVALID                      :           std_logic                                                                               ;
    signal  DEV_RREADY                      :           std_logic                                                    := '0'                     ;

    signal  M_AXIS_TDATA                    :           std_logic_vector (                              7 downto 0 )                            ;
    signal  M_AXIS_TKEEP                    :           std_logic_vector (                              0 downto 0 )                            ;
    signal  M_AXIS_TUSER                    :           std_logic_vector (                              7 downto 0 )                            ;
    signal  M_AXIS_TVALID                   :           std_logic                                                                               ;
    signal  M_AXIS_TLAST                    :           std_logic                                                                               ;
    signal  M_AXIS_TREADY                   :           std_logic                                                    := '0'                     ;

    signal  S_AXIS_TDATA                    :           std_logic_vector (                              7 downto 0 ) := (others => '0')         ;
    signal  S_AXIS_TKEEP                    :           std_logic_vector (                              0 downto 0 ) := (others => '0')         ;
    signal  S_AXIS_TUSER                    :           std_logic_vector (                              7 downto 0 ) := (others => '0')         ;
    signal  S_AXIS_TVALID                   :           std_logic                                                    := '0'                     ;
    signal  S_AXIS_TLAST                    :           std_logic                                                    := '0'                     ;
    signal  S_AXIS_TREADY                   :           std_logic                                                                               ;
    signal  ADXL_INTERRUPT                  :           std_logic                                                    := '0'                     ;
    signal  ADXL_IRQ                        :           std_logic                                                                               ;

    signal  i                               :           integer                                                      := 0                       ;

    component axis_iic_master_controller
        generic(
            CLK_FREQUENCY                       :   integer         :=  100000000                                                   ;
            CLK_IIC_FREQUENCY                   :   integer         :=  400000                                                      ;
            FIFO_DEPTH                          :   integer         :=  64 
        );
        port(
            CLK                                 :   in      std_logic                                                               ;
            RESET                               :   in      std_logic                                                               ;
            -- SLave AXI-Stream 
            S_AXIS_TDATA                        :   in      std_logic_Vector ( 7 downto 0 )                                         ;
            S_AXIS_TDEST                        :   in      std_logic_Vector ( 7 downto 0 )                                         ;
            S_AXIS_TVALID                       :   in      std_logic                                                               ;
            S_AXIS_TLAST                        :   in      std_logic                                                               ;
            S_AXIS_TREADY                       :   out     std_logic                                                               ;   

            M_AXIS_TDATA                        :   out     std_logic_Vector ( 7 downto 0 )                                         ;
            M_AXIS_TDEST                        :   out     std_logic_Vector ( 7 downto 0 )                                         ;
            M_AXIS_TVALID                       :   out     std_logic                                                               ;
            M_AXIS_TLAST                        :   out     std_logic                                                               ;
            M_AXIS_TREADY                       :   in      std_logic                                                               ;

            SCL_I                               :   in      std_logic                                                               ;
            SCL_T                               :   out     std_logic                                                               ;
            SDA_I                               :   in      std_logic                                                               ;
            SDA_T                               :   out     std_logic                                                                

        );
    end component;

    signal  SCL_I                               :           std_logic                                                               ;
    signal  SCL_T                               :           std_logic                                                               ;
    signal  SDA_I                               :           std_logic                                                               ;
    signal  SDA_T                               :           std_logic                                                               ;



    component tb_device_imitation 
        port (
            IIC_SCL_I           : in   std_logic    ;
            IIC_SDA_I           : in   std_logic    ;
            IIC_SCL_O           : out  std_logic    ;
            IIC_SDA_O           : out  std_logic    ;
            IRQ                 : out  std_logic     
        );
    end component;

begin

    CLK <= not CLK after 5 ns;

    i_proecssing : process(CLK)
    begin 
        if CLK'event AND CLK = '1' then 
            i <= i + 1;
        end if;
    end process;

    RESET <= '1' when i < 10 else '0';

    axi_adxl345_inst : axi_adxl345 
        generic map  (
            S_AXI_LITE_DEV_DATA_WIDTH       =>  S_AXI_LITE_DEV_DATA_WIDTH        ,
            S_AXI_LITE_DEV_ADDR_WIDTH       =>  S_AXI_LITE_DEV_ADDR_WIDTH        ,
            DEFAULT_DEVICE_ADDRESS          =>  DEFAULT_DEVICE_ADDRESS           ,
            DEFAULT_REQUESTION_INTERVAL     =>  DEFAULT_REQUESTION_INTERVAL      ,
            S_AXI_LITE_CFG_DATA_WIDTH       =>  S_AXI_LITE_CFG_DATA_WIDTH        ,
            S_AXI_LITE_CFG_ADDR_WIDTH       =>  S_AXI_LITE_CFG_ADDR_WIDTH        ,
            CLK_PERIOD                      =>  CLK_PERIOD                       ,
            RESET_DURATION                  =>  RESET_DURATION                    
        )
        port map (
            CLK                             =>  CLK                                 ,
            RESET                           =>  RESET                               ,
            
            S_AXI_LITE_CFG_AWADDR           =>  CFG_AWADDR                          ,
            S_AXI_LITE_CFG_AWPROT           =>  CFG_AWPROT                          ,
            S_AXI_LITE_CFG_AWVALID          =>  CFG_AWVALID                         ,
            S_AXI_LITE_CFG_AWREADY          =>  CFG_AWREADY                         ,
            S_AXI_LITE_CFG_WDATA            =>  CFG_WDATA                           ,
            S_AXI_LITE_CFG_WSTRB            =>  CFG_WSTRB                           ,
            S_AXI_LITE_CFG_WVALID           =>  CFG_WVALID                          ,
            S_AXI_LITE_CFG_WREADY           =>  CFG_WREADY                          ,
            S_AXI_LITE_CFG_BRESP            =>  CFG_BRESP                           ,
            S_AXI_LITE_CFG_BVALID           =>  CFG_BVALID                          ,
            S_AXI_LITE_CFG_BREADY           =>  CFG_BREADY                          ,
            S_AXI_LITE_CFG_ARADDR           =>  CFG_ARADDR                          ,
            S_AXI_LITE_CFG_ARPROT           =>  CFG_ARPROT                          ,
            S_AXI_LITE_CFG_ARVALID          =>  CFG_ARVALID                         ,
            S_AXI_LITE_CFG_ARREADY          =>  CFG_ARREADY                         ,
            S_AXI_LITE_CFG_RDATA            =>  CFG_RDATA                           ,
            S_AXI_LITE_CFG_RRESP            =>  CFG_RRESP                           ,
            S_AXI_LITE_CFG_RVALID           =>  CFG_RVALID                          ,
            S_AXI_LITE_CFG_RREADY           =>  CFG_RREADY                          ,
            
            S_AXI_LITE_DEV_AWADDR           =>  DEV_AWADDR                          ,
            S_AXI_LITE_DEV_AWPROT           =>  DEV_AWPROT                          ,
            S_AXI_LITE_DEV_AWVALID          =>  DEV_AWVALID                         ,
            S_AXI_LITE_DEV_AWREADY          =>  DEV_AWREADY                         ,
            S_AXI_LITE_DEV_WDATA            =>  DEV_WDATA                           ,
            S_AXI_LITE_DEV_WSTRB            =>  DEV_WSTRB                           ,
            S_AXI_LITE_DEV_WVALID           =>  DEV_WVALID                          ,
            S_AXI_LITE_DEV_WREADY           =>  DEV_WREADY                          ,
            S_AXI_LITE_DEV_BRESP            =>  DEV_BRESP                           ,
            S_AXI_LITE_DEV_BVALID           =>  DEV_BVALID                          ,
            S_AXI_LITE_DEV_BREADY           =>  DEV_BREADY                          ,
            S_AXI_LITE_DEV_ARADDR           =>  DEV_ARADDR                          ,
            S_AXI_LITE_DEV_ARPROT           =>  DEV_ARPROT                          ,
            S_AXI_LITE_DEV_ARVALID          =>  DEV_ARVALID                         ,
            S_AXI_LITE_DEV_ARREADY          =>  DEV_ARREADY                         ,
            S_AXI_LITE_DEV_RDATA            =>  DEV_RDATA                           ,
            S_AXI_LITE_DEV_RRESP            =>  DEV_RRESP                           ,
            S_AXI_LITE_DEV_RVALID           =>  DEV_RVALID                          ,
            S_AXI_LITE_DEV_RREADY           =>  DEV_RREADY                          ,
            
            M_AXIS_TDATA                    =>  M_AXIS_TDATA                        ,
            M_AXIS_TKEEP                    =>  M_AXIS_TKEEP                        ,
            M_AXIS_TUSER                    =>  M_AXIS_TUSER                        ,
            M_AXIS_TVALID                   =>  M_AXIS_TVALID                       ,
            M_AXIS_TLAST                    =>  M_AXIS_TLAST                        ,
            M_AXIS_TREADY                   =>  M_AXIS_TREADY                       ,
            
            S_AXIS_TDATA                    =>  S_AXIS_TDATA                        ,
            S_AXIS_TKEEP                    =>  S_AXIS_TKEEP                        ,
            S_AXIS_TUSER                    =>  S_AXIS_TUSER                        ,
            S_AXIS_TVALID                   =>  S_AXIS_TVALID                       ,
            S_AXIS_TLAST                    =>  S_AXIS_TLAST                        ,
            S_AXIS_TREADY                   =>  S_AXIS_TREADY                       ,
            ADXL_INTERRUPT                  =>  ADXL_INTERRUPT                      ,
            ADXL_IRQ                        =>  ADXL_IRQ                             
        );
 

    axis_iic_master_controller_inst : axis_iic_master_controller
        generic map (
            CLK_FREQUENCY                   =>  CLK_PERIOD                          ,
            CLK_IIC_FREQUENCY               =>  400000                              ,
            FIFO_DEPTH                      =>  64 
        )
        port map (
            CLK                                 =>  CLK                                 ,
            RESET                               =>  RESET                               ,
            -- SLave AXI-Stream 
            S_AXIS_TDATA                        =>  M_AXIS_TDATA                        ,
            S_AXIS_TDEST                        =>  M_AXIS_TUSER                        ,
            S_AXIS_TVALID                       =>  M_AXIS_TVALID                       ,
            S_AXIS_TLAST                        =>  M_AXIS_TLAST                        ,
            S_AXIS_TREADY                       =>  M_AXIS_TREADY                       ,

            M_AXIS_TDATA                        =>  S_AXIS_TDATA                        ,
            M_AXIS_TDEST                        =>  S_AXIS_TUSER                        ,
            M_AXIS_TVALID                       =>  S_AXIS_TVALID                       ,
            M_AXIS_TLAST                        =>  S_AXIS_TLAST                        ,
            M_AXIS_TREADY                       =>  S_AXIS_TREADY                       ,

            SCL_I                               =>  SCL_I                               ,
            SCL_T                               =>  SCL_T                               ,
            SDA_I                               =>  SDA_I                               ,
            SDA_T                               =>  SDA_T                                

        );


    tb_device_imitation_inst : tb_device_imitation 
        port map (
            IIC_SCL_I           =>  SCL_T                       ,
            IIC_SDA_I           =>  SDA_T                       ,
            IIC_SCL_O           =>  SCL_I                       ,
            IIC_SDA_O           =>  SDA_I                       ,
            IRQ                 =>  ADXL_INTERRUPT               
        );


    device_write_processing : process(CLK)
    begin 
        if CLK'event AND CLK = '1' then 
            case i is 

                --when 10000  => DEV_AWADDR <= x"00000004";  DEV_AWVALID <= '1'; DEV_WDATA <= x"03020100"; DEV_WSTRB <= x"F"; DEV_WVALID <= '1'; DEV_BREADY <= '1';
                --when 10001  => DEV_AWADDR <= x"00000004";  DEV_AWVALID <= '1'; DEV_WDATA <= x"03020100"; DEV_WSTRB <= x"F"; DEV_WVALID <= '1'; DEV_BREADY <= '1';
                --when 10002  => DEV_AWADDR <= x"00000004";  DEV_AWVALID <= '0'; DEV_WDATA <= x"03020100"; DEV_WSTRB <= x"F"; DEV_WVALID <= '0'; DEV_BREADY <= '1';

                when 10000  => DEV_AWADDR <= x"0000002D";  DEV_AWVALID <= '1'; DEV_WDATA <= x"00008000"; DEV_WSTRB <= x"2"; DEV_WVALID <= '1'; DEV_BREADY <= '1';
                when 10001  => DEV_AWADDR <= x"0000002D";  DEV_AWVALID <= '1'; DEV_WDATA <= x"00008000"; DEV_WSTRB <= x"2"; DEV_WVALID <= '1'; DEV_BREADY <= '1';
                when 10002  => DEV_AWADDR <= x"0000002D";  DEV_AWVALID <= '0'; DEV_WDATA <= x"00008000"; DEV_WSTRB <= x"2"; DEV_WVALID <= '0'; DEV_BREADY <= '1';





                when others => DEV_AWADDR <= DEV_AWADDR;  DEV_AWVALID <= '0'; DEV_WDATA <= DEV_WDATA; DEV_WSTRB <= DEV_WSTRB; DEV_WVALID <= '0'; DEV_BREADY <= '0';

            end case;
        end if;
    end process;


    cfg_write_processing : process(CLK)
    begin 
        if CLK'event AND CLK = '1' then 
            case i is 

                when  900  => CFG_AWADDR <= x"00000004";  CFG_AWVALID <= '1'; CFG_WDATA <= x"00010000"; CFG_WSTRB <= x"F"; CFG_WVALID <= '1'; CFG_BREADY <= '1';
                when  901  => CFG_AWADDR <= x"00000004";  CFG_AWVALID <= '1'; CFG_WDATA <= x"00010000"; CFG_WSTRB <= x"F"; CFG_WVALID <= '1'; CFG_BREADY <= '1';
                when  902  => CFG_AWADDR <= x"00000004";  CFG_AWVALID <= '0'; CFG_WDATA <= x"00010000"; CFG_WSTRB <= x"F"; CFG_WVALID <= '0'; CFG_BREADY <= '1';

                --when 1000  => CFG_AWADDR <= x"00000000";  CFG_AWVALID <= '1'; CFG_WDATA <= x"00000002"; CFG_WSTRB <= x"1"; CFG_WVALID <= '1'; CFG_BREADY <= '1';
                --when 1001  => CFG_AWADDR <= x"00000000";  CFG_AWVALID <= '1'; CFG_WDATA <= x"00000002"; CFG_WSTRB <= x"1"; CFG_WVALID <= '1'; CFG_BREADY <= '1';
                --when 1002  => CFG_AWADDR <= x"00000000";  CFG_AWVALID <= '0'; CFG_WDATA <= x"00000002"; CFG_WSTRB <= x"1"; CFG_WVALID <= '0'; CFG_BREADY <= '1';

                --when 1000  => CFG_AWADDR <= x"00000030";  CFG_AWVALID <= '1'; CFG_WDATA <= x"00320601"; CFG_WSTRB <= x"F"; CFG_WVALID <= '1'; CFG_BREADY <= '1';
                --when 1001  => CFG_AWADDR <= x"00000030";  CFG_AWVALID <= '1'; CFG_WDATA <= x"00320601"; CFG_WSTRB <= x"F"; CFG_WVALID <= '1'; CFG_BREADY <= '1';
                --when 1002  => CFG_AWADDR <= x"00000030";  CFG_AWVALID <= '0'; CFG_WDATA <= x"00320601"; CFG_WSTRB <= x"F"; CFG_WVALID <= '0'; CFG_BREADY <= '1';


                when 1000  => CFG_AWADDR <= x"00000000";  CFG_AWVALID <= '1'; CFG_WDATA <= x"00000004"; CFG_WSTRB <= x"1"; CFG_WVALID <= '1'; CFG_BREADY <= '1';
                when 1001  => CFG_AWADDR <= x"00000000";  CFG_AWVALID <= '1'; CFG_WDATA <= x"00000004"; CFG_WSTRB <= x"1"; CFG_WVALID <= '1'; CFG_BREADY <= '1';
                when 1002  => CFG_AWADDR <= x"00000000";  CFG_AWVALID <= '0'; CFG_WDATA <= x"00000004"; CFG_WSTRB <= x"1"; CFG_WVALID <= '0'; CFG_BREADY <= '1';

                when others => CFG_AWADDR <= CFG_AWADDR;  CFG_AWVALID <= '0'; CFG_WDATA <= CFG_WDATA; CFG_WSTRB <= CFG_WSTRB; CFG_WVALID <= '0'; CFG_BREADY <= '0';

            end case;
        end if;
    end process;


    --cfg_read_processing : process(CLK)
    --begin 
    --    if CLK'event AND CLK = '1' then 
    --        case i is 

    --            when 100000  => CFG_ARADDR <= x"00000000";  CFG_ARVALID <= '1'; CFG_RREADY <= '1';
    --            when 100001  => CFG_ARADDR <= x"00000000";  CFG_ARVALID <= '1'; CFG_RREADY <= '1';
    --            when 100002  => CFG_ARADDR <= x"00000000";  CFG_ARVALID <= '0'; CFG_RREADY <= '1';
    --            when 100003  => CFG_ARADDR <= x"00000000";  CFG_ARVALID <= '0'; CFG_RREADY <= '1';


    --            when others => CFG_ARADDR <= CFG_ARADDR;  CFG_ARVALID <= '0'; CFG_RREADY <= '0';

    --        end case;
    --    end if;
    --end process;




end Behavioral;
