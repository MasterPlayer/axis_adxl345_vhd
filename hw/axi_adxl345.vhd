library IEEE;
    use IEEE.STD_LOGIC_1164.ALL;
    use ieee.std_logic_unsigned.all;
    use ieee.std_logic_arith.all;
--Адрес  | Номер | Имя регистра           |   Биты  |  Название поля           |  Маска     |  Доступ |
--  0x00 |     0 | CTRL_REG               | [31:24] | VERSION_MAJOR            | 0xFF000000 |  RO     |         
--       |       |                        | [23:16] | VERSION_MINOR            | 0x00FF0000 |  RO     |         
--       |       |                        | [   15] | LINK_ON                  | 0x00008000 |  RO     |         
--       |       |                        | [14: 8] | IIC_ADDRESS              | 0x00007F00 |  R/W    |             
--       |       |                        |     [7] | ON_WORK                  | 0x00000080 |  RO     |         
--       |       |                        |     [6] | SINGLE_REQUEST_COMPLETED | 0x00000040 |  RO     |         
--       |       |                        |     [5] | RESERVED                 | 0x00000020 |  RO     |         
--       |       |                        |     (4) | INTR_ACK                 | 0x00000010 |  WC     |         
--       |       |                        |     (3) | RESERVED                 | 0x00000008 |  RO     |         
--       |       |                        |     (2) | IRQ_ALLOW                | 0x00000004 |  R/W    |             
--       |       |                        |     (1) | REQUEST_INTERVAL_ENABLE  | 0x00000002 |  R/W    |             
--       |       |                        |     (0) | RESET_LOGIC              | 0x00000001 |  R/W    |             
--  0x04 |     1 | REQ_INTERVAL_REG       | [31: 0] | REQUEST_INTERVAL         | 0xFFFFFFFF |  R/W    |             
--  0x08 |     2 | READ_VALID_CNT         | [31: 0] | READ_VALID_COUNT         | 0xFFFFFFFF |  RO     |         
--  0x0C |     3 | WRITE_VALID_CNT        | [31: 0] | WRITE_VALID_COUNT        | 0xFFFFFFFF |  RO     |         
--  0x10 |     4 | READ_TRANSACTIONS_LSB  | [31: 0] | READ_TRANSACTIONS_LSB    | 0xFFFFFFFF |  RO     |         
--  0x14 |     5 | READ_TRANSACTIONS_MSB  | [31: 0] | READ_TRANSACTIONS_MSB    | 0xFFFFFFFF |  RO     |         
--  0x18 |     6 | WRITE_TRANSACTIONS_LSB | [31: 0] | WRITE_TRANSACTIONS_LSB   | 0xFFFFFFFF |  RO     |         
--  0x1C |     7 | WRITE_TRANSACTIONS_MSB | [31: 0] | WRITE_TRANSACTIONS_MSB   | 0xFFFFFFFF |  RO     |         
--  0x20 |     8 | OPT_REQUEST_LSB        | [31: 0] | OPT_REQUEST_LSB          | 0xFFFFFFFF |  RO     |         
--  0x24 |     9 | OPT_REQUEST_MSB        | [15: 0] | OPT_REQUEST_MSB          | 0x0000FFFF |  RO     |         
--  0x28 |    10 | CLK_PERIOD             | [31: 0] | CLK_PERIOD               | 0xFFFFFFFF |  RO     |         
--  0x2C |    11 | DATA_WIDTH             | [31: 0] | DATA_WIDTH               | 0xFFFFFFFF |  RO     |         
--  0x30 |    10 | SINGLE_REQ_REG         | [21:16] | START_ADDRESS            | 0x003F0000 |  R/W    |             
--       |       |                        | [13: 8] | SIZE                     | 0x00003F00 |  R/W    |             
--       |       |                        | [    0] | SINGLE_REQUEST           | 0x00000001 |  R/W    |             


entity axi_adxl345 is 
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
        M_AXIS_TDEST                    :   out     std_logic_vector (                              7 downto 0 )                            ;
        M_AXIS_TVALID                   :   out     std_logic                                                                               ;
        M_AXIS_TLAST                    :   out     std_logic                                                                               ;
        M_AXIS_TREADY                   :   in      std_logic                                                                               ;
        
        S_AXIS_TDATA                    :   in      std_logic_vector (                              7 downto 0 )                            ;
        S_AXIS_TKEEP                    :   in      std_logic_vector (                              0 downto 0 )                            ;
        S_AXIS_TDEST                    :   in      std_logic_vector (                              7 downto 0 )                            ;
        S_AXIS_TVALID                   :   in      std_logic                                                                               ;
        S_AXIS_TLAST                    :   in      std_logic                                                                               ;
        S_AXIS_TREADY                   :   out     std_logic                                                                               ;
        ADXL_INTERRUPT                  :   in      std_logic                                                                               ;
        ADXL_IRQ                        :   out     std_logic                                                                                
    );
    ATTRIBUTE X_INTERFACE_INFO : STRING;
    ATTRIBUTE X_INTERFACE_PARAMETER : STRING;
    ATTRIBUTE X_INTERFACE_INFO of ADXL_INTERRUPT: SIGNAL is "xilinx.com:signal:interrupt:1.0 ADXL_INTERRUPT INTERRUPT";
    ATTRIBUTE X_INTERFACE_PARAMETER of ADXL_INTERRUPT: SIGNAL is "SENSITIVITY EDGE_RISING" ;
    ATTRIBUTE X_INTERFACE_INFO of ADXL_IRQ: SIGNAL is "xilinx.com:signal:interrupt:1.0 ADXL_IRQ INTERRUPT";
    ATTRIBUTE X_INTERFACE_PARAMETER of ADXL_IRQ: SIGNAL is "SENSITIVITY EDGE_RISING";
