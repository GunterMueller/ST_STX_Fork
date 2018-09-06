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
package stx.libjava.tools.environment.utils;

import java.io.BufferedWriter;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.io.StringWriter;
import java.io.Writer;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.net.URL;
import java.net.URLClassLoader;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Comparator;
import java.util.Enumeration;
import java.util.jar.JarEntry;
import java.util.jar.JarFile;

import org.eclipse.jdt.internal.compiler.classfmt.AnnotationInfo;
import org.eclipse.jdt.internal.compiler.classfmt.ClassFileReader;
import org.eclipse.jdt.internal.compiler.classfmt.ClassFormatException;
import org.eclipse.jdt.internal.compiler.env.IBinaryAnnotation;
import org.eclipse.jdt.internal.compiler.env.IBinaryElementValuePair;
import org.eclipse.jdt.internal.compiler.env.IBinaryField;
import org.eclipse.jdt.internal.compiler.env.IBinaryMethod;
import org.eclipse.jdt.internal.compiler.env.IBinaryNestedType;
import org.eclipse.jdt.internal.compiler.env.IBinaryType;
import org.eclipse.jdt.internal.compiler.impl.Constant;

import stx.libjava.tools.environment.ReflectiveType;
import stx.libjava.tools.environment.ReflectiveUtils;

/*
 * This class handles dumping of an IBinaryType object to text.
 */
@stx.libjava.annotation.Package("stx:libjava/tools")
public class BinaryDumper {
	
	IBinaryType type;
	Writer out;
	BinaryDumperConfig config = new BinaryDumperConfig();
	
	static final int MAX_LEVEL = 10;
	static final int MIN_LEVEL = 0;
	static final String DELIMITER = "---";
	static final String INDENTATION = "   ";
	static final String YES = "Yes";
	static final String NO = "No";
	static final String ANNOTATIONS = "Anotations: ";
	static final String ANNOTATED_PARAMS_CNT = "Annotated parameters count: ";
	static final String PARAMETER_ANNOTATIONS = "Parameter annotations: ";
	static final String DEFAULT_VALUE = "Default value: ";
	static final String ENCLOSING_METHOD = "Enclosing method: ";
	static final String ENCLOSING_TYPE_NAME = "Enclosing type name: ";
	static final String EXCEPTION_TYPE_NAMES = "Exception type names: ";
	static final String FIELDS = "Fields: ";
	static final String FIELD_CONST = "Field constant: ";
	static final String GENERIC_SIGNATURE = "Generic signature: ";
	static final String INTERFACE_NAMES = "Interface names: ";
	static final String MEMBER_TYPES = "Member types: ";
	static final String METHODS = "Methods: ";
	static final String MISSING_TYPE_NAMES = "Missing type names: ";
	static final String MODIFIERS = "Modifiers: ";
	static final String NAME = "Name: ";
	static final String SOURCE_NAME = "Source name: ";
	static final String SUPERCLASS_NAME = "Superclass name: ";
	static final String TAG_BITS = "Tag bits: ";
	static final String IS_ANONYMOUS = "Is anonymous? ";
	static final String IS_CLINIT = "Is class inicializer? ";
	static final String IS_LOCAL = "Is local? ";
	static final String IS_MEMBER = "Is member? ";
	static final String SOURCE_FILE_NAME = "Source file name: ";
	static final String HASHCODE_SUBSTITUTE = "@HASHCODE";
	
	public BinaryDumper(IBinaryType binType, Writer output) {
		type = binType;
		out = output;
		
	}
	
	void delim(int lvl) throws IOException {
		indent(lvl);
		for (int i = MIN_LEVEL; i < MAX_LEVEL - lvl; i++)
			out.write(DELIMITER);
		out.write("\n");
	}
	
	void indent(int lvl) throws IOException {
		for (int i = MIN_LEVEL; i < lvl; i++)
			out.write(INDENTATION);
	}
	
