----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 20.05.2023 17:29:38
-- Design Name: 
-- Module Name: tb_axi_adxl345 - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
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
    use ieee.std_logic_unsigned.all;
    use ieee.std_Logic_arith.all;


entity tb_axi_adxl345 is
end tb_axi_adxl345;



architecture Behavioral of tb_axi_adxl345 is


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
 


    --device_write_processing : process(CLK)
    --begin 
    --    if CLK'event AND CLK = '1' then 
    --        case i is 

    --            when 10000  => DEV_AWADDR <= x"00000004";  DEV_AWVALID <= '1'; DEV_WDATA <= x"03020100"; DEV_WSTRB <= x"F"; DEV_WVALID <= '1'; DEV_BREADY <= '1';
    --            when 10001  => DEV_AWADDR <= x"00000004";  DEV_AWVALID <= '1'; DEV_WDATA <= x"03020100"; DEV_WSTRB <= x"F"; DEV_WVALID <= '1'; DEV_BREADY <= '1';
    --            when 10002  => DEV_AWADDR <= x"00000004";  DEV_AWVALID <= '0'; DEV_WDATA <= x"03020100"; DEV_WSTRB <= x"F"; DEV_WVALID <= '0'; DEV_BREADY <= '1';




    --            when others => DEV_AWADDR <= DEV_AWADDR;  DEV_AWVALID <= '0'; DEV_WDATA <= DEV_WDATA; DEV_WSTRB <= DEV_WSTRB; DEV_WVALID <= '0'; DEV_BREADY <= '0';

    --        end case;
    --    end if;
    --end process;


    cfg_write_processing : process(CLK)
    begin 
        if CLK'event AND CLK = '1' then 
            case i is 

                when 1000  => CFG_AWADDR <= x"00000000";  CFG_AWVALID <= '1'; CFG_WDATA <= x"00000001"; CFG_WSTRB <= x"1"; CFG_WVALID <= '1'; CFG_BREADY <= '1';
                when 1001  => CFG_AWADDR <= x"00000000";  CFG_AWVALID <= '1'; CFG_WDATA <= x"00000001"; CFG_WSTRB <= x"1"; CFG_WVALID <= '1'; CFG_BREADY <= '1';
                when 1002  => CFG_AWADDR <= x"00000000";  CFG_AWVALID <= '0'; CFG_WDATA <= x"00000001"; CFG_WSTRB <= x"1"; CFG_WVALID <= '0'; CFG_BREADY <= '1';

                when 2000  => CFG_AWADDR <= x"00000000";  CFG_AWVALID <= '1'; CFG_WDATA <= x"00000002"; CFG_WSTRB <= x"1"; CFG_WVALID <= '1'; CFG_BREADY <= '1';
                when 2001  => CFG_AWADDR <= x"00000000";  CFG_AWVALID <= '1'; CFG_WDATA <= x"00000002"; CFG_WSTRB <= x"1"; CFG_WVALID <= '1'; CFG_BREADY <= '1';
                when 2002  => CFG_AWADDR <= x"00000000";  CFG_AWVALID <= '0'; CFG_WDATA <= x"00000002"; CFG_WSTRB <= x"1"; CFG_WVALID <= '0'; CFG_BREADY <= '1';

                when 3000  => CFG_AWADDR <= x"00000000";  CFG_AWVALID <= '1'; CFG_WDATA <= x"00000006"; CFG_WSTRB <= x"1"; CFG_WVALID <= '1'; CFG_BREADY <= '1';
                when 3001  => CFG_AWADDR <= x"00000000";  CFG_AWVALID <= '1'; CFG_WDATA <= x"00000006"; CFG_WSTRB <= x"1"; CFG_WVALID <= '1'; CFG_BREADY <= '1';
                when 3002  => CFG_AWADDR <= x"00000000";  CFG_AWVALID <= '0'; CFG_WDATA <= x"00000006"; CFG_WSTRB <= x"1"; CFG_WVALID <= '0'; CFG_BREADY <= '1';

                when 4000  => CFG_AWADDR <= x"00000000";  CFG_AWVALID <= '1'; CFG_WDATA <= x"00000007"; CFG_WSTRB <= x"1"; CFG_WVALID <= '1'; CFG_BREADY <= '1';
                when 4001  => CFG_AWADDR <= x"00000000";  CFG_AWVALID <= '1'; CFG_WDATA <= x"00000007"; CFG_WSTRB <= x"1"; CFG_WVALID <= '1'; CFG_BREADY <= '1';
                when 4002  => CFG_AWADDR <= x"00000000";  CFG_AWVALID <= '0'; CFG_WDATA <= x"00000007"; CFG_WSTRB <= x"1"; CFG_WVALID <= '0'; CFG_BREADY <= '1';

                when 5000  => CFG_AWADDR <= x"00000001";  CFG_AWVALID <= '1'; CFG_WDATA <= x"00005400"; CFG_WSTRB <= x"2"; CFG_WVALID <= '1'; CFG_BREADY <= '1';
                when 5001  => CFG_AWADDR <= x"00000001";  CFG_AWVALID <= '1'; CFG_WDATA <= x"00005400"; CFG_WSTRB <= x"2"; CFG_WVALID <= '1'; CFG_BREADY <= '1';
                when 5002  => CFG_AWADDR <= x"00000001";  CFG_AWVALID <= '0'; CFG_WDATA <= x"00005400"; CFG_WSTRB <= x"2"; CFG_WVALID <= '0'; CFG_BREADY <= '1';

                when 6000  => CFG_AWADDR <= x"00000004";  CFG_AWVALID <= '1'; CFG_WDATA <= x"FFFFFF11"; CFG_WSTRB <= x"1"; CFG_WVALID <= '1'; CFG_BREADY <= '1';
                when 6001  => CFG_AWADDR <= x"00000004";  CFG_AWVALID <= '1'; CFG_WDATA <= x"FFFFFF11"; CFG_WSTRB <= x"1"; CFG_WVALID <= '1'; CFG_BREADY <= '1';
                when 6002  => CFG_AWADDR <= x"00000004";  CFG_AWVALID <= '0'; CFG_WDATA <= x"FFFFFF11"; CFG_WSTRB <= x"1"; CFG_WVALID <= '0'; CFG_BREADY <= '1';

                when 6100  => CFG_AWADDR <= x"00000005";  CFG_AWVALID <= '1'; CFG_WDATA <= x"FFFF22FF"; CFG_WSTRB <= x"2"; CFG_WVALID <= '1'; CFG_BREADY <= '1';
                when 6101  => CFG_AWADDR <= x"00000005";  CFG_AWVALID <= '1'; CFG_WDATA <= x"FFFF22FF"; CFG_WSTRB <= x"2"; CFG_WVALID <= '1'; CFG_BREADY <= '1';
                when 6102  => CFG_AWADDR <= x"00000005";  CFG_AWVALID <= '0'; CFG_WDATA <= x"FFFF22FF"; CFG_WSTRB <= x"2"; CFG_WVALID <= '0'; CFG_BREADY <= '1';

                when 6200  => CFG_AWADDR <= x"00000006";  CFG_AWVALID <= '1'; CFG_WDATA <= x"FF33FFFF"; CFG_WSTRB <= x"4"; CFG_WVALID <= '1'; CFG_BREADY <= '1';
                when 6201  => CFG_AWADDR <= x"00000006";  CFG_AWVALID <= '1'; CFG_WDATA <= x"FF33FFFF"; CFG_WSTRB <= x"4"; CFG_WVALID <= '1'; CFG_BREADY <= '1';
                when 6202  => CFG_AWADDR <= x"00000006";  CFG_AWVALID <= '0'; CFG_WDATA <= x"FF33FFFF"; CFG_WSTRB <= x"4"; CFG_WVALID <= '0'; CFG_BREADY <= '1';

                when 6300  => CFG_AWADDR <= x"00000007";  CFG_AWVALID <= '1'; CFG_WDATA <= x"44FFFFFF"; CFG_WSTRB <= x"8"; CFG_WVALID <= '1'; CFG_BREADY <= '1';
                when 6301  => CFG_AWADDR <= x"00000007";  CFG_AWVALID <= '1'; CFG_WDATA <= x"44FFFFFF"; CFG_WSTRB <= x"8"; CFG_WVALID <= '1'; CFG_BREADY <= '1';
                when 6302  => CFG_AWADDR <= x"00000007";  CFG_AWVALID <= '0'; CFG_WDATA <= x"44FFFFFF"; CFG_WSTRB <= x"8"; CFG_WVALID <= '0'; CFG_BREADY <= '1';

                when 7000  => CFG_AWADDR <= x"00000031";  CFG_AWVALID <= '1'; CFG_WDATA <= x"00001F00"; CFG_WSTRB <= x"2"; CFG_WVALID <= '1'; CFG_BREADY <= '1';
                when 7001  => CFG_AWADDR <= x"00000031";  CFG_AWVALID <= '1'; CFG_WDATA <= x"00001F00"; CFG_WSTRB <= x"2"; CFG_WVALID <= '1'; CFG_BREADY <= '1';
                when 7002  => CFG_AWADDR <= x"00000031";  CFG_AWVALID <= '0'; CFG_WDATA <= x"00001F00"; CFG_WSTRB <= x"2"; CFG_WVALID <= '0'; CFG_BREADY <= '1';

                when 7100  => CFG_AWADDR <= x"00000032";  CFG_AWVALID <= '1'; CFG_WDATA <= x"00F10000"; CFG_WSTRB <= x"4"; CFG_WVALID <= '1'; CFG_BREADY <= '1';
                when 7101  => CFG_AWADDR <= x"00000032";  CFG_AWVALID <= '1'; CFG_WDATA <= x"00F10000"; CFG_WSTRB <= x"4"; CFG_WVALID <= '1'; CFG_BREADY <= '1';
                when 7102  => CFG_AWADDR <= x"00000032";  CFG_AWVALID <= '0'; CFG_WDATA <= x"00F10000"; CFG_WSTRB <= x"4"; CFG_WVALID <= '0'; CFG_BREADY <= '1';

                when 7110  => CFG_AWADDR <= x"00000030";  CFG_AWVALID <= '1'; CFG_WDATA <= x"00000001"; CFG_WSTRB <= x"1"; CFG_WVALID <= '1'; CFG_BREADY <= '1';
                when 7111  => CFG_AWADDR <= x"00000030";  CFG_AWVALID <= '1'; CFG_WDATA <= x"00000001"; CFG_WSTRB <= x"1"; CFG_WVALID <= '1'; CFG_BREADY <= '1';
                when 7112  => CFG_AWADDR <= x"00000030";  CFG_AWVALID <= '0'; CFG_WDATA <= x"00000001"; CFG_WSTRB <= x"1"; CFG_WVALID <= '0'; CFG_BREADY <= '1';


                when others => CFG_AWADDR <= CFG_AWADDR;  CFG_AWVALID <= '0'; CFG_WDATA <= CFG_WDATA; CFG_WSTRB <= CFG_WSTRB; CFG_WVALID <= '0'; CFG_BREADY <= '0';

            end case;
        end if;
    end process;


    cfg_read_processing : process(CLK)
    begin 
        if CLK'event AND CLK = '1' then 
            case i is 

                when 100000  => CFG_ARADDR <= x"00000000";  CFG_ARVALID <= '1'; CFG_RREADY <= '1';
                when 100001  => CFG_ARADDR <= x"00000000";  CFG_ARVALID <= '1'; CFG_RREADY <= '1';
                when 100002  => CFG_ARADDR <= x"00000000";  CFG_ARVALID <= '0'; CFG_RREADY <= '1';
                when 100003  => CFG_ARADDR <= x"00000000";  CFG_ARVALID <= '0'; CFG_RREADY <= '1';

                when 100010  => CFG_ARADDR <= x"00000004";  CFG_ARVALID <= '1'; CFG_RREADY <= '1';
                when 100011  => CFG_ARADDR <= x"00000004";  CFG_ARVALID <= '1'; CFG_RREADY <= '1';
                when 100012  => CFG_ARADDR <= x"00000004";  CFG_ARVALID <= '0'; CFG_RREADY <= '1';
                when 100013  => CFG_ARADDR <= x"00000004";  CFG_ARVALID <= '0'; CFG_RREADY <= '1';

                when 100020  => CFG_ARADDR <= x"00000008";  CFG_ARVALID <= '1'; CFG_RREADY <= '1';
                when 100021  => CFG_ARADDR <= x"00000008";  CFG_ARVALID <= '1'; CFG_RREADY <= '1';
                when 100022  => CFG_ARADDR <= x"00000008";  CFG_ARVALID <= '0'; CFG_RREADY <= '1';
                when 100023  => CFG_ARADDR <= x"00000008";  CFG_ARVALID <= '0'; CFG_RREADY <= '1';

                when 100030  => CFG_ARADDR <= x"0000000C";  CFG_ARVALID <= '1'; CFG_RREADY <= '1';
                when 100031  => CFG_ARADDR <= x"0000000C";  CFG_ARVALID <= '1'; CFG_RREADY <= '1';
                when 100032  => CFG_ARADDR <= x"0000000C";  CFG_ARVALID <= '0'; CFG_RREADY <= '1';
                when 100033  => CFG_ARADDR <= x"0000000C";  CFG_ARVALID <= '0'; CFG_RREADY <= '1';

                when 100040  => CFG_ARADDR <= x"00000010";  CFG_ARVALID <= '1'; CFG_RREADY <= '1';
                when 100041  => CFG_ARADDR <= x"00000010";  CFG_ARVALID <= '1'; CFG_RREADY <= '1';
                when 100042  => CFG_ARADDR <= x"00000010";  CFG_ARVALID <= '0'; CFG_RREADY <= '1';
                when 100043  => CFG_ARADDR <= x"00000010";  CFG_ARVALID <= '0'; CFG_RREADY <= '1';

                when 100050  => CFG_ARADDR <= x"00000014";  CFG_ARVALID <= '1'; CFG_RREADY <= '1';
                when 100051  => CFG_ARADDR <= x"00000014";  CFG_ARVALID <= '1'; CFG_RREADY <= '1';
                when 100052  => CFG_ARADDR <= x"00000014";  CFG_ARVALID <= '0'; CFG_RREADY <= '1';
                when 100053  => CFG_ARADDR <= x"00000014";  CFG_ARVALID <= '0'; CFG_RREADY <= '1';

                when 100060  => CFG_ARADDR <= x"00000018";  CFG_ARVALID <= '1'; CFG_RREADY <= '1';
                when 100061  => CFG_ARADDR <= x"00000018";  CFG_ARVALID <= '1'; CFG_RREADY <= '1';
                when 100062  => CFG_ARADDR <= x"00000018";  CFG_ARVALID <= '0'; CFG_RREADY <= '1';
                when 100063  => CFG_ARADDR <= x"00000018";  CFG_ARVALID <= '0'; CFG_RREADY <= '1';

                when 100070  => CFG_ARADDR <= x"0000001C";  CFG_ARVALID <= '1'; CFG_RREADY <= '1';
                when 100071  => CFG_ARADDR <= x"0000001C";  CFG_ARVALID <= '1'; CFG_RREADY <= '1';
                when 100072  => CFG_ARADDR <= x"0000001C";  CFG_ARVALID <= '0'; CFG_RREADY <= '1';
                when 100073  => CFG_ARADDR <= x"0000001C";  CFG_ARVALID <= '0'; CFG_RREADY <= '1';

                when 100080  => CFG_ARADDR <= x"00000020";  CFG_ARVALID <= '1'; CFG_RREADY <= '1';
                when 100081  => CFG_ARADDR <= x"00000020";  CFG_ARVALID <= '1'; CFG_RREADY <= '1';
                when 100082  => CFG_ARADDR <= x"00000020";  CFG_ARVALID <= '0'; CFG_RREADY <= '1';
                when 100083  => CFG_ARADDR <= x"00000020";  CFG_ARVALID <= '0'; CFG_RREADY <= '1';

                when 100090  => CFG_ARADDR <= x"00000024";  CFG_ARVALID <= '1'; CFG_RREADY <= '1';
                when 100091  => CFG_ARADDR <= x"00000024";  CFG_ARVALID <= '1'; CFG_RREADY <= '1';
                when 100092  => CFG_ARADDR <= x"00000024";  CFG_ARVALID <= '0'; CFG_RREADY <= '1';
                when 100093  => CFG_ARADDR <= x"00000024";  CFG_ARVALID <= '0'; CFG_RREADY <= '1';

                when 100100  => CFG_ARADDR <= x"00000028";  CFG_ARVALID <= '1'; CFG_RREADY <= '1';
                when 100101  => CFG_ARADDR <= x"00000028";  CFG_ARVALID <= '1'; CFG_RREADY <= '1';
                when 100102  => CFG_ARADDR <= x"00000028";  CFG_ARVALID <= '0'; CFG_RREADY <= '1';
                when 100103  => CFG_ARADDR <= x"00000028";  CFG_ARVALID <= '0'; CFG_RREADY <= '1';

                when 100110  => CFG_ARADDR <= x"0000002C";  CFG_ARVALID <= '1'; CFG_RREADY <= '1';
                when 100111  => CFG_ARADDR <= x"0000002C";  CFG_ARVALID <= '1'; CFG_RREADY <= '1';
                when 100112  => CFG_ARADDR <= x"0000002C";  CFG_ARVALID <= '0'; CFG_RREADY <= '1';
                when 100113  => CFG_ARADDR <= x"0000002C";  CFG_ARVALID <= '0'; CFG_RREADY <= '1';

                when 100120  => CFG_ARADDR <= x"00000030";  CFG_ARVALID <= '1'; CFG_RREADY <= '1';
                when 100121  => CFG_ARADDR <= x"00000030";  CFG_ARVALID <= '1'; CFG_RREADY <= '1';
                when 100122  => CFG_ARADDR <= x"00000030";  CFG_ARVALID <= '0'; CFG_RREADY <= '1';
                when 100123  => CFG_ARADDR <= x"00000030";  CFG_ARVALID <= '0'; CFG_RREADY <= '1';


                when others => CFG_ARADDR <= CFG_ARADDR;  CFG_ARVALID <= '0'; CFG_RREADY <= '0';

            end case;
        end if;
    end process;




    S_AXIS_processing : process(CLK)
    begin 
        if CLK'event AND CLK = '1' then 
            case i is 
                -- Имитация получения данных от датчика при проверке работы по таймеру. 
                when 2000   => S_AXIS_TDATA <= x"E5"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"0"
                when 2001   => S_AXIS_TDATA <= x"01"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"0"
                when 2002   => S_AXIS_TDATA <= x"02"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"0"
                when 2003   => S_AXIS_TDATA <= x"03"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"0"
                when 2004   => S_AXIS_TDATA <= x"04"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"1"
                when 2005   => S_AXIS_TDATA <= x"05"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"1"
                when 2006   => S_AXIS_TDATA <= x"06"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"1"
                when 2007   => S_AXIS_TDATA <= x"07"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"1"
                when 2008   => S_AXIS_TDATA <= x"08"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"2"
                when 2009   => S_AXIS_TDATA <= x"09"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"2"
                when 2010   => S_AXIS_TDATA <= x"0A"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"2"
                when 2011   => S_AXIS_TDATA <= x"0B"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"2"
                when 2012   => S_AXIS_TDATA <= x"0C"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"3"
                when 2013   => S_AXIS_TDATA <= x"0D"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"3"
                when 2014   => S_AXIS_TDATA <= x"0E"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"3"
                when 2015   => S_AXIS_TDATA <= x"0F"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"3"
                when 2016   => S_AXIS_TDATA <= x"10"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"4"
                when 2017   => S_AXIS_TDATA <= x"11"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"4"
                when 2018   => S_AXIS_TDATA <= x"12"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"4"
                when 2019   => S_AXIS_TDATA <= x"13"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"4"
                when 2020   => S_AXIS_TDATA <= x"14"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"5"
                when 2021   => S_AXIS_TDATA <= x"15"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"5"
                when 2022   => S_AXIS_TDATA <= x"16"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"5"
                when 2023   => S_AXIS_TDATA <= x"17"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"5"
                when 2024   => S_AXIS_TDATA <= x"18"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"6"
                when 2025   => S_AXIS_TDATA <= x"19"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"6"
                when 2026   => S_AXIS_TDATA <= x"1A"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"6"
                when 2027   => S_AXIS_TDATA <= x"1B"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"6"
                when 2028   => S_AXIS_TDATA <= x"1C"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"7"
                when 2029   => S_AXIS_TDATA <= x"1D"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"7"
                when 2030   => S_AXIS_TDATA <= x"1E"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"7"
                when 2031   => S_AXIS_TDATA <= x"1F"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"7"
                when 2032   => S_AXIS_TDATA <= x"20"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"8"
                when 2033   => S_AXIS_TDATA <= x"21"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"8"
                when 2034   => S_AXIS_TDATA <= x"22"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"8"
                when 2035   => S_AXIS_TDATA <= x"23"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"8"
                when 2036   => S_AXIS_TDATA <= x"24"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"9"
                when 2037   => S_AXIS_TDATA <= x"25"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"9"
                when 2038   => S_AXIS_TDATA <= x"26"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"9"
                when 2039   => S_AXIS_TDATA <= x"27"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"9"
                when 2040   => S_AXIS_TDATA <= x"28"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"A"
                when 2041   => S_AXIS_TDATA <= x"29"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"A"
                when 2042   => S_AXIS_TDATA <= x"2A"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"A"
                when 2043   => S_AXIS_TDATA <= x"2B"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"A"
                when 2044   => S_AXIS_TDATA <= x"2C"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"B"
                when 2045   => S_AXIS_TDATA <= x"2D"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"B"
                when 2046   => S_AXIS_TDATA <= x"2E"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"B"
                when 2047   => S_AXIS_TDATA <= x"2F"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"B"
                when 2048   => S_AXIS_TDATA <= x"30"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"C"
                when 2049   => S_AXIS_TDATA <= x"31"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"C"
                when 2050   => S_AXIS_TDATA <= x"32"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"C"
                when 2051   => S_AXIS_TDATA <= x"33"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"C"
                when 2052   => S_AXIS_TDATA <= x"34"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"d"
                when 2053   => S_AXIS_TDATA <= x"35"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"d"
                when 2054   => S_AXIS_TDATA <= x"36"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"d"
                when 2055   => S_AXIS_TDATA <= x"37"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"d"
                when 2056   => S_AXIS_TDATA <= x"38"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0';
                when 2057   => S_AXIS_TDATA <= x"39"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '1';


                -- Проверка после того, как мы отправили обновление для некоторых регистров 
                when 30000   => S_AXIS_TDATA <= x"E5"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"0"
                when 30001   => S_AXIS_TDATA <= x"01"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"0"
                when 30002   => S_AXIS_TDATA <= x"02"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"0"
                when 30003   => S_AXIS_TDATA <= x"03"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"0"
                when 30004   => S_AXIS_TDATA <= x"04"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"1"
                when 30005   => S_AXIS_TDATA <= x"05"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"1"
                when 30006   => S_AXIS_TDATA <= x"06"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"1"
                when 30007   => S_AXIS_TDATA <= x"07"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"1"
                when 30008   => S_AXIS_TDATA <= x"08"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"2"
                when 30009   => S_AXIS_TDATA <= x"09"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"2"
                when 30010   => S_AXIS_TDATA <= x"0A"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"2"
                when 30011   => S_AXIS_TDATA <= x"0B"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"2"
                when 30012   => S_AXIS_TDATA <= x"0C"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"3"
                when 30013   => S_AXIS_TDATA <= x"0D"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"3"
                when 30014   => S_AXIS_TDATA <= x"0E"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"3"
                when 30015   => S_AXIS_TDATA <= x"0F"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"3"
                when 30016   => S_AXIS_TDATA <= x"10"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"4"
                when 30017   => S_AXIS_TDATA <= x"11"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"4"
                when 30018   => S_AXIS_TDATA <= x"12"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"4"
                when 30019   => S_AXIS_TDATA <= x"13"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"4"
                when 30020   => S_AXIS_TDATA <= x"14"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"5"
                when 30021   => S_AXIS_TDATA <= x"15"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"5"
                when 30022   => S_AXIS_TDATA <= x"16"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"5"
                when 30023   => S_AXIS_TDATA <= x"17"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"5"
                when 30024   => S_AXIS_TDATA <= x"18"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"6"
                when 30025   => S_AXIS_TDATA <= x"19"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"6"
                when 30026   => S_AXIS_TDATA <= x"1A"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"6"
                when 30027   => S_AXIS_TDATA <= x"1B"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"6"
                when 30028   => S_AXIS_TDATA <= x"1C"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"7"
                when 30029   => S_AXIS_TDATA <= x"1D"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"7"
                when 30030   => S_AXIS_TDATA <= x"1E"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"7"
                when 30031   => S_AXIS_TDATA <= x"1F"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"7"
                when 30032   => S_AXIS_TDATA <= x"20"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"8"
                when 30033   => S_AXIS_TDATA <= x"21"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"8"
                when 30034   => S_AXIS_TDATA <= x"22"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"8"
                when 30035   => S_AXIS_TDATA <= x"23"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"8"
                when 30036   => S_AXIS_TDATA <= x"24"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"9"
                when 30037   => S_AXIS_TDATA <= x"25"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"9"
                when 30038   => S_AXIS_TDATA <= x"26"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"9"
                when 30039   => S_AXIS_TDATA <= x"27"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"9"
                when 30040   => S_AXIS_TDATA <= x"28"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"A"
                when 30041   => S_AXIS_TDATA <= x"29"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"A"
                when 30042   => S_AXIS_TDATA <= x"2A"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"A"
                when 30043   => S_AXIS_TDATA <= x"2B"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"A"
                when 30044   => S_AXIS_TDATA <= x"00"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"B" -- THIS PLACE
                when 30045   => S_AXIS_TDATA <= x"01"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"B" -- THIS PLACE
                when 30046   => S_AXIS_TDATA <= x"2E"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"B"
                when 30047   => S_AXIS_TDATA <= x"2F"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"B"
                when 30048   => S_AXIS_TDATA <= x"30"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"C"
                when 30049   => S_AXIS_TDATA <= x"31"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"C"
                when 30050   => S_AXIS_TDATA <= x"32"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"C"
                when 30051   => S_AXIS_TDATA <= x"33"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"C"
                when 30052   => S_AXIS_TDATA <= x"34"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"d"
                when 30053   => S_AXIS_TDATA <= x"35"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"d"
                when 30054   => S_AXIS_TDATA <= x"36"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"d"
                when 30055   => S_AXIS_TDATA <= x"37"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"d"
                when 30056   => S_AXIS_TDATA <= x"38"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0';
                when 30057   => S_AXIS_TDATA <= x"39"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '1';
                when others => S_AXIS_TDATA <= S_AXIS_TDATA; S_AXIS_TKEEP <= S_AXIS_TKEEP; S_AXIS_TUSER <= S_AXIS_TUSER; S_AXIS_TVALID <= '0'; S_AXIS_TLAST <= S_AXIS_TLAST; 
            end case;
        end if;
    end process;



end Behavioral;
