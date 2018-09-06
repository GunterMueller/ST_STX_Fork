package stx.libjava.tests.mocks.asm;

import org.objectweb.asm.MethodAdapter;
import org.objectweb.asm.MethodVisitor;

@stx.libjava.annotation.Package("stx:libjava/tests")
public class MethodRenamer extends MethodAdapter {
	  
	/****************************************************************************
	 * we only modify a name so two String attributes are enough
	 */
	private String oldName;
	private String newName;
	
	/****************************************************************************
	 * nothing to say...a super() constructor
	 * @param mv
	 */
	public MethodRenamer(MethodVisitor mv,String oldName, String newName){
		super(mv);
		this.oldName = oldName;
		this.newName = newName;
	}
		
	
	
	/****************************************************************************
	 * Visits a type instruction. 
	 * A type instruction is an instruction that takes a type descriptor as parameter.
	 * 
	 * @param opcode - the opcode of the type instruction to be visited. 
	 * This opcode is either NEW, ANEWARRAY, CHECKCAST or INSTANCEOF. 
	 * 
	 * @param desc - the operand of the instruction to be visited. 
	 * This operand is must be a fully qualified class name in internal form, 
	 * or the type descriptor of an array type (see Type).
	 */
	public void visitTypeInsn (int opcode, String desc) {
		if (oldName.equals(desc)) {
			desc = newName;
		}
		mv.visitTypeInsn(opcode, desc);
	}
	
	
	
	/****************************************************************************
	 * Visits a field instruction. 
	 * A field instruction is an instruction that loads or stores the value of a field of an object.
	 * 
	 * @param opcode - the opcode of the type instruction to be visited. 
	 * This opcode is either GETSTATIC, PUTSTATIC, GETFIELD or PUTFIELD. 
	 * @param owner - the internal name of the field's owner class (see getInternalName).
	 * @param name - the field's name.
	 * @param desc - the field's descriptor (see Type).
	 */	
	public void visitFieldInsn (int opcode, String owner, String name, String desc) {
		if (oldName.equals(owner)) {
			mv.visitFieldInsn(opcode, newName, name, fix(desc));
		} else {
			mv.visitFieldInsn(opcode, owner, name, fix(desc));
		}
	}
		
	
	
	/****************************************************************************
	 * Visits a method instruction. 
	 * A method instruction is an instruction that invokes a method.
	 * @param opcode - the opcode of the type instruction to be visited. 
	 * This opcode is either INVOKEVIRTUAL, INVOKESPECIAL, INVOKESTATIC or INVOKEINTERFACE.
	 * @param owner - the internal name of the method's owner class (see getInternalName).
	 * @param name - the method's name.
	 * @param desc - the method's descriptor (see Type).
	 */
	public void visitMethodInsn (int opcode, String owner, String name, String desc) {
		if (oldName.equals(owner)) {
			mv.visitMethodInsn(opcode, newName, name, fix(desc));
		} else {
			mv.visitMethodInsn(opcode, owner, name, fix(desc));
		}
	 }
	
	/****************************************************************************
	   * The fix method which change all the occurences of <tt>oldName<tt> with 
	   * <tt>newName</tt>. As the called method is <tt>String.replaceAll</tt>
	   * no ones can assure that it works perfectly for sure. But the fail rate 
	   * should be less that 0.0001%...
	   */
	  private String fix (String s) {
		  
		if (s != null) {
			if (s.contains(oldName)){
				s = s.replaceAll(oldName, newName);
			}
		}
		
		return s;
	  }
	
}
