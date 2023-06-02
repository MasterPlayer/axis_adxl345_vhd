library IEEE;
    use IEEE.STD_LOGIC_1164.ALL;
    use ieee.std_logic_unsigned.all;
    use ieee.std_logic_arith.all;

Library xpm;
    use xpm.vcomponents.all;


entity axi_adxl345_functional is
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

        READ_VALID_COUNT                    :   out     std_logic_vector ( 31 downto 0 )                                    ;
        WRITE_VALID_COUNT                   :   out     std_logic_vector ( 31 downto 0 )                                    ;

        WRITE_TRANSACTIONS                  :   out     std_logic_vector ( 63 downto 0 )                                    ;
        READ_TRANSACTIONS                   :   out     std_logic_vector ( 63 downto 0 )                                    ;

        ON_WORK                             :   out     std_logic                                                           ;

        OPTIMAL_REQUEST_TIMER               :   out     std_Logic_Vector ( 47 downto 0 )                                    ;

        -- data to device
        M_AXIS_TDATA                        :   out     std_logic_vector (  7 downto 0 )                                    ;
        M_AXIS_TKEEP                        :   out     std_logic_vector (  0 downto 0 )                                    ;
        M_AXIS_TDEST                        :   out     std_logic_vector (  7 downto 0 )                                    ;
        M_AXIS_TVALID                       :   out     std_logic                                                           ;
        M_AXIS_TLAST                        :   out     std_logic                                                           ;
        M_AXIS_TREADY                       :   in      std_logic                                                           ;
        -- data from device
        S_AXIS_TDATA                        :   in      std_logic_vector (  7 downto 0 )                                    ;
        S_AXIS_TKEEP                        :   in      std_logic_vector (  0 downto 0 )                                    ;
        S_AXIS_TDEST                        :   in      std_logic_vector (  7 downto 0 )                                    ;
        S_AXIS_TVALID                       :   in      std_logic                                                           ;
        S_AXIS_TLAST                        :   in      std_logic                                                           ;
        S_AXIS_TREADY                       :   out     std_logic                                                            
    );
end axi_adxl345_functional;



