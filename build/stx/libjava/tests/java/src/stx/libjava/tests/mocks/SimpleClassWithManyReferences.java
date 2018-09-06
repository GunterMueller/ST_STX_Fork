package stx.libjava.tests.mocks;

import java.util.Date;

@stx.libjava.annotation.Package("stx:libjava/tests")
public class SimpleClassWithManyReferences {

	private Object[] values;

	public SimpleClassWithManyReferences() {
		values = new Object[10];
		values[0] = "hello";
		values[1] = 1;
		values[2] = 1.1;
		values[3] = 'a';
		values[4] = 10l;
		values[5] = new int[5];
		values[6] = new Short("1");
		values[7] = new Byte("11");
		values[8] = new Date[3];
		values[9] = Boolean.TRUE;
	}

	public String getString() {
		return (String) values[0];
	}

	public int getInt() {
		return (Integer) values[1];
	}

	public Double getDouble() {
		return (Double) values[2];
	}

	public char getChar() {
		return (Character) values[3];
	}

	public long getLong() {
		return (Long) values[4];
	}

	public int[] getIntArray() {
		return (int[]) values[5];
	}

	public short getShort() {
		return (Short) values[6];
	}

	public byte getByte() {
		return (Byte) values[7];
	}

	public Date[] getDateArray() {
		return (Date[]) values[8];
	}

	public boolean getBoolean() {
		return (Boolean) values[9];
	}

	public void setBoolean(int i) {
		if (i % 2 == 0) {
			values[9] = Boolean.TRUE;
		} else {
			values[9] = false;
		}
	}

	public void setDate(long milis) {
		((Date[]) values[8])[0] = new Date(milis);
	}

	public void setByte(byte b) {
		values[7] = b;
	}

	public void setIntArray(int[] array) {
		values[5] = array;
	}

	public void setDouble(double d) {
		values[2] = d;
	}

	public void setShort(short s) {
		values[6] = s;
	}

	public void setChar(char c) {
		values[3] = c;
	}

	public void setLong(long l) {
		 values[4] = l;
	}
	public void setString(String s) {
		values[0] = s;
	}

	public void setInt(int i) {
		values[1] = i;
	}
}
