package stx.libjava.tests.mocks.asm;

import org.objectweb.asm.ClassAdapter;
import org.objectweb.asm.ClassVisitor;
import org.objectweb.asm.FieldVisitor;

@stx.libjava.annotation.Package("stx:libjava/tests")
public class AddFieldAdapter extends ClassAdapter {
	private int fAcc;
	private String fName;
	private String fDesc;
	private boolean isFieldPresent;

	public AddFieldAdapter(ClassVisitor cv, int fAcc, String fName, String fDesc) {
		super(cv);
		this.fAcc = fAcc;
		this.fName = fName;
		this.fDesc = fDesc;
	}

	@Override
	public FieldVisitor visitField(int access, String name, String desc,
			String signature, Object value) {
		if (name.equals(fName)) {
			isFieldPresent = true;
		}
		return cv.visitField(access, name, desc, signature, value);
	}

	@Override
	public void visitEnd() {
		if (!isFieldPresent) {
			FieldVisitor fv = cv.visitField(fAcc, fName, fDesc, null, null);
			if (fv != null) {
				fv.visitEnd();
			}

			cv.visitEnd();
		}
	}
}
