module CPU;

import std.stdio;
import std.bitmanip;
import Opcodes;
import Memory;

class CPU {
	private Registers _registers;
	private ushort counter;
	private Memory _memory;
	
	this(Memory memory)
	{
		counter=10;	
		_memory=memory;
  		_registers.PC = 0x100;
		_registers.BC=0x24f0;
	}

	struct F {
		mixin(bitfields!(
			bool, "flag0", 1,
			bool, "flag1", 1,
			bool, "flag2", 1,
			bool, "flag3", 1,
			bool, "flag4", 1,
			bool, "flag5", 1,
			bool, "flag6", 1,
			bool, "flag7", 1
			));
	}

	struct Registers {
		ubyte B,C,D,E,H,L,A; //Main 8 Bit Registers
		short SP, PC; // 
		byte F,I,R,IXH,IXL,IYH,IYL;
		short IX,IY;
		
		@property ref short HL() { _HL = cast(short)(L + (H << 8)); return _HL; }
		@property void HL(short value) { H=value>>8; L=0x00ff & value; }

		@property void BC(short value) { B=value>>8; C=0x00ff & value; }
		@property ref short BC() { _BC = cast(short)(B + (C << 8)); return _BC; }

		@property void DE(short value) { D=value>>8; E=0x00ff & value; }
		@property ref short DE() { _DE = cast(short)(D + (E << 8)); return _DE; }

		@property void AF(short value) { A=value>>8; F=0x00ff & value; }
		@property ref short AF() { _AF = cast(short)(A + (F << 8)); return _AF; }

		private:
		short _HL,_BC,_DE,_AF;


		
	}

	void reset()
	{		
		_registers.SP=0;
		_registers.PC=0;
		_registers.I=0;
		//F blah;
		//blah.flag0 =false;
	}

