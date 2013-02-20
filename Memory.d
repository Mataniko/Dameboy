module Memory;
import ROM;

class Memory {
	
	private ROM _data;

	this(ROM rom) {
		_data = rom;
	}

	public void WriteByte(byte Address, byte Data) {
		_data[Address]=Data;
	}

	public void WriteByte(short Address, byte Data) {
		_data[Address]=Data;
	}


	public void WriteWord(short Address, short Data) {
		//_data[Address]=Data;
	}

	public byte ReadByte(short Address) {
		return _data[Address];
	}

	public short ReadWord(short Address) {
		return cast(short)(_data[Address+1] << 8) | _data[Address];
	}

	public byte ReadByte(byte Address) {
		return _data[Address];
	}

	public short ReadWord(byte Address) {
		return cast(short)(_data[Address] + (_data[Address+1] << 8));
	}

}