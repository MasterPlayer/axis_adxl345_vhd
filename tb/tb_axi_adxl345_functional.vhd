library IEEE;
    use IEEE.STD_LOGIC_1164.ALL;
    use ieee.std_logic_unsigned.all;
    use ieee.std_logic_arith.all;

entity tb_axi_adxl345_functional is
end tb_axi_adxl345_functional;



architecture Behavioral of tb_axi_adxl345_functional is


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


    signal  CLK                                 :           std_logic                        := '0'                             ;
    signal  RESET                               :           std_logic                        := '0'                             ;
    signal  WDATA                               :           std_logic_vector ( 31 downto 0 ) := (others => '0')                 ;
    signal  WSTRB                               :           std_logic_vector (  3 downto 0 ) := (others => '0')                 ;
    signal  WADDR                               :           std_logic_vector (  3 downto 0 ) := (others => '0')                 ;
    signal  WVALID                              :           std_logic                        := '0'                             ;
    signal  RADDR                               :           std_logic_vector (  3 downto 0 ) := (others => '0')                 ;
    signal  RDATA                               :           std_logic_vector ( 31 downto 0 )                                    ;
    signal  I2C_ADDRESS                         :           std_logic_vector (  6 downto 0 ) := (others => '0')                 ;
    signal  ENABLE_INTERVAL_REQUESTION          :           std_logic                        := '0'                             ;
    signal  REQUESTION_INTERVAL                 :           std_logic_vector ( 31 downto 0 ) := (others => '0')                 ;
    signal  SINGLE_REQUEST                      :           std_logic                        := '0'                             ;
    signal  SINGLE_REQUEST_ADDRESS              :           std_logic_vector (  7 downto 0 ) := (others => '0')                 ;
    signal  SINGLE_REQUEST_SIZE                 :           std_logic_vector (  7 downto 0 ) := (others => '0')                 ;
    signal  SINGLE_REQUEST_COMPLETE             :           std_logic                                                           ;
    signal  ALLOW_IRQ                           :           std_logic                        := '0'                             ;
    signal  LINK_ON                             :           std_logic                                                           ;
    signal  ADXL_INTERRUPT                      :           std_logic                        := '0'                             ;
    signal  ADXL_IRQ                            :           std_logic                                                           ;
    signal  ADXL_IRQ_ACK                        :           std_logic                        := '0'                             ;
    signal  READ_VALID_COUNT                    :           std_logic_vector ( 31 downto 0 )                                    ;
    signal  WRITE_VALID_COUNT                   :           std_logic_vector ( 31 downto 0 )                                    ;
    signal  WRITE_TRANSACTIONS                  :           std_logic_vector ( 63 downto 0 )                                    ;
    signal  READ_TRANSACTIONS                   :           std_logic_vector ( 63 downto 0 )                                    ;
    signal  ON_WORK                             :           std_logic                                                           ;
    signal  M_AXIS_TDATA                        :           std_logic_vector (  7 downto 0 )                                    ;
    signal  M_AXIS_TKEEP                        :           std_logic_vector (  0 downto 0 )                                    ;
    signal  M_AXIS_TUSER                        :           std_logic_vector (  7 downto 0 )                                    ;
    signal  M_AXIS_TVALID                       :           std_logic                                                           ;
    signal  M_AXIS_TLAST                        :           std_logic                                                           ;
    signal  M_AXIS_TREADY                       :           std_logic                        := '0'                             ;
    signal  S_AXIS_TDATA                        :           std_logic_vector (  7 downto 0 ) := (others => '0')                 ;
    signal  S_AXIS_TKEEP                        :           std_logic_vector (  0 downto 0 ) := (others => '0')                 ;
    signal  S_AXIS_TUSER                        :           std_logic_vector (  7 downto 0 ) := (others => '0')                 ;
    signal  S_AXIS_TVALID                       :           std_logic                        := '0'                             ;
    signal  S_AXIS_TLAST                        :           std_logic                        := '0'                             ;
    signal  S_AXIS_TREADY                       :           std_logic                                                           ;

    signal  i : integer := 0;