	public void run()
	{		
		int opcode;
		for (;;)
		{
			try {
			//Get next opcode
			opcode = 0x000000ff & _memory.ReadByte(_registers.PC++); 	
			writefln("Opcode: %0x", opcode); 
			writefln("A %0x\r\nB %0x\r\nC %0x\r\nD %0x\r\nE %0x\r\nHL %0x\r\nPC %0x\r\nSP %0x", _registers.A,_registers.B,_registers.C,_registers.D,_registers.E,_registers.HL,_registers.PC-1,_registers.SP);
			writefln("---------------------------------------------------------");
			//writeln(opcode);		
			switch (opcode) {
				case 0x00:                    
					NOP();
					break;                    
                case 0x01:                    
					LD_BC_nn();
					break;                    
                case 0x02:                    
					LD_BC_A();
					break;                    
                case 0x03:                    
					INC_BC();
					break;                    
                case 0x04:                    
					INC_B();
					break;                    
                case 0x05:                    
					DEC_B();
					break;                    
                case 0x06:                    
					LD_B_n();
					break;                    
                case 0x07:                    
					RLC_A();
					break;                    
                case 0x08:                    
					LD_nn_SP();
					break;                    
                case 0x09:                    
					ADD_HL_BC();
					break;                    
                case 0x0A:                    
					LD_A_BC();
					break;                    
                case 0x0B:                    
					DEC_BC();
					break;                    
                case 0x0C:                    
					INC_C();
					break;                    
                case 0x0D:                    
					DEC_C();
					break;                    
                case 0x0E:                    
					LD_C_n();
					break;                    
                case 0x0F:                    
					RRC_A();
					break;                    
                case 0x10:                    
					STOP();
					break;                    
                case 0x11:                    
					LD_DE_nn();
					break;                    
                case 0x12:                    
					LD_DE_A();
					break;                    
                case 0x13:                    
					INC_DE();
					break;                    
                case 0x14:                    
					INC_D();
					break;                    
                case 0x15:                    
					DEC_D();
					break;                    
                case 0x16:                    
					LD_D_n();
					break;                    
                case 0x17:                    
					RL_A();
					break;                    
                case 0x18:                    
					JR_n();
					break;                    
                case 0x19:                    
					ADD_HL_DE();
					break;                    
                case 0x1A:                    
					LDI_A_HL();
					break;                    
                case 0x1B:                    
					DEC_DE();
					break;                    
                case 0x1C:                    
					INC_E();
					break;                    
                case 0x1D:                    
					DEC_E();
					break;                    
                case 0x1E:                    
					LD_E_n();					
					break;                    
                case 0x1F:                    
					RR_A();
					break;                    
                case 0x20:                    
					JR_NZ_n();
					break;                    
                case 0x21:                    
					LD_HL_nn();
					break;                    
                case 0x22:                    
					LDI_HL_A();
					break;                    
                case 0x23:                    
					INC_HL();
					break;                    
                case 0x24:                    
					INC_H();
					break;                    
                case 0x25:                    
					DEC_H();
					break;                    
                case 0x26:                    
					LD_H_n();
					break;                    
                case 0x27:                    
					DAA();
					break;                    
                case 0x28:                    
					JR_Z_n();
					break;                    
                case 0x29:                    
					ADD_HL_HL();
					break;                    
                case 0x2A:                    
					LDI_A_HL();
					break;                    
                case 0x2B:                    
					DEC_HL();
					break;                    
                case 0x2C:                    
					INC_L();
					break;                    
                case 0x2D:                    
					DEC_L();
					break;                    
                case 0x2E:                    
					LD_L_n();
					break;                    
                case 0x2F:                    
					CPL();
					break;                    
                case 0x30:                    
					JR_NC_n();
					break;                    
                case 0x31:                    
					LD_SP_nn();
					break;                    
                case 0x32:                    
					LDD_HL_A();
					break;                    
                case 0x33:                    
					INC_SP();
					break;                    
                case 0x34:                    
					INC_HL();
					break;                    
                case 0x35:                    
					DEC_HL();
					break;                    
                case 0x36:                    
					LD_HL_n();
					break;                    
                case 0x37:                    
					SCF();
					break;                    
                case 0x38:                    
					JR_C_n();
					break;                    
                case 0x39:                    
					ADD_HL_SP();
					break;                    
                case 0x3A:                    
					LDD_A_HL();
					break;                    
                case 0x3B:                    
					DEC_SP();
					break;                    
                case 0x3C:                    
					INC_A();
					break;                    
                case 0x3D:                    
					DEC_A();
					break;                    
                case 0x3E:                    
					LD_A_n();
					break;                    
                case 0x3F:                    
					CCF();
					break;                    
                case 0x40:                    
					LD_B_B();
					break;                    
                case 0x41:                    
					LD_C_B();
					break;                    
                case 0x42:                    
					LD_D_B();
					break;                    
                case 0x43:                    
					LD_E_B();
					break;                    
                case 0x44:                    
					LD_H_B();
					break;                    
                case 0x45:                    
					LD_L_B();
					break;                    
                case 0x46:                    
					LD_HL_B();
					break;                    
                case 0x47:                    
					LD_A_B();
					break;                    
                case 0x48:                    
					LD_B_C();
					break;                    
                case 0x49:                    
					LD_C_C();
					break;                    
                case 0x4A:                    
					LD_D_C();
					break;                    
                case 0x4B:                    
					LD_E_C();
					break;                    
                case 0x4C:                    
					LD_H_C();
					break;                    
                case 0x4D:                    
					LD_L_C();
					break;                    
                case 0x4E:                    
					LD_HL_C();
					break;                    
                case 0x4F:                    
					LD_A_C();
					break;                    
                case 0x50:                    
					LD_B_D();
					break;                    
                case 0x51:                    
					LD_C_D();
					break;                    
                case 0x52:                    
					LD_D_D();
					break;                    
                case 0x53:                    
					LD_E_D();
					break;                    
                case 0x54:                    
					LD_H_D();
					break;                    
                case 0x55:                    
					LD_L_D();
					break;                    
                case 0x56:                    
					LD_HL_D();
					break;                    
                case 0x57:                    
					LD_A_D();
					break;                    
                case 0x58:                    
					LD_B_E();
					break;                    
                case 0x59:                    
					LD_C_E();
					break;                    
                case 0x5A:                    
					LD_D_E();
					break;                    
                case 0x5B:                    
					LD_E_E();
					break;                    
                case 0x5C:                    
					LD_H_E();
					break;                    
                case 0x5D:                    
					LD_L_E();
					break;                    
                case 0x5E:                    
					LD_HL_E();
					break;                    
                case 0x5F:                    
					LD_A_E();
					break;                    
                case 0x60:                    
					LD_B_H();
					break;                    
                case 0x61:                    
					LD_C_H();
					break;                    
                case 0x62:                    
					LD_D_H();
					break;                    
                case 0x63:                    
					LD_E_H();
					break;                    
                case 0x64:                    
					LD_H_H();
					break;                    
                case 0x65:                    
					LD_L_H();
					break;                    
                case 0x66:                    
					LD_HL_H();
					break;                    
                case 0x67:                    
					LD_A_H();
					break;                    
                case 0x68:                    
					LD_B_L();
					break;                    
                case 0x69:                    
					LD_C_L();
					break;                    
                case 0x6A:                    
					LD_D_L();
					break;                    
                case 0x6B:                    
					LD_E_L();
					break;                    
                case 0x6C:                    
					LD_H_L();
					break;                    
                case 0x6D:                    
					LD_L_L();
					break;                    
                case 0x6E:                    
					LD_HL_L();
					break;                    
                case 0x6F:                    
					LD_A_L();
					break;                    
                case 0x70:                    
					LD_B_HL();
					break;                    
                case 0x71:                    
					LD_C_HL();
					break;                    
                case 0x72:                    
					LD_D_HL();
					break;                    
                case 0x73:                    
					LD_E_HL();
					break;                    
                case 0x74:                    
					LD_H_HL();
					break;                    
                case 0x75:                    
					LD_L_HL();
					break;                    
                case 0x76:                    
					HALT();
					break;                    
                case 0x77:                    
					LD_A_HL();
					break;                    
                case 0x78:                    
					LD_B_A();
					break;                    
                case 0x79:                    
					LD_C_A();
					break;                    
                case 0x7A:                    
					LD_D_A();
					break;                    
                case 0x7B:                    
					LD_E_A();
					break;                    
                case 0x7C:                    
					LD_H_A();
					break;                    
                case 0x7D:                    
					LD_L_A();
					break;                    
                case 0x7E:                    
					LD_HL_A();
					break;                    
                case 0x7F:                    
					LD_A_A();
					break;                    
                case 0x80:                    
					ADD_A_B();
					break;                    
                case 0x81:                    
					ADD_A_C();
					break;                    
                case 0x82:                    
					ADD_A_D();
					break;                    
                case 0x83:                    
					ADD_A_E();
					break;                    
                case 0x84:                    
					ADD_A_H();
					break;                    
                case 0x85:                    
					ADD_A_L();
					break;                    
                case 0x86:                    
					ADD_A_HL();
					break;                    
                case 0x87:                    
					ADD_A_A();
					break;                    
                case 0x88:                    
					ADC_A_B();
					break;                    
                case 0x89:                    
					ADC_A_C();
					break;                    
                case 0x8A:                    
					ADC_A_D();
					break;                    
                case 0x8B:                    
					ADC_A_E();
					break;                    
                case 0x8C:                    
					ADC_A_H();
					break;                    
                case 0x8D:                    
					ADC_A_L();
					break;                    
                case 0x8E:                    
					ADC_A_HL();
					break;                    
                case 0x8F:                    
					ADC_A_A();
					break;                    
                case 0x90:                    
					SUB_A_B();
					break;                    
                case 0x91:                    
					SUB_A_C();
					break;                    
                case 0x92:                    
					SUB_A_D();
					break;                    
                case 0x93:                    
					SUB_A_E();
					break;                    
                case 0x94:                    
					SUB_A_H(); 
					break;                    
                case 0x95:                    
					SUB_A_L();
					break;                    
                case 0x96:                    
					SUB_A_HL();
					break;                    
                case 0x97:                    
					SUB_A_A();
					break;                    
                case 0x98:                    
					SBC_A_B();
					break;                    
                case 0x99:                    
					SBC_A_C();
					break;                    
                case 0x9A:                    
					SBC_A_D();
					break;                    
                case 0x9B:                    
					SBC_A_E();
					break;                    
                case 0x9C:                    
					SBC_A_H();
					break;                    
                case 0x9D:                    
					SBC_A_L();
					break;                    
                case 0x9E:                    
					SBC_A_HL();
					break;                    
                case 0x9F:                    
					SBC_A_A();
					break;                    
                case 0xA0:                    
					AND_B();
					break;                    
                case 0xA1:                    
					AND_C();
					break;                    
                case 0xA2:                    
					AND_D();
					break;                    
                case 0xA3:                    
					AND_E();
					break;                    
                case 0xA4:                    
					AND_H();
					break;                    
                case 0xA5:                    
					AND_L();
					break;                    
                case 0xA6:                    
					AND_HL();
					break;                    
                case 0xA7:                    
					AND_A();
					break;                    
                case 0xA8:                    
					XOR_B();
					break;                    
                case 0xA9:                    
					XOR_C();
					break;                    
                case 0xAA:                    
					XOR_D();
					break;                    
                case 0xAB:                    
					XOR_E();
					break;                    
                case 0xAC:                    
					XOR_H();
					break;                    
                case 0xAD:                    
					XOR_L();
					break;                    
                case 0xAE:                    
					XOR_HL();
					break;                    
                case 0xAF:                    
					XOR_A();
					break;                    
                case 0xB0:                    
					OR_B();
					break;                    
                case 0xB1:                    
					OR_C();
					break;                    
                case 0xB2:                    
					OR_D();
					break;                    
                case 0xB3:                    
					OR_E();
					break;                    
                case 0xB4:                    
					OR_H();
					break;                    
                case 0xB5:                    
					OR_L();
					break;                    
                case 0xB6:                    
					OR_HL();
					break;                    
                case 0xB7:                    
					OR_A();
					break;                    
                case 0xB8:                    
					CP_B();
					break;                    
                case 0xB9:                    
					CP_C();
					break;                    
                case 0xBA:                    
					CP_D();
					break;                    
                case 0xBB:                    
					CP_E();
					break;                    
                case 0xBC:                    
					CP_H();
					break;                    
                case 0xBD:                    
					CP_L();
					break;                    
                case 0xBE:                    
					CP_HL();
					break;                    
                case 0xBF:                    
					CP_A();
					break;                    
                case 0xC0:                    
					RET_NZ();
					break;                    
                case 0xC1:                    
					POP_BC();
					break;                    
                case 0xC2:                    
					JP_NZ_nn();
					break;                    
                case 0xC3:                    
					JP_nn();
					break;                    
                case 0xC4:                    
					CALL_NZ_nn();
					break;                    
                case 0xC5:                    
					PUSH_BC();
					break;                    
                case 0xC6:                    
					ADD_A_n();
					break;                    
                case 0xC7:                    
					RST_0();
					break;                    
                case 0xC8:                    
					RET_Z();
					break;                    
                case 0xC9:                    
					RET();
					break;                    
                case 0xCA:                    
					JP_Z_nn();
					break;                    
                case 0xCB:                    
					//Decode_Opcode_CB(_memory.read_byte((ushort)(pc + 1)));
					break;                    
                case 0xCC:                    
					CALL_Z_nn();
					break;                    
                case 0xCD:                    
					CALL_nn();
					break;                    
                case 0xCE:                    
					ADC_A_n();
					break;                    
                case 0xCF:                    
					RST_8();
					break;                    
                case 0xD0:                    
					RET_NC();
					break;                    
                case 0xD1:                    
					POP_DE();
					break;                    
                case 0xD2:                    
					JP_NC_nn();
					break;                    
                case 0xD4:                    
					CALL_NC_nn();
					break;                    
                case 0xD5:                    
					PUSH_DE();
					break;                    
                case 0xD6:                    
					SUB_A_n();
					break;                    
                case 0xD7:                    
					RST_10();
					break;                    
                case 0xD8:                    
					RET_C();
					break;                    
                case 0xD9:                    
					RETI();
					break;                    
                case 0xDA:                    
					JP_C_nn();
					break;                    
                case 0xDC:                    
					CALL_C_nn();
					break;                    
                case 0xDE:                    
					SBC_A_n();
					break;                    
                case 0xDF:                    
					RST_18();
					break;                    
                case 0xE0:                    
					LDH_n_A();
					break;                    
                case 0xE1:                    
					POP_HL();
					break;                    
                case 0xE2:                    
					LDH_C_A();
					break;                    
                case 0xE5:                    
					PUSH_HL();
					break;                    
                case 0xE6:                    
					AND_n();
					break;                    
                case 0xE7:                    
					RST_20();
					break;                    
                case 0xE8:                    
					ADD_SP_d();
					break;                    
                case 0xE9:                    
					JP_HL();
					break;                    
                case 0xEA:                    
					LD_nn_A();
					break;                    
                case 0xEE:                    
					XOR_n();
					break;                    
                case 0xEF:                    
					RST_28();
					break;                    
                case 0xF0:                    
					LDH_A_n();
					break;                    
                case 0xF1:                    
					POP_AF();
					break;                                    
                case 0xF3:                    
					DI();
					break;                    
                case 0xF5:                    
					PUSH_AF();
					break;                    
                case 0xF6:                    
					OR_n();
					break;                    
                case 0xF7:                    
					RST_30();
					break;                    
                case 0xF8:                    
					LDHL_SP_d();
					break;                    
                case 0xF9:                    
					LD_SP_HL();
					break;                    
                case 0xFA:                    
					LD_A_nn();
					break;                    
                case 0xFB:                    
					EI();
					break;                    
                case 0xFE:                    
					CP_n();
					break;                    
                case 0xFF:                    
					RST_38();
					break;                    
                default:                    
					//_registers.PC++;
					writefln("Unsupported Opcode: %0x", opcode);
					break;
			}
			//_registers.PC++;
			
			}
			catch { 
				writefln("Unsupported Opcode: %0x", opcode); 
			}
		}
	}



