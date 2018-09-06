package stx.libjava.examples;

/**
 * This example demonstrates how to use Smalltalk classes
 * from Groovy code. 
 * 
 * It creates an instance of Smalltalk class <code>ByteCodeCompiler</code>
 * and then use it to evaluate Smalltalk code from Groovy. 
 * 
 * In workspace, evaluate:
 * 
 * Smalltalk loadPackage:'stx:libjava/examples'.
 * Java flushAllJavaResources.
 * Java initialize.
 * JavaVM initializeVM.
 * evaluator := JAVA stx libjava examples SmalltalkEvaluator new.
 * evaluator evaluate: 'Transcript showCR:''Haya!'''
 */
class SmalltalkEvaluator {
	
	protected Object evaluator;
	
	public SmalltalkEvaluator() {		
		ClassLoader stcl = stx.libjava.ClassLoader.getSmalltalkClassLoader();
		evaluator = stcl.loadClass("SMALLTALK.ByteCodeCompiler").newInstance();		
	} 
	
	/**
	 * Evaluates given code in Smalltalk and returns result of evaluation 
	 * @param code A Smalltalk code to evaluate
	 * @return Result of evaluation.
	 */
	public Object evaluate(String code) {
		return evaluator.evaluate(code);
	}
	
	static main(String[] args) {
		SmalltalkEvaluator se = new SmalltalkEvaluator();
		for (int i = 1; i<args.size; i++) {
			System.out.println(se.evaluate(args[i]));
		}	
	}

}
