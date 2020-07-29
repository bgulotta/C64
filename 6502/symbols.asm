#importonce

/*
  65C22 Registers
*/
.const VIA1REGB    = $6000  // Input/Output Register "B"
.const VIA1REGA    = $6001  // Input/Output Register "A"
.const VIA1DDRB    = $6002  // Data Direction Register "B"   0 Input 1 Output
.const VIA1DDRA    = $6003  // Data Direction Register "A"   0 Input 1 Output
.const VIA1T1CL    = $6004  // T1 Counter/Low Order Latches
.const VIA1T1CH    = $6005  // T1 High Order Counter
.const VIA1T1LL    = $6006  // T1 Low Order Latches
.const VIA1T1LH    = $6007  // T2 High Order Latches
.const VIA1T2CL    = $6008  // T2 Counter/Low Order Latches
.const VIA1T2CH    = $6009  // T2 High Order Counter
.const VIA1SR      = $600A  // Shift Register
.const VIA1ACR     = $600B  // Auxiliary Control Register
.const VIA1PCR     = $600C  // Peripheral Control Register
.const VIA1IFR     = $600D  // Interrupt Flag Register
.const VIA1IER     = $600E  // Interrupt Enable Register
.const VIA1REGA2   = $600F  // Same as IOREGA w/o Handshake

/* System VARS */
.const PRG            = $0200   // range of bytes from: $0200 - $3dff to load a progam into the 6502
/* VARS $3e00 - $3eff */
// TODO: Once development is complete, reclaim any unused bytes for PRG 
.const IO_RPTR        = $3e00; // read pointer into IOBUF 
.const IO_WPTR        = $3e01; // write pointer into IOBUF
/* 256 Byte IO Buffer */ 
.const IO_BUF          = $3f00 // a wrapping buffer of 256 bytes to process IO
