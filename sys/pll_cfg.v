// megafunction wizard: %PLL Reconfig Intel FPGA IP v19.1%
// GENERATION: XML
// pll_cfg.v

// Generated using ACDS version 19.1 670

`timescale 1 ps / 1 ps
module pll_cfg #(
		parameter ENABLE_BYTEENABLE   = 0,
		parameter BYTEENABLE_WIDTH    = 4,
		parameter RECONFIG_ADDR_WIDTH = 6,
		parameter RECONFIG_DATA_WIDTH = 32,
		parameter reconf_width        = 64,
		parameter WAIT_FOR_LOCK       = 1
	) (
		input  wire        mgmt_clk,          //          mgmt_clk.clk
		input  wire        mgmt_reset,        //        mgmt_reset.reset
		output wire        mgmt_waitrequest,  // mgmt_avalon_slave.waitrequest
		input  wire        mgmt_read,         //                  .read
		input  wire        mgmt_write,        //                  .write
		output wire [31:0] mgmt_readdata,     //                  .readdata
		input  wire [5:0]  mgmt_address,      //                  .address
		input  wire [31:0] mgmt_writedata,    //                  .writedata
		output wire [63:0] reconfig_to_pll,   //   reconfig_to_pll.reconfig_to_pll
		input  wire [63:0] reconfig_from_pll  // reconfig_from_pll.reconfig_from_pll
	);

	altera_pll_reconfig_top #(
		.device_family       ("Cyclone V"),
		.ENABLE_MIF          (0),
		.MIF_FILE_NAME       ("sys/pll_cfg.mif"),
		.ENABLE_BYTEENABLE   (ENABLE_BYTEENABLE),
		.BYTEENABLE_WIDTH    (BYTEENABLE_WIDTH),
		.RECONFIG_ADDR_WIDTH (RECONFIG_ADDR_WIDTH),
		.RECONFIG_DATA_WIDTH (RECONFIG_DATA_WIDTH),
		.reconf_width        (reconf_width),
		.WAIT_FOR_LOCK       (WAIT_FOR_LOCK)
	) pll_cfg_inst (
		.mgmt_clk          (mgmt_clk),          //          mgmt_clk.clk
		.mgmt_reset        (mgmt_reset),        //        mgmt_reset.reset
		.mgmt_waitrequest  (mgmt_waitrequest),  // mgmt_avalon_slave.waitrequest
		.mgmt_read         (mgmt_read),         //                  .read
		.mgmt_write        (mgmt_write),        //                  .write
		.mgmt_readdata     (mgmt_readdata),     //                  .readdata
		.mgmt_address      (mgmt_address),      //                  .address
		.mgmt_writedata    (mgmt_writedata),    //                  .writedata
		.reconfig_to_pll   (reconfig_to_pll),   //   reconfig_to_pll.reconfig_to_pll
		.reconfig_from_pll (reconfig_from_pll), // reconfig_from_pll.reconfig_from_pll
		.mgmt_byteenable   (4'b0000)            //       (terminated)
	);

endmodule
// Retrieval info: <?xml version="1.0"?>
//<!--
//	Generated by Altera MegaWizard Launcher Utility version 1.0
//	************************************************************
//	THIS IS A WIZARD-GENERATED FILE. DO NOT EDIT THIS FILE!
//	************************************************************
//	Copyright (C) 1991-2020 Altera Corporation
//	Any megafunction design, and related net list (encrypted or decrypted),
//	support information, device programming or simulation file, and any other
//	associated documentation or information provided by Altera or a partner
//	under Altera's Megafunction Partnership Program may be used only to
//	program PLD devices (but not masked PLD devices) from Altera.  Any other
//	use of such megafunction design, net list, support information, device
//	programming or simulation file, or any other related documentation or
//	information is prohibited for any other purpose, including, but not
//	limited to modification, reverse engineering, de-compiling, or use with
//	any other silicon devices, unless such use is explicitly licensed under
//	a separate agreement with Altera or a megafunction partner.  Title to
//	the intellectual property, including patents, copyrights, trademarks,
//	trade secrets, or maskworks, embodied in any such megafunction design,
//	net list, support information, device programming or simulation file, or
//	any other related documentation or information provided by Altera or a
//	megafunction partner, remains with Altera, the megafunction partner, or
//	their respective licensors.  No other licenses, including any licenses
//	needed under any third party's intellectual property, are provided herein.
//-->
// Retrieval info: <instance entity-name="altera_pll_reconfig" version="19.1" >
// Retrieval info: 	<generic name="device_family" value="Cyclone V" />
// Retrieval info: 	<generic name="ENABLE_MIF" value="false" />
// Retrieval info: 	<generic name="MIF_FILE_NAME" value="sys/pll_cfg.mif" />
// Retrieval info: 	<generic name="ENABLE_BYTEENABLE" value="false" />
// Retrieval info: </instance>
// IPFS_FILES : pll_cfg.vo
// RELATED_FILES: pll_cfg.v, altera_pll_reconfig_top.v, altera_pll_reconfig_core.v, altera_std_synchronizer.v