	void writeIndented(String s, int lvl) throws IOException {
		indent(lvl);
		out.write(s);
	}
	
	void writeIndented(char[] arr, int lvl) throws IOException {
		indent(lvl);
		out.write(arr);
	}
	
	void writelnIndented(String s, int lvl) throws IOException {
		writeIndented(s, lvl);
		out.write("\n");
	}
	
	void writelnIndented(char[] arr, int lvl) throws IOException {
		writeIndented(arr, lvl);
		out.write("\n");
	}
	
	/**
	 * Returns the given object as a string and replaces its hashcode (if 
	 * needed) with a constant string (useful when comparing two dumps).
	 * If the given object is an array, its type and contents is dumped.
	 * If null is given as a parameter, the String "null" is returned.
	 * 
	 * @param obj Object to be dumped.
	 * @return String representing the given object, ready to be dumped. 
	 */
	String stringToDump(Object obj) {
		if (obj == null)
			return "null";
		
		if (obj.getClass().isArray()) {
			Object[] arr = (Object[]) obj;
			String componentType = arr.getClass().getComponentType().getName();
			String arrString = "[" + componentType + ": "; 
						
			if (arr.length == 0)
				return arrString + "(empty array)]";
			
			for (int i = 0; i < arr.length - 1; i++) {
				arrString += stringToDump(arr[i]) + ", "; 
			}
			arrString += stringToDump(arr[arr.length - 1]) + "]";
			return arrString;
		}

		String str = obj.toString();
		if (str.matches(obj.getClass().getName() + ";@[0-9a-fA-F]+")) {
			return str.replaceAll("@[0-9a-fA-F]+", HASHCODE_SUBSTITUTE);
		}
		
		if (obj instanceof AnnotationInfo) {
			if (!config.dumpRuntimeInvisibleAnnots && !isRuntimeVisible((AnnotationInfo) obj))
				str = "null";
		}
		
		return str;
	}
	
	/**
	 * Checks if the given annotation is visible in runtime or not.
	 * It's runtime visible if it has RetentionPolicy.RUNTIME. 
	 * 
	 * @param annotation Annotation to be checked.
	 * @return true if the annotation is visible in runtime, false otherwise.
	 */
	static boolean isRuntimeVisible(AnnotationInfo annotation) {
		String annotType = new String(annotation.getTypeName());
		String annotName = ReflectiveUtils.getNameFromSig(annotType);
		return isRuntimeVisible(annotName);
	}
	
	/**
	 * Checks if the given annotation is visible in runtime or not.
	 * It's runtime visible if it has RetentionPolicy.RUNTIME. 
	 * 
	 * @param annotation Annotation to be checked.
	 * @return true if the annotation is visible in runtime, false otherwise.
	 */
	static boolean isRuntimeVisible(IBinaryAnnotation annotation) {
		String annotType = new String(annotation.getTypeName());
		String annotName = ReflectiveUtils.getNameFromSig(annotType);
		return isRuntimeVisible(annotName);
	}
	
	/**
	 * Checks if the given annotation is visible in runtime or not.
	 * It's runtime visible if it has RetentionPolicy.RUNTIME. 
	 * 
	 * @param annotName Name of the annotation to be checked.
	 * @return true if the annotation is visible in runtime, false otherwise.
	 */
	static boolean isRuntimeVisible(String annotName) {
		Class<?> annot;
		try {
			annot = Class.forName(annotName);
		} catch (ClassNotFoundException e) {
			return false;
		}
		Retention retention = annot.getAnnotation(Retention.class);
		if (retention != null && retention.value() == RetentionPolicy.RUNTIME)
			return true;
		
		return false;
	}
	