	// Instructions
		
	//Load (83)
	void LD_BC_nn() { _registers.BC = _memory.ReadWord(_registers.PC++); }
	void LD_BC_A() { _memory.WriteByte(_registers.BC, _registers.A); }

	void LD_DE_nn() { _registers.DE = _memory.ReadWord(_registers.PC++); }
	void LD_DE_A() { _memory.WriteByte(_registers.DE, _registers.A); }
	
	void LD_SP_nn() { _registers.SP = _memory.ReadWord(_registers.PC++); }
	void LD_SP_HL() { _registers.SP = _registers.HL; }	

	void LD_nn_SP() { _memory.WriteWord(_registers.PC, _registers.SP); }	
	void LD_nn_A() { _memory.WriteByte(_registers.PC, _registers.A);  }	
	
	void LDH_n_A() { _memory.WriteByte(cast(short)(0xff00 + _registers.PC++),_registers.A);  }	
	void LDH_C_A() { _memory.WriteByte(cast(short)(0xff00 + _registers.C),_registers.A);  }	
	void LDH_A_n() { _registers.A = _memory.ReadByte(cast(short)(0xff00 + _registers.PC++));  }	

	void LDHL_SP_d() { }

	void LD_B_n() { _registers.B = _memory.ReadByte(_registers.PC++); }
	void LD_C_n() { _registers.C = _memory.ReadByte(_registers.PC++); }
	void LD_D_n() { _registers.D = _memory.ReadByte(_registers.PC++); }
	void LD_E_n() { _registers.E = _memory.ReadByte(_registers.PC++); }
	void LD_F_n() { _registers.F = _memory.ReadByte(_registers.PC++); }
	void LD_H_n() { _registers.H = _memory.ReadByte(_registers.PC++); }
	void LD_L_n() { _registers.L = _memory.ReadByte(_registers.PC++); }
	void LD_A_n() { _registers.A = _memory.ReadByte(_registers.PC++); }		

