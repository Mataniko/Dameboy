module ROM;

import std.stdio;
import std.file;

class ROM
{
	private ubyte[] data;
	private byte counter;
	private CartType cartType;

	private enum CartType {
		ROM_ONLY=0, ROM_MBC1=1, ROM_MBC1_RAM=2,ROM_MBC1_RAM_BATTERY=3, ROM_MBC2=5,ROM_MBC2_BATTERY=6,
	}

	this(string path) {
		counter=0;
		path = "D:\\Dropbox\\Projects\\Dameboy\\Dameboy\\Debug\\" ~ path;
		//auto dir = dirEntries("D:\Dropbox\Projects\Dameboy\Dameboy\Debug", SpanMode.breadth);
		if (exists(path) != 0) {			
			data = cast(ubyte[])read(path);
			//writeln(data[1]);
		}
	}

	private string getRomName()
	{
		char[] name = new char[0x143-0x134];
		for (int i=0; i <= 0x143-0x134; i++) {
			name[i]=data[0x134+i];
		}
		return cast(string)name;
	}

	private CartType getCartType()
	{
		return cast(CartType)data[0x147];
	}

	public ushort getNextInstruction()
	{
		ushort instruction = (data[counter++] << 8) | data[counter++];
		return instruction;
	}

	ref ubyte opIndex(int v)
	{
		return data[v];
	}
}