	/**
	 * This method answers the question whether any of the given annotations
	 * should be actually dumped.  
	 * For example with the dumpRuntimeInvisibleAnnots config option set to 
	 * false, only annotations with RetentionPolicy.RUNTIME should be dumped.
	 * There fore if there are only annotations with RetentionPolicy.CLASS
	 * in the given array, none of them will be actually dumped.
	 * 
	 * @param annotations Array of annotations to be checked.
	 * @return True if there is at least one annotation in the given array that
	 * will actually be dumped, false otherwise.
	 */
	boolean dumpAnyAnnotationsActually(IBinaryAnnotation[] annotations) {
		if (config.dumpRuntimeInvisibleAnnots)
			return true;
		
		if (annotations == null)
			return false;
		
		// if runtime invisible annotations aren't supposed to be
		// dumped then at least one of them should be runtime visible
		for (int i = 0; i < annotations.length; i++)
			if (isRuntimeVisible(annotations[i]))
				return true;
		
		return false;
	}
	
	/**
	 * Filters the given fields according to the configuration.
	 * 
	 * @param fields Fields to be filtered.
	 * @return The given fields array without the fields that were filtered.
	 */
	IBinaryField[] filterFields(IBinaryField[] fields) {		
		if (!config.filterFields || fields == null)
			return fields;
		
		// find the fields that are supposed to be filtered
		String owner = new String (type.getName());
		int filteredCnt = 0;
		boolean[] filtered = new boolean[fields.length];
		Arrays.fill(filtered, false);
		for (int i = 0; i < fields.length; i++) {
			String name = new String(fields[i].getName());
			MemberToFilter field = new MemberToFilter(owner, name);
			if (config.fieldsToFilter.contains(field)) {
				filtered[i] = true;
				filteredCnt++;
			}
		}
		
		if (filteredCnt == 0)	// no field filtered
			return fields;
		
		if (filteredCnt == fields.length)	// all fields filtered
			return null;
		
		// filter the fields
		int newFieldsCnt = fields.length - filteredCnt;
		IBinaryField[] newFields = new IBinaryField[newFieldsCnt];
		int copied = 0;
		for (int i = 0; i < fields.length; i++) {
			if (!filtered[i]) {
				newFields[copied++] = fields[i];
			}
		}
		return newFields;
	}
	
	/**
	 * Filters the given methods according to the configuration.
	 * 
	 * @param methods Methods to be filtered.
	 * @return The given methods array without the methods that were filtered.
	 */
	IBinaryMethod[] filterMethods(IBinaryMethod[] methods) {		
		if (!config.filterMethods || methods == null)
			return methods;
		
		// find the methods that are supposed to be filtered
		String owner = new String (type.getName());
		int filteredCnt = 0;
		boolean[] filtered = new boolean[methods.length];
		Arrays.fill(filtered, false);
		for (int i = 0; i < methods.length; i++) {
			String name = new String(methods[i].getSelector());
			MemberToFilter method = new MemberToFilter(owner, name);
			if (config.methodsToFilter.contains(method)) {
				filtered[i] = true;
				filteredCnt++;
			}
		}
		
		if (filteredCnt == 0)	// no method filtered
			return methods;
		
		if (filteredCnt == methods.length)	// all methods filtered
			return null;
		
		// filter the methods
		int newMethodsCnt = methods.length - filteredCnt;
		IBinaryMethod[] newMethods = new IBinaryMethod[newMethodsCnt];
		int copied = 0;
		for (int i = 0; i < methods.length; i++) {
			if (!filtered[i]) {
				newMethods[copied++] = methods[i];
			}
		}
		return newMethods;
	}
	
	/*
	 * Dumps this type to the out as a text.
	 */
	public void dump() throws IOException {
		dumpName(MIN_LEVEL);
		dumpSourceName(MIN_LEVEL);
		dumpSuperclassName(MIN_LEVEL);
		dumpTagBits(type.getTagBits(), MIN_LEVEL);
		dumpIsAnonymous(MIN_LEVEL);
		dumpIsLocal(MIN_LEVEL);
		dumpIsMember(MIN_LEVEL);
		dumpSourceFileName(MIN_LEVEL);	
		dumpAnnotations(type.getAnnotations(), MIN_LEVEL);
		dumpEnclosingMethod(MIN_LEVEL);
		dumpEnclosingTypeName(type.getEnclosingTypeName(), MIN_LEVEL);
		dumpGenericSignature(type.getGenericSignature(), MIN_LEVEL);
		dumpInterfaceNames(MIN_LEVEL);
		dumpMemberTypes(MIN_LEVEL);
		dumpFields(MIN_LEVEL);
		dumpMethods(MIN_LEVEL);
		dumpMissingTypeNames(MIN_LEVEL);	
	}