	void LD_B_B() { _registers.B = _registers.B; }
	void LD_B_C() { _registers.B = _registers.C; }
	void LD_B_D() { _registers.B = _registers.D; }
	void LD_B_E() { _registers.B = _registers.E; }
	void LD_B_H() { _registers.B = _registers.H; }
	void LD_B_L() { _registers.B = _registers.L; }
	void LD_B_HL() { _registers.B = _memory.ReadByte(_registers.HL); }
	void LD_B_A() { _registers.B = _registers.A; }

	void LD_C_B() { _registers.C = _registers.C; }
	void LD_C_C() { _registers.C = _registers.C; }
	void LD_C_D() { _registers.C = _registers.D; }
	void LD_C_E() { _registers.C = _registers.E; }
	void LD_C_H() { _registers.C = _registers.H; }
	void LD_C_L() { _registers.C = _registers.L; }
	void LD_C_HL() { _registers.C = _memory.ReadByte(_registers.HL); }
	void LD_C_A() { _registers.C = _registers.A; }

	void LD_D_B() { _registers.D = _registers.D; }
	void LD_D_C() { _registers.D = _registers.C; }
	void LD_D_D() { _registers.D = _registers.D; }
	void LD_D_E() { _registers.D = _registers.E; }
	void LD_D_H() { _registers.D = _registers.H; }
	void LD_D_L() { _registers.D = _registers.L; }
	void LD_D_HL() { _registers.D = _memory.ReadByte(_registers.HL); }
	void LD_D_A() { _registers.D = _registers.A; }

