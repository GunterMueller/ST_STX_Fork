package stx.libjava.tests.mocks.asm;

import java.util.Iterator;
import java.util.Set;

import org.objectweb.asm.ClassAdapter;
import org.objectweb.asm.ClassVisitor;
import org.objectweb.asm.MethodAdapter;
import org.objectweb.asm.MethodVisitor;
import org.objectweb.asm.Opcodes;

@stx.libjava.annotation.Package("stx:libjava/tests")
public class ClassRenamer extends ClassAdapter implements Opcodes {

	// The old name of the class
	private String oldName;
	// The new name of the class
	private String newName;

	/****************************************************************************
	 * A ClassRenamer is composed of a ClassVisitor and the different names
	 * 
	 * @param cv
	 *            : a ClassVisitor which will visit the whole class.
	 * @param oldNames
	 *            : the old name
	 * @param newName
	 *            : the new one
	 */
	public ClassRenamer(ClassVisitor cv, String oldName, String newName) {
		super(cv);
		this.oldName = oldName;
		this.newName = newName;
	}

	/****************************************************************************
	 * the visit method which scans the class header.
	 * <dl>
	 * <dt>version</dt>
	 * <dd>??? the version of the method?</dd>
	 * <dt>access</dt>
	 * <dd>public, private of protected. The constant ACC_PUBLIC is 1 when
	 * ACC_PRIVATE is 2</dd>
	 * <dt>name</dt>
	 * <dd>the name of the class, so here is our first replacement</dd>
	 * </dl>
	 */
	public void visit(int version, int access, String name, String signature,
			String superName, String[] interfaces) {
		cv.visit(version, ACC_PUBLIC, newName, signature, superName, interfaces);
	}

	/****************************************************************************
	 * This method does the same work as the one before but, this time, in all
	 * methods. <br />
	 * I don't know the meaning of the if test yet.
	 * <ul>
	 * <li> <tt> desc </tt> - the method's descriptor, (public Class<?>
	 * methodName(args[]))</li>
	 * </ul>
	 */
	public MethodVisitor visitMethod(int access, String name, String desc,
			String signature, String[] exceptions) {

		MethodVisitor mv = cv.visitMethod(access, name, fix(desc),
				fix(signature), exceptions);
		// MethodVisitor mv = cv.visitMethod(access, name, (desc), (signature),
		// exceptions);
		// (access & ACC_ABSTRACT) is looking for whether the class is an
		// abstract class or not.
		// ACC_ABSTRACT = 1024 is the level of an abstract class.
		if (mv != null && (access != ACC_ABSTRACT)) {
			mv = (MethodVisitor)(new MethodRenamer(mv, oldName, newName));
		}
		return mv;

	}

	/****************************************************************************
	 * The fix method which change all the occurences of <tt>oldName<tt> with 
	 * <tt>newName</tt>. As the called method is <tt>String.replaceAll</tt> no
	 * ones can assure that it works perfectly for sure. But the fail rate
	 * should be less that 0.0001%...
	 */
	private String fix(String s) {

		if (s != null) {
			if (s.contains(oldName)) {
				s = s.replaceAll(oldName, newName);
			}
		}

		return s;
	}
}