	/*
	 * Dumps the given annotation array if there are any. Otherwise does nothing.
	 */
	public void dumpAnnotations(IBinaryAnnotation[] annotations, int lvl) throws IOException {
		if (annotations != null) {
			
			if (!dumpAnyAnnotationsActually(annotations))
				return;
			
			Arrays.sort(annotations, new Comparator<IBinaryAnnotation>(){
			    public int compare(IBinaryAnnotation a1, IBinaryAnnotation a2) {
			    	String tn1 = new String(a1.getTypeName());
			    	String tn2 = new String(a2.getTypeName());
	                return tn1.compareTo(tn2); 
			    }
			});
			writelnIndented(ANNOTATIONS, lvl);
			for (int i = 0; i < annotations.length; i++) {
				dumpAnnotation(annotations[i], lvl + 1);
			}
			delim(lvl);
		}
	}
	
	/*
	 * Dumps the given IBinaryAnnotation to the out as a text.
	 */
	public void dumpAnnotation(IBinaryAnnotation annot, int lvl) throws IOException {
		if (!config.dumpRuntimeInvisibleAnnots && !isRuntimeVisible(annot))
			return;
		
		writelnIndented(annot.getTypeName(), lvl);
		
		IBinaryElementValuePair[] pairs = annot.getElementValuePairs();
		if (pairs != null) {
			Arrays.sort(pairs, new Comparator<IBinaryElementValuePair>(){
			    public int compare(IBinaryElementValuePair evp1, IBinaryElementValuePair evp2) {
			    	String n1 = new String(evp1.getName());
			    	String n2 = new String(evp2.getName());
	                return n1.compareTo(n2); 
			    }
			});
			for (IBinaryElementValuePair pair : pairs) {
				dumpElementValuePair(pair, lvl + 1);
			}
		}
	}
	
	/*
	 * Dumps the given element-value pair to the out a a text.
	 */
	public void dumpElementValuePair(IBinaryElementValuePair pair, int lvl) throws IOException {
		writeIndented(pair.getName(), lvl);
		out.write("=" + stringToDump(pair.getValue()) + "\n");
	}
	
	/*
	 * Dumps the enclosing method of this type if there is any. Otherwise does
	 * nothing.
	 */
	public void dumpEnclosingMethod(int lvl) throws IOException {
		char[] enclMethod = type.getEnclosingMethod();
		if (enclMethod != null) {
			writeIndented(ENCLOSING_METHOD, lvl);
			out.write(enclMethod);
			out.write("\n");
		}
	}
	
	/*
	 * Dumps the enclosing type name if there is any. If this type is 
	 * a top-level type, this method does nothing.
	 */
	public void dumpEnclosingTypeName(char[] etn, int lvl) throws IOException {
		if (etn != null) {
			writeIndented(ENCLOSING_TYPE_NAME, lvl);
			out.write(etn);
			out.write("\n");
		}
	}
	
	/*
	 * Dumps the fields of this type if there are any.
	 */
	public void dumpFields(int lvl) throws IOException {
		IBinaryField[] fields = filterFields(type.getFields());
		if (fields != null) {
			Arrays.sort(fields, new Comparator<IBinaryField>(){
			    public int compare(IBinaryField ibf1, IBinaryField ibf2) {
			    	String fn1 = new String(ibf1.getName());
			    	String fn2 = new String(ibf2.getName());
	                return fn1.compareTo(fn2); 
			    }
			});
			writelnIndented(FIELDS, lvl);
			for (int i = 0; i < fields.length; i++) {
				dumpField(fields[i], lvl + 1);
			}
			delim(lvl);
		}	
	}
		
