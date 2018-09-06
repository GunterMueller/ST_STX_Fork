/*
 * COPYRIGHT (c) 2010-2015 by Jan Vrany, Jan Kurs and Marcel Hlopko
 * COPYRIGHT (c) 2014-2015 by Tomas Heger
 *                            SWING Research Group, Czech Technical University in Prague
 *
 * This software is furnished under a license and may be used
 * only in accordance with the terms of that license and with the
 * inclusion of the above copyright notice. This software may not
 * be provided or otherwise made available to, or used by, any
 * other person. No title to or ownership of the software is
 * hereby transferred.
 */
package stx.libjava.tools.compiler.utils;

import java.io.ByteArrayOutputStream;
import java.io.DataInputStream;
import java.io.IOException;
import java.util.Arrays;

/**
 * Scans a class file and retrieves information from it. Currently, it
 * only allows to get the class name.
 *
 */
@stx.libjava.annotation.Package("stx:libjava/tools")
public class ClassFileScanner {
	
	private static final int MAGIC = 0xCAFEBABE;
	
	// constant pool info tags:
	private static final int CP_TAG_STRING = 1;
	private static final int CP_TAG_INTEGER = 3;
	private static final int CP_TAG_FLOAT = 4;
	private static final int CP_TAG_LONG = 5;
	private static final int CP_TAG_DOUBLE = 6;
	private static final int CP_TAG_CLASS_REF = 7;
	private static final int CP_TAG_STRING_REF = 8;
	private static final int CP_TAG_FIELD_REF = 9;
	private static final int CP_TAG_METHOD_REF = 10;
	private static final int CP_TAG_INTERFACE_METHOD_REF = 11;
	private static final int CP_TAG_NAME_TYPE_DESCRIPTOR = 12;
	
	/** 
	 * Retrieves a class name from the class file given as parameter. The goal
	 * is to do it efficiently (i.e. without storing the whole class file to
	 * memory). Storing the constant pool is unavoidable though.
	 * 
	 * @param classFile Input stream containing the class file.
	 * @return class name or null (if retrieving the class name fails)
	 */
	public String getClassName(DataInputStream classFile) {
		try {
			// read and check the magic number
			int magic = classFile.readInt();
			if (magic != MAGIC)
				return null;
			
			// read the minor version number
			classFile.readUnsignedShort();
			
			// read and check the major version number
			// supported versions and their respective values:
			// J2SE 8 = 52 (0x34 hex)
			// J2SE 7 = 51 (0x33 hex)
			// J2SE 6.0 = 50 (0x32 hex)
			// J2SE 5.0 = 49 (0x31 hex)
			// JDK 1.4 = 48 (0x30 hex)
			// JDK 1.3 = 47 (0x2F hex)
			// JDK 1.2 = 46 (0x2E hex)
			// JDK 1.1 = 45 (0x2D hex)
			int major = classFile.readUnsignedShort();
			if (major < 45 || major > 52)
				return null;
			
			// read and store the constant pool (and remember the offsets)
			int cpItemCount = classFile.readUnsignedShort();
			ByteArrayOutputStream cpCopy = new ByteArrayOutputStream();
			int[] offsets = new int[cpItemCount + 1];
			for (int item = 1; item < cpItemCount; item++) {
				offsets[item] = cpCopy.size();
				storeConstPoolItem(classFile, cpCopy);
			}
			
			// read the access flags
			classFile.readUnsignedShort();
			
			// read the index to CP to 'this class'
			int tcIndex = classFile.readUnsignedShort();
			
			// find the class reference item index
			byte[] cpCopyBytes = cpCopy.toByteArray();
			int tcOffset = offsets[tcIndex];
			// ignore the tag
			tcOffset++; 
			// read the 'this class' string item index
			tcIndex = (cpCopyBytes[tcOffset] << 8) | cpCopyBytes[tcOffset + 1];
			tcOffset = offsets[tcIndex];
			// ignore the tag
			tcOffset++;
			// read the string length
			int len = (cpCopyBytes[tcOffset] << 8) | cpCopyBytes[tcOffset + 1];
			// retrieve the class name
			tcOffset += 2;
			byte[] className = Arrays.copyOfRange(cpCopyBytes, tcOffset, tcOffset + len);
			
			return new String(className, "UTF-8");
		} catch (IOException e) {
			return null;
		}
		
	}
	
	/** 
	 * Reads one constant pool item from the given stream and stores it for 
	 * future use.
	 * 
	 * @param from Input stream to read the constant pool item from.
	 * @param to Output stream to store the constant pool item to.
	 */
	void storeConstPoolItem(DataInputStream from, ByteArrayOutputStream to)
	throws IOException {
		int tag = from.readUnsignedByte();
		to.write((byte)(tag & 0xff));
		int bytesToRead = 0;
		
		switch (tag) {
		
			case CP_TAG_STRING:
				bytesToRead = from.readUnsignedShort();
				to.write((byte)((bytesToRead >> 8) & 0xff));
				to.write((byte)(bytesToRead & 0xff));
				break;
				
			case CP_TAG_CLASS_REF:
			case CP_TAG_STRING_REF:
				bytesToRead = 2;
				break;
				
			case CP_TAG_INTEGER:
			case CP_TAG_FLOAT:
			case CP_TAG_FIELD_REF:
			case CP_TAG_METHOD_REF:
			case CP_TAG_INTERFACE_METHOD_REF:
			case CP_TAG_NAME_TYPE_DESCRIPTOR:
				bytesToRead = 4;
				break;
				
			case CP_TAG_LONG:
			case CP_TAG_DOUBLE:
				bytesToRead = 8;
				break;
		}
		
		for (int i = 0; i < bytesToRead; i++) {
			to.write((byte)(from.readUnsignedByte() & 0xff));
		}
	}
}