	void LD_E_B() { _registers.E = _registers.E; }
	void LD_E_C() { _registers.E = _registers.C; }
	void LD_E_D() { _registers.E = _registers.D; }
	void LD_E_E() { _registers.E = _registers.E; }
	void LD_E_H() { _registers.E = _registers.H; }
	void LD_E_L() { _registers.E = _registers.L; }
	void LD_E_HL() { _registers.E = _memory.ReadByte(_registers.HL); }
	void LD_E_A() { _registers.E = _registers.A; }

	void LD_H_B() { _registers.H = _registers.H; }
	void LD_H_C() { _registers.H = _registers.C; }
	void LD_H_D() { _registers.H = _registers.D; }
	void LD_H_E() { _registers.H = _registers.E; }
	void LD_H_H() { _registers.H = _registers.H; }
	void LD_H_L() { _registers.H = _registers.L; }
	void LD_H_HL() { _registers.H = _memory.ReadByte(_registers.HL); }
	void LD_H_A() { _registers.H = _registers.A; }

	void LD_L_B() { _registers.L = _registers.L; }
	void LD_L_C() { _registers.L = _registers.C; }
	void LD_L_D() { _registers.L = _registers.D; }
	void LD_L_E() { _registers.L = _registers.E; }
	void LD_L_H() { _registers.L = _registers.H; }
	void LD_L_L() { _registers.L = _registers.L; }
	void LD_L_HL() { _registers.L = _memory.ReadByte(_registers.HL); }
	void LD_L_A() { _registers.L = _registers.A; }