	/*
	 * Dumps the given IBinaryField to the out as a text.
	 */
	public void dumpField(IBinaryField field, int lvl) throws IOException {
		writeIndented(field.getTypeName(), lvl);
		out.write(" ");
		out.write(field.getName());
		out.write("\n");
		dumpGenericSignature(field.getGenericSignature(), lvl);
		
		if (config.dumpFieldConstant) {
			Constant constant = field.getConstant();
			if (constant != null)
				writelnIndented(FIELD_CONST + stringToDump(constant), lvl);
		}
		dumpTagBits(field.getTagBits(), lvl);
		dumpAnnotations(field.getAnnotations(), lvl);
		delim(lvl);
	}

	/*
	 * Dumps the given generic signature if there is any.
	 */
	public void dumpGenericSignature(char[] genSig, int lvl) throws IOException {
		if (genSig != null) {
			writeIndented(GENERIC_SIGNATURE, lvl);
			out.write(genSig);
			out.write("\n");
		}
	}
	
	/*
	 * Dumps the interface names of this type if there are any.
	 */
	public void dumpInterfaceNames(int lvl) throws IOException {
		char[][] ifaceNames = type.getInterfaceNames();
		if (ifaceNames != null) {
			Arrays.sort(ifaceNames, new Comparator<char[]>(){
			    public int compare(char[] if1, char[] if2) {
			    	String in1 = new String(if1);
			    	String in2 = new String(if2);
	                return in1.compareTo(in2); 
			    }
			});
			writelnIndented(INTERFACE_NAMES, lvl);
			for (int i = 0; i < ifaceNames.length; i++) {
				writelnIndented(ifaceNames[i], lvl + 1);
			}
			delim(lvl);
		}	
	}
	
	/*
	 * Dumps the member types of this type if there are any.
	 */
	public void dumpMemberTypes(int lvl) throws IOException {
		IBinaryNestedType[] memberTypes = type.getMemberTypes();
		if (memberTypes != null) {
			writelnIndented(MEMBER_TYPES, lvl);
			Arrays.sort(memberTypes, new Comparator<IBinaryNestedType>(){
			    public int compare(IBinaryNestedType ibnt1, IBinaryNestedType ibnt2) {
			    	String name1 = new String(ibnt1.getName());
			    	String name2 = new String(ibnt2.getName());
	                return name1.compareTo(name2); 
			    }
			});
			for (int i = 0; i < memberTypes.length; i++) {
				dumpNestedType(memberTypes[i], lvl + 1);
			}
			delim(lvl);
		}	
	}
	
	/*
	 * Dumps the given IBinaryNestedType to the out as a text.
	 */
	public void dumpNestedType(IBinaryNestedType nestType, int lvl) throws IOException {
		writelnIndented(nestType.getName(), lvl);
		writelnIndented(MODIFIERS + nestType.getModifiers(), lvl);
		dumpEnclosingTypeName(nestType.getEnclosingTypeName(), lvl);
		delim(lvl);
	}
	
	/*
	 * Dumps the methods of this type if there are any.
	 */
	public void dumpMethods(int lvl) throws IOException {
		IBinaryMethod[] methods = filterMethods(type.getMethods());
		if (methods != null) {
			if (!config.dumpStaticInitializer && methods.length == 1 && methods[0].isClinit())
				return;
			
			writelnIndented(METHODS, lvl);
			Arrays.sort(methods, new Comparator<IBinaryMethod>(){
			    public int compare(IBinaryMethod ibm1, IBinaryMethod ibm2) {
			    	String mn1 = new String(ibm1.getSelector()) + new String(ibm1.getMethodDescriptor());
			    	String mn2 = new String(ibm2.getSelector()) + new String(ibm2.getMethodDescriptor());
	                   // this method should return < 0, 0 or > 0 
	                   // whether obj1 is less than, equal to 
	                   // or greater than obj2
	                   return mn1.compareTo(mn2); 
			    }
			});
			for (int i = 0; i < methods.length; i++) {
				dumpMethod(methods[i], lvl + 1);
			}
			delim(lvl);
		}	
	}
	