begin

    CLK <= not CLK after 5 ns;

    i_processing : process(CLK)
    begin 
        if CLK'event AND CLK = '1' then 
            i <= i + 1;
        end if;
    end process;

    RESET <= '1' when i < 100 else '0';

    I2C_ADDRESS <= "1010011";

    axi_adxl345_functional_inst : axi_adxl345_functional
        generic map (
            CLK_PERIOD                          =>  100000000                                    
        )
        port map (
            CLK                                 =>  CLK                                         ,
            RESET                               =>  RESET                                       ,

            WDATA                               =>  WDATA                                       ,
            WSTRB                               =>  WSTRB                                       ,
            WADDR                               =>  WADDR                                       ,
            WVALID                              =>  WVALID                                      ,
            
            RADDR                               =>  RADDR                                       ,
            RDATA                               =>  RDATA                                       ,
            
            I2C_ADDRESS                         =>  I2C_ADDRESS                                 ,

            ENABLE_INTERVAL_REQUESTION          =>  ENABLE_INTERVAL_REQUESTION                  ,
            REQUESTION_INTERVAL                 =>  REQUESTION_INTERVAL                         ,
            
            SINGLE_REQUEST                      =>  SINGLE_REQUEST                              ,
            SINGLE_REQUEST_ADDRESS              =>  SINGLE_REQUEST_ADDRESS                      ,
            SINGLE_REQUEST_SIZE                 =>  SINGLE_REQUEST_SIZE                         ,
            SINGLE_REQUEST_COMPLETE             =>  SINGLE_REQUEST_COMPLETE                     ,

            ALLOW_IRQ                           =>  ALLOW_IRQ                                   ,
            LINK_ON                             =>  LINK_ON                                     ,
            ADXL_INTERRUPT                      =>  ADXL_INTERRUPT                              ,
            ADXL_IRQ                            =>  ADXL_IRQ                                    ,
            ADXL_IRQ_ACK                        =>  ADXL_IRQ_ACK                                ,

            READ_VALID_COUNT                    =>  READ_VALID_COUNT                            ,
            WRITE_VALID_COUNT                   =>  WRITE_VALID_COUNT                           ,

            WRITE_TRANSACTIONS                  =>  WRITE_TRANSACTIONS                          ,
            READ_TRANSACTIONS                   =>  READ_TRANSACTIONS                           ,

            ON_WORK                             =>  ON_WORK                                     ,
            -- data to device
            M_AXIS_TDATA                        =>  M_AXIS_TDATA                                ,
            M_AXIS_TKEEP                        =>  M_AXIS_TKEEP                                ,
            M_AXIS_TUSER                        =>  M_AXIS_TUSER                                ,
            M_AXIS_TVALID                       =>  M_AXIS_TVALID                               ,
            M_AXIS_TLAST                        =>  M_AXIS_TLAST                                ,
            M_AXIS_TREADY                       =>  M_AXIS_TREADY                               ,
            -- data from device
            S_AXIS_TDATA                        =>  S_AXIS_TDATA                                ,
            S_AXIS_TKEEP                        =>  S_AXIS_TKEEP                                ,
            S_AXIS_TUSER                        =>  S_AXIS_TUSER                                ,
            S_AXIS_TVALID                       =>  S_AXIS_TVALID                               ,
            S_AXIS_TLAST                        =>  S_AXIS_TLAST                                ,
            S_AXIS_TREADY                       =>  S_AXIS_TREADY                                
        );

    M_AXIS_TREADY <= '1';

    interval_requestion_processing : process(CLK)
    begin 
        if CLK'event AND CLK = '1' then 
            case i is 
                -- Имитация работы опроса регистрового пространства датчика по таймеру
                when 1000   => ENABLE_INTERVAL_REQUESTION <= '1'; REQUESTION_INTERVAL <= x"00001000";
                when 2000   => ENABLE_INTERVAL_REQUESTION <= '0'; REQUESTION_INTERVAL <= x"00000000";

                when others => ENABLE_INTERVAL_REQUESTION <= ENABLE_INTERVAL_REQUESTION; REQUESTION_INTERVAL <= REQUESTION_INTERVAL;
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
                when 4000   => S_AXIS_TDATA <= x"E5"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"0"
                when 4001   => S_AXIS_TDATA <= x"01"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"0"
                when 4002   => S_AXIS_TDATA <= x"02"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"0"
                when 4003   => S_AXIS_TDATA <= x"03"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"0"
                when 4004   => S_AXIS_TDATA <= x"04"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"1"
                when 4005   => S_AXIS_TDATA <= x"05"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"1"
                when 4006   => S_AXIS_TDATA <= x"06"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"1"
                when 4007   => S_AXIS_TDATA <= x"07"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"1"
                when 4008   => S_AXIS_TDATA <= x"08"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"2"
                when 4009   => S_AXIS_TDATA <= x"09"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"2"
                when 4010   => S_AXIS_TDATA <= x"0A"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"2"
                when 4011   => S_AXIS_TDATA <= x"0B"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"2"
                when 4012   => S_AXIS_TDATA <= x"0C"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"3"
                when 4013   => S_AXIS_TDATA <= x"0D"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"3"
                when 4014   => S_AXIS_TDATA <= x"0E"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"3"
                when 4015   => S_AXIS_TDATA <= x"0F"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"3"
                when 4016   => S_AXIS_TDATA <= x"10"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"4"
                when 4017   => S_AXIS_TDATA <= x"11"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"4"
                when 4018   => S_AXIS_TDATA <= x"12"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"4"
                when 4019   => S_AXIS_TDATA <= x"13"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"4"
                when 4020   => S_AXIS_TDATA <= x"14"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"5"
                when 4021   => S_AXIS_TDATA <= x"15"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"5"
                when 4022   => S_AXIS_TDATA <= x"16"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"5"
                when 4023   => S_AXIS_TDATA <= x"17"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"5"
                when 4024   => S_AXIS_TDATA <= x"18"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"6"
                when 4025   => S_AXIS_TDATA <= x"19"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"6"
                when 4026   => S_AXIS_TDATA <= x"1A"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"6"
                when 4027   => S_AXIS_TDATA <= x"1B"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"6"
                when 4028   => S_AXIS_TDATA <= x"1C"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"7"
                when 4029   => S_AXIS_TDATA <= x"1D"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"7"
                when 4030   => S_AXIS_TDATA <= x"1E"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"7"
                when 4031   => S_AXIS_TDATA <= x"1F"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"7"
                when 4032   => S_AXIS_TDATA <= x"20"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"8"
                when 4033   => S_AXIS_TDATA <= x"21"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"8"
                when 4034   => S_AXIS_TDATA <= x"22"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"8"
                when 4035   => S_AXIS_TDATA <= x"23"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"8"
                when 4036   => S_AXIS_TDATA <= x"24"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"9"
                when 4037   => S_AXIS_TDATA <= x"25"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"9"
                when 4038   => S_AXIS_TDATA <= x"26"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"9"
                when 4039   => S_AXIS_TDATA <= x"27"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"9"
                when 4040   => S_AXIS_TDATA <= x"28"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"A"
                when 4041   => S_AXIS_TDATA <= x"29"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"A"
                when 4042   => S_AXIS_TDATA <= x"2A"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"A"
                when 4043   => S_AXIS_TDATA <= x"2B"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"A"
                when 4044   => S_AXIS_TDATA <= x"00"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"B" -- THIS PLACE
                when 4045   => S_AXIS_TDATA <= x"01"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"B" -- THIS PLACE
                when 4046   => S_AXIS_TDATA <= x"2E"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"B"
                when 4047   => S_AXIS_TDATA <= x"2F"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"B"
                when 4048   => S_AXIS_TDATA <= x"30"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"C"
                when 4049   => S_AXIS_TDATA <= x"31"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"C"
                when 4050   => S_AXIS_TDATA <= x"32"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"C"
                when 4051   => S_AXIS_TDATA <= x"33"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"C"
                when 4052   => S_AXIS_TDATA <= x"34"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"d"
                when 4053   => S_AXIS_TDATA <= x"35"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"d"
                when 4054   => S_AXIS_TDATA <= x"36"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"d"
                when 4055   => S_AXIS_TDATA <= x"37"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0'; -- WADDR = x"d"
                when 4056   => S_AXIS_TDATA <= x"38"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0';
                when 4057   => S_AXIS_TDATA <= x"39"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '1';
                when others => S_AXIS_TDATA <= S_AXIS_TDATA; S_AXIS_TKEEP <= S_AXIS_TKEEP; S_AXIS_TUSER <= S_AXIS_TUSER; S_AXIS_TVALID <= '0'; S_AXIS_TLAST <= S_AXIS_TLAST; 
            end case;
        end if;
    end process;


    -- Имитация отправки каких-либо данных на устройство - интерфейс W*
    W_processing : process(CLK)
    begin 
        if CLK'event AND CLK = '1' then 
            case i is 
                when 3000   => WDATA <= x"03020100"; WSTRB <= x"3"; WADDR <= x"B"; WVALID <= '1';
                --when 3001   => WDATA <= x"03020100"; WSTRB <= x"2"; WADDR <= x"B"; WVALID <= '1';
                when others => WDATA <= WDATA; WSTRB <= WSTRB; WADDR <= WADDR; WVALID <= '0';
            end case;
        end if;
    end process;


    R_processing : process(CLK)
    begin 
        if CLK'event aND CLK = '1' then 
            case (i) is 
                when 5000 => RADDR <= x"B"; 
                when others => RADDR <= x"0"; 
            end case;
        end if;
    end process;


    ALLOW_IRQ <= '1' when i > 10000 else '0';


    ADXL_INTERRUPT_processing : process(CLK)
    begin 
        if CLK'event AND CLK = '1' then 
            case i is 
                when 11000  => ADXL_INTERRUPT <= '1';
                when others => ADXL_INTERRUPT <= ADXL_INTERRUPT;
            end case;
        end if;
    end process;



end Behavioral;