	void LD_A_B() { _registers.A = _registers.A; }
	void LD_A_C() { _registers.A = _registers.C; }
	void LD_A_D() { _registers.A = _registers.D; }
	void LD_A_E() { _registers.A = _registers.E; }
	void LD_A_H() { _registers.A = _registers.H; }
	void LD_A_L() { _registers.A = _registers.A; }
	void LD_A_HL() { _registers.A = _memory.ReadByte(_registers.HL); }
	void LD_A_A() { _registers.A = _registers.A; }
	void LD_A_BC() { _registers.A = _memory.ReadByte(_registers.BC); }
	void LD_A_DE() { _registers.A = _memory.ReadByte(_registers.DE); }	
	void LD_A_nn() { _registers.A = _memory.ReadByte(_registers.PC++); }	

	void LD_HL_B() { _memory.WriteByte(_registers.HL,_registers.B); }
	void LD_HL_C() { _memory.WriteByte(_registers.HL,_registers.C); }
	void LD_HL_D() { _memory.WriteByte(_registers.HL,_registers.D); }
	void LD_HL_E() { _memory.WriteByte(_registers.HL,_registers.E); }
	void LD_HL_H() { _memory.WriteByte(_registers.HL,_registers.H); }
	void LD_HL_L() { _memory.WriteByte(_registers.HL,_registers.L); }	
	void LD_HL_A() { _memory.WriteByte(_registers.HL,_registers.A); }
	void LD_HL_nn() { _registers.HL = _memory.ReadWord(_registers.PC++); _registers.PC++; }
	void LD_HL_n() {  _memory.WriteByte(_registers.HL, _memory.ReadByte(_registers.PC++)); }

	//ADD
	void ADD_A_B() { _registers.A +=  _registers.B; }
	void ADD_A_C() { _registers.A +=  _registers.C; }
	void ADD_A_D() { _registers.A +=  _registers.D; }
	void ADD_A_E() { _registers.A +=  _registers.E; }
	void ADD_A_H() { _registers.A +=  _registers.H; }
	void ADD_A_L() { _registers.A +=  _registers.L; }
	void ADD_A_HL() { _registers.A += _memory.ReadByte(_registers.HL); }
	void ADD_A_A() { _registers.A +=  _registers.A; }
	void ADD_A_DE() { _registers.A += _registers.DE; }
	void ADD_HL_BC() { _registers.HL +=_registers.BC; }
	void ADD_HL_DE() { _registers.HL +=_registers.DE; }
	void ADD_HL_HL() { _registers.HL *= 2; }
	void ADD_HL_SP() { _registers.HL +=_registers.SP; }
	void ADD_A_n() { _registers.A +=  _memory.ReadByte(_registers.PC++); }
	void ADD_SP_d() { _registers.SP +=  _memory.ReadByte(_registers.PC++); }
	
