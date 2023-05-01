library IEEE;
    use IEEE.STD_LOGIC_1164.ALL;



entity zturn_top is
    port(
        ddr_addr                    :   inout   std_logic_vector ( 14 downto 0 )            ;
        ddr_ba                      :   inout   std_logic_vector (  2 downto 0 )            ;
        ddr_cas_n                   :   inout   std_logic                                   ;
        ddr_ck_n                    :   inout   std_logic                                   ;
        ddr_ck_p                    :   inout   std_logic                                   ;
        ddr_cke                     :   inout   std_logic                                   ;
        ddr_cs_n                    :   inout   std_logic                                   ;
        ddr_dm                      :   inout   std_logic_vector (  3 downto 0 )            ;
        ddr_dq                      :   inout   std_logic_vector ( 31 downto 0 )            ;
        ddr_dqs_n                   :   inout   std_logic_vector (  3 downto 0 )            ;
        ddr_dqs_p                   :   inout   std_logic_vector (  3 downto 0 )            ;
        ddr_odt                     :   inout   std_logic                                   ;
        ddr_ras_n                   :   inout   std_logic                                   ;
        ddr_reset_n                 :   inout   std_logic                                   ;
        ddr_we_n                    :   inout   std_logic                                   ;
        fixed_io_ddr_vrn            :   inout   std_logic                                   ;
        fixed_io_ddr_vrp            :   inout   std_logic                                   ;
        fixed_io_mio                :   inout   std_logic_vector ( 53 downto 0 )            ;
        fixed_io_ps_clk             :   inout   std_logic                                   ;
        fixed_io_ps_porb            :   inout   std_logic                                   ;
        fixed_io_ps_srstb           :   inout   std_logic                                   ;
        I2C0_SCL                    :   inout   std_logic                                   ;
        I2C0_SDA                    :   inout   std_logic                                    
    );
end zturn_top;



architecture Behavioral of zturn_top is


    component zturn_bd_wrapper
        port (
            CLK_100                 :   out     STD_LOGIC;
            DDR_addr                :   inout   STD_LOGIC_VECTOR ( 14 downto 0 );
            DDR_ba                  :   inout   STD_LOGIC_VECTOR ( 2 downto 0 );
            DDR_cas_n               :   inout   STD_LOGIC;
            DDR_ck_n                :   inout   STD_LOGIC;
            DDR_ck_p                :   inout   STD_LOGIC;
            DDR_cke                 :   inout   STD_LOGIC;
            DDR_cs_n                :   inout   STD_LOGIC;
            DDR_dm                  :   inout   STD_LOGIC_VECTOR ( 3 downto 0 );
            DDR_dq                  :   inout   STD_LOGIC_VECTOR ( 31 downto 0 );
            DDR_dqs_n               :   inout   STD_LOGIC_VECTOR ( 3 downto 0 );
            DDR_dqs_p               :   inout   STD_LOGIC_VECTOR ( 3 downto 0 );
            DDR_odt                 :   inout   STD_LOGIC;
            DDR_ras_n               :   inout   STD_LOGIC;
            DDR_reset_n             :   inout   STD_LOGIC;
            DDR_we_n                :   inout   STD_LOGIC;
            FIXED_IO_ddr_vrn        :   inout   STD_LOGIC;
            FIXED_IO_ddr_vrp        :   inout   STD_LOGIC;
            FIXED_IO_mio            :   inout   STD_LOGIC_VECTOR ( 53 downto 0 );
            FIXED_IO_ps_clk         :   inout   STD_LOGIC;
            FIXED_IO_ps_porb        :   inout   STD_LOGIC;
            FIXED_IO_ps_srstb       :   inout   STD_LOGIC;
    I2C0_SCL_I_0 : in STD_LOGIC;
    I2C0_SCL_O_0 : out STD_LOGIC;
    I2C0_SCL_T_0 : out STD_LOGIC;
    I2C0_SDA_I_0 : in STD_LOGIC;
    I2C0_SDA_O_0 : out STD_LOGIC;
    I2C0_SDA_T_0 : out STD_LOGIC

        );
    end component;

    signal  I2C0_SCL_I_0 : std_logic ; 
    signal  I2C0_SCL_O_0 : std_logic ; 
    signal  I2C0_SCL_T_0 : std_logic ; 
    signal  I2C0_SDA_I_0 : std_logic ; 
    signal  I2C0_SDA_O_0 : std_logic ; 
    signal  I2C0_SDA_T_0 : std_logic ; 

    signal  CLK                     :           STD_LOGIC;


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

    signal  reset                               :           std_logic                                                               ;
    -- SLave AXI-Stream 
    signal  s_axis_tdata                        :           std_logic_Vector ( 7 downto 0 )                                         ;
    signal  s_axis_tdest                        :           std_logic_Vector ( 7 downto 0 )                                         ;
    signal  s_axis_tvalid                       :           std_logic                                                               ;
    signal  d_s_axis_tvalid                     :           std_logic                                                               ;
    signal  s_axis_tvalid_event                 :           std_logic                                                               ;
    signal  s_axis_tlast                        :           std_logic                                                               ;
    signal  s_axis_tready                       :           std_logic                                                               ;

    signal  m_axis_tdata                        :           std_logic_Vector ( 7 downto 0 )                                         ;
    signal  m_axis_tdest                        :           std_logic_Vector ( 7 downto 0 )                                         ;
    signal  m_axis_tvalid                       :           std_logic                                                               ;
    signal  m_axis_tlast                        :           std_logic                                                               ;
    signal  m_axis_tready                       :           std_logic                                                               ;

    signal  scl_i                               :           std_logic                                                               ;
    signal  scl_t                               :           std_logic                                                               ;
    signal  sda_i                               :           std_logic                                                               ;
    signal  sda_t                               :           std_logic                                                               ;

    component vio_iic_ctrl
        port (
            clk                                 :   in      std_logic;
            probe_out0                          :   out     std_logic_vector(0 downto 0);
            probe_out1                          :   out     std_logic_vector(7 downto 0);
            probe_out2                          :   out     std_logic_vector(7 downto 0);
            probe_out3                          :   out     std_logic_vector(0 downto 0);
            probe_out4                          :   out     std_logic_vector(0 downto 0);
            probe_out5                          :   out     std_logic_vector(0 downto 0) 
        );
    end component;


    component ila_axis_iic
        port (
            clk : in std_logic;
            probe0 : in std_logic_vector(7 downto 0); 
            probe1 : in std_logic_vector(7 downto 0); 
            probe2 : in std_logic_vector(0 downto 0); 
            probe3 : in std_logic_vector(0 downto 0); 
            probe4 : in std_logic_vector(0 downto 0); 
            probe5 : in std_logic_vector(7 downto 0); 
            probe6 : in std_logic_vector(7 downto 0); 
            probe7 : in std_logic_vector(0 downto 0); 
            probe8 : in std_logic_vector(0 downto 0);
            probe9 : in std_logic_vector(0 downto 0)
        );
    end component;
    

    COMPONENT ila_iic
        PORT (
            clk : IN STD_LOGIC;
            probe0 : IN STD_LOGIC_VECTOR(0 DOWNTO 0); 
            probe1 : IN STD_LOGIC_VECTOR(0 DOWNTO 0); 
            probe2 : IN STD_LOGIC_VECTOR(0 DOWNTO 0); 
            probe3 : IN STD_LOGIC_VECTOR(0 DOWNTO 0); 
            probe4 : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
            probe5 : IN STD_LOGIC_VECTOR(0 DOWNTO 0)
        );
    END COMPONENT  ;

