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

import java.util.HashSet;

@stx.libjava.annotation.Package("stx:libjava/tools")
public class BinaryDumperConfig {
	public static final String CONFIG_PREFIX="IBinaryDumper";
	
	public static boolean getDefaultBooleanValue(String key, boolean def) {
		
		String value = System.getProperty(key);
		if (value == null) return def;
		return Boolean.parseBoolean(value);
	}
	
	
	public boolean dumpStaticInitializer = getDefaultBooleanValue("dumpStaticInitializer", false);
	public boolean dumpSourceFileName = getDefaultBooleanValue("dumpSourceFileName", false);
	public boolean dumpFieldConstant = getDefaultBooleanValue("dumpFieldConstant", false);
	
	// false -> dump only annotations with RetentionPolicy.RUNTIME
	public boolean dumpRuntimeInvisibleAnnots = getDefaultBooleanValue("dumpRuntimeInvisibleAnnots", false);
	
	// JDK filters some fields and methods - should the dumper filter them too?
	public boolean filterFields = getDefaultBooleanValue("filterFields", true);
	public boolean filterMethods = getDefaultBooleanValue("filterMethods", true);

	public HashSet<MemberToFilter> fieldsToFilter;
	public HashSet<MemberToFilter> methodsToFilter;
	
	/**
	 * This method sets the members that will be filtered by the dumper.
	 * The members will be filtered only if the respective configuration
	 * options (filterFields and filterMethods) are set to true. Therefore it's
	 * possible to leave this method unchanged and still easily switch 
	 * the filtering off temporarily.
	 */
	void initializeMembersToFilter() {
		fieldsToFilter = new HashSet<MemberToFilter>();
		fieldsToFilter.add(new MemberToFilter("sun.reflect.Reflection", "fieldFilterMap"));
		fieldsToFilter.add(new MemberToFilter("sun.reflect.Reflection", "methodFilterMap"));
		fieldsToFilter.add(new MemberToFilter("sun.reflect.ConstantPool", "constantPoolOop"));
		fieldsToFilter.add(new MemberToFilter("sun.reflect.UnsafeStaticFieldAccessorImpl", "base"));
		fieldsToFilter.add(new MemberToFilter("java.lang.System", "security"));
		fieldsToFilter.add(new MemberToFilter("java.lang.Throwable", "backtrace"));
		
		methodsToFilter = new HashSet<MemberToFilter>();
		methodsToFilter.add(new MemberToFilter("sun.misc.Unsafe", "getUnsafe"));
	}
	
	public BinaryDumperConfig() {
		initializeMembersToFilter();
	}
}
