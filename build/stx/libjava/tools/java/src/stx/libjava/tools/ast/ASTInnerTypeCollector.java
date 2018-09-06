package stx.libjava.tools.ast;

import java.util.ArrayList;
import java.util.HashMap;

import org.eclipse.jdt.internal.compiler.ASTVisitor;
import org.eclipse.jdt.internal.compiler.ast.TypeDeclaration;
import org.eclipse.jdt.internal.compiler.lookup.BlockScope;
import org.eclipse.jdt.internal.compiler.lookup.ClassScope;
import org.eclipse.jdt.internal.compiler.lookup.CompilationUnitScope;

/**
 * 
 * 
 * @author Jan Vrany <jan.vrany@fit.cvut.cz>
 *
 */
@stx.libjava.annotation.Package("stx:libjava/tools")
public class ASTInnerTypeCollector extends ASTVisitor {
	public HashMap<TypeDeclaration, ArrayList<TypeDeclaration>> innerTypeMap = new HashMap<TypeDeclaration, ArrayList<TypeDeclaration>>();
	private TypeDeclaration[] typeStack = new TypeDeclaration[100];
	private int               typeStackDepth = 0;
	
	public HashMap<TypeDeclaration, ArrayList<TypeDeclaration>> getInnerTypeMap() {
		return innerTypeMap;
	}
	
	private void typeStackPush(TypeDeclaration type) {
		if (typeStackDepth > 0) {
			TypeDeclaration parent = typeStack[typeStackDepth-1];
			ArrayList<TypeDeclaration> innerTypes = innerTypeMap.get(parent);
			if (innerTypes == null) {
				innerTypes = new ArrayList<TypeDeclaration>();
				innerTypeMap.put(parent, innerTypes);
			}
			innerTypes.add(type);
		}
		typeStack[typeStackDepth++] = type;
	}
	private void typeStackPop(TypeDeclaration type) {
		typeStack[--typeStackDepth] = null;
	}
	
	
	
	public boolean visit(TypeDeclaration typeDeclaration, CompilationUnitScope scope) {
		typeStackPush(typeDeclaration);
		return true;
	}
	
	@Override
    public boolean visit(TypeDeclaration localTypeDeclaration, BlockScope scope) {
		typeStackPush(localTypeDeclaration);
		return true;
	}
	
	public boolean visit(TypeDeclaration memberTypeDeclaration, ClassScope scope) {
		typeStackPush(memberTypeDeclaration);
		return true;
	}
	
	public void endVisit(TypeDeclaration localTypeDeclaration, BlockScope scope) {
		typeStackPop(localTypeDeclaration);
	}

	public void endVisit(TypeDeclaration memberTypeDeclaration, ClassScope scope) {
		typeStackPop(memberTypeDeclaration);
	}

	public void endVisit(TypeDeclaration typeDeclaration, CompilationUnitScope scope) {
		typeStackPop(typeDeclaration);
	}	

}
