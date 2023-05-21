library IEEE;
    use IEEE.STD_LOGIC_1164.ALL;



entity zturn_top is
    port(
        DDR_ADDR                    :   inout   std_logic_vector ( 14 downto 0 )            ;
        DDR_BA                      :   inout   std_logic_vector (  2 downto 0 )            ;
        DDR_CAS_N                   :   inout   std_logic                                   ;
        DDR_CK_N                    :   inout   std_logic                                   ;
        DDR_CK_P                    :   inout   std_logic                                   ;
        DDR_CKE                     :   inout   std_logic                                   ;
        DDR_CS_N                    :   inout   std_logic                                   ;
        DDR_DM                      :   inout   std_logic_vector (  3 downto 0 )            ;
        DDR_DQ                      :   inout   std_logic_vector ( 31 downto 0 )            ;
        DDR_DQS_N                   :   inout   std_logic_vector (  3 downto 0 )            ;
        DDR_DQS_P                   :   inout   std_logic_vector (  3 downto 0 )            ;
        DDR_ODT                     :   inout   std_logic                                   ;
        DDR_RAS_N                   :   inout   std_logic                                   ;
        DDR_RESET_N                 :   inout   std_logic                                   ;
        DDR_WE_N                    :   inout   std_logic                                   ;
        FIXED_IO_DDR_VRN            :   inout   std_logic                                   ;
        FIXED_IO_DDR_VRP            :   inout   std_logic                                   ;
        FIXED_IO_MIO                :   inout   std_logic_vector ( 53 downto 0 )            ;
        FIXED_IO_PS_CLK             :   inout   std_logic                                   ;
        FIXED_IO_PS_PORB            :   inout   std_logic                                   ;
        FIXED_IO_PS_SRSTB           :   inout   std_logic                                   ;
        I2C0_SCL                    :   inout   std_logic                                   ;
        I2C0_SDA                    :   inout   std_logic                                    
    );
end zturn_top;



architecture Behavioral of zturn_top is

    component zturn_bd_wrapper
        port (
            ADXL_INTERRUPT          : in STD_LOGIC_VECTOR ( 1 downto 0 );
            CLK_10                  : out STD_LOGIC;
            DDR_addr                : inout STD_LOGIC_VECTOR ( 14 downto 0 );
            DDR_ba                  : inout STD_LOGIC_VECTOR ( 2 downto 0 );
            DDR_cas_n               : inout STD_LOGIC;
            DDR_ck_n                : inout STD_LOGIC;
            DDR_ck_p                : inout STD_LOGIC;
            DDR_cke                 : inout STD_LOGIC;
            DDR_cs_n                : inout STD_LOGIC;
            DDR_dm                  : inout STD_LOGIC_VECTOR ( 3 downto 0 );
            DDR_dq                  : inout STD_LOGIC_VECTOR ( 31 downto 0 );
            DDR_dqs_n               : inout STD_LOGIC_VECTOR ( 3 downto 0 );
            DDR_dqs_p               : inout STD_LOGIC_VECTOR ( 3 downto 0 );
            DDR_odt                 : inout STD_LOGIC;
            DDR_ras_n               : inout STD_LOGIC;
            DDR_reset_n             : inout STD_LOGIC;
            DDR_we_n                : inout STD_LOGIC;
            FIXED_IO_ddr_vrn        : inout STD_LOGIC;
            FIXED_IO_ddr_vrp        : inout STD_LOGIC;
            FIXED_IO_mio            : inout STD_LOGIC_VECTOR ( 53 downto 0 );
            FIXED_IO_ps_clk         : inout STD_LOGIC;
            FIXED_IO_ps_porb        : inout STD_LOGIC;
            FIXED_IO_ps_srstb       : inout STD_LOGIC;
            SCL_I                   : in STD_LOGIC;
            SCL_T                   : out STD_LOGIC;
            SDA_I                   : in STD_LOGIC;
            SDA_T                   : out STD_LOGIC
        );
    end component;


    -- Данный сигнал прерывания надо подключить на два ваших пина, которые ADXL_INT1, ADXL_INT2. 
    signal  adxl_interrupt      :           STD_LOGIC_VECTOR ( 1 downto 0 ) := (others => '0')      ;
    signal  clk                 :           STD_LOGIC                                               ;
    signal  scl_i               :           STD_LOGIC                                               ;
    signal  scl_t               :           STD_LOGIC                                               ;
    signal  sda_i               :           STD_LOGIC                                               ;
    signal  sda_t               :           STD_LOGIC                                               ;




begin

    zturn_bd_wrapper_inst : zturn_bd_wrapper
        port map (
            ADXL_INTERRUPT          =>  adxl_interrupt              ,
            CLK_10                  =>  clk                         ,
            DDR_addr                =>  DDR_ADDR                    ,
            DDR_ba                  =>  DDR_BA                      ,
            DDR_cas_n               =>  DDR_CAS_N                   ,
            DDR_ck_n                =>  DDR_CK_N                    ,
            DDR_ck_p                =>  DDR_CK_P                    ,
            DDR_cke                 =>  DDR_CKE                     ,
            DDR_cs_n                =>  DDR_CS_N                    ,
            DDR_dm                  =>  DDR_DM                      ,
            DDR_dq                  =>  DDR_DQ                      ,
            DDR_dqs_n               =>  DDR_DQS_N                   ,
            DDR_dqs_p               =>  DDR_DQS_P                   ,
            DDR_odt                 =>  DDR_ODT                     ,
            DDR_ras_n               =>  DDR_RAS_N                   ,
            DDR_reset_n             =>  DDR_RESET_N                 ,
            DDR_we_n                =>  DDR_WE_N                    ,
            FIXED_IO_ddr_vrn        =>  FIXED_IO_DDR_VRN            ,
            FIXED_IO_ddr_vrp        =>  FIXED_IO_DDR_VRP            ,
            FIXED_IO_mio            =>  FIXED_IO_MIO                ,
            FIXED_IO_ps_clk         =>  FIXED_IO_PS_CLK             ,
            FIXED_IO_ps_porb        =>  FIXED_IO_PS_PORB            ,
            FIXED_IO_ps_srstb       =>  FIXED_IO_PS_SRSTB           ,
            SCL_I                   =>  scl_i                       ,
            SCL_T                   =>  scl_t                       ,
            SDA_I                   =>  sda_i                       ,
            SDA_T                   =>  sda_t                        
        );

    i2c0_scl_inst : IOBUF
        port map (
            O           => scl_i        ,   -- Buffer output
            IO          => I2C0_SCL     ,   -- Buffer inout port (connect directly to top-level port)
            I           => '0'          ,   -- Buffer input
            T           => scl_t            -- 3-state enable input, high=input, low=output 
        );

    i2c0_sda_inst : IOBUF
        port map (
            O           => sda_i        ,     -- Buffer output
            IO          => I2C0_SDA     ,   -- Buffer inout port (connect directly to top-level port)
            I           => '0'          ,     -- Buffer input
            T           => sda_t            -- 3-state enable input, high=input, low=output 
        );

end Behavioral;