end axi_adxl345;




architecture axi_adxl345_arch of axi_adxl345 is


    constant  ADDR_LSB_CFG                  :           integer                                                         := ((S_AXI_LITE_CFG_DATA_WIDTH/32) + 1) ;
    constant  OPT_MEM_ADDR_BITS_CFG         :           integer                                                         := 5                                    ;
    constant  ADDR_LSB_DEV                  :           integer                                                         := ((S_AXI_LITE_DEV_DATA_WIDTH/32) + 1) ;
    constant  OPT_MEM_ADDR_BITS_DEV         :           integer                                                         := 3                                    ;
    constant  DATA_WIDTH                    :           integer                                                         := 8                                    ;
    constant  USER_WIDTH                    :           integer                                                         := 8                                    ;
    constant  DEFAULT_REQUESTION_INTERVAL_V :           std_logic_vector (                          31 downto 0 )       := conv_std_logic_Vector ( DEFAULT_REQUESTION_INTERVAL, 32);
    constant VERSION_MAJOR                  :           std_logic_Vector (                           7 downto 0 )       := x"02"                                ; -- read only,
    constant VERSION_MINOR                  :           std_logic_Vector (                           7 downto 0 )       := x"01"                                ; -- read only,
 

    signal  axi_awaddr_cfg                  :           std_logic_vector ( S_AXI_LITE_CFG_ADDR_WIDTH-1 downto 0 )                                               ;
    signal  axi_awready_cfg                 :           std_logic                                                                                               ;
    signal  axi_wready_cfg                  :           std_logic                                                                                               ;
    signal  axi_bresp_cfg                   :           std_logic_vector (                           1 downto 0 )                                               ;
    signal  axi_bvalid_cfg                  :           std_logic                                                                                               ;
    signal  axi_araddr_cfg                  :           std_logic_vector ( S_AXI_LITE_CFG_ADDR_WIDTH-1 downto 0 )                                               ;
    signal  axi_arready_cfg                 :           std_logic                                                                                               ;
    signal  axi_rdata_cfg                   :           std_logic_vector ( S_AXI_LITE_CFG_DATA_WIDTH-1 downto 0 )                                               ;
    signal  axi_rresp_cfg                   :           std_logic_vector (                           1 downto 0 )                                               ;
    signal  axi_rvalid_cfg                  :           std_logic                                                                                               ;

    signal  axi_dev_awaddr                  :           std_logic_vector ( S_AXI_LITE_DEV_ADDR_WIDTH-1 downto 0 )                                               ;
    signal  axi_dev_awready                 :           std_logic                                                                                               ;
    signal  axi_dev_wready                  :           std_logic                                                                                               ;
    signal  axi_dev_bresp                   :           std_logic_vector (                           1 downto 0 )                                               ;
    signal  axi_dev_bvalid                  :           std_logic                                                                                               ;
    signal  axi_dev_araddr                  :           std_logic_vector ( S_AXI_LITE_DEV_ADDR_WIDTH-1 downto 0 )                                               ;
    signal  axi_dev_arready                 :           std_logic                                                                                               ;
    signal  axi_dev_rdata                   :           std_logic_vector ( S_AXI_LITE_DEV_DATA_WIDTH-1 downto 0 )                                               ;
    signal  axi_dev_rresp                   :           std_logic_vector (                           1 downto 0 )                                               ;
    signal  axi_dev_rvalid                  :           std_logic                                                                                               ;

    signal  slv_reg_rden                    :           std_logic                                                                                               ;
    signal  slv_reg_wren                    :           std_logic                                                                                               ;
    signal  reg_data_out                    :           std_logic_Vector ( S_AXI_LITE_DEV_DATA_WIDTH-1 downto 0 )                                               ;
    signal  aw_en                           :           std_Logic                                                                                               ;

    signal  slv_reg_rden_cfg                :           std_logic                                                                                               ;
    signal  slv_reg_wren_cfg                :           std_logic                                                                                               ;
    signal  reg_data_out_cfg                :           std_logic_Vector ( S_AXI_LITE_CFG_DATA_WIDTH-1 downto 0 )                                               ;
    signal  aw_en_cfg                       :           std_logic                                                                                               ;

    signal   reset_logic                    :           std_logic                                                               := '0'                          ;
    signal   reset_timer                    :           std_logic_vector ( 31 downto 0 )                                        := (others => '0')              ;

    signal  i2c_address                     :           std_logic_Vector (  6 downto 0 )                                        := DEFAULT_DEVICE_ADDRESS       ; -- reg(0)[14:8]

    -- single requesting data from device
    signal  single_request                  :           std_logic                                                               := '0'                          ;
    signal  single_request_address          :           std_logic_Vector ( 7 downto 0 )                                                                         ;
    signal  single_request_size             :           std_logic_Vector ( 7 downto 0 )                                                                         ;
    signal  single_request_complete         :           std_logic                                                                                               ; -- output signal from functional 
    signal  single_request_complete_flaq    :           std_logic                                                               := '0'                          ; -- signal to register space for reading from device

    -- periodic requests for interval timer
    signal  request_interval_enable         :           std_logic                                                               := '0'                          ;
    signal  requestion_interval             :           std_logic_Vector ( 31 downto 0 )                                        := (others => '0')              ;

    -- allow interrupt mech 
    signal allow_irq_reg                    :           std_logic                                                               := '0'                          ;

    -- link state
    signal  link_on                         :           std_Logic                                                                                               ;

    --
    signal  adxl_irq_ack                    :           std_Logic                                                                                               ;


    signal  opt_request_interval            :           std_Logic_Vector ( 47 downto 0 )                                                                        ;

    signal  read_valid_count                :           std_Logic_Vector ( 31 downto 0 )                                                                        ;
    signal  write_valid_count               :           std_Logic_Vector ( 31 downto 0 )                                                                        ;

    signal  write_transactions              :           std_Logic_Vector ( 63 downto 0 )                                                                        ;
    signal  read_transactions               :           std_Logic_Vector ( 63 downto 0 )                                                                        ;

    signal  on_work                         :           std_logic                                                                                               ;
    signal  adxl_irq_reg                    :           std_logic                                                                                               ;


    component axi_adxl345_functional
        generic (
            CLK_PERIOD : integer := 100000000
        );
        port (
            CLK                                 :   in      std_logic                                                           ;
            RESET                               :   in      std_logic                                                           ;
            -- signal from AXI_DEV interface
            WDATA                               :   in      std_logic_vector ( 31 downto 0 )                                    ;
            WSTRB                               :   in      std_logic_vector (  3 downto 0 )                                    ;
            WADDR                               :   in      std_logic_vector (  3 downto 0 )                                    ;
            WVALID                              :   in      std_logic                                                           ;
            RADDR                               :   in      std_logic_vector (  3 downto 0 )                                    ;
            RDATA                               :   out     std_logic_vector ( 31 downto 0 )                                    ;
            -- control
            I2C_ADDRESS                         :   in      std_logic_vector (  6 downto 0 )                                    ;
            ENABLE_INTERVAL_REQUESTION          :   in      std_logic                                                           ;
            REQUESTION_INTERVAL                 :   in      std_logic_vector ( 31 downto 0 )                                    ;
            
            SINGLE_REQUEST                      :   in      std_logic                                                           ;
            SINGLE_REQUEST_ADDRESS              :   in      std_logic_vector (  7 downto 0 )                                    ;
            SINGLE_REQUEST_SIZE                 :   in      std_logic_vector (  7 downto 0 )                                    ;
            SINGLE_REQUEST_COMPLETE             :   out     std_logic                                                           ;

            ALLOW_IRQ                           :   in      std_logic                                                           ;
            LINK_ON                             :   out     std_logic                                                           ;
            ADXL_INTERRUPT                      :   in      std_logic                                                           ;
            ADXL_IRQ                            :   out     std_logic                                                           ;
            ADXL_IRQ_ACK                        :   in      std_logic                                                           ;

            OPTIMAL_REQUEST_TIMER               :   out     std_Logic_Vector ( 47 downto 0 )                                    ;

            READ_VALID_COUNT                    :   out     std_logic_vector ( 31 downto 0 )                                    ;
            WRITE_VALID_COUNT                   :   out     std_logic_vector ( 31 downto 0 )                                    ;

            WRITE_TRANSACTIONS                  :   out     std_logic_vector ( 63 downto 0 )                                    ;
            READ_TRANSACTIONS                   :   out     std_logic_vector ( 63 downto 0 )                                    ;

            ON_WORK                             :   out     std_logic                                                           ;

            -- data to device
            M_AXIS_TDATA                        :   out     std_logic_vector (  7 downto 0 )                                    ;
            M_AXIS_TKEEP                        :   out     std_logic_vector (  0 downto 0 )                                    ;
            M_AXIS_TUSER                        :   out     std_logic_vector (  7 downto 0 )                                    ;
            M_AXIS_TVALID                       :   out     std_logic                                                           ;
            M_AXIS_TLAST                        :   out     std_logic                                                           ;
            M_AXIS_TREADY                       :   in      std_logic                                                           ;
            -- data from device
            S_AXIS_TDATA                        :   in      std_logic_vector (  7 downto 0 )                                    ;
            S_AXIS_TKEEP                        :   in      std_logic_vector (  0 downto 0 )                                    ;
            S_AXIS_TUSER                        :   in      std_logic_vector (  7 downto 0 )                                    ;
            S_AXIS_TVALID                       :   in      std_logic                                                           ;
            S_AXIS_TLAST                        :   in      std_logic                                                           ;
            S_AXIS_TREADY                       :   out     std_logic                                                            
        );
    end component;



