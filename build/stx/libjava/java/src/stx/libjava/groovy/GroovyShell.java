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
package stx.libjava.groovy;

import java.util.Iterator;
import java.util.Set;
import java.util.HashSet;

import groovy.lang.Binding;
import groovyjarjarasm.asm.tree.VarInsnNode;

import org.codehaus.groovy.ast.ASTNode;
import org.codehaus.groovy.ast.ClassCodeExpressionTransformer;
import org.codehaus.groovy.ast.ClassNode;
import org.codehaus.groovy.ast.ImportNode;
import org.codehaus.groovy.ast.expr.Expression;
import org.codehaus.groovy.ast.expr.VariableExpression;
import org.codehaus.groovy.classgen.GeneratorContext;
import org.codehaus.groovy.control.CompilationFailedException;
import org.codehaus.groovy.control.CompilePhase;
import org.codehaus.groovy.control.CompilerConfiguration;
import org.codehaus.groovy.control.SourceUnit;
import org.codehaus.groovy.control.customizers.ASTTransformationCustomizer;
import org.codehaus.groovy.control.customizers.CompilationCustomizer;
import org.codehaus.groovy.control.customizers.ImportCustomizer;
import org.codehaus.groovy.transform.ASTTestTransformation;
import org.codehaus.groovy.transform.ASTTransformation;
import org.codehaus.groovy.transform.GroovyASTTransformation;


/**
 * A customised GroovyShell that remembers all imports across multiple
 * evaluation. 
 * 
 * @author Jan Vrany <jan.vrany [at] fit.cvut.cz>
 *
 */
@stx.libjava.annotation.Package("stx:libjava")
public class GroovyShell extends groovy.lang.GroovyShell {
    
    protected AutoImporter importer;
   
    public GroovyShell() {
        this(null, new Binding());
    }

    public GroovyShell(Binding binding) {
        this(null, binding);
    }

    public GroovyShell(CompilerConfiguration config) {
        this(new Binding(), config);
    }

    public GroovyShell(Binding binding, CompilerConfiguration config) {
        this(null, binding, config);
    }

    public GroovyShell(ClassLoader parent, Binding binding) {
        this(parent, binding, CompilerConfiguration.DEFAULT);
    }

    public GroovyShell(ClassLoader parent) {
        this(parent, new Binding(), CompilerConfiguration.DEFAULT);
    }
    
    public GroovyShell(ClassLoader parent, Binding binding, final CompilerConfiguration config) {        
        super(parent,binding,config);
        importer = new AutoImporter();
        config.addCompilationCustomizers(importer);      
       	config.addCompilationCustomizers(new ASTTransformationCustomizer(new This2SelfTransformation()));
    }
    
    /**
     * Imports a given class so it is ready to use in successive evaluations. 
     * 
     * @param className fully qualified class name to import
     */
    public void addClassImport(String className) {
        importer.addImports(className);
    }
    
    /**
     * Imports all classes in given package so they are ready to use 
     * in successive evaluations. 
     * 
     * @param className fully qualified package name to import
     */
    public void addPackageImport(String className) {
        importer.addStarImports(className);
    }
 
    /**
     * An AST transformation that rewrites references to `this` to `self`.
     * 
     * Used to allow referencing inspected object as `this` when a code is evaluated
     * within an inspector or a debugger.  
     * 
     * @author Jan Vrany <jan.vrany [at] fit.cvut.cz>
     *
     */
    @GroovyASTTransformation(phase = CompilePhase.SEMANTIC_ANALYSIS)    
    public static class This2SelfTransformation implements ASTTransformation {
    	public void visit(ASTNode[] nodes, final SourceUnit source) {
    		ClassCodeExpressionTransformer transformer = new ClassCodeExpressionTransformer() {
				@Override
				protected SourceUnit getSourceUnit() {
					return source;
				}    			
				
				public Expression transform(Expression exp) {
			        if (exp == null) return null;
			        if (exp instanceof VariableExpression) {
			        	VariableExpression var = (VariableExpression)exp;
			        	/* 
			        	 * Here we only transform `this` node that is explicitly 
			        	 * in the source code (hence the test for line number != -1). 
			        	 * 
			        	 * The reason is that call to any helper function defined within
			        	 * evaluated code is compiled as self-send to the script object
			        	 * (function is actually a method in script class). To allow using
			        	 * helper functions, do not transform receiver of such calls.  
			        	 * 
			        	 * OTOH, when one explicitly writes something like `this.foo()`
			        	 *  assume she wants to invoke `foo()` on context object (`this`)
			        	 */
			        	if (var.isThisExpression() && var.getLineNumber() != -1) {
			        		return new VariableExpression("self");
			        	}
			        }
			        return exp.transformExpression(this);
			    }
    		};
    		for (ClassNode node : source.getAST().getClasses()) {
    			transformer.visitClass(node);				
			}
    	}
    }

    
    /**
     * A compiler customizer that search the code being evaluated and remembers
     * all imports so they are available in successively evaluated code. 
     *
     * @author Jan Vrany <jan.vrany [at] fit.cvut.cz>
     *
     */
    public static class AutoImporter extends ImportCustomizer {
        Set<String> classes = new HashSet<String>();
        Set<String> packages = new HashSet<String>();
        
        public void call(final SourceUnit source, final GeneratorContext context, final ClassNode classNode) throws CompilationFailedException {               
            super.call(source, context, classNode);
            
            for (Iterator<ImportNode> i = source.getAST().getImports().iterator(); i.hasNext();) {                            
                String name = i.next().getClassName();
                if ( ! classes.contains(name) ) {
                    classes.add(name);
                    this.addImports(name);                    
                }
            }
            for (Iterator<ImportNode> i = source.getAST().getStarImports().iterator(); i.hasNext();) {
                String name = i.next().getPackageName();
                if ( ! packages.contains(name) ) {
                    packages.add(name);
                    this.addStarImports(name);
                }
            }
        }
              
    }    
}