	/*
	 * Dumps the given IBinaryMethod to the out as a text.
	 */
	public void dumpMethod(IBinaryMethod method, int lvl) throws IOException {
		if (!config.dumpStaticInitializer && method.isClinit()) return;
		
		writeIndented(method.getSelector(), lvl);
		out.write(method.getMethodDescriptor());
		out.write("\n");
		writeIndented(IS_CLINIT, lvl);
		if (method.isClinit())
			out.write(YES + "\n");
		else
			out.write(NO + "\n");
		
		dumpGenericSignature(method.getGenericSignature(), lvl);
		dumpTagBits(method.getTagBits(), lvl);
		Object dv = method.getDefaultValue();
		if (dv != null)
			writelnIndented(DEFAULT_VALUE + stringToDump(dv), lvl);
		dumpAnnotations(method.getAnnotations(), lvl);
		
		char[][] exceptionTypeNames = method.getExceptionTypeNames();
		if (exceptionTypeNames != null && exceptionTypeNames.length > 0) {
			writelnIndented(EXCEPTION_TYPE_NAMES, lvl + 1);
			for (char[] etn : exceptionTypeNames)
				writelnIndented(etn, lvl + 1);
			delim(lvl + 1);
		}
		
		int annotParamsCnt = method.getAnnotatedParametersCount();		
		int paramsWithAnnotsToDump = 0;
		for (int i = 0; i < annotParamsCnt; i++) {
			if (dumpAnyAnnotationsActually(method.getParameterAnnotations(i))) {
				paramsWithAnnotsToDump++;
			}
		}		
		writelnIndented(ANNOTATED_PARAMS_CNT + paramsWithAnnotsToDump, lvl);
		if (paramsWithAnnotsToDump > 0) {
			writelnIndented(PARAMETER_ANNOTATIONS, lvl);
			for (int i = 0; i < annotParamsCnt; i++) 
				dumpAnnotations(method.getParameterAnnotations(i), lvl + 1);
		}
	
		delim(lvl);
	}
	
	/*
	 * Dumps the missing type names of this type. (not supported by 
	 * the ReflectiveType currently)
	 */
	public void dumpMissingTypeNames(int lvl) throws IOException {
		// TODO
	}
	
	/*
	 * Dumps the name of this type.
	 */
	public void dumpName(int lvl) throws IOException {
		char[] name = type.getName();
		if (name != null) {
			writeIndented(NAME, lvl);
			out.write(name);
			out.write("\n");
		}
	}
	
	/*
	 * Dumps the source name of this type. Does nothing for anonymous classes.
	 */
	public void dumpSourceName(int lvl) throws IOException {
		if (type.isAnonymous())
			return;
		
		char[] sourceName = type.getSourceName();
		if (sourceName != null) {
			writeIndented(SOURCE_NAME, lvl);
			out.write(sourceName);
			out.write("\n");
		}
	}
	
	/*
	 * Dumps the superclass name of this type if there is any.
	 */
	public void dumpSuperclassName(int lvl) throws IOException {
		char[] superclassName = type.getSuperclassName();
		if (superclassName != null) {
			writeIndented(SUPERCLASS_NAME, lvl);
			out.write(superclassName);
			out.write("\n");
		}
	}
	
	/*
	 * Dumps the given tag bits.
	 */
	public void dumpTagBits(long tagBits, int lvl) throws IOException {
		writeIndented(TAG_BITS, lvl);
		out.write(Long.toBinaryString(tagBits) + "\n");	
	}
	