begin 
    

    S_AXI_LITE_DEV_AWREADY <= axi_dev_awready;
    S_AXI_LITE_DEV_WREADY  <= axi_dev_wready;
    S_AXI_LITE_DEV_BRESP   <= axi_dev_bresp;
    S_AXI_LITE_DEV_BVALID  <= axi_dev_bvalid;
    S_AXI_LITE_DEV_ARREADY <= axi_dev_arready;
    S_AXI_LITE_DEV_RDATA   <= axi_dev_rdata;
    S_AXI_LITE_DEV_RRESP   <= axi_dev_rresp;

    S_AXI_LITE_CFG_AWREADY <= axi_awready_cfg;
    S_AXI_LITE_CFG_WREADY  <= axi_wready_cfg;
    S_AXI_LITE_CFG_BRESP   <= axi_bresp_cfg;
    S_AXI_LITE_CFG_BVALID  <= axi_bvalid_cfg;
    S_AXI_LITE_CFG_ARREADY <= axi_arready_cfg;
    S_AXI_LITE_CFG_RDATA   <= axi_rdata_cfg;
    S_AXI_LITE_CFG_RRESP   <= axi_rresp_cfg;

    S_AXI_LITE_DEV_RVALID <= axi_dev_rvalid;

    ADXL_IRQ <= adxl_irq_reg;

    S_AXI_LITE_CFG_RVALID_proc : process(CLK)
    begin 
        if CLK'event AND CLK = '1' then 
            S_AXI_LITE_CFG_RVALID <= axi_rvalid_cfg;
        end if;
    end process;


    axi_dev_awready_proc : process(CLK)
    begin 
        if CLK'event AND CLK = '1' then 
            if (RESET = '1') then 
                axi_dev_awready <= '0';
            else    
                if (axi_dev_awready = '0' and S_AXI_LITE_DEV_AWVALID = '1' and S_AXI_LITE_DEV_WVALID = '1' and aw_en = '1') then 
                    axi_dev_awready <= '1';
                else 
                    if (S_AXI_LITE_DEV_BREADY = '1' and axi_dev_bvalid = '1') then 
                        axi_dev_awready <= '0';
                    else
                        axi_dev_awready <= '0';
                    end if;
                end if;
            end if;
        end if;
    end process;       



    aw_en_proc : process(CLK)
    begin 
        if CLK'event AND CLK = '1' then 
            if (RESET = '1') then 
                aw_en <= '1';
            else
                if (axi_dev_awready = '0' and S_AXI_LITE_DEV_AWVALID = '1' and S_AXI_LITE_DEV_WVALID = '1' and aw_en = '1') then 
                    aw_en <= '0';
                else 
                    if (S_AXI_LITE_DEV_BREADY = '1' and axi_dev_bvalid = '1') then 
                        aw_en <= '1';
                    end if;
                end if;
            end if;
        end if;
    end process;       



    axi_dev_awaddr_proc : process(CLK)
    begin 
        if CLK'event AND CLK = '1' then 
            if (RESET = '1') then 
                axi_dev_awaddr <= (others => '0');
            else
                if (axi_dev_awready = '0' and S_AXI_LITE_DEV_AWVALID = '1' and S_AXI_LITE_DEV_WVALID = '1' and aw_en = '1') then 
                    axi_dev_awaddr <= S_AXI_LITE_DEV_AWADDR;
                end if;
            end if;
        end if;
    end process;       



    axi_dev_wready_proc : process(CLK)
    begin 
        if CLK'event AND CLK = '1' then 
            if (RESET = '1') then 
                axi_dev_wready <= '0';
            else    
                if (axi_dev_wready = '0' and S_AXI_LITE_DEV_WVALID = '1' and S_AXI_LITE_DEV_AWVALID = '1' and aw_en = '1') then
                    axi_dev_wready <= '1';
                else
                    axi_dev_wready <= '0';
                end if;
            end if;
        end if;
    end process;       



    slv_reg_wren <= axi_dev_wready and S_AXI_LITE_DEV_WVALID and axi_dev_awready and S_AXI_LITE_DEV_AWVALID;



    axi_dev_bvalid_proc : process(CLK)
    begin 
        if CLK'event AND CLK = '1' then 
            if (RESET = '1') then 
                axi_dev_bvalid  <= '0';
            else
                if (axi_dev_awready = '1' and S_AXI_LITE_DEV_AWVALID = '1' and axi_dev_bvalid = '0' and axi_dev_wready = '1' and S_AXI_LITE_DEV_WVALID = '1') then 
                    axi_dev_bvalid <= '1';
                else
                    if (S_AXI_LITE_DEV_BREADY = '1' and axi_dev_bvalid = '1') then 
                        axi_dev_bvalid <= '0'; 
                    end if;
                end if;
            end if;
        end if;
    end process;   



    axi_dev_bresp_proc : process(CLK)
    begin 
        if CLK'event AND CLK = '1' then 
            if (RESET = '1') then 
                    axi_dev_bresp <= (others => '0');
            else
                if (axi_dev_awready = '1' and S_AXI_LITE_DEV_AWVALID = '1' and axi_dev_bvalid = '0' and axi_dev_wready = '1' and S_AXI_LITE_DEV_WVALID = '1') then 
                    axi_dev_bresp  <= (others => '0');
                end if;
            end if;
        end if;
    end process;   

 -- ///////////////////////////////////////////// READ INTERFACE SIGNALS /////////////////////////////////////////////

    axi_dev_arready_proc : process(CLK)
    begin 
        if CLK'event AND CLK = '1' then 
            if (RESET = '1') then 
                axi_dev_arready <= '0';
            else    
                if (axi_dev_arready = '0' and S_AXI_LITE_DEV_ARVALID = '1') then 
                    axi_dev_arready <= '1';
                else
                    axi_dev_arready <= '0';
                end if;
            end if;
        end if;
    end process;       



    axi_dev_araddr_proc : process(CLK)
    begin 
        if CLK'event AND CLK = '1' then 
            if (RESET = '1') then 
                axi_dev_araddr  <= (others => '0');
            else    
                if (axi_dev_arready = '0' and S_AXI_LITE_DEV_ARVALID = '1') then 
                    axi_dev_araddr <= S_AXI_LITE_DEV_ARADDR;  
                end if;
            end if;
        end if;
    end process;       



    axi_dev_rvalid_proc : process(CLK)
    begin 
        if CLK'event AND CLK = '1' then 
            if (RESET = '1') then 
                axi_dev_rvalid <= '0';
            else
                if (axi_dev_arready = '1' and S_AXI_LITE_DEV_ARVALID = '1' and axi_dev_rvalid = '0') then 
                    axi_dev_rvalid <= '1';
                else 
                    if (axi_dev_rvalid = '1' and S_AXI_LITE_DEV_RREADY = '1') then 
                        axi_dev_rvalid <= '0';
                    end if;
                end if;
            end if;
        end if;
    end process;    



    axi_dev_rresp_proc : process(CLK)
    begin 
        if CLK'event AND CLK = '1' then 
            if (RESET = '1') then 
                axi_dev_rresp  <= (others => '0');
            else
                if (axi_dev_arready = '1' and S_AXI_LITE_DEV_ARVALID = '1' and axi_dev_rvalid = '0') then 
                    axi_dev_rresp <= (others => '0');
                end if;
            end if;
        end if;
    end process;    



    slv_reg_rden_proc : process(CLK)
    begin 
        if CLK'event AND CLK = '1' then
            slv_reg_rden <= axi_dev_arready and S_AXI_LITE_DEV_ARVALID and not(axi_dev_rvalid);
        end if;
    end process; 



    axi_dev_rdata <= reg_data_out;    -- register read data




    axi_awready_proc_cfg : process(CLK)
    begin 
        if CLK'event AND CLK = '1' then 
            if (RESET = '1') then 
                axi_awready_cfg <= '0';
            else    
                if (axi_awready_cfg = '0' and S_AXI_LITE_CFG_AWVALID = '1' and S_AXI_LITE_CFG_WVALID = '1' and aw_en_cfg = '1') then 
                    axi_awready_cfg <= '1';
                else 
                    if (S_AXI_LITE_CFG_BREADY = '1' and axi_bvalid_cfg = '1') then 
                        axi_awready_cfg <= '0';
                    else
                        axi_awready_cfg <= '0';
                    end if;
                end if;
            end if;
        end if;
    end process;       


    aw_en_proc_cfg : process(CLK)
    begin 
        if CLK'event AND CLK = '1' then 
            if (RESET = '1') then 
                aw_en_cfg <= '1';
            else
                if (axi_awready_cfg = '0' and S_AXI_LITE_CFG_AWVALID = '1' and S_AXI_LITE_CFG_WVALID = '1' and aw_en_cfg = '1') then 
                    aw_en_cfg <= '0';
                else 
                    if (S_AXI_LITE_CFG_BREADY = '1' and axi_bvalid_cfg = '1') then 
                        aw_en_cfg <= '1';
                    end if;
                end if;
            end if;
        end if;
    end process;       



    axi_awaddr_proc_cfg : process(CLK)
    begin 
        if CLK'event AND CLK = '1' then 
            if (RESET = '1') then 
                axi_awaddr_cfg <= (others => '0');
            else
                if (axi_awready_cfg = '0' and S_AXI_LITE_CFG_AWVALID = '1' and S_AXI_LITE_CFG_WVALID = '1' and aw_en_cfg = '1') then 
                    axi_awaddr_cfg <= S_AXI_LITE_CFG_AWADDR;
                end if;
            end if;
        end if;
    end process;       



    axi_wready_proc : process(CLK)
    begin 
        if CLK'event AND CLK = '1' then 
            if (RESET = '1') then 
                axi_wready_cfg <= '0';
            else    
                if (axi_wready_cfg = '0' and S_AXI_LITE_CFG_WVALID = '1' and S_AXI_LITE_CFG_AWVALID = '1' and aw_en_cfg = '1' ) then 
                    axi_wready_cfg <= '1';
                else
                    axi_wready_cfg <= '0';
                end if;
            end if;
        end if;
    end process;       

    

    slv_reg_wren_cfg <= axi_wready_cfg and S_AXI_LITE_CFG_WVALID and axi_awready_cfg and S_AXI_LITE_CFG_AWVALID;



    axi_bvalid_proc_cfg : process(CLK)
    begin 
        if CLK'event AND CLK = '1' then 
            if (RESET = '1') then 
                axi_bvalid_cfg  <= '0';
            else
                if (axi_awready_cfg = '1' and S_AXI_LITE_CFG_AWVALID = '1' and axi_bvalid_cfg = '0' and axi_wready_cfg = '1' and S_AXI_LITE_CFG_WVALID = '1') then 
                    axi_bvalid_cfg <= '1';
                else
                    if (S_AXI_LITE_CFG_BREADY = '1' and axi_bvalid_cfg = '1') then 
                        axi_bvalid_cfg <= '0'; 
                    end if;
                end if;
            end if;
        end if;
    end process;   



    axi_bresp_proc_cfg : process(CLK)
    begin 
        if CLK'event AND CLK = '1' then 
            if (RESET = '1') then 
                axi_bresp_cfg   <= (others => '0');
            else
                if (axi_awready_cfg = '1' and S_AXI_LITE_CFG_AWVALID = '1' and axi_bvalid_cfg = '0' and axi_wready_cfg = '1' and S_AXI_LITE_CFG_WVALID = '1') then 
                    axi_bresp_cfg  <= (others => '0'); -- 'OKAY' response 
                end if;
            end if;
        end if;
    end process;   



    axi_arready_proc_cfg : process(CLK)
    begin 
        if CLK'event AND CLK = '1' then 
            if (RESET = '1') then 
                axi_arready_cfg <= '0';
            else    
                if (axi_arready_cfg = '0' and S_AXI_LITE_CFG_ARVALID = '1') then 
                    axi_arready_cfg <= '1';
                else
                    axi_arready_cfg <= '0';
                end if;
            end if;
        end if;
    end process;       


    axi_araddr_proc_cfg : process(CLK)
    begin 
        if CLK'event AND CLK = '1' then 
            if (RESET = '1') then 
                axi_araddr_cfg  <= (others => '0');
            else    
                if (axi_arready_cfg = '0' and S_AXI_LITE_CFG_ARVALID = '1') then 
                    axi_araddr_cfg  <= S_AXI_LITE_CFG_ARADDR;
                end if;
            end if;
        end if;
    end process;       



    axi_rvalid_proc_cfg : process(CLK)
    begin 
        if CLK'event AND CLK = '1' then 
            if (RESET = '1') then 
                axi_rvalid_cfg <= '0';
            else
                if (axi_arready_cfg = '1' and S_AXI_LITE_CFG_ARVALID = '1' and axi_rvalid_cfg = '0') then 
                    axi_rvalid_cfg <= '1';
                else 
                    if (axi_rvalid_cfg = '1' and S_AXI_LITE_CFG_RREADY = '1') then 
                        axi_rvalid_cfg <= '0';
                    end if;
                end if;
            end if;
        end if;
    end process;    



    axi_rresp_proc_cfg : process(CLK)
    begin 
        if CLK'event AND CLK = '1' then 
            if (RESET = '1') then 
                axi_rresp_cfg  <= (others => '0');
            else
                if (axi_arready_cfg = '1' and S_AXI_LITE_CFG_ARVALID = '1' and axi_rvalid_cfg = '0') then 
                    axi_rresp_cfg <= (others => '0');
                end if;
            end if;
        end if;
    end process;    



    slv_reg_rden_cfg_proc : process(CLK)
    begin 
        if CLK'event AND CLK = '1' then 
            slv_reg_rden_cfg <= axi_arready_cfg and S_AXI_LITE_CFG_ARVALID and not(axi_rvalid_cfg);
        end if;
    end process; 



    reg_data_out_cfg_processing : process(CLK)
    begin 
        if CLK'event AND CLK = '1' then 
            case ( axi_araddr_cfg((ADDR_LSB_CFG + OPT_MEM_ADDR_BITS_CFG) downto ADDR_LSB_CFG)) is 
                when ("00" & x"0")  => reg_data_out_cfg <= version_major & version_minor & link_on & i2c_address & on_work & single_request_complete_flaq & "000" & allow_irq_reg & request_interval_enable & reset_logic;
                when ("00" & x"1")  => reg_data_out_cfg <= requestion_interval;
                when ("00" & x"2")  => reg_data_out_cfg <= read_valid_count; 
                when ("00" & x"3")  => reg_data_out_cfg <= write_valid_count;
                when ("00" & x"4")  => reg_data_out_cfg <= read_transactions(31 downto  0 );
                when ("00" & x"5")  => reg_data_out_cfg <= read_transactions(63 downto 32 );
                when ("00" & x"6")  => reg_data_out_cfg <= write_transactions(31 downto  0 );
                when ("00" & x"7")  => reg_data_out_cfg <= write_transactions(63 downto 32 );
                when ("00" & x"8")  => reg_data_out_cfg <= opt_request_interval(31 downto  0 );
                when ("00" & x"9")  => reg_data_out_cfg <= x"0000" & opt_request_interval(47 downto 32); --opt_request_interval;
                when ("00" & x"A")  => reg_data_out_cfg <= conv_std_logic_Vector (CLK_PERIOD, reg_data_out_cfg'length) ;
                when ("00" & x"B")  => reg_data_out_cfg <= conv_std_logic_Vector (DATA_WIDTH, reg_data_out_cfg'length) ;
                when ("00" & x"C")  => reg_data_out_cfg <= x"00" & single_request_address & single_request_size & x"00";
                when others => reg_data_out_cfg <= (others => '0');
            end case;
        end if;
    end process;

    


    axi_rdata_cfg_processing : process(CLK)
    begin 
        if CLK'event AND CLK = '1' then
            if (slv_reg_rden_cfg = '1') then 
                axi_rdata_cfg <= reg_data_out_cfg;     -- register read data
            end if;
        end if;
    end process;



    reset_timer_processing : process(CLK)
    begin 
        if CLK'event AND CLK = '1' then
            if (RESET = '1') then
                reset_timer <= (others => '0');
            else 
                if (reset_timer < (RESET_DURATION-1)) then  
                    reset_timer <= reset_timer + 1;
                else 
                    if (slv_reg_wren_cfg = '1') then  
                        if (axi_awaddr_cfg((ADDR_LSB_CFG + OPT_MEM_ADDR_BITS_CFG) downto ADDR_LSB_CFG) = 0) then  
                            if (S_AXI_LITE_CFG_WSTRB(0) = '1' and S_AXI_LITE_CFG_WDATA(0) = '1') then  
                                reset_timer <= (others => '0');
                            else 
                                reset_timer <= reset_timer;
                            end if;
                        else 
                            reset_timer <= reset_timer;
                        end if; 
                    else 
                        reset_timer <= reset_timer;
                    end if;     
                end if; 
            end if; 
        end if;
    end process;



    reset_processing : process(CLK)
    begin 
        if CLK'event AND CLK = '1' then
            if (RESET = '1') then 
                reset_logic <= '1';
            else 
                if (reset_timer < (RESET_DURATION-1)) then  
                    reset_logic <= '1';
                else  
                    reset_logic <= '0';
                end if; 
            end if; 
        end if; 
    end process;



    -- logic for perform single request
    single_request_processing : process(CLK)
    begin 
        if CLK'event AND CLK = '1' then
            if (RESET = '1' or reset_logic = '1' ) then  
                single_request <= '0';
            else 
                if (slv_reg_wren_cfg = '1') then  
                    if (axi_awaddr_cfg(ADDR_LSB_CFG + OPT_MEM_ADDR_BITS_CFG downto ADDR_LSB_CFG) = 12) then  
                        if ( S_AXI_LITE_CFG_WSTRB(0) = '1' and S_AXI_LITE_CFG_WDATA(0) = '1') then  
                            single_request <= '1';
                        else 
                            single_request <= single_request;
                        end if; 
                    else 
                        single_request <= single_request;
                    end if; 
                else 
                    if (single_request_complete = '1') then  
                        single_request <= '0';
                    else 
                        single_request <= single_request;
                    end if; 
                end if; 
            end if; 
        end if; 
    end process;



    single_request_complete_flaq_processing : process(CLK)
    begin 
        if CLK'event AND CLK = '1' then
            if (RESET = '1' or reset_logic = '1' ) then  
                single_request_complete_flaq <= '0';
            else 
                if (single_request = '1') then  
                    if (single_request_complete = '1') then  
                        single_request_complete_flaq <= '1';        
                    else 
                        single_request_complete_flaq <= '0';
                    end if; 
                else 
                    single_request_complete_flaq <= single_request_complete_flaq;
                end if; 
            end if; 
        end if; 
    end process;



    -- i2c address holding 
    i2c_address_processing : process(CLK)
    begin 
        if CLK'event AND CLK = '1' then
            if (RESET = '1' or reset_logic = '1' ) then  
                i2c_address <= DEFAULT_DEVICE_ADDRESS;
            else  
                if (slv_reg_wren_cfg = '1') then  
                    if (axi_awaddr_cfg((ADDR_LSB_CFG + OPT_MEM_ADDR_BITS_CFG) downto ADDR_LSB_CFG) = 0) then  
                        if ( S_AXI_LITE_CFG_WSTRB(1) = '1') then  
                            i2c_address <= S_AXI_LITE_CFG_WDATA( 14 downto 8 );
                        else 
                            i2c_address <= i2c_address;
                        end if;  
                    else 
                        i2c_address <= i2c_address;
                    end if; 
                end if; 
            end if; 
        end if;  
    end process;

    -- periodic requesting of register from device 
    request_interval_enable_processing : process(CLK)
    begin 
        if CLK'event AND CLK = '1' then
            if (RESET = '1' or reset_logic = '1' ) then  
                request_interval_enable <= '0';
            else 
                if (slv_reg_wren_cfg = '1') then  
                    if (axi_awaddr_cfg((ADDR_LSB_CFG + OPT_MEM_ADDR_BITS_CFG) downto ADDR_LSB_CFG) = 0) then  
                        if ( S_AXI_LITE_CFG_WSTRB(0) = '1') then  
                            request_interval_enable <= S_AXI_LITE_CFG_WDATA(1);
                        else 
                            request_interval_enable <= request_interval_enable;
                        end if;   
                    else 
                        request_interval_enable <= request_interval_enable;
                    end if;  
                else 
                    request_interval_enable <= request_interval_enable;
                end if;  
            end if;
        end if; 
    end process;



    allow_irq_reg_processing : process(CLK)
    begin 
        if CLK'event AND CLK = '1' then
            if (RESET = '1' or reset_logic = '1' ) then  
                allow_irq_reg <= '0';
            else 
                if (slv_reg_wren_cfg = '1') then  
                    if (axi_awaddr_cfg(ADDR_LSB_CFG + OPT_MEM_ADDR_BITS_CFG downto ADDR_LSB_CFG) = 0) then  
                        if (S_AXI_LITE_CFG_WSTRB(0) = '1') then  
                            allow_irq_reg <= S_AXI_LITE_CFG_WDATA(2);
                        else 
                            allow_irq_reg <= allow_irq_reg;
                        end if; 
                    else 
                        allow_irq_reg <= allow_irq_reg;
                    end if; 
                else 
                    allow_irq_reg <= allow_irq_reg;
                end if; 
            end if; 
        end if; 
    end process;



    --generate 

    --    for (genvar index = 0; index < 4; index++) then  : GEN_REGISTER_FILE_BYTE_INDEX 

    requestion_interval_processing : process(CLK)
    begin 
        if CLK'event AND CLK = '1' then 
            for index in 0 to 3 loop
                if (RESET = '1' or reset_logic = '1' ) then 
                    requestion_interval((((index+1)*8)-1) downto (index*8)) <= DEFAULT_REQUESTION_INTERVAL_V((((index+1)*8)-1) downto (index*8));
                else
                    if (slv_reg_wren_cfg = '1') then 
                        if (axi_awaddr_cfg((ADDR_LSB_CFG + OPT_MEM_ADDR_BITS_CFG) downto ADDR_LSB_CFG) = 1) then 
                            if ( S_AXI_LITE_CFG_WSTRB(index) = '1') then 
                                requestion_interval((((index+1)*8)-1) downto (index*8)) <= S_AXI_LITE_CFG_WDATA((((index+1)*8)-1) downto (index*8));
                            else
                                requestion_interval((((index+1)*8)-1) downto (index*8)) <= requestion_interval((((index+1)*8)-1) downto (index*8));
                            end if;
                        else
                            requestion_interval((((index+1)*8)-1) downto (index*8)) <= requestion_interval((((index+1)*8)-1) downto (index*8));
                        end if;
                    else
                        requestion_interval((((index+1)*8)-1) downto (index*8)) <= requestion_interval((((index+1)*8)-1) downto (index*8));
                    end if;
                end if;
            end loop;
        end if;
    end process;



    --endgenerate



    adxl_irq_ack_processing : process(CLK)
    begin 
        if CLK'event AND CLK = '1' then
            if (RESET = '1' or reset_logic = '1' ) then  
                adxl_irq_ack <= '0';
            else 
                if (slv_reg_wren_cfg = '1') then  
                    if (axi_awaddr_cfg ((ADDR_LSB_CFG + OPT_MEM_ADDR_BITS_CFG) downto ADDR_LSB_CFG ) = 0) then  
                        if (S_AXI_LITE_CFG_WSTRB(1) = '1' and S_AXI_LITE_CFG_WDATA(4) = '1' and adxl_irq_reg = '1' ) then  
                            adxl_irq_ack <= '1';
                        else 
                            adxl_irq_ack <= '0';
                        end if; 
                    else
                        adxl_irq_ack <= '0';
                    end if; 
                else  
                    adxl_irq_ack <= '0';
                end if;  
            end if; 
        end if; 
    end process;




    single_request_address_processing : process(CLK)
    begin 
        if CLK'event AND CLK = '1' then
            if (RESET = '1' or reset_logic = '1' ) then  
                single_request_address <= (others => '0');
            else 
                if (slv_reg_wren_cfg = '1') then 
                    if (on_work = '0') then  
                        if (axi_awaddr_cfg(ADDR_LSB_CFG + OPT_MEM_ADDR_BITS_CFG downto ADDR_LSB_CFG) = 12) then 
                            if ( S_AXI_LITE_CFG_WSTRB(2) = '1') then 
                                single_request_address <= S_AXI_LITE_CFG_WDATA( 23 downto 16 );
                            else
                                single_request_address <= single_request_address;
                            end if; 
                        else
                            single_request_address <= single_request_address;
                        end if; 
                    else 
                        single_request_address <= single_request_address;
                    end if; 
                else
                    single_request_address <= single_request_address;
                end if; 
            end if; 
        end if; 
    end process;



    single_request_size_processing : process(CLK)
    begin 
        if CLK'event AND CLK = '1' then
            if (RESET = '1' or reset_logic = '1' ) then  
                single_request_size <= x"3A";
            else 
                if (on_work = '0') then  
                    if (slv_reg_wren_cfg = '1') then 
                        if (axi_awaddr_cfg(ADDR_LSB_CFG + OPT_MEM_ADDR_BITS_CFG downto ADDR_LSB_CFG) = 12) then 
                            if (S_AXI_LITE_CFG_WSTRB(1) = '1') then 
                                single_request_size <= S_AXI_LITE_CFG_WDATA( 15 downto 8 );
                            else
                                single_request_size <= single_request_size;
                            end if; 
                        else
                            single_request_size <= single_request_size;
                        end if; 
                    else 
                        single_request_size <= single_request_size;
                    end if; 
                else
                    single_request_size <= single_request_size;
                end if; 
            end if; 
        end if; 
    end process;



    axi_adxl345_functional_inst : axi_adxl345_functional
        generic map (
            CLK_PERIOD                          =>  CLK_PERIOD                                               
        )
        port map (
            CLK                                 =>  CLK                                                     ,
            RESET                               =>  reset_logic                                             ,
            -- signal from AXI_DEV interface
            WDATA                               =>  S_AXI_LITE_DEV_WDATA                                    ,
            WSTRB                               =>  S_AXI_LITE_DEV_WSTRB                                    ,
            WADDR                               =>  axi_dev_awaddr(5 downto 2)                              ,
            WVALID                              =>  slv_reg_wren                                            ,
            RADDR                               =>  axi_dev_araddr(5 downto 2)                              ,
            RDATA                               =>  reg_data_out                                            ,
            -- control
            I2C_ADDRESS                         =>  i2c_address                                             ,
            ENABLE_INTERVAL_REQUESTION          =>  request_interval_enable                                 ,
            REQUESTION_INTERVAL                 =>  requestion_interval                                     ,
            
            SINGLE_REQUEST                      =>  single_request                                          ,
            SINGLE_REQUEST_ADDRESS              =>  single_request_address                                  ,
            SINGLE_REQUEST_SIZE                 =>  single_request_size                                     ,
            SINGLE_REQUEST_COMPLETE             =>  single_request_complete                                 ,

            ALLOW_IRQ                           =>  allow_irq_reg                                           ,
            LINK_ON                             =>  link_on                                                 ,
            ADXL_INTERRUPT                      =>  ADXL_INTERRUPT                                          ,
            ADXL_IRQ                            =>  adxl_irq_reg                                            ,
            ADXL_IRQ_ACK                        =>  adxl_irq_ack                                            ,

            OPTIMAL_REQUEST_TIMER               =>  opt_request_interval                                    ,

            READ_VALID_COUNT                    =>  read_valid_count                                        ,
            WRITE_VALID_COUNT                   =>  write_valid_count                                       ,

            WRITE_TRANSACTIONS                  =>  write_transactions                                      ,
            READ_TRANSACTIONS                   =>  read_transactions                                       ,

            ON_WORK                             =>  on_work                                                 ,
            -- data to device
            M_AXIS_TDATA                        =>  M_AXIS_TDATA                                            ,
            M_AXIS_TKEEP                        =>  M_AXIS_TKEEP                                            ,
            M_AXIS_TUSER                        =>  M_AXIS_TDEST                                            ,
            M_AXIS_TVALID                       =>  M_AXIS_TVALID                                           ,
            M_AXIS_TLAST                        =>  M_AXIS_TLAST                                            ,
            M_AXIS_TREADY                       =>  M_AXIS_TREADY                                           ,
            -- data from device
            S_AXIS_TDATA                        =>  S_AXIS_TDATA                                            ,
            S_AXIS_TKEEP                        =>  S_AXIS_TKEEP                                            ,
            S_AXIS_TUSER                        =>  S_AXIS_TDEST                                            ,
            S_AXIS_TVALID                       =>  S_AXIS_TVALID                                           ,
            S_AXIS_TLAST                        =>  S_AXIS_TLAST                                            ,
            S_AXIS_TREADY                       =>  S_AXIS_TREADY                                            
        );



end axi_adxl345_arch;