	//ADC (0)
	void ADC_A_B() { _registers.A +=  _registers.B; }
	void ADC_A_C() { _registers.A +=  _registers.C; }
	void ADC_A_D() { _registers.A +=  _registers.D; }
	void ADC_A_E() { _registers.A +=  _registers.E; }
	void ADC_A_H() { _registers.A +=  _registers.H; }
	void ADC_A_L() { _registers.A +=  _registers.L; }
	void ADC_A_HL() { _registers.A += _memory.ReadByte(_registers.HL); }
	void ADC_A_A() { _registers.A +=  _registers.A; }
	void ADC_A_n() { _registers.A +=  _memory.ReadByte(_registers.PC++); }

	//SBC (9)
	void SBC_A_B() { _registers.A -=  _registers.B; }
	void SBC_A_C() { _registers.A -=  _registers.C; }
	void SBC_A_D() { _registers.A -=  _registers.D; }
	void SBC_A_E() { _registers.A -=  _registers.E; }
	void SBC_A_H() { _registers.A -=  _registers.H; }
	void SBC_A_L() { _registers.A -=  _registers.L; }
	void SBC_A_HL() { _registers.A -= _memory.ReadByte(_registers.HL); }
	void SBC_A_A() { _registers.A = 0; }	
	void SBC_A_n() { _registers.A -=  _memory.ReadByte(_registers.PC++); }

	//SUB (9)
	void SUB_A_B() { _registers.A -=  _registers.B; }
	void SUB_A_C() { _registers.A -=  _registers.C; }
	void SUB_A_D() { _registers.A -=  _registers.D; }
	void SUB_A_E() { _registers.A -=  _registers.E; }
	void SUB_A_H() { _registers.A -=  _registers.H; }
	void SUB_A_L() { _registers.A -=  _registers.L; }
	void SUB_A_HL() { _registers.A -= _memory.ReadByte(_registers.HL); }
	void SUB_A_A() { _registers.A = 0; }	
	void SUB_A_n() { _registers.A -=  _memory.ReadByte(_registers.PC++); }

	//XOR (9)
	void XOR_A() { _registers.A ^= _registers.A; }
	void XOR_B() { _registers.A ^= _registers.B; }
	void XOR_C() { _registers.A ^= _registers.C; }
	void XOR_D() { _registers.A ^= _registers.D; }
	void XOR_E() { _registers.A ^= _registers.E; }
	void XOR_H() { _registers.A ^= _registers.H; }
	void XOR_L() { _registers.A ^= _registers.L; }
	void XOR_HL() { _registers.A ^= _memory.ReadByte(_registers.HL); }	
	void XOR_n() { _registers.A ^= _memory.ReadByte(_registers.PC++); }

	//OR (9)
	void OR_A() { _registers.A |= _registers.A; }
	void OR_B() { _registers.A |= _registers.B; }
	void OR_C() { _registers.A |= _registers.C; }
	void OR_D() { _registers.A |= _registers.D; }
	void OR_E() { _registers.A |= _registers.E; }
	void OR_H() { _registers.A |= _registers.H; }
	void OR_L() { _registers.A |= _registers.L; }
	void OR_HL() { _registers.A |= _memory.ReadByte(_registers.HL); }	
	void OR_n() { _registers.A |= _memory.ReadByte(_registers.PC++); }

	//AND (9)
	void AND_A() { _registers.A &= _registers.A; }
	void AND_B() { _registers.A &= _registers.B; }
	void AND_C() { _registers.A &= _registers.C; }
	void AND_D() { _registers.A &= _registers.D; }
	void AND_E() { _registers.A &= _registers.E; }
	void AND_H() { _registers.A &= _registers.H; }
	void AND_L() { _registers.A &= _registers.L; }
	void AND_HL() { _registers.A &= _memory.ReadByte(_registers.HL); }	
	void AND_n() { _registers.A &= _memory.ReadByte(_registers.PC++); }
	

