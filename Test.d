module Test;

import std.stdio;
import CPU;
import ROM;
import Memory;

private int T;
private CPU _cpu;
private ROM _rom;
private Memory _memory;

int main(char[][]argv)
{
	
	_rom = new ROM("tetris.gb");
	_memory = new Memory(_rom);
	_cpu = new CPU(_memory);	
	_cpu.run();
	//_rom.getNextInstruction();
	return 0;
} 

