# 8-bit Accumulator CPU (VHDL)

- **Student:** Taposhi Rabeya Bashar
- **ID:** 22201060
- **Course:** CSE 450 (VLSI Lab), Final Project, Spring 2026
- **Set:** 0

A small single-cycle 8-bit accumulator CPU written in VHDL.

## Instruction set (Set 0)

| Instruction | Opcode | Operation |
|---|---|---|
| LDI imm | 0001 | ACC <- imm |
| ADD imm | 0010 | ACC <- ACC + imm (carry dropped) |
| AND imm | 0100 | ACC <- ACC AND imm |
| NOT | 0111 | ACC <- NOT ACC |
| JZ addr | 1100 | If Z = 1 then PC <- addr, else PC <- PC + 1 |

Any other opcode is a NOP. Each instruction takes one clock cycle.
Instruction format: 4-bit opcode + 8-bit operand (12 bits).

## Files

| File | Description |
|---|---|
| `pc.vhd` | 4-bit program counter (count up or load for JZ) |
| `program_rom.vhd` | 16 x 12-bit program ROM |
| `control_unit.vhd` | Decodes the opcode and drives the control signals |
| `alu.vhd` | 8-bit ALU (LDI, ADD, AND, NOT) |
| `acc_register.vhd` | 8-bit accumulator |
| `z_register.vhd` | 1-bit zero flag |
| `cpu_top.vhd` | Top level, connects all blocks |
| `tb_cpu.vhd` | Testbench (checks the Appendix B results) |

## How to run

1. Create a VHDL project in Xilinx ISE and add all the `.vhd` files.
2. Set `cpu_top` as the top module and `tb_cpu` as the simulation top.
3. Run **Simulate Behavioral Model** (ISim) for about 100 ns.
4. The console should show no `FAILED` message.

## Expected results (Appendix B, Set 0)

| Cycle | Instruction | ACC | Z | Next PC |
|---|---|---|---|---|
| 0 | RESET | 00 | 1 | 0 |
| 1 | LDI 0xA5 | A5 | 0 | 1 |
| 2 | AND 0x5A | 00 | 1 | 2 |
| 3 | JZ 0x05 (taken) | 00 | 1 | 5 |
| 4 | NOT | FF | 0 | 6 |
| 5 | AND 0x0F | 0F | 0 | 7 |
| 6 | JZ 0x00 (not taken) | 0F | 0 | 8 |
| 7 | ADD 0x01 | 10 | 0 | 9 |