module pipeline_d_to_e (
input logic clk, reset,
input logic reg_dst_in, alu_src_in,
input logic mem_to_reg_in, reg_write_in,
input logic mem_write_in,
input logic [2:0] alu_control_in,
input logic [31:0] rd1_in, rd2_in, sign_imm_in,
input logic [4:0] rs_in, rt_in, rd_in,
output logic reg_dst_out, alu_src_out,
output logic mem_to_reg_out, reg_write_out,
output logic mem_write_out,
output logic [2:0] alu_control_out,
output logic [31:0] rd1_out, rd2_out, sign_imm_out,
output logic [4:0] rs_out, rt_out, rd_out
);
always_ff @(posedge clk or posedge reset) begin
if (reset) begin
reg_dst_out <= 0;
alu_src_out <= 0;
mem_to_reg_out <= 0;
reg_write_out <= 0;
mem_write_out <= 0;
alu_control_out <= 0;
rd1_out <= 0;
rd2_out <= 0;
sign_imm_out <= 0;
rs_out <= 0;
rt_out <= 0;
rd_out <= 0;
end else begin
reg_dst_out <= reg_dst_in;
alu_src_out <= alu_src_in;
mem_to_reg_out <= mem_to_reg_in;
reg_write_out <= reg_write_in;
mem_write_out <= mem_write_in;
alu_control_out <= alu_control_in;
rd1_out <= rd1_in;
rd2_out <= rd2_in;
sign_imm_out <= sign_imm_in;
rs_out <= rs_in;
rt_out <= rt_in;
rd_out <= rd_in;
end
end
endmodule
module pipeline_e_to_m (
input logic clk, reset,
input logic reg_write_in, mem_to_reg_in, mem_write_in,
input logic [31:0] alu_result_in, write_data_in,
input logic [4:0] write_reg_in,
output logic reg_write_out, mem_to_reg_out, mem_write_out,
output logic [31:0] alu_result_out, write_data_out,
output logic [4:0] write_reg_out
);
always_ff @(posedge clk or posedge reset) begin
if (reset) begin
reg_write_out <= 0;
mem_to_reg_out <= 0;
mem_write_out <= 0;
alu_result_out <= 0;
write_data_out <= 0;
write_reg_out <= 0;
end else begin
reg_write_out <= reg_write_in;
mem_to_reg_out <= mem_to_reg_in;
mem_write_out <= mem_write_in;
alu_result_out <= alu_result_in;
write_data_out <= write_data_in;
write_reg_out <= write_reg_in;
end
end
endmodule
module pipeline_m_to_w (
input logic clk, reset,
input logic reg_write_in, mem_to_reg_in,
input logic [31:0] read_data_in, alu_result_in,
input logic [4:0] write_reg_in,
output logic reg_write_out, mem_to_reg_out,
output logic [31:0] read_data_out, alu_result_out,
output logic [4:0] write_reg_out
);
always_ff @(posedge clk or posedge reset) begin
if (reset) begin
reg_write_out <= 0;
mem_to_reg_out <= 0;
read_data_out <= 0;
alu_result_out <= 0;
write_reg_out <= 0;
end else begin
reg_write_out <= reg_write_in;
mem_to_reg_out <= mem_to_reg_in;
read_data_out <= read_data_in;
alu_result_out <= alu_result_in;
write_reg_out <= write_reg_in;
end
end
endmodule
module datapath (
input logic clk, reset,
input logic [31:0] instrF,
input logic [31:0] readdataM,
output logic [31:0] pcF,
output logic [31:0] alu_outM, write_dataM,
output logic mem_writeM
);
// === FETCH STAGE ===
logic [31:0] pc_next, pc_plus4F;
assign pc_plus4F = pcF + 4;
always_ff @(posedge clk or posedge reset)
if (reset) pcF <= 0;
else pcF <= pc_next;
// === F to D Register ===
logic [31:0] instrD, pc_plus4D;
pipeline_f_to_d reg_f_to_d (
.clk(clk), .reset(reset),
.instr_in(instrF), .pc_plus4_in(pc_plus4F),
.instr_out(instrD), .pc_plus4_out(pc_plus4D)
);
// === DECODE STAGE ===
logic [4:0] rsD, rtD, rdD;
assign rsD = instrD[25:21];
assign rtD = instrD[20:16];
assign rdD = instrD[15:11];
logic [31:0] rd1D, rd2D, sign_immD;
assign sign_immD = {{16{instrD[15]}}, instrD[15:0]};
// Dummy control logic (replace with your controller)
logic reg_dstD, alu_srcD, mem_to_regD, reg_writeD, mem_writeD;
logic [2:0] alu_controlD;
// Register File (placeholder)
regfile rf (
.clk(clk), .we3(reg_writeW),
.ra1(rsD), .ra2(rtD), .wa3(write_regW),
.wd3(resultW), .rd1(rd1D), .rd2(rd2D)
);
// === D to E Register ===
logic reg_dstE, alu_srcE, mem_to_regE, reg_writeE, mem_writeE;
logic [2:0] alu_controlE;
logic [31:0] rd1E, rd2E, sign_immE;
logic [4:0] rsE, rtE, rdE;
pipeline_d_to_e reg_d_to_e (
.clk(clk), .reset(reset),
.reg_dst_in(reg_dstD),
.alu_src_in(alu_srcD),
.mem_to_reg_in(mem_to_regD),
.reg_write_in(reg_writeD),
.mem_write_in(mem_writeD),
.alu_control_in(alu_controlD),
.rd1_in(rd1D), .rd2_in(rd2D),
.sign_imm_in(sign_immD),
.rs_in(rsD), .rt_in(rtD), .rd_in(rdD),
.reg_dst_out(reg_dstE),
.alu_src_out(alu_srcE),
.mem_to_reg_out(mem_to_regE),
.reg_write_out(reg_writeE),
.mem_write_out(mem_writeE),
.alu_control_out(alu_controlE),
.rd1_out(rd1E), .rd2_out(rd2E),
.sign_imm_out(sign_immE),
.rs_out(rsE), .rt_out(rtE), .rd_out(rdE)
);
// === EXECUTE STAGE ===
logic [31:0] srcaE, srcbE, alu_resultE;
assign srcaE = rd1E;
assign srcbE = alu_srcE ? sign_immE : rd2E;
alu alu_unit (
.a(srcaE), .b(srcbE),
.alu_control(alu_controlE),
.result(alu_resultE)
);
logic [4:0] write_regE;
assign write_regE = reg_dstE ? rdE : rtE;
// === E to M Register ===
pipeline_e_to_m reg_e_to_m (
.clk(clk), .reset(reset),
.reg_write_in(reg_writeE), .mem_to_reg_in(mem_to_regE),
.mem_write_in(mem_writeE),
.alu_result_in(alu_resultE),
.write_data_in(rd2E), .write_reg_in(write_regE),
.reg_write_out(reg_writeM), .mem_to_reg_out(mem_to_regM),
.mem_write_out(mem_writeM),
.alu_result_out(alu_outM),
.write_data_out(write_dataM), .write_reg_out(write_regM)
);
// === MEMORY STAGE ===
// handled externally via readdataM input
// === M to W Register ===
pipeline_m_to_w reg_m_to_w (
.clk(clk), .reset(reset),
.reg_write_in(reg_writeM), .mem_to_reg_in(mem_to_regM),
.alu_result_in(alu_outM), .readdata_in(readdataM),
.write_reg_in(write_regM),
.reg_write_out(reg_writeW), .mem_to_reg_out(mem_to_regW),
.alu_result_out(alu_resultW), .readdata_out(readdataW),
.write_reg_out(write_regW)
);
// === WRITEBACK STAGE ===
assign resultW = mem_to_regW ? readdataW : alu_resultW;
endmodule
endmodule
module HazardUnit( input logic RegWriteW,
input logic [4:0] WriteRegW,
input logic RegWriteM,MemToRegM,
input logic [4:0] WriteRegM,
input logic RegWriteE,MemtoRegE,
input logic [4:0] rsE,rtE,
input logic [4:0] rsD,rtD,
output logic [1:0] ForwardAE,ForwardBE,
output logic FlushE,StallD,StallF);
logic lwstall;
always_comb begin
lwstall = ((rsD == rtE) | (rtD == rsE)) & MemtoRegE; StallF = StallD = FlushE = lwstall;
if ((rsE != 0) & (rsE == WriteRegM) & RegWriteM) begin
ForwardAE = 2'b10;
end
else if ((rsE != 0) & (rsE == WriteRegW) & RegWriteW) begin
ForwardAE = 2'b01;
end
else
ForwardAE = 2'b00;
end
endmodule
module mips (
input logic clk, reset,
output logic [31:0] pcF,
input logic [31:0] instrF,
);
output logic [31:0] alu_outM, write_dataM,
output logic mem_writeM
logic [31:0] readdataM;
datapath dp (
.clk(clk),
.reset(reset),
.instrF(instrF),
.readdataM(readdataM),
.pcF(pcF),
.alu_outM(alu_outM),
.write_dataM(write_dataM),
.mem_writeM(mem_writeM)
);
// Placeholder memory read
assign readdataM = 32'hDEADBEEF; // or connect to your real data memory
endmodule
module imem ( input logic [5:0] addr, output logic [31:0] instr);
// imem is modeled as a lookup table, a stored-program byte-addressable ROM
always_comb
case ({addr,2'b00}) // word-aligned fetch
8'h00: instr = 32'h2003000a; // addi $v1, $zero, 0x000a
8'h04: instr = 32'h2078fff7; // addi $t8, $v1, 0xfff7
8'h08: instr = 32'h03032825; // or $a1, $t8, $v1
8'h0c: instr = 32'h01aa9024; // and $s2, $t5, $t2
8'h10: instr = 32'h01f59020; // add $s2, $t7, $s5
8'h14: instr = 32'h12b8000a; // beq $s5, $t8, 0x000a
8'h18: instr = 32'h0075282a; // slt $a1, $v1, $s5
8'h1c: instr = 32'h10a000AF; // beq $a1, $zero, 0x00AF
8'h20: instr = 32'h0303282a; // slt $a1, $t8, $v1
8'h24: instr = 32'h03033822; // sub $a3, $t8, $v1
8'h28: instr = 32'hac780044; // sw $t8, 0x0044($v1)
8'h2c: instr = 32'h8c030050; // lw $v1, 0x0050($zero)
8'h30: instr = 32'hac0300cf; // sw $v1, 0x00CF($zero)
endmodule