architecture Behavioral of axi_adxl345_functional is

    constant  OPT_REQ_INTERVAL              :           std_logic_Vector ( 31 downto 0 ) := conv_std_logic_Vector((CLK_PERIOD/3200), 32); -- optimal requestion interval constant for data

    constant  ADDRESS_LIMIT                 :           std_logic_Vector (  7 downto 0 ) := x"3A"                           ;
    constant  ADDRESS_WRITE_BEGIN           :           std_logic_Vector (  7 downto 0 ) := x"1D"                           ;
    constant  ADDRESS_WRITE_END             :           std_logic_Vector (  7 downto 0 ) := x"38"                           ;

    -- constant parameters for comparison
    constant  DEVICE_ID_ADDR                :           std_Logic_Vector (  5 downto 0 ) := "00" & x"0"; --6'h00; -- 
    constant  OFSX_ADDR                     :           std_Logic_Vector (  5 downto 0 ) := "01" & x"E"; --6'h1E; -- 
    constant  BW_RATE_ADDR                  :           std_Logic_Vector (  5 downto 0 ) := "10" & x"C"; --6'h2C; -- 
    constant  INT_ENABLE_ADDR               :           std_Logic_Vector (  5 downto 0 ) := "10" & x"E"; --6'h2E; -- 
    constant  INT_SOURCE_ADDR               :           std_Logic_Vector (  5 downto 0 ) := "11" & x"0"; --6'h30; -- 
    constant  DATAX0_ADDR                   :           std_Logic_Vector (  5 downto 0 ) := "11" & x"2"; --6'h32; -- 
    constant  DATAX1_ADDR                   :           std_Logic_Vector (  5 downto 0 ) := "11" & x"3"; --6'h33; -- 
    constant  DATAY1_ADDR                   :           std_Logic_Vector (  5 downto 0 ) := "11" & x"5"; --6'h35; -- 
    constant  DATAZ1_ADDR                   :           std_Logic_Vector (  5 downto 0 ) := "11" & x"7"; --6'h37; -- 

    constant  DEVICE_ID                     : std_logic_Vector (  7 downto 0 ) := x"E5";

    type need_update_reg_memory is array (0 to 15) of std_logic_vector ( 3 downto 0 );
    type write_mask_register_memory is array (0 to 15) of std_logic_vector ( 3 downto 0 );

    type fsm is (
        IDLE_CHK_REQ_ST         , -- await new action
        IDLE_CHK_UPD_ST         , -- await new action
        -- if request data flaq
        REQ_TX_ADDR_PTR_ST      , -- send address pointer 
        REQ_TX_READ_DATA_ST     , -- send read request for reading 0x39 data bytes 
        REQ_RX_READ_DATA_ST     , -- await data from start to tlast signal 
        -- if need update flaq asserted
        UPD_CHK_FLAQ_ST         ,
        UPD_TX_DATA_ST          , 
        UPD_INCREMENT_ADDR_ST   ,
        STUB_ST                   

    );

    signal  need_update_reg : need_update_reg_memory := (
        "0000", -- 0x00
        "0000", -- 0x04
        "0000", -- 0x08
        "0000", -- 0x0C
        "0000", -- 0x10
        "0000", -- 0x14
        "0000", -- 0x18
        "0000", -- 0x1C
        "0000", -- 0x20
        "0000", -- 0x24
        "0000", -- 0x28
        "0000", -- 0x2C
        "0000", -- 0x30
        "0000", -- 0x34
        "0000", -- 0x38
        "0000"  -- 0x3C
    );

    signal  write_mask_register : write_mask_register_memory := (
        "0000", -- 0x00
        "0000", -- 0x04
        "0000", -- 0x08
        "0000", -- 0x0C
        "0000", -- 0x10
        "0000", -- 0x14
        "0000", -- 0x18
        "1110", -- 0x1C
        "1111", -- 0x20
        "1111", -- 0x24
        "0111", -- 0x28
        "1111", -- 0x2C
        "0010", -- 0x30
        "0000", -- 0x34
        "0001", -- 0x38
        "0000"  -- 0x3C
    );

    signal  need_update_flaq                        :       std_logic                           := '0'                          ;

    signal  current_state                           :       fsm                                 := IDLE_CHK_REQ_ST              ;
    signal  request_flaq                            :       std_logic                           := '0'                          ;

    -- periodic requesting data for interval time
    signal  requestion_interval_counter             :       std_logic_vector ( 31 downto 0 )    := (others => '0')              ;
    signal  requestion_interval_assigned            :       std_logic                           := '0'                          ;

    signal  out_din_data                            :       std_Logic_Vector (  7 downto 0 )    := (others => '0')              ;
    signal  out_din_keep                            :       std_Logic_Vector (  0 downto 0 )    := (others => '1')              ;
    signal  out_din_user                            :       std_Logic_Vector (  7 downto 0 )    := (others => '0')              ;
    signal  out_din_last                            :       std_logic                           := '0'                          ;
    signal  out_wren                                :       std_logic                           := '0'                          ;
    signal  out_full                                :       std_logic                                                           ;
    signal  out_awfull                              :       std_logic                                                           ;

    signal  word_counter                            :       std_logic_Vector (  3 downto 0 )    := (others => '0')              ;
    signal  address_ptr                             :       std_logic_Vector (  7 downto 0 )    := (others => '0')              ;
    -- write memory signal group : 32 bit input, 8 bit output;
    signal  write_memory_addra                      :       std_logic_vector (  3 downto 0 )    := (others => '0')              ;
    signal  write_memory_doutb                      :       std_logic_vector (  7 downto 0 )    := (others => '0')              ;
    signal  write_memory_addrb                      :       std_logic_vector (  5 downto 0 )    := (others => '0')              ;
    signal  write_memory_dina                       :       std_logic_vector ( 31 downto 0 )    := (others => '0')              ;
    signal  write_memory_wea                        :       std_logic_vector (  3 downto 0 )    := (others => '0')              ;

    -- read memory signal group : 8 bit input 32 bit output;
    signal  read_memory_addra                       :       std_logic_vector (  5 downto 0 )    := (others => '0')              ;
    signal  read_memory_doutb                       :       std_logic_vector ( 31 downto 0 )    := (others => '0')              ;
    signal  read_memory_addrb                       :       std_logic_vector (  3 downto 0 )    := (others => '0')              ;
    signal  read_memory_dina                        :       std_logic_vector (  7 downto 0 )    := (others => '0')              ;
    signal  read_memory_wea                         :       std_logic                           := '0'                          ;

    signal  write_memory_hi                         :       std_Logic_vector (  3 downto 0 )                                    ;
    signal  write_memory_lo                         :       std_Logic_vector (  1 downto 0 )                                    ;

    signal  interrupt                               :       std_logic                           := '0'                          ; -- signal for flaq which needed for FSM for transit to REQ_* states
    signal  interrupt_saved                         :       std_logic                           := '0'                          ; -- signal for assertion adxl_irq_reg signal

    signal  need_calibration_flaq                   :       std_logic                           := '0'                          ;

    -- saved registers in internal
    signal  bw_rate_reg                             :       std_Logic_vector (  7 downto 0 )    := (others => '0')              ;
    signal  int_enable_reg                          :       std_Logic_vector (  7 downto 0 )    := (others => '0')              ;
    signal  int_source_reg                          :       std_Logic_vector (  7 downto 0 )    := (others => '0')              ;

    -- saved fields from registers (as latches, not regs)
    -- enabled_interrupts flaqs
    signal  has_watermark_intr                      :       std_logic                           := '0'                          ;


    -- fields of registers

    signal  timer                                   :       std_logic_vector ( 31 downto 0 )    := (others => '0')              ;
    signal  read_valid_counter                      :       std_logic_vector ( 31 downto 0 )    := (others => '0')              ;
    signal  write_valid_counter                     :       std_logic_vector ( 31 downto 0 )    := (others => '0')              ;

    signal  require_update_flaq                     :       std_logic                           := '0'                          ; -- flaq for update internal <read>memory after changes on <write>memory and device memory 

    signal  fifo_memory_addra                       :       std_logic_Vector (  5 downto 0 )    := (others => '0')              ;
    signal  fifo_memory_dina                        :       std_logic_Vector (  7 downto 0 )    := (others => '0')              ;
    signal  fifo_memory_addrb                       :       std_logic_Vector (  3 downto 0 )    := (others => '0')              ;
    signal  fifo_memory_doutb                       :       std_logic_Vector ( 31 downto 0 )                                    ;
    signal  fifo_memory_wea                         :       std_logic                           := '0'                          ;

    component fifo_out_sync_xpm_dest
        generic(
            DATA_WIDTH      :           integer         :=  16                          ;
            DEST_WIDTH      :           integer         :=  1                           ;
            MEMTYPE         :           String          :=  "block"                     ;
            DEPTH           :           integer         :=  16                           
        );
        port(
            CLK             :   in      std_logic                                       ;
            RESET           :   in      std_logic                                       ;
            
            OUT_DIN_DATA    :   in      std_logic_Vector ( DATA_WIDTH-1 downto 0 )      ;
            OUT_DIN_KEEP    :   in      std_logic_Vector ( ( DATA_WIDTH/8)-1 downto 0 ) ;
            OUT_DIN_DEST    :   in      std_logic_Vector ( DEST_WIDTH-1 downto 0 )      ;
            OUT_DIN_LAST    :   in      std_logic                                       ;
            OUT_WREN        :   in      std_logic                                       ;
            OUT_FULL        :   out     std_logic                                       ;
            OUT_AWFULL      :   out     std_logic                                       ;
            
            M_AXIS_TDATA    :   out     std_logic_Vector ( DATA_WIDTH-1 downto 0 )      ;
            M_AXIS_TKEEP    :   out     std_logic_Vector (( DATA_WIDTH/8)-1 downto 0 )  ;
            M_AXIS_TDEST    :   out     std_logic_vector ( DEST_WIDTH-1 downto 0 )      ;
            M_AXIS_TVALID   :   out     std_logic                                       ;
            M_AXIS_TLAST    :   out     std_logic                                       ;
            M_AXIS_TREADY   :   in      std_logic                                        

        );
    end component;

    signal  s_axis_tready_signal : std_logic ;

    signal  adxl_irq_reg : std_logic := '0';

    signal  single_request_complete_reg             :       std_logic                        := '0'                                     ;


    signal  link_on_reg                         :           std_logic                        := '0'                                     ;
    signal  read_valid_count_reg                :           std_logic_vector ( 31 downto 0 ) := (others => '0')                         ;
    signal  write_valid_count_reg               :           std_logic_vector ( 31 downto 0 ) := (others => '0')                         ;
    signal  write_transactions_reg              :           std_logic_vector ( 63 downto 0 ) := (others => '0')                         ;
    signal  read_transactions_reg               :           std_logic_vector ( 63 downto 0 ) := (others => '0')                         ;
    signal  on_work_reg                         :           std_logic                        := '0'                                     ;

    signal  index : integer := 0;

    signal  optimal_request_timer_reg           :           std_logic_Vector ( 47 downto 0 ) := (others => '0')                         ;