	/*
	 * Dumps an information whether this type is an anonymous class or not.
	 */
	public void dumpIsAnonymous(int lvl) throws IOException {
		writeIndented(IS_ANONYMOUS, lvl);
		if (type.isAnonymous()) {
			out.write(YES + "\n");
		} else {
			out.write(NO + "\n");
		}
	}
	
	/*
	 * Dumps an information whether this type is a local class or not.
	 */
	public void dumpIsLocal(int lvl) throws IOException {
		writeIndented(IS_LOCAL, lvl);
		if (type.isLocal()) {
			out.write(YES + "\n");
		} else {
			out.write(NO + "\n");
		}
	}
	
	/*
	 * Dumps an information whether this type is a member class or not.
	 */
	public void dumpIsMember(int lvl) throws IOException {
		writeIndented(IS_MEMBER, lvl);
		if (type.isMember()) {
			out.write(YES + "\n");
		} else {
			out.write(NO + "\n");
		}
	}
	
	/*
	 * Dumps the source file name of this type if available.
	 */
	public void dumpSourceFileName(int lvl) throws IOException {
		if (config.dumpSourceFileName) {
			char[] sourceFileName = type.sourceFileName();
			if (sourceFileName != null) {
				writeIndented(SOURCE_FILE_NAME, lvl);
				out.write(sourceFileName);
				out.write("\n");
			}		
		}
	}
	
	
	
	
	
	private static byte[] extractBytes(InputStream inputStream) throws IOException {	
		ByteArrayOutputStream baos = new ByteArrayOutputStream();				
		byte[] buffer = new byte[1024];
		int read = 0;
		while ((read = inputStream.read(buffer, 0, buffer.length)) != -1) {
			baos.write(buffer, 0, read);
		}		
		baos.flush();		
		return  baos.toByteArray();
	}
	
	/**
	 * Dumps the given class to the given BufferedWriters using both 
	 * ReflectiveType and ClassFileReader. Returns true, if both dumps
	 * are the same, meaning that ReflectiveType returns same information
	 * as original Eclipse's ClassReader. 
	 * 
	 * @param clazz class to be dumped
	 * @param bwR buffered reader for the ReflectiveType
	 * @param bwCR buffered reader for the ClassFileReader
	 * @throws IOException 
	 * @throws ClassFormatException 
	 * @return true if both dumps are the same (byte-identical), false otherwise.
	 */
	private static boolean dumpClass(Class<?> c, BufferedWriter bwR, BufferedWriter bwCR) throws IOException, ClassFormatException {
		Writer classDumpBufferRT = new StringWriter();
		Writer classDumpBufferCR = new StringWriter();
		
		System.out.print("Dumping " + c.getName() + "...");
		
		BinaryDumper dumperReflective = new BinaryDumper(new ReflectiveType(c), classDumpBufferRT);
		ClassLoader cl = c.getClassLoader();
		if (cl == null) { 
			cl = ClassLoader.getSystemClassLoader();
		}
		
		String cfilename = c.getName().replace('.', '/') + ".class";
		byte[] classFileBytes = extractBytes(cl.getResourceAsStream(cfilename));
		BinaryDumper dumperClassReader = new BinaryDumper(new ClassFileReader(classFileBytes, null), classDumpBufferCR);		
		
		dumperReflective.dump();
		dumperClassReader.dump();
		
		bwR.append(classDumpBufferRT.toString());
		bwCR.append(classDumpBufferCR.toString());
		
		if (classDumpBufferRT.toString().equals(classDumpBufferCR.toString())) {
			System.out.println("done (OK)");
			return true;
		} else {
			System.out.println("done (!!! OUTPUT DIFFER !!!)");
			return false;
		}
	}
	