	//PUSH (4)
	void PUSH_BC() { }
	void PUSH_DE() { }
	void PUSH_HL() { }
	void PUSH_AF() { }

	//POP (4)
	void POP_BC() { }
	void POP_DE() { }
	void POP_HL() { }
	void POP_AF() { }
	
	//JUMP (6)
	void JP_NZ_nn() { _registers.PC = _memory.ReadWord(_registers.PC++); } 
	void JP_nn() { _registers.PC = _memory.ReadWord(_registers.PC++); } 
	void JP_Z_nn() { _registers.PC = _memory.ReadWord(_registers.PC++); } 
	void JP_NC_nn() { _registers.PC = _memory.ReadWord(_registers.PC++); } 
	void JP_C_nn() { _registers.PC = _memory.ReadWord(_registers.PC++); } 
	void JP_HL() { _registers.PC = _memory.ReadWord(_registers.PC++); } 

	//RST
	void RST_0() { }
	void RST_8() { }
	void RST_10() { }
	void RST_18() { }
	void RST_20() { }
	void RST_28() { }
	void RST_30() { }
	void RST_38() { }	

	//DEC
	void DEC_A() { _registers.A--; }
	void DEC_B() { _registers.B--; }
	void DEC_BC() { _registers.BC--; }
	void DEC_C() { _registers.C--; }
	void DEC_D() { _registers.D--; }
	void DEC_DE() { _registers.DE--; }
	void DEC_E() { _registers.E--; }
	void DEC_H() { _registers.H--; }
	void DEC_L() { _registers.L--; }
	void DEC_HL() { _registers.HL--; }
	void DEC_SP() { _registers.SP--; }	

	//INC
	void INC_A() { _registers.A++; }
	void INC_B() { _registers.B++; }
	void INC_BC() { _registers.BC++; }
	void INC_C() { _registers.C++; }
	void INC_D() { _registers.D++; }
	void INC_E() { _registers.E++; }
	void INC_DE() { _registers.DE++; }
	void INC_H() { _registers.H++; }
	void INC_L() { _registers.L++; }
	void INC_HL() { _registers.HL++; }
	void INC_SP() { _registers.SP++; }	
	
	//Other
	void NOP() { }
	void STOP() { }
	void HALT() { NOP(); _registers.PC--; }

	//JR
	void JR_n() { }
	void JR_NC_n() { }
	void JR_NZ_n() { }
	void JR_Z_n() { }
	void JR_C_n() { }

	void RLC_A() { }
	void RRC_A() { }

	void RL_A() { }

	//RET
	void RET() { }
	void RET_C() { }
	void RET_NZ() { }
	void RET_NC() { }
	void RET_Z() { }
	void RET_Z_nn() { }

	void RETI() { }

	void LDI_HL_A() {  _memory.WriteByte(_registers.HL, _registers.A); _registers.HL++; }
	void LDI_A_HL() { _registers.A = _memory.ReadByte(_registers.HL); _registers.HL++; }

	void LDD_HL_A() {  _memory.WriteByte(_registers.HL, _registers.A); _registers.HL--; }
	void LDD_A_HL() { _registers.A = _memory.ReadByte(_registers.HL); _registers.HL--; }

	void RR_A() { }	

	void DAA() { }
	void SCF() { }
	void CPL() { _registers.A = !_registers.A; }

	//CP (9)
	void CP_B() { bool CP = _registers.A == _registers.B ? true : false; }
	void CP_C() { bool CP = _registers.A == _registers.C ? true : false; }
	void CP_D() { bool CP = _registers.A == _registers.D ? true : false; }
	void CP_E() { bool CP = _registers.A == _registers.E ? true : false; }
	void CP_H() { bool CP = _registers.A == _registers.H ? true : false; }
	void CP_L() { bool CP = _registers.A == _registers.L ? true : false; }
	void CP_HL() { bool CP = _registers.A == _memory.ReadByte(_registers.HL) ? true : false; }
	void CP_A() { bool CP = _registers.A == _registers.A ? true : false; }
	void CP_n() { bool CP = _registers.A == _memory.ReadByte(_registers.PC++) ? true : false; }
	
	void CALL_nn() { }	
	void CALL_Z_nn() { }
	void CALL_C_nn() { }
	void CALL_NZ_nn() { }
	void CALL_NC_nn() { }

	void CCF() { }

	void DI() { }
	void EI() { }

	

	





}