begin


    LINK_ON             <=  link_on_reg             ;
    READ_VALID_COUNT    <=  read_valid_count_reg    ;
    WRITE_VALID_COUNT   <=  write_valid_count_reg   ;
    WRITE_TRANSACTIONS  <=  write_transactions_reg  ;
    READ_TRANSACTIONS   <=  read_transactions_reg   ;
    ON_WORK             <=  on_work_reg             ;

    SINGLE_REQUEST_COMPLETE <= single_request_complete_reg;
    S_AXIS_TREADY       <=  s_axis_tready_signal                ;
    ADXL_IRQ            <=  adxl_irq_reg                        ;
    RDATA               <=  read_memory_doutb                   ;

    OPTIMAL_REQUEST_TIMER <= optimal_request_timer_reg;


    write_memory_hi     <=  write_memory_addrb ( 5 downto 2)    ;
    write_memory_lo     <=  write_memory_addrb ( 1 downto 0)    ;
    read_memory_addrb   <=  RADDR                               ;
    write_memory_addra  <=  WADDR                               ;


    optimal_request_timer_reg_processing : process(CLK)
    begin 
        if CLK'event AND CLK = '1' then 
            case (bw_rate_reg( 3 downto 0 )) is 
                when x"0"   => optimal_request_timer_reg <= EXT(OPT_REQ_INTERVAL & "000000000000000", 48);
                when x"1"   => optimal_request_timer_reg <= EXT(OPT_REQ_INTERVAL & "00000000000000", 48);
                when x"2"   => optimal_request_timer_reg <= EXT(OPT_REQ_INTERVAL & "0000000000000", 48);
                when x"3"   => optimal_request_timer_reg <= EXT(OPT_REQ_INTERVAL & "000000000000", 48);
                when x"4"   => optimal_request_timer_reg <= EXT(OPT_REQ_INTERVAL & "00000000000", 48);
                when x"5"   => optimal_request_timer_reg <= EXT(OPT_REQ_INTERVAL & "0000000000", 48);
                when x"6"   => optimal_request_timer_reg <= EXT(OPT_REQ_INTERVAL & "000000000", 48);
                when x"7"   => optimal_request_timer_reg <= EXT(OPT_REQ_INTERVAL & "00000000", 48);
                when x"8"   => optimal_request_timer_reg <= EXT(OPT_REQ_INTERVAL & "0000000", 48);
                when x"9"   => optimal_request_timer_reg <= EXT(OPT_REQ_INTERVAL & "000000", 48);
                when x"a"   => optimal_request_timer_reg <= EXT(OPT_REQ_INTERVAL & "00000", 48);
                when x"b"   => optimal_request_timer_reg <= EXT(OPT_REQ_INTERVAL & "0000", 48);
                when x"c"   => optimal_request_timer_reg <= EXT(OPT_REQ_INTERVAL & "000", 48);
                when x"d"   => optimal_request_timer_reg <= EXT(OPT_REQ_INTERVAL & "00", 48);
                when x"e"   => optimal_request_timer_reg <= EXT(OPT_REQ_INTERVAL & "0", 48);
                when x"f"   => optimal_request_timer_reg <= EXT(OPT_REQ_INTERVAL, 48);

                when others => optimal_request_timer_reg <= EXT(OPT_REQ_INTERVAL, 48);
            end case;
        end if;
    end process;


    s_axis_tready_signal_processing : process(CLK)
    begin 
        if CLK'event AND CLK = '1' then  
            if RESET = '1' then 
                s_axis_tready_signal <= '0';
            else
                s_axis_tready_signal <= '1';
            end if;
        end if;
    end process;



    interrupt_processing : process(CLK)
    begin 
        if CLK'event AND CLK = '1' then  
            case (current_state) is
                when others =>  
                    if (ADXL_INTERRUPT = '1' and ALLOW_IRQ = '1') then 
                        interrupt <= '1';
                    else
                        interrupt <= '0';
                    end if;

            end case; -- current_state
        end if;
    end process;



    interrupt_saved_processing : process(CLK)
    begin 
        if CLK'event AND CLK = '1' then  
            case (current_state) is

                when REQ_TX_READ_DATA_ST =>  
                    if (interrupt = '1') then 
                        interrupt_saved <= '1';
                    else
                        interrupt_saved <= '0';
                    end if;

                when REQ_RX_READ_DATA_ST => 
                    if (S_AXIS_TVALID = '1' and s_axis_tready_signal <= '1' and S_AXIS_TLAST = '1') then 
                        if (interrupt_saved = '1') then 
                            interrupt_saved <= '0';
                        else
                            interrupt_saved <= interrupt_saved;
                        end if; 
                    else
                        interrupt_saved <= interrupt_saved;
                    end if; 


                when others =>  
                    interrupt_saved <= interrupt_saved;

            end case;
        end if;
    end process;



    adxl_irq_processing : process(CLK)
    begin 
        if CLK'event AND CLK = '1' then  
            if (ADXL_IRQ_ACK = '1' or RESET = '1') then 
                adxl_irq_reg <= '0';
            else
                case (current_state) is
                    when REQ_RX_READ_DATA_ST => 
                        if (S_AXIS_TVALID = '1' and s_axis_tready_signal <= '1' and S_AXIS_TLAST = '1') then  
                            if (interrupt_saved = '1' and ADXL_INTERRUPT = '0') then 
                                adxl_irq_reg <= '1';
                            else
                                adxl_irq_reg <= adxl_irq_reg;
                            end if;
                        else
                            adxl_irq_reg <= adxl_irq_reg;
                        end if;

                    when others =>  
                        adxl_irq_reg <= adxl_irq_reg;
                end case;
            end if;
        end if;
    end process;



    --generate
    
    --GEN_NEED_UPDATE : for index in 0 to 3 generate 
    --    -- TODO :: Accuracy            
    --    need_update_reg_processing : process(CLK)
    --    begin 
    --        if CLK'event AND CLK = '1' then 
    --            if (WVALID = '1' and WSTRB(index) = '1' ) then 
    --                need_update_reg(conv_integer(WADDR))(index) <= write_mask_register(conv_integer(WADDR))(index);
    --            else
    --                --if (index = conv_integer(write_memory_lo)) then 
    --                --    if (current_state = UPD_CHK_FLAQ_ST) then 
    --                --        need_update_reg(conv_integer(write_memory_hi))(index) <= '0';
    --                    --else
    --                        --need_update_reg(conv_integer(write_memory_hi))(index) <= need_update_reg(conv_integer(write_memory_hi))(index);
    --                    --end if;
    --                --else
    --                    --need_update_reg(conv_integer(WADDR))(index) <= need_update_reg(conv_integer(WADDR))(index);
    --                --end if; 
    --            end if;
    --        end if;
    --    end process;

    --end generate GEN_NEED_UPDATE;


    --endgenerate

    need_update_reg_processing : process(CLK)
    begin 
        if CLK'event AND CLK = '1' then 
            for index in 0 to 3 loop 
                if (WVALID = '1') then 
                    if (WSTRB(index) = '1') then 
                        need_update_reg(conv_integer(WADDR))(index) <= write_mask_register(conv_integer(WADDR))(index);
                    end if;
                else
                    if (index = conv_integer(write_memory_lo)) then 
                        if (current_state = UPD_CHK_FLAQ_ST) then 
                            need_update_reg(conv_integer(write_memory_hi))(index) <= '0';
                        else
                            need_update_reg(conv_integer(write_memory_hi))(index) <= need_update_reg(conv_integer(write_memory_hi))(index);
                        end if;
                    else
                        need_update_reg(conv_integer(WADDR))(index) <= need_update_reg(conv_integer(WADDR))(index);
                    end if; 
                end if;
            end loop;
        end if;
    end process;





    write_memory_wea_processing : process(CLK)
    begin 
        if CLK'event AND CLK = '1' then  
            if (WVALID = '1') then 
                write_memory_wea <= write_mask_register(conv_integer(WADDR)) and WSTRB;
            else
                write_memory_wea <= (others => '0');
            end if;
       end if;
    end process;



    write_memory_dina_processing : process(CLK)
    begin 
        if CLK'event AND CLK = '1' then   
            if (WVALID = '1') then 
                write_memory_dina <= WDATA;
            else
                write_memory_dina <= write_memory_dina;
            end if;
        end if;
    end process;


    need_update_flaq_processing : process(CLK)
    begin 
        if CLK'event AND CLK = '1' then  
            if (write_memory_wea(3) = '1' or write_memory_wea(2) = '1' or write_memory_wea(1) = '1' or write_memory_wea(0) = '1' ) then 
                need_update_flaq <= '1';
            else
                -- to do : deassert according fsm
                case (current_state) is
                    when REQ_RX_READ_DATA_ST => 
                        if (need_update_flaq = '1') then 
                            need_update_flaq <= '0';
                        else
                            need_update_flaq <= need_update_flaq;
                        end if; 

                    when others =>  
                        need_update_flaq <= need_update_flaq;

                end case;
            end if;
        end if;
    end process;



    -- if needed request, OR for this register
    request_flaq_processing : process(CLK)
    begin 
        if CLK'event AND CLK = '1' then  
            request_flaq <= SINGLE_REQUEST or requestion_interval_assigned or interrupt or require_update_flaq;
        end if;
    end process;



    write_memory_addrb_processing : process(CLK)
    begin 
        if CLK'event AND CLK = '1' then  
            case (current_state) is
                when IDLE_CHK_UPD_ST => 
                    write_memory_addrb <= ADDRESS_WRITE_BEGIN( 5 downto 0 );

                when UPD_INCREMENT_ADDR_ST =>
                    write_memory_addrb <= write_memory_addrb + 1;

                when others =>  
                    write_memory_addrb <= write_memory_addrb;
            end case;
        end if;
    end process;



    requestion_interval_counter_processing : process(CLK)
    begin 
        if CLK'event AND CLK = '1' then  
            case (current_state) is 

                when REQ_RX_READ_DATA_ST => 
                    requestion_interval_counter <= REQUESTION_INTERVAL;

                when others =>  
                    if (ENABLE_INTERVAL_REQUESTION = '1') then 
                        if (requestion_interval_counter = 0) then 
                            requestion_interval_counter <= requestion_interval_counter;
                        else
                            requestion_interval_counter <= requestion_interval_counter - 1;
                        end if;
                    else
                        requestion_interval_counter <= REQUESTION_INTERVAL;
                    end if;

            end case;
        end if;
    end process;



    requestion_interval_assigned_processing : process(CLK)
    begin 
        if CLK'event AND CLK = '1' then  
            if (ENABLE_INTERVAL_REQUESTION = '1') then 
                if (requestion_interval_counter = 0) then 
                    requestion_interval_assigned <= not (adxl_irq_reg);
                else
                    requestion_interval_assigned <= '0'; 
                end if; 
            else
                requestion_interval_assigned <= '0';
            end if; 
        end if;
    end process;


    xpm_memory_sdpram_write_inst : xpm_memory_sdpram 
        generic map (
            ADDR_WIDTH_A                => 4                        ,
            ADDR_WIDTH_B                => 6                        ,
            AUTO_SLEEP_TIME             => 0                        ,
            BYTE_WRITE_WIDTH_A          => 8                        ,
            CASCADE_HEIGHT              => 0                        ,
            CLOCKING_MODE               => "common_clock"           ,
            ECC_MODE                    => "no_ecc"                 ,
            MEMORY_INIT_FILE            => "none"                   ,
            MEMORY_INIT_PARAM           => "0"                      ,
            MEMORY_OPTIMIZATION         => "true"                   ,
            MEMORY_PRIMITIVE            => "auto"                   ,
            MEMORY_SIZE                 => 512                      ,
            MESSAGE_CONTROL             => 0                        ,
            READ_DATA_WIDTH_B           => 8                        ,
            READ_LATENCY_B              => 2                        ,
            READ_RESET_VALUE_B          => "0"                      ,
            RST_MODE_A                  => "SYNC"                   ,
            RST_MODE_B                  => "SYNC"                   ,
            SIM_ASSERT_CHK              => 0                        ,
            USE_EMBEDDED_CONSTRAINT     => 0                        ,
            USE_MEM_INIT                => 1                        ,
            WAKEUP_TIME                 => "disable_sleep"          ,
            WRITE_DATA_WIDTH_A          => 32                       ,
            WRITE_MODE_B                => "no_change"     
        ) port map (
            dbiterrb                    =>  open                    , -- 1-bit output: Status signal to indicate double bit error occurrence
            sbiterrb                    =>  open                    , -- 1-bit output: Status signal to indicate single bit error occurrence
            doutb                       =>  write_memory_doutb      , -- READ_DATA_WIDTH_B-bit output: Data output for port B read operations.
            addra                       =>  write_memory_addra      , -- ADDR_WIDTH_A-bit input: Address for port A write operations.
            addrb                       =>  write_memory_addrb      , -- ADDR_WIDTH_B-bit input: Address for port B read operations.
            clka                        =>  CLK                     , -- 1-bit input: Clock signal for port A. Also clocks port B when
            clkb                        =>  CLK                     , -- 1-bit input: Clock signal for port B when parameter CLOCKING_MODE is
            dina                        =>  write_memory_dina       , -- WRITE_DATA_WIDTH_A-bit input: Data input for port A write operations.
            ena                         =>  '1'                     , -- 1-bit input: Memory enable signal for port A. Must be high on clock
            enb                         =>  '1'                     , -- 1-bit input: Memory enable signal for port B. Must be high on clock
            injectdbiterra              =>  '0'                     , -- 1-bit input: Controls double bit error injection on input data when
            injectsbiterra              =>  '0'                     , -- 1-bit input: Controls single bit error injection on input data when
            regceb                      =>  '1'                     , -- 1-bit input: Clock Enable for the last register stage on the output
            rstb                        =>  RESET                   , -- 1-bit input: Reset signal for the final port B output register stage.
            sleep                       =>  '0'                     , -- 1-bit input: sleep signal to enable the dynamic power saving feature.
            wea                         =>  write_memory_wea          -- WRITE_DATA_WIDTH_A/BYTE_WRITE_WIDTH_A-bit input: Write enable vector
        );




    xpm_memory_sdpram_read_inst : xpm_memory_sdpram
        generic map (
            ADDR_WIDTH_A                =>  6                       , -- DECIMAL
            ADDR_WIDTH_B                =>  4                       , -- DECIMAL
            AUTO_SLEEP_TIME             =>  0                       , -- DECIMAL
            BYTE_WRITE_WIDTH_A          =>  8                       , -- DECIMAL
            CASCADE_HEIGHT              =>  0                       , -- DECIMAL
            CLOCKING_MODE               =>  "common_clock"          , -- String
            ECC_MODE                    =>  "no_ecc"                , -- String
            MEMORY_INIT_FILE            =>  "none"                  , -- String
            MEMORY_INIT_PARAM           =>  "0"                     , -- String
            MEMORY_OPTIMIZATION         =>  "true"                  , -- String
            MEMORY_PRIMITIVE            =>  "auto"                  , -- String
            MEMORY_SIZE                 =>  512                     , -- DECIMAL
            MESSAGE_CONTROL             =>  0                       , -- DECIMAL
            READ_DATA_WIDTH_B           =>  32                      , -- DECIMAL
            READ_LATENCY_B              =>  1                       , -- DECIMAL
            READ_RESET_VALUE_B          =>  "0"                     , -- String
            RST_MODE_A                  =>  "SYNC"                  , -- String
            RST_MODE_B                  =>  "SYNC"                  , -- String
            SIM_ASSERT_CHK              =>  0                       , -- DECIMAL; 0=disable simulation messages, 1=enable simulation messages
            USE_EMBEDDED_CONSTRAINT     =>  0                       , -- DECIMAL
            USE_MEM_INIT                =>  1                       , -- DECIMAL
            WAKEUP_TIME                 =>  "disable_sleep"         , -- String
            WRITE_DATA_WIDTH_A          =>  8                       , -- DECIMAL
            WRITE_MODE_B                =>  "no_change"               -- String
        )
        port map (
            dbiterrb                    =>  open                    ,
            sbiterrb                    =>  open                    ,
            doutb                       =>  read_memory_doutb       ,
            addra                       =>  read_memory_addra       ,
            addrb                       =>  read_memory_addrb       ,
            clka                        =>  CLK                     ,
            clkb                        =>  CLK                     ,
            dina                        =>  read_memory_dina        ,
            ena                         =>  '1'                     ,
            enb                         =>  '1'                     ,
            injectdbiterra              =>  '0'                     ,
            injectsbiterra              =>  '0'                     ,
            regceb                      =>  '1'                     ,
            rstb                        =>  RESET                   ,
            sleep                       =>  '0'                     ,
            wea(0)                      =>  read_memory_wea                      
        );



    -- address : sets before receive data, implies on MEM
    read_memory_addra_processing : process(CLK)
    begin 
        if CLK'event AND CLK = '1' then  
            case (current_state) is
                when REQ_TX_READ_DATA_ST =>  
                    read_memory_addra <= address_ptr(5 downto 0);

                when REQ_RX_READ_DATA_ST => 
                    if (read_memory_wea = '1') then 
                        if (read_memory_addra = (ADDRESS_LIMIT-1)) then 
                            read_memory_addra <= (others => '0');
                        else
                            read_memory_addra <= read_memory_addra + 1;
                        end if;
                    else
                        read_memory_addra <= read_memory_addra;
                    end if;

                when others =>  
                    read_memory_addra <= read_memory_addra;

            end case;
        end if;
    end process;


    -- readed data from interface S_AXIS_ to porta for readmemory
    read_memory_wea_processing : process(CLK)
    begin 
        if CLK'event AND CLK = '1' then 
            case (current_state) is
                when REQ_RX_READ_DATA_ST => 
                    read_memory_wea <= S_AXIS_TVALID;

                when others =>  
                    read_memory_wea <= '0';

            end case;
        end if;
    end process;

    
    
    read_memory_dina_processing : process(CLK)
    begin 
        if CLK'event AND CLK = '1' then  
            case (current_state) is
                when REQ_RX_READ_DATA_ST => 
                    read_memory_dina <= S_AXIS_TDATA;

                when others => 
                    read_memory_dina <= read_memory_dina;
            end case;
        end if;
    end process;



    bw_rate_reg_processing : process(CLK)
    begin 
        if CLK'event AND CLK = '1' then  
            if (read_memory_addra = BW_RATE_ADDR) then 
                if (read_memory_wea = '1') then 
                    bw_rate_reg <= read_memory_dina;
                else
                    bw_rate_reg <= bw_rate_reg;
                end if;
            else
                bw_rate_reg <= bw_rate_reg;
            end if;
        end if;
    end process;




    int_source_reg_processing : process(CLK)
    begin 
        if CLK'event AND CLK = '1' then 
            if (read_memory_addra = INT_SOURCE_ADDR) then 
                if (read_memory_wea = '1') then 
                    int_source_reg <= read_memory_dina;
                else
                    int_source_reg <= int_source_reg;
                end if;
            else
                int_source_reg <= int_source_reg;
            end if;
        end if;
    end process;




    int_enable_reg_processing : process(CLK)
    begin 
        if CLK'event AND CLK = '1' then 
            if (read_memory_addra = INT_ENABLE_ADDR) then 
                if (read_memory_wea = '1') then 
                    int_enable_reg <= read_memory_dina;
                else
                    int_enable_reg <= int_enable_reg;
                end if; 
            else
                int_enable_reg <= int_enable_reg;
            end if;
        end if;
    end process;



    has_watermark_intr_processing : process(CLK)
    begin 
        if CLK'event AND CLK = '1' then 
            if (int_source_reg(1) = '1' and int_enable_reg(1) = '1') then 
                has_watermark_intr <= '1';
            else
                has_watermark_intr <= '0';
            end if;
        end if;
    end process;



    xpm_memory_sdpram_inst : xpm_memory_sdpram
        generic map (
            ADDR_WIDTH_A                =>  6                       ,   -- DECIMAL
            ADDR_WIDTH_B                =>  4                       ,   -- DECIMAL
            AUTO_SLEEP_TIME             =>  0                       ,   -- DECIMAL
            BYTE_WRITE_WIDTH_A          =>  8                       ,   -- DECIMAL
            CASCADE_HEIGHT              =>  0                       ,   -- DECIMAL
            CLOCKING_MODE               =>  "common_clock"          ,   -- String
            ECC_MODE                    =>  "no_ecc"                ,   -- String
            MEMORY_INIT_FILE            =>  "none"                  ,   -- String
            MEMORY_INIT_PARAM           =>  "0"                     ,   -- String
            MEMORY_OPTIMIZATION         =>  "true"                  ,   -- String
            MEMORY_PRIMITIVE            =>  "auto"                  ,   -- String
            MEMORY_SIZE                 =>  512                     ,   -- DECIMAL
            MESSAGE_CONTROL             =>  0                       ,   -- DECIMAL
            READ_DATA_WIDTH_B           =>  32                      ,   -- DECIMAL
            READ_LATENCY_B              =>  1                       ,   -- DECIMAL
            READ_RESET_VALUE_B          =>  "0"                     ,   -- String
            RST_MODE_A                  =>  "SYNC"                  ,   -- String
            RST_MODE_B                  =>  "SYNC"                  ,   -- String
            SIM_ASSERT_CHK              =>  0                       ,   -- DECIMAL; 0=disable simulation messages, 1=enable simulation messages
            USE_EMBEDDED_CONSTRAINT     =>  0                       ,   -- DECIMAL
            USE_MEM_INIT                =>  1                       ,   -- DECIMAL
            USE_MEM_INIT_MMI            =>  0                       ,   -- DECIMAL
            WAKEUP_TIME                 =>  "disable_sleep"         ,   -- String
            WRITE_DATA_WIDTH_A          =>  8                       ,   -- DECIMAL
            WRITE_MODE_B                =>  "no_change"                 -- String
            --WRITE_PROTECT               =>  1                           -- DECIMAL
        )
        port map (
            dbiterrb                    =>  open                    , -- 1-bit output: Status signal to indicate double bit error occurrence
            sbiterrb                    =>  open                    , -- 1-bit output: Status signal to indicate single bit error occurrence
            doutb                       =>  fifo_memory_doutb       , -- READ_DATA_WIDTH_B-bit output: Data output for port B read operations.
            addra                       =>  fifo_memory_addra       , -- ADDR_WIDTH_A-bit input: Address for port A write operations.
            addrb                       =>  fifo_memory_addrb       , -- ADDR_WIDTH_B-bit input: Address for port B read operations.
            clka                        =>  CLK                     , -- 1-bit input: Clock signal for port A. Also clocks port B when
            clkb                        =>  CLK                     , -- 1-bit input: Clock signal for port B when parameter CLOCKING_MODE is
            dina                        =>  fifo_memory_dina        , -- WRITE_DATA_WIDTH_A-bit input: Data input for port A write operations.
            ena                         =>  '1'                     , -- 1-bit input: Memory enable signal for port A. Must be high on clock
            enb                         =>  '1'                     , -- 1-bit input: Memory enable signal for port B. Must be high on clock
            injectdbiterra              =>  '0'                     , -- 1-bit input: Controls double bit error injection on input data when
            injectsbiterra              =>  '0'                     , -- 1-bit input: Controls single bit error injection on input data when
            regceb                      =>  '1'                     , -- 1-bit input: Clock Enable for the last register stage on the output
            rstb                        =>  RESET                   , -- 1-bit input: Reset signal for the final port B output register
            sleep                       =>  '0'                     , -- 1-bit input: sleep signal to enable the dynamic power saving feature.
            wea(0)                      =>  fifo_memory_wea           -- WRITE_DATA_WIDTH_A/BYTE_WRITE_WIDTH_A-bit input: Write enable vector

        );





    fifo_out_sync_xpm_dest_inst : fifo_out_sync_xpm_dest
        generic map (
            DATA_WIDTH      =>  8                               ,
            DEST_WIDTH      =>  8                               ,
            MEMTYPE         =>  "block"                         ,
            DEPTH           =>  16                               
        )
        port map (
            CLK             =>  CLK                             , 
            RESET           =>  RESET                           , 
            
            OUT_DIN_DATA    =>  out_din_data                    , 
            OUT_DIN_KEEP    =>  out_din_keep                    , 
            OUT_DIN_DEST    =>  out_din_user                    , 
            OUT_DIN_LAST    =>  out_din_last                    , 
            OUT_WREN        =>  out_wren                        , 
            OUT_FULL        =>  out_full                        , 
            OUT_AWFULL      =>  out_awfull                      , 
            
            M_AXIS_TDATA    =>  M_AXIS_TDATA                    , 
            M_AXIS_TKEEP    =>  M_AXIS_TKEEP                    , 
            M_AXIS_TDEST    =>  M_AXIS_TDEST                    , 
            M_AXIS_TVALID   =>  M_AXIS_TVALID                   , 
            M_AXIS_TLAST    =>  M_AXIS_TLAST                    , 
            M_AXIS_TREADY   =>  M_AXIS_TREADY                    

        );





    out_din_user(7 downto 1) <= I2C_ADDRESS;

    -- operation : 
    -- 0 - write
    -- 1 - read
    out_din_user_0_processing : process(CLK)
    begin 
        if CLK'event AND CLK = '1' then 
            case (current_state) is 
                when REQ_TX_ADDR_PTR_ST =>
                    out_din_user(0) <= '0'; -- is writing data to dev

                when REQ_TX_READ_DATA_ST =>  
                    out_din_user(0) <= '1'; -- cmd for reading data from dev

                when UPD_TX_DATA_ST =>
                    out_din_user(0) <= '0';

                when others =>  
                    out_din_user(0) <= out_din_user(0);

            end case; -- current_state
        end if;
    end process;



    out_din_data_processing : process(CLK)
    begin 
        if CLK'event AND CLK = '1' then 
            case (current_state) is 
                when REQ_TX_ADDR_PTR_ST =>
                    case (word_counter) is 
                        when x"0"   =>  out_din_data <= x"01"; -- how many bytes write
                        when x"1"   =>  out_din_data <= address_ptr; -- address pointer
                        when others =>  out_din_data <= out_din_data;
                    end case; -- word_counter

                when REQ_TX_READ_DATA_ST =>  
                    if (interrupt = '1') then 
                        if (has_watermark_intr = '1') then 
                            out_din_data <= x"06";
                        else
                            out_din_data <= x"0A";
                        end if;
                    else
                        if (SINGLE_REQUEST = '1') then 
                            out_din_data <= SINGLE_REQUEST_SIZE;
                        else
                            out_din_data <= ADDRESS_LIMIT;
                        end if;
                    end if;


                when UPD_TX_DATA_ST =>
                    case (word_counter) is
                        when x"0"   =>  out_din_data <= x"02";
                        when x"1"   =>  out_din_data <= EXT(write_memory_addrb, out_din_data'length);
                        when x"2"   =>  out_din_data <= write_memory_doutb;
                        when others =>  out_din_data <= out_din_data;
                    end case; -- word_counter

                when others =>  
                    out_din_data <= out_din_data;

            end case; -- current_state
        end if;
    end process;



    out_din_last_processing : process(CLK)
    begin 
        if CLK'event AND CLK = '1' then 
            case (current_state) is 
                when REQ_TX_ADDR_PTR_ST =>
                    case (word_counter) is 
                        when x"0"   => out_din_last <= '0';
                        when x"1"   => out_din_last <= '1';
                        when others => out_din_last <= out_din_last;
                    end case; -- word_counter

                when UPD_TX_DATA_ST =>
                    case (word_counter) is 
                        when x"0"   => out_din_last <= '0';
                        when x"1"   => out_din_last <= '0';
                        when x"2"   => out_din_last <= '1';
                        when others => out_din_last <= out_din_last;
                    end case; -- word_counter


                when others =>  
                    out_din_last <= out_din_last;

            end case; -- current_state
        end if;
    end process;



    out_wren_processing : process(CLK)
    begin 
        if CLK'event AND CLK = '1' then 
            case (current_state) is 
                when REQ_TX_ADDR_PTR_ST =>
                    if (out_awfull = '0') then   
                        out_wren <= '1';
                    else
                        out_wren <= '0';
                    end if;

                when REQ_TX_READ_DATA_ST =>  
                    if (out_awfull = '0') then   
                        out_wren <= '1'; 
                    else
                        out_wren <= '1';
                    end if; 

                when UPD_TX_DATA_ST =>  
                    if (out_awfull = '0') then   
                        out_wren <= '1';
                    else
                        out_wren <= '0';
                    end if;

                when others =>  
                    out_wren <= '0';

            end case; -- current_state
        end if;
    end process;






    current_state_processing : process(CLK)
    begin 
        if CLK'event AND CLK = '1' then 
            if RESET = '1' then 
                current_state <= IDLE_CHK_REQ_ST;
            else
                case (current_state) is 

                    when IDLE_CHK_REQ_ST =>
                        if (request_flaq = '1') then 
                            current_state <= REQ_TX_ADDR_PTR_ST;
                        else
                            current_state <= IDLE_CHK_UPD_ST;
                        end if; 

                    when IDLE_CHK_UPD_ST => 
                        if (need_update_flaq = '1') then 
                            current_state <= UPD_CHK_FLAQ_ST;
                        else
                            current_state <= IDLE_CHK_REQ_ST;
                        end if;

                    when REQ_TX_ADDR_PTR_ST => 
                        if (out_awfull = '0') then   
                            if (word_counter = x"1") then 
                                current_state <= REQ_TX_READ_DATA_ST;
                            else
                                current_state <= current_state;
                            end if; 
                        else
                            current_state <= current_state;
                        end if;

                    when REQ_TX_READ_DATA_ST => 
                        if (out_awfull = '0') then   
                            current_state <= REQ_RX_READ_DATA_ST;
                        else
                            current_state <= current_state;
                        end if;

                    when REQ_RX_READ_DATA_ST => 
                        if (S_AXIS_TVALID = '1' and S_AXIS_TLAST = '1') then 
                            current_state <= IDLE_CHK_UPD_ST;
                        else
                            current_state <= current_state;
                        end if;

                    when UPD_CHK_FLAQ_ST =>  
                        if (need_update_reg(conv_integer(write_memory_hi))(conv_integer(write_memory_lo)) = '1') then 
                            current_state <= UPD_TX_DATA_ST;
                        else
                            current_state <= UPD_INCREMENT_ADDR_ST;
                        end if;

                    when UPD_TX_DATA_ST =>
                        if (out_awfull = '0') then   
                            if (word_counter = x"2") then 
                                current_state <= UPD_INCREMENT_ADDR_ST;
                            else
                                current_state <= current_state;
                            end if; 
                        else
                            current_state <= current_state;
                        end if;

                    when UPD_INCREMENT_ADDR_ST =>
                        if (write_memory_addrb = ADDRESS_WRITE_END) then 
                            current_state <= IDLE_CHK_REQ_ST;
                        else
                            current_state <= UPD_CHK_FLAQ_ST;
                        end if;

                    when others =>  
                        current_state <= current_state;

                end case; -- current_state
            end if;
        end if;
    end process;



    address_ptr_processing : process(CLK)
    begin 
        if CLK'event AND CLK = '1' then 
            case (current_state) is 
                
                when IDLE_CHK_REQ_ST =>
                    if (interrupt = '1') then 
                        if (has_watermark_intr = '1') then 
                            address_ptr <= EXT(DATAX0_ADDR, address_ptr'length);
                        else
                            address_ptr <= EXT(INT_SOURCE_ADDR, address_ptr'length);
                        end if; 
                    else
                        if (SINGLE_REQUEST = '1' ) then 
                            address_ptr <= SINGLE_REQUEST_ADDRESS;
                        else
                            address_ptr <= EXT(DEVICE_ID_ADDR, address_ptr'length);
                        end if;
                    end if;
                
                when others =>  
                    address_ptr <= address_ptr;

            end case; -- current_state
        end if;
    end process;



    word_counter_processing : process(CLK)
    begin 
        if CLK'event AND CLK = '1' then 
            case (current_state) is
                when REQ_TX_ADDR_PTR_ST =>
                    if (out_awfull = '0') then   
                        word_counter <= word_counter + 1;
                    else
                        word_counter <= word_counter;
                    end if;

                when UPD_TX_DATA_ST =>
                    if (out_awfull = '0') then   
                        word_counter <= word_counter + 1;
                    else
                        word_counter <= word_counter;
                    end if;


                when others =>  
                    word_counter <= (others => '0');

            end case; -- current_state
        end if;
    end process;



    SINGLE_REQUEST_COMPLETE_processing : process(CLK)
    begin 
        if CLK'event AND CLK = '1' then 
            case (current_state) is 
                when REQ_TX_READ_DATA_ST =>  
                    if (out_awfull = '0') then   
                        single_request_complete_reg <= SINGLE_REQUEST;
                    else
                        single_request_complete_reg <= single_request_complete_reg;
                    end if;

                when others =>  
                    single_request_complete_reg <= '0';

            end case; -- current_state
        end if;
    end process;



    LINK_ON_processing : process(CLK)
    begin 
        if CLK'event AND CLK = '1' then 
            if RESET = '1' then 
                link_on_reg <= '0';
            else
                case (current_state) is
                    when REQ_RX_READ_DATA_ST =>   
                        if (read_memory_wea = '1') then 
                            if (read_memory_addra = DEVICE_ID_ADDR) then 
                                if (read_memory_dina = DEVICE_ID) then 
                                    link_on_reg <= '1';
                                else
                                    link_on_reg <= '0';
                                end if;
                            else
                                link_on_reg <= link_on_reg;
                            end if;
                        else
                            link_on_reg <= link_on_reg;
                        end if;

                    when others =>  
                        link_on_reg <= link_on_reg;

                end case; -- word_counter
            end if;
        end if;
    end process;



    require_update_flaq_processing : process(CLK)
    begin 
        if CLK'event AND CLK = '1' then 
            case (current_state) is

                when UPD_CHK_FLAQ_ST =>  
                    require_update_flaq <= '1';

                when IDLE_CHK_REQ_ST =>
                    if (request_flaq = '1') then 
                        if (interrupt = '1') then 
                            require_update_flaq <= require_update_flaq;
                        else
                            require_update_flaq <= '0';
                        end if;
                    else
                        require_update_flaq <= require_update_flaq;
                    end if;

                when others =>  
                    require_update_flaq <= require_update_flaq;

            end case; -- data_format_range_field
        end if;
    end process;



    timer_processing : process(CLK)
    begin 
        if CLK'event AND CLK = '1' then  
            if (timer = (CLK_PERIOD-1)) then 
                timer <= (others => '0');
            else
                timer <= timer + 1;
            end if;
        end if;
    end process;



    read_valid_counter_processing  : process(CLK)
    begin 
        if CLK'event AND CLK = '1' then 
            if (timer = (CLK_PERIOD-1)) then 
                read_valid_counter <= (others => '0');
            else
                if (S_AXIS_TVALID = '1' and s_axis_tready_signal <= '1') then  
                    read_valid_counter <= read_valid_counter + 1;
                else
                    read_valid_counter <= read_valid_counter;
                end if;
            end if;
        end if;
    end process;



    READ_VALID_COUNT_processing : process(CLK)
    begin 
        if CLK'event AND CLK = '1' then  
            if (timer = (CLK_PERIOD-1)) then 
                if (S_AXIS_TVALID = '1' and s_axis_tready_signal <= '1') then 
                    read_valid_count_reg <= read_valid_counter + 1;
                else
                    read_valid_count_reg <= read_valid_counter;
                end if; 
            else
                read_valid_count_reg <= read_valid_count_reg;
            end if; 
        end if;
    end process;



    write_valid_counter_processing : process(CLK)
    begin 
        if CLK'event AND CLK = '1' then 
            if (timer = (CLK_PERIOD-1)) then 
                write_valid_counter <= (others => '0');
            else
                if (out_wren = '1') then  
                    write_valid_counter <= write_valid_counter + 1;
                else
                    write_valid_counter <= write_valid_counter;
                end if;
            end if;
        end if;
    end process;



    WRITE_VALID_COUNT_processing : process(CLK)
    begin 
        if CLK'event AND CLK = '1' then 
            if (timer = (CLK_PERIOD-1)) then 
                if (out_wren = '1') then  
                    write_valid_count_reg <= write_valid_counter + 1;
                else
                    write_valid_count_reg <= write_valid_counter;
                end if; 
            else
                write_valid_count_reg <= write_valid_count_reg;
            end if; 
        end if;
    end process;


    WRITE_TRANSACTIONS_processing : process(CLK)
    begin 
        if CLK'event AND CLK = '1' then  
            if RESET = '1' then 
                write_transactions_reg <= (others => '0');
            else
                if (out_wren = '1' and out_din_last = '1') then  
                    write_transactions_reg <= write_transactions_reg + 1;
                else
                    write_transactions_reg <= write_transactions_reg;
                end if; 
            end if;
        end if;
    end process; 



    READ_TRANSACTIONS_processing : process(CLK)
    begin 
        if CLK'event AND CLK = '1' then  
            if RESET = '1' then 
                read_transactions_reg <= (others => '0');
            else
                if (S_AXIS_TVALID = '1' and s_axis_tready_signal <= '1' and S_AXIS_TLAST = '1') then 
                    read_transactions_reg <= read_transactions_reg + 1;
                else
                    read_transactions_reg <= read_transactions_reg;
                end if;
            end if;
        end if;
    end process;



    ON_WORK_processing : process(CLK)
    begin  
        if CLK'event AND CLK = '1' then 
            if RESET = '1' then 
                on_work_reg <= '0';
            else
                case (current_state) is
                    
                    when IDLE_CHK_REQ_ST => 
                        on_work_reg <= '0';
                    
                    when IDLE_CHK_UPD_ST => 
                        on_work_reg <= '0';

                    when others =>  
                        on_work_reg <= '1';
     
                end case; -- data_format_range_field
            end if;
        end if;
    end process;





end Behavioral;
