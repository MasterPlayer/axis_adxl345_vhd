library IEEE;
    use IEEE.STD_LOGIC_1164.ALL;
    use ieee.std_logic_unsigned.all;
    use ieee.std_logic_arith.all;

library UNISIM;
    use UNISIM.VComponents.all;


entity axis_iic_master_controller is
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
end axis_iic_master_controller;



architecture axis_iic_master_controller_arch of axis_iic_master_controller is

    constant CLK_DURATION                   :           integer                         := (CLK_FREQUENCY/CLK_IIC_FREQUENCY)    ;
    constant CLK_DURATION_DIV2              :           integer                         := ((CLK_DURATION/2)-1)                 ;
    constant CLK_DURATION_DIV4              :           integer                         := (CLK_DURATION/4)                     ;

    -- Основной сччетчик . Предел его счета - CLK_DURATION, которая получается из отношения частоты тактирования к частоте I2C
    signal  clk_duration_counter            :           std_Logic_Vector ( 7 downto 0 ) := (others => '0')                      ;
    -- Этот счетчик должен считать когда основной счетчик достигает 1/4 своего значения
    signal  clk_duration_counter_shifted    :           std_logic_Vector ( 7 downto 0 ) := (others => '0')                      ; 
    -- Разрешение счета для смещенного(shifted) Счетчика
    signal  allow_counting                  :           std_logic                       := '0'                                  ;

    -- По данному флагу происходят все события на шине SDA, чтение очередей, работа конечного автомата.
    signal  has_event                       :           std_logic                       := '0'                                  ;
    signal  clk_assert                      :           std_logic                       := '0'                                  ;
    signal  clk_deassert                    :           std_logic                       := '0'                                  ;


    type fsm is ( -- Конечный автомат - Finite State Machine
        IDLE_ST                             , -- Состояние когда ничего не делаем, и ничего не передается не принимается
        TX_START_ST                         , -- Состояние передачи START
        TX_ADDR_ST                          , -- Состояние передачи адреса + операции которую выполняем
        WAIT_ACK_ST                         , -- Ожидание от устройства сигнала ACK
        FLUSH_ST                            , -- Состояние отчистки очереди, в случае, если устройства с искомым адресом нет
        WRITE_ST                            , 
        WRITE_WAIT_ACK_ST                   , -- состояние ожидания ответа ACK после передачи данных на устройство
        READ_ST                             ,
        READ_WAIT_ACK_ST                    , -- состояние, когда мы передаем ACK или NACK. 
        TX_STOP_ST                          , -- состояние передачи STOP-последовательности
        STUB_ST                               -- Состояние тестовое, когда ничего не делаем(его надо будет убрать)
    ); 

    signal current_state                    :           fsm                             := IDLE_ST                              ;


    component fifo_in_sync_xpm_dest
        generic(
            DATA_WIDTH                      :           integer                         :=  16                                  ;
            DEST_WIDTH                      :           integer                         :=  1                                   ;
            MEMTYPE                         :           String                          :=  "block"                             ;
            DEPTH                           :           integer                         :=  16                                  
        );
        port(
            CLK                             :   in      std_logic                                                               ;
            RESET                           :   in      std_logic                                                               ;
            
            S_AXIS_TDATA                    :   in      std_logic_vector ( DATA_WIDTH-1 downto 0 )                              ;
            S_AXIS_TKEEP                    :   in      std_logic_vector (( DATA_WIDTH/8)-1 downto 0 )                          ;
            S_AXIS_TDEST                    :   in      std_logic_vector ( DEST_WIDTH-1 downto 0 )                              ;
            S_AXIS_TVALID                   :   in      std_logic                                                               ;
            S_AXIS_TLAST                    :   in      std_logic                                                               ;
            S_AXIS_TREADY                   :   out     std_logic                                                               ;

            IN_DOUT_DATA                    :   out     std_logic_vector ( DATA_WIDTH-1 downto 0 )                              ;
            IN_DOUT_KEEP                    :   out     std_logic_vector ( ( DATA_WIDTH/8)-1 downto 0 )                         ;
            IN_DOUT_DEST                    :   out     std_logic_vector ( DEST_WIDTH-1 downto 0 )                              ;
            IN_DOUT_LAST                    :   out     std_logic                                                               ;
            IN_RDEN                         :   in      std_logic                                                               ;
            IN_EMPTY                        :   out     std_logic                                                                
        );
    end component;

    signal  s_axis_tready_signal            :           std_logic                                                               ;

    signal  in_dout_data                    :           std_logic_vector ( 7 downto 0 )                                         ;
    signal  in_dout_data_shift              :           std_logic_vector ( 7 downto 0 )                                         ; -- Сдвиговый регистр для передачи данных на устройство. Двигать будем влево на 1 бит в состоянии WRITE_ST 
    signal  in_dout_dest                    :           std_logic_vector ( 7 downto 0 )                                         ;
    signal  in_dout_last                    :           std_logic                                                               ;
    signal  in_rden                         :           std_logic                       := '0'                                  ;
    signal  in_empty                        :           std_logic                                                               ;


    -- Очередь запросов
    -- При необходимости от нее можно избавиться 
    component fifo_cmd_sync_xpm 
        generic(
            DATA_WIDTH      :           integer         :=  64                          ;
            MEMTYPE         :           String          :=  "block"                     ;
            DEPTH           :           integer         :=  16                           
        );
        port(
            CLK             :   in      std_logic                                       ;
            RESET           :   in      std_logic                                       ;
            
            DIN             :   in      std_logic_vector ( DATA_WIDTH-1 downto 0 )      ;
            WREN            :   in      std_logic                                       ;
            FULL            :   out     std_logic                                       ;
            DOUT            :   out     std_logic_Vector ( DATA_WIDTH-1 downto 0 )      ;
            RDEN            :   IN      std_logic                                       ;
            EMPTY           :   out     std_logic                                        

        );
    end component;


    signal  cmd_wren        :           std_logic                                       ;
    signal  cmd_full        :           std_logic                                       ;

    signal  cmd_rden        :           std_logic                                       ;
    signal  cmd_empty       :           std_logic                                       ;



    signal  scl_t_reg                       :           std_logic                       := '1'                                  ; -- сигнал тактирования шины I2C
    signal  sda_t_reg                       :           std_logic                       := '1'                                  ; -- Сигнал данных шины I2C

    -- задержанный на 1 такт сигнал SCL_I
    signal  d_scl_i                         :           std_logic                       := '0'                                  ;
    -- Флаг события от SCL_I (изменение с нуля в единицу от устройства) 
    signal  scl_i_event                     :           std_logic                       := '0'                                  ;


    -- Регистр, который хранит извлеченное из очереди первое слово. 
    signal  size_limit                      :           std_logic_vector ( 7 downto 0 ) := (others => '0')                      ;
    signal  size_counter                    :           std_logic_vector ( 7 downto 0 ) := (others => '0')                      ;
    -- Сохраненный адрес устройства - нужен для того чтобы избежать ошибки + при чтеннии знать кому отправлять данные
    signal  address                         :           std_logic_vector ( 7 downto 0 ) := (others => '0')                      ;
    signal  has_read_operation              :           std_logic                       := '0'                                  ;
    signal  iic_address                     :           std_logic_vector ( 7 downto 0 ) := (others => '0')                      ;

    signal  bit_counter                     :           std_logic_vector ( 2 downto 0 ) := (others => '0')                      ;

    signal  has_ack_from_device             :           std_logic                       := '0'                                  ;
    signal  has_last_word_readed            :           std_logic                       := '0'                                  ;
    signal  has_nack                        :           std_logic                       := '0'                                  ;



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

    signal  out_din_data    :           std_logic_Vector ( 7 downto 0 ) := (others => '0')      ;
    signal  out_din_dest    :           std_logic_Vector ( 7 downto 0 ) := (others => '0')      ;
    signal  out_din_last    :           std_logic                       := '0'                  ;
    signal  out_wren        :           std_logic                       := '0'                  ;
    signal  out_full        :           std_logic                                               ;
    signal  out_awfull      :           std_logic                                               ;




