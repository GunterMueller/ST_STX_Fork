package stx.libjava.stworkspace;

/**
 *
 * @author Marcel Hlopko
 * @author Jan Vrany
 */
public class Evaluator {
	
    public static final int SYNTAX_SMALLTALK = 1;
	public static final int SYNTAX_JAVASCRIPT = 2;
	public static final int SYNTAX_GROOVY = 3;
	
	protected static runningOnStX = System.getProperty("java.vm.name").equals("Smalltalk/X"); 
	
	protected Object evaluatorSmalltalk;
	protected Object evaluatorJavaScript;
	protected Object evaluatorGroovy;
	
	public Evaluator() {
		if (runningOnStX) {
			ClassLoader stcl = stx.libjava.ClassLoader.getSmalltalkClassLoader();
			try {
				evaluatorSmalltalk = stcl.loadClass("SMALLTALK.ByteCodeCompiler").newInstance();
				evaluatorGroovy = stcl.loadClass("SMALLTALK.GroovyEvaluator").newInstance();
			} catch (ClassNotFoundException cnfe) {            
				evaluatorSmalltalk = evaluatorJavaScript = evaluatorGroovy = null;
				cnfe.printStackTrace();
				throw new RuntimeException(cnfe);
			} catch (InstantiationException ie) {
				evaluatorSmalltalk = evaluatorJavaScript = evaluatorGroovy = null;
				ie.printStackTrace();
				throw new RuntimeException(ie);
			} catch (Exception e) {
				evaluatorSmalltalk = evaluatorJavaScript = evaluatorGroovy = null;
				e.printStackTrace();
				throw new RuntimeException(e);
			}
              
            try {
                evaluatorJavaScript = stcl.loadClass("SMALLTALK.JavaScriptCompiler").newInstance();
            } catch (ClassNotFoundException cnfe) {
                // JavaScript is optional...            
                //evaluatorSmalltalk = evaluatorJavaScript = evaluatorGroovy = null;
                //cnfe.printStackTrace();
                //throw new RuntimeException(cnfe);
            } catch (InstantiationException ie) {
                evaluatorSmalltalk = evaluatorJavaScript = evaluatorGroovy = null;
                ie.printStackTrace();
                throw new RuntimeException(ie);
            } catch (Exception e) {
                evaluatorSmalltalk = evaluatorJavaScript = evaluatorGroovy = null;
                e.printStackTrace();
                throw new RuntimeException(e);
            }

		} 
	}
	
    public Object evaluate(String code, final int syntax) {
		if (! runningOnStX) {
			throw new RuntimeException("Sorry, not running in Smalltalk/X VM");
		}
		
		Object e = null;
		
    	switch (syntax) {
    	case SYNTAX_SMALLTALK:
    		e = evaluatorSmalltalk;
			break;    		
    	case SYNTAX_JAVASCRIPT:
			e = evaluatorJavaScript;
			break;
    	case SYNTAX_GROOVY:
			e = evaluatorGroovy;
			break;
    	default:
    		throw new RuntimeException("Unsuported syntax: " + syntax);    		
    	}
		
		if (e == null) {
			throw new RuntimeException("Null evaluator! Initialization failed?");
		}
		
		return e.evaluate(code);
    }
    
    public boolean hasSmalltalkLanguageSupport() {
        return evaluatorSmalltalk != null;
    }     
    
    public boolean hasJavaScriptLanguageSupport() {
        return evaluatorJavaScript != null;
    }
    
    public boolean hasGroovyLanguageSupport() {
        return evaluatorGroovy != null;
    }

}