	// The first argument must be the output directory, the following arguments
	// should be a list of class names and/or jar files. 
	// Every class listed and every class in every jar file will be dumped
	// to reflective.txt and classReader.txt files in the output directory.
	public static void main(String [] args) throws IOException, ClassFormatException, ClassNotFoundException {
		
		if (args.length == 0) {
			System.out.println("No arguments provided. Nothing to do.");
			System.exit(0);
		}
		
		// prepare the output files
		String outputDirName = args[0];
		File outputDir = new File(outputDirName);
		if (!outputDir.exists() || !outputDir.isDirectory()) {
			System.out.println("The output directory doesn't exist or isn't a directory.");
			System.exit(0);
		}
		if (!outputDirName.endsWith("/")) {
			outputDirName += "/";
		}
		
		final String filenameReflective = outputDirName + "reflective.txt";
		final String filenameClassReader = outputDirName + "classReader.txt";
		
		File fileReflective = new File(filenameReflective);
		File fileClassReader = new File(filenameClassReader);
		
		if (!fileReflective.exists()) {
				fileReflective.createNewFile();
		}
		if (!fileClassReader.exists()) {
				fileClassReader.createNewFile();
		}
		
		FileWriter fwReflective = new FileWriter(fileReflective.getAbsoluteFile());
		BufferedWriter bwReflective = new BufferedWriter(fwReflective);
		FileWriter fwClassReader = new FileWriter(fileClassReader.getAbsoluteFile());
		BufferedWriter bwClassReader = new BufferedWriter(fwClassReader);
		
		// go through the rest of the arguments and dump it		
		for (int i = 1; i < args.length; i++) {
			if (args[i].endsWith(".jar")) {
				JarFile jarFile = new JarFile(args[i]);
	            Enumeration<JarEntry> entries = jarFile.entries();

	            URL[] urls = { new URL("jar:file:" + args[i]+"!/") };
	            ClassLoader cl = URLClassLoader.newInstance(urls);
	            
	            int classesProcessed = 0;	           
	            ArrayList<String> classesFailed = new ArrayList<String>();
	            ArrayList<String> classesError = new ArrayList<String>();

	            while (entries.hasMoreElements()) {
	                JarEntry entry = (JarEntry) entries.nextElement();
	                if(entry.isDirectory() || !entry.getName().endsWith(".class")){
	                    continue;
	                }
	                
	                String className = entry.getName();
	                // get rid of the ending ".class" 
	                className = className.substring(0, className.length() - ".class".length());
	                className = className.replace('/', '.');
	                classesProcessed++;
	                
	                try {	                
	                	Class<?> c = cl.loadClass(className);	               	               
	                	if (! dumpClass(c, bwReflective, bwClassReader)) {
	                		classesFailed.add(className);	                
	                	}
	                } catch (Exception e) {
	                	System.out.println("Dumping " + className + "...EXCEPTION (" + e.getClass().getName() + ": " + e.getMessage());
	                	classesError.add(className);
	                } catch (Error e) {
	                	System.out.println("Dumping " + className + "...ERROR (" + e.getClass().getName() + ": " + e.getMessage());
	                	classesError.add(className);
	                }
	            }	            
	            jarFile.close();
	            if (classesFailed.size() > 0) {
	            	System.out.println();
	            	System.out.println();
	            	for (String name : classesFailed) {
	            		System.out.println("DIFFERENT: " + name);
	            	}
	            	
	            	for (String name : classesError) {
	            		System.out.println("ERROR: " + name);
	            	}
	            	
	            	System.out.println();
	            	System.out.println(
	            			"Classes: " + classesProcessed +
	            			", OK: " + (classesProcessed - classesFailed.size() - classesError.size()) +
	            			", Different: " + classesFailed.size() + 
	            			", Error: " + classesError.size());
	            }
	            
			} else {
				// not jar file -> considered a class name
				Class<?> c;
				try {
					c = Class.forName(args[i]);
				} catch (ClassNotFoundException e) {
					System.out.println("Class " + args[i] + " not found.");
					continue;
				}
				dumpClass(c, bwReflective, bwClassReader);
			}
		}
		
		System.out.println("Done.");
		bwReflective.close();
		bwClassReader.close();
	}
}