begin




    zturn_bd_wrapper_inst : zturn_bd_wrapper
        port map (
            CLK_100                 =>  CLK                     ,
            DDR_addr                =>  DDR_addr                ,
            DDR_ba                  =>  DDR_ba                  ,
            DDR_cas_n               =>  DDR_cas_n               ,
            DDR_ck_n                =>  DDR_ck_n                ,
            DDR_ck_p                =>  DDR_ck_p                ,
            DDR_cke                 =>  DDR_cke                 ,
            DDR_cs_n                =>  DDR_cs_n                ,
            DDR_dm                  =>  DDR_dm                  ,
            DDR_dq                  =>  DDR_dq                  ,
            DDR_dqs_n               =>  DDR_dqs_n               ,
            DDR_dqs_p               =>  DDR_dqs_p               ,
            DDR_odt                 =>  DDR_odt                 ,
            DDR_ras_n               =>  DDR_ras_n               ,
            DDR_reset_n             =>  DDR_reset_n             ,
            DDR_we_n                =>  DDR_we_n                ,
            FIXED_IO_ddr_vrn        =>  FIXED_IO_ddr_vrn        ,
            FIXED_IO_ddr_vrp        =>  FIXED_IO_ddr_vrp        ,
            FIXED_IO_mio            =>  FIXED_IO_mio            ,
            FIXED_IO_ps_clk         =>  FIXED_IO_ps_clk         ,
            FIXED_IO_ps_porb        =>  FIXED_IO_ps_porb        ,
            FIXED_IO_ps_srstb       =>  FIXED_IO_ps_srstb       ,
            I2C0_SCL_I_0            =>  I2C0_SCL_I_0            ,
            I2C0_SCL_O_0            =>  I2C0_SCL_O_0            ,
            I2C0_SCL_T_0            =>  I2C0_SCL_T_0            ,
            I2C0_SDA_I_0            =>  I2C0_SDA_I_0            ,
            I2C0_SDA_O_0            =>  I2C0_SDA_O_0            ,
            I2C0_SDA_T_0            =>  I2C0_SDA_T_0             
        );

    --ila_iic_inst : ila_iic
    --    PORT map (
    --        clk                 =>  CLK                     ,
    --        probe0(0)           =>  I2C0_SCL_I_0            ,
    --        probe1(0)           =>  I2C0_SCL_O_0            ,
    --        probe2(0)           =>  I2C0_SCL_T_0            ,
    --        probe3(0)           =>  I2C0_SDA_I_0            ,
    --        probe4(0)           =>  I2C0_SDA_O_0            ,
    --        probe5(0)           =>  I2C0_SDA_T_0             
    --    );


    --i2c0_scl_inst : IOBUF
    --    port map (
    --        O           => I2C0_SCL_I_0        ,   -- Buffer output
    --        IO          => I2C0_SCL     ,   -- Buffer inout port (connect directly to top-level port)
    --        I           => I2C0_SCL_O_0        ,   -- Buffer input
    --        T           => I2C0_SCL_T_0            -- 3-state enable input, high=input, low=output 
    --    );


    --i2c0_sda_inst : IOBUF
    --    port map (
    --        O           => I2C0_SDA_I_0        ,     -- Buffer output
    --        IO          => I2C0_SDA     ,   -- Buffer inout port (connect directly to top-level port)
    --        I           => I2C0_SDA_O_0        ,     -- Buffer input
    --        T           => I2C0_SDA_T_0            -- 3-state enable input, high=input, low=output 
    --    );

    I2C0_SCL_I_0 <= '0';
    I2C0_SDA_I_0 <= '0';

    vio_iic_ctrl_inst : vio_iic_ctrl
        port map (
            clk                                 =>  clk                                     ,
            probe_out0(0)                       =>  reset                                   ,
            probe_out1                          =>  s_axis_tdata                            ,
            probe_out2                          =>  s_axis_tdest                            ,
            probe_out3(0)                       =>  s_axis_tvalid                           ,
            probe_out4(0)                       =>  s_axis_tlast                            ,
            probe_out5(0)                       =>  m_axis_tready                            
        );

    d_s_axis_tvalid_processing : process(CLK)
    begin 
        if CLK'event AND CLK = '1' then 
            d_s_axis_tvalid <= S_AXIS_TVALID;
        end if;
    end process;


    s_axis_tvalid_event_processing : process(CLK)
    begin 
        if CLK'event AND CLK = '1' then 
            if d_s_axis_tvalid = '0' and S_AXIS_TVALID = '1' then
                s_axis_tvalid_event <= '1';
            else
                s_axis_tvalid_event <= '0';
            end if;
        end if;
    end process;

    axis_iic_master_controller_inst : axis_iic_master_controller
        generic map (
            CLK_FREQUENCY                       =>  10000000                                ,
            CLK_IIC_FREQUENCY                   =>  400000                                  ,
            FIFO_DEPTH                          =>  256                                      
        )
        port map (
            CLK                                 =>  clk                                     ,
            RESET                               =>  reset                                   ,
            -- SLave AXI-Stream 
            S_AXIS_TDATA                        =>  s_axis_tdata                            ,
            S_AXIS_TDEST                        =>  s_axis_tdest                            ,
            S_AXIS_TVALID                       =>  s_axis_tvalid_event                     ,
            S_AXIS_TLAST                        =>  s_axis_tlast                            ,
            S_AXIS_TREADY                       =>  s_axis_tready                           ,

            M_AXIS_TDATA                        =>  m_axis_tdata                            ,
            M_AXIS_TDEST                        =>  m_axis_tdest                            ,
            M_AXIS_TVALID                       =>  m_axis_tvalid                           ,
            M_AXIS_TLAST                        =>  m_axis_tlast                            ,
            M_AXIS_TREADY                       =>  m_axis_tready                           ,

            SCL_I                               =>  scl_i                                   ,
            SCL_T                               =>  scl_t                                   ,
            SDA_I                               =>  sda_i                                   ,
            SDA_T                               =>  sda_t                                    

        );

    ila_iic_inst : ila_iic
        port map (
            clk        =>  clk                                     ,
            probe0(0)  =>  scl_i                                   ,
            probe1(0)  =>  scl_t                                   ,
            probe2(0)  =>  sda_i                                   ,
            probe3(0)  =>  sda_t                                   ,
            probe4(0)  =>  '0'                                     ,
            probe5(0)  =>  '0'                                      
        );


    ila_axis_iic_inst : ila_axis_iic
        port map (
            clk         =>  clk                                     ,
            probe0      =>  s_axis_tdata                            ,
            probe1      =>  s_axis_tdest                            ,
            probe2(0)   =>  s_axis_tvalid_event                     ,
            probe3(0)   =>  s_axis_tlast                            ,
            probe4(0)   =>  s_axis_tready                           ,
            probe5      =>  m_axis_tdata                            ,
            probe6      =>  m_axis_tdest                            ,
            probe7(0)   =>  m_axis_tvalid                           ,
            probe8(0)   =>  m_axis_tlast                            ,
            probe9(0)   =>  m_axis_tready                            
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