begin



    SCL_T <= scl_t_reg;
    SDA_T <= sda_t_reg;

    S_AXIS_TREADY <= s_axis_tready_signal;


    clk_duration_counter_processing : process(CLK)
    begin 
        if CLK'event AND CLK = '1' then 
            if (clk_duration_counter < (CLK_DURATION-1)) then 
                clk_duration_counter <= clk_duration_counter + 1;
            else
                clk_duration_counter <= (others => '0');
            end if;
        end if;
    end process;



    allow_counting_processing  : process(CLK)
    begin 
        if CLK'event AND CLK = '1' then 
            if (clk_duration_counter = (CLK_DURATION_DIV4-1)) then 
                allow_counting <= '1';
            end if;
        end if;
    end process;



    clk_duration_counter_shifted_processing : process(CLK)
    begin 
        if CLK'event AND CLK = '1' then 
            if (allow_counting = '1') then 
                if (clk_duration_counter_shifted < (CLK_DURATION-1)) then 
                    clk_duration_counter_shifted <= clk_duration_counter_shifted + 1;
                else
                    clk_duration_counter_shifted <= (others => '0');
                end if;

            end if;
        end if;
    end process;



    has_event_processing : process(CLK)
    begin 
        if CLK'event AND CLK = '1' then 
            if (clk_duration_counter = (CLK_DURATION-1)) then 
                has_event <= '1';
            else
                has_event <= '0';
            end if;
        end if;
    end process;



    clk_assert_processing : process(CLK)
    begin 
        if CLK'event AND CLK = '1' then 
            if (clk_duration_counter_shifted = (CLK_DURATION-1)) then 
                clk_assert <= '1';
            else
                clk_assert <= '0';  
            end if;
        end if;
    end process;



    clk_deassert_processing : process(CLK)
    begin 
        if CLK'event AND CLK = '1' then 
            if (clk_duration_counter_shifted = CLK_DURATION_DIV2) then 
                clk_deassert <= '1';
            else
                clk_deassert <= '0';
            end if;
        end if;
    end process;



    current_state_processing : process(CLK)
    begin 
        if CLK'event AND CLK = '1' then  
            if (RESET = '1') then 
                current_state <= IDLE_ST;
            else
                if (has_event = '1') then 
                    case (current_state) is 
                        when IDLE_ST => 
                            --if (in_empty = '0') then 
                             if (cmd_empty = '0') then 
                                current_state <= TX_START_ST;
                            else 
                                current_state <= current_state;
                            end if;

                        when TX_START_ST => 
                            current_state <= TX_ADDR_ST;

                        when TX_ADDR_ST => 
                            if (bit_counter = 7) then 
                                current_state <= WAIT_ACK_ST;
                            else
                                current_state <= current_state;
                            end if;

                        when WAIT_ACK_ST => 
                            if (has_ack_from_device = '1') then 
                                if (has_read_operation = '1') then 
                                    current_state <= READ_ST;
                                else
                                    current_state <= WRITE_ST;
                                end if;
                            else
                                current_state <= FLUSH_ST;
                            end if;

                        when WRITE_ST => 
                            if (bit_counter = 7) then 
                                current_state <= WRITE_WAIT_ACK_ST;
                            else
                                current_state <= current_state;
                            end if;

                        when WRITE_WAIT_ACK_ST => 
                            if (has_ack_from_device = '1') then 
                                if (size_counter = size_limit) then 
                                    current_state <= TX_STOP_ST;
                                else
                                    current_state <= WRITE_ST;
                                end if;
                            else
                                current_state <= current_state;
                            end if;

                        when FLUSH_ST => 
                            if (has_last_word_readed = '1') then 
                                current_state <= IDLE_ST;
                            else
                                current_state <= current_state;
                            end if;


                        when READ_ST => 
                            if (bit_counter = 7) then 
                                current_state <= READ_WAIT_ACK_ST;
                            else
                                current_state <= current_state;
                            end if;

                        when READ_WAIT_ACK_ST => 
                            if (size_counter = size_limit) then 
                                current_state <= TX_STOP_ST;
                            else
                                current_state <= READ_ST;
                            end if;

                        when TX_STOP_ST =>
                            current_state <= IDLE_ST;

                        when others => 
                            current_state <= current_state;

                    end case;
                else
                    current_state <= current_state;
                end if;
            end if;
        end if;
    end process;



    has_ack_from_device_processing : process(CLK)
    begin 
        if CLK'event and clk = '1' then 
            case (current_state) is 
                when WAIT_ACK_ST | WRITE_WAIT_ACK_ST => 
                    if (clk_assert = '1') then 
                        if (SDA_I = '0') then 
                            has_ack_from_device <= '1';
                        else
                            has_ack_from_device <= '0';
                        end if;
                    else
                        has_ack_from_device <= has_ack_from_device;
                    end if;

                when others => 
                    has_ack_from_device <= '0';

            end case;
        end if;
    end process;



    scl_t_reg_processing : process(CLK)
    begin 
        if CLK'event AND CLK = '1' then 
            case (current_state) is 
                when TX_START_ST => 
                    if (clk_assert = '1') then 
                        scl_t_reg <= '0';
                    else
                        scl_t_reg <= scl_t_reg;
                    end if;

                when TX_ADDR_ST | WAIT_ACK_ST | WRITE_ST | WRITE_WAIT_ACK_ST => 
                    if (clk_assert = '1') then 
                        scl_t_reg <= '1';
                    else
                        if clk_deassert = '1' then 
                            scl_t_reg <= '0';
                        else
                            scl_t_reg <= scl_t_reg;
                        end if;
                    end if;

                when FLUSH_ST => 
                    if (clk_assert = '1') then 
                        scl_t_reg <= '1';
                    else
                        scl_t_reg <= scl_t_reg;
                    end if; 

                when TX_STOP_ST => 
                    if (clk_assert = '1') then 
                        scl_t_reg <= '1';
                    else
                        scl_t_reg <= scl_t_reg;
                    end if; 

                when READ_ST => 
                    if (clk_assert = '1') then 
                        scl_t_reg <= '1';
                    else
                        if clk_deassert = '1' then 
                            scl_t_reg <= '0';
                        else
                            scl_t_reg <= scl_t_reg;
                        end if;
                    end if;

                when READ_WAIT_ACK_ST => 
                    if (clk_assert = '1') then 
                        scl_t_reg <= '1';
                    else
                        if clk_deassert = '1' then 
                            scl_t_reg <= '0';
                        else
                            scl_t_reg <= scl_t_reg;
                        end if;
                    end if;


                when others => 
                    scl_t_reg <= scl_t_reg;

            end case;
        end if;
    end process;



    sda_t_reg_processing : process(CLK)
    begin 
        if CLK'event AND CLK = '1' then 
            if (has_event = '1') then 
                case (current_state) is 
                    when IDLE_ST => 
                        --if (in_empty = '0') then 
                         if (cmd_empty = '0') then 
                            sda_t_reg <= '0';
                        else
                            sda_t_reg <= sda_t_reg;
                        end if;

                    when TX_START_ST => 
                        sda_t_reg <= iic_address(7);

                    when TX_ADDR_ST => 
                        if (bit_counter = 7) then 
                            sda_t_reg <= '1';
                        else
                            sda_t_reg <= iic_address(7);
                        end if;

                    when WAIT_ACK_ST => 
                        if (has_read_operation = '0') then 
                            sda_t_reg <= in_dout_data_shift(7);
                        else
                            sda_t_reg <= '1';
                        end if;

                    when WRITE_ST => 
                        if (bit_counter = 7) then 
                            sda_t_reg <= '1';
                        else
                            sda_t_reg <= in_dout_data_shift(7);
                        end if;

                    when WRITE_WAIT_ACK_ST => 
                        sda_t_reg <= in_dout_data_shift(7);

                    when FLUSH_ST => 
                        sda_t_reg <= '1';

                    when TX_STOP_ST => 
                        sda_t_reg <= '1';

                    when READ_ST => 
                        if (bit_counter = 7) then 
                            if (has_nack = '1') then 
                                sda_t_reg <= '1';
                            else
                                sda_t_reg <= '0';
                            end if;
                        else
                            sda_t_reg <= '1';
                        end if;

                    when READ_WAIT_ACK_ST => 
                        if (size_counter = size_limit) then 
                            sda_t_reg <= '0';
                        else
                            sda_t_reg <= '1';
                        end if;

                    when others => 
                        sda_t_reg <= sda_t_reg;

                end case;

            else
                sda_t_reg <= sda_t_reg;
            end if;

        end if;
    end process;


    d_scl_i_processing : process(CLK)
    begin 
        if CLK'event AND CLK = '1' then 
            d_scl_i <= SCL_I;
        end if;
    end process;

    scl_i_event_processing : process(CLK)
    begin 
        if CLK'event aND CLK = '1' then 
            if (SCL_I = '1' and d_scl_i = '0') then 
                scl_i_event <= '1';
            else
                scl_i_event <= '0';
            end if;
        end if;
    end process;


    size_limit_processing : process(CLK)
    begin 
        if CLK'event AND CLK = '1' then 
            if (has_event = '1') then 
                case (current_state) is 
                    when IDLE_ST => 
                        --if (in_empty = '0') then 
                         if (cmd_empty = '0') then 
                            size_limit <= in_dout_data;
                        else
                            size_limit <= size_limit;
                        end if;

                    when others => 
                        size_limit <= size_limit;

                end case;
            else
                size_limit <= size_limit;
            end if;
        end if;
    end process;

    size_counter_processing : process(CLK)
    begin 
        if CLK'event AND CLK = '1' then 
            if (has_event = '1') then 
                case (current_state) is
                    when IDLE_ST => 
                        size_counter <= (others => '0');

                    when WAIT_ACK_ST => 
                        size_counter <= size_counter + 1;

                    when WRITE_WAIT_ACK_ST => 
                        size_counter <= size_counter + 1;

                    when READ_WAIT_ACK_ST => 
                        size_counter <= size_counter + 1;

                    when others => 
                        size_counter <= size_counter;
                end case;
            else
                size_counter <= size_counter;
            end if;
        end if;
    end process;

    has_nack_processing : process(CLK)
    begin
        if CLK'event AND CLK = '1' then 
            if size_counter = size_limit then 
                has_nack <= '1';
            else
                has_nack <= '0';
            end if;
        end if;
    end process;

    address_processing : process(CLK)
    begin 
        if CLK'event AND CLK = '1' then 
            if (has_event = '1') then 
                case (current_state) is 
                    when IDLE_ST => 
                        --if (in_empty = '0') then 
                         if (cmd_empty = '0') then 
                            address <= in_dout_dest;
                        else
                            address <= address;
                        end if;

                    when others => 
                        address <= address;

                end case;
            else
                address <= address;
            end if;
        end if;
    end process;



    has_read_operation <= address(0);



    iic_address_processing : process(CLK)
    begin 
        if CLK'event AND CLK = '1' then 
            if (has_event = '1') then 
                case (current_state) is 
                    when IDLE_ST => 
                        --if (in_empty = '0') then 
                        if (cmd_empty = '0') then 
                            iic_address <= in_dout_dest;
                        else
                            iic_address <= iic_address;
                        end if;

                    when TX_START_ST =>
                        iic_address <= iic_address(6 downto 0) & '0';

                    when TX_ADDR_ST => 
                        iic_address <= iic_address(6 downto 0) & '0';

                    when others => 
                        iic_address <= iic_address;

                end case;
            else
                iic_address <= iic_address;
            end if;
        end if;
    end process;



    bit_counter_processing : process(CLK)
    begin 
        if CLK'event AND CLK = '1' then 
            if (has_event = '1') then 
                case (current_state) is 
                    
                    when TX_ADDR_ST => 
                        bit_counter <= bit_counter + 1;

                    when WRITE_ST => 
                        bit_counter <= bit_counter + 1;

                    when READ_ST => 
                        bit_counter <= bit_counter + 1;

                    when others => 
                        bit_counter <= (others => '0');

                end case;
            else
                bit_counter <= bit_counter;
            end if;
        end if;
    end process;



    fifo_in_sync_xpm_dest_inst : fifo_in_sync_xpm_dest
        generic map (
            DATA_WIDTH      =>  8                               ,
            DEST_WIDTH      =>  8                               ,
            MEMTYPE         =>  "block"                         ,
            DEPTH           =>  FIFO_DEPTH                       
        )
        port map (
            CLK             =>  CLK                             ,
            RESET           =>  RESET                           ,
            
            S_AXIS_TDATA    =>  S_AXIS_TDATA                    ,
            S_AXIS_TKEEP    =>  "1"                             ,
            S_AXIS_TDEST    =>  S_AXIS_TDEST                    ,
            S_AXIS_TVALID   =>  S_AXIS_TVALID                   ,
            S_AXIS_TLAST    =>  S_AXIS_TLAST                    ,
            S_AXIS_TREADY   =>  s_axis_tready_signal            ,

            IN_DOUT_DATA    =>  in_dout_data                    ,
            IN_DOUT_KEEP    =>  open                            ,
            IN_DOUT_DEST    =>  in_dout_dest                    ,
            IN_DOUT_LAST    =>  in_dout_last                    ,
            IN_RDEN         =>  in_rden                         ,
            IN_EMPTY        =>  in_empty                         
        );

    fifo_cmd_sync_xpm_inst : fifo_cmd_sync_xpm 
        generic map (
            DATA_WIDTH      =>  64                              ,
            MEMTYPE         =>  "block"                         ,
            DEPTH           =>  64                           
        )
        port map (
            CLK             =>  CLK                             ,
            RESET           =>  RESET                           ,
            DIN             =>  (others => '0')                 ,
            WREN            =>  cmd_wren                        ,
            FULL            =>  cmd_full                        ,
            DOUT            =>  open                            ,
            RDEN            =>  cmd_rden                        ,
            EMPTY           =>  cmd_empty                        
        );


    cmd_wren_processing : process(CLK)
    begin 
        if CLK'event AND CLK = '1' then 
            if (S_AXIS_TVALID = '1' AND S_AXIS_TLAST = '1' AND s_axis_tready_signal = '1') then 
                cmd_wren <= '1';
            else
                cmd_wren <= '0';
            end if;
        end if;
    end process;

    cmd_rden_processing : process(CLK)
    begin 
        if CLK'event AND CLK = '1' then 
            if (has_event = '1') then 
                case (current_state) is 
                    when IDLE_ST => 
                        if (cmd_empty = '0') then 
                            cmd_rden <= '1';
                        else
                            cmd_rden <= '0';
                        end if;

                    when others => 
                        cmd_rden <= '0';
                end case;
            else
                cmd_rden <= '0';
            end if;
        end if;
    end process;



    in_rden_processing : process(CLK)
    begin 
        if CLK'event AND CLK = '1' then 
            if (has_event = '1') then 
                case (current_state) is 
                    when IDLE_ST => 
                        if (cmd_empty = '0') then 
                        --if (in_empty = '0') then 
                            in_rden <= '1';
                        else
                            in_rden <= '0';
                        end if;

                    when FLUSH_ST => 
                        if (has_last_word_readed = '1') then 
                            in_rden <= '0';
                        else
                            in_rden <= '1';
                        end if; 

                    when TX_ADDR_ST => 
                        if (bit_counter = 7) then 
                            if (has_read_operation = '0') then 
                                in_rden <= '1';
                            else
                                in_rden <= '0';
                            end if;
                        else 
                            in_rden <= '0';
                        end if;

                    when WRITE_ST => 
                        if (bit_counter = 7) then 
                            if (size_counter = size_limit) then 
                                in_rden <= '0';
                            else
                                in_rden <= '1';
                            end if;
                        else
                            in_rden <= '0';
                        end if;

                    when others => 
                        in_rden <= '0';

                end case;
            else 
                in_rden <= '0';
            end if;
        end if;
    end process;



    in_dout_data_shift_processing : process(CLK)
    begin 
        if CLK'event and clk = '1' then 
            if (has_event = '1') then 
                case (current_state)  is
                    when TX_ADDR_ST => 
                        if (bit_counter = 7) then 
                            in_dout_data_shift <= in_dout_data;
                        else
                            in_dout_data_shift <= in_dout_data_shift;
                        end if;

                    when WAIT_ACK_ST => 
                        in_dout_data_shift(7 downto 1) <= in_dout_data_shift(6 downto 0);

                    when WRITE_ST => 
                        if (bit_counter = 7) then 
                            in_dout_data_shift <= in_dout_data;
                        else
                            in_dout_data_shift(7 downto 1) <= in_dout_data_shift(6 downto 0);
                        end if;

                    when WRITE_WAIT_ACK_ST => 
                        in_dout_data_shift(7 downto 1) <= in_dout_data_shift(6 downto 0);

                    when others => 
                        in_dout_data_shift <= in_dout_data_shift;
                end case;
            else
                in_dout_data_shift <= in_dout_data_shift;
            end if;
        end if;
    end process;



    has_last_word_readed_processing : process(CLK)
    begin 
        if CLK'event AND CLK = '1' then 
            if (in_rden = '1') then 
                if (in_dout_last = '1') then    
                    has_last_word_readed <= '1';
                else
                    has_last_word_readed <= '0';
                end if;
            else
                has_last_word_readed <= has_last_word_readed;
            end if;
        end if;
    end process;




    fifo_out_sync_xpm_dest_inst : fifo_out_sync_xpm_dest
        generic map (
            DATA_WIDTH      =>  8                               ,
            DEST_WIDTH      =>  8                               ,
            MEMTYPE         =>  "distributed"                   ,
            DEPTH           =>  FIFO_DEPTH                       
        )
        port map (
            CLK             =>  CLK                             ,
            RESET           =>  RESET                           ,
            
            OUT_DIN_DATA    =>  out_din_data                    ,
            OUT_DIN_KEEP    =>  (others => '0')                 ,
            OUT_DIN_DEST    =>  out_din_dest                    ,
            OUT_DIN_LAST    =>  out_din_last                    ,
            OUT_WREN        =>  out_wren                        ,
            OUT_FULL        =>  out_full                        ,
            OUT_AWFULL      =>  out_awfull                      ,
            
            M_AXIS_TDATA    =>  M_AXIS_TDATA                    ,
            M_AXIS_TKEEP    =>  open                            ,
            M_AXIS_TDEST    =>  M_AXIS_TDEST                    ,
            M_AXIS_TVALID   =>  M_AXIS_TVALID                   ,
            M_AXIS_TLAST    =>  M_AXIS_TLAST                    ,
            M_AXIS_TREADY   =>  M_AXIS_TREADY                    
        );

    out_din_dest <= address;

    out_din_data_processing : process(CLK)
    begin 
        if CLK'event AND CLK = '1' then 
            if (scl_i_event = '1') then 
                out_din_data <= out_din_data(6 downto 0) & SDA_I;
            else
                out_din_data <= out_din_data;
            end if;
        end if;
    end process;

    out_wren_processing : process(CLK)
    begin 
        if CLK'event AND CLK = '1' then 
            case (current_state) is 
                when READ_ST => 
                    if (scl_i_event = '1') then 
                        if (bit_counter = 7) then 
                            out_wren <= '1';
                        else
                            out_wren <= '0';
                        end if;
                    else
                        out_wren <= '0';
                    end if;

                when others => 
                    out_wren <= '0';

            end case;
        end if;
    end process;

    out_din_last_processing : process(CLK)
    begin 
        if CLK'event AND CLK = '1' then 
            case (current_state) is 

                when READ_ST => 
                    if (scl_i_event = '1') then 
                        if (size_counter = size_limit) then 
                            if (bit_counter = 7) then 
                                out_din_last <= '1';
                            else
                                out_din_last <= '0';
                            end if;
                        else
                            out_din_last <= '0';
                        end if;
                    else
                        out_din_last <= '0';
                    end if;

                when others => 
                    out_din_last <= '0';

            end case;
        end if;
    end process;


end axis_iic_master_controller_arch;
