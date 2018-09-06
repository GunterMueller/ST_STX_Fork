package stx.libjava.examples;

/**
 * A simple class to exercise Java finally semantics.
 * 
 * @author Jan Vrany
 */

@stx.libjava.annotation.Package("stx:libjava/examples")
public class HelloFinally {	
	/** 
	 * Return a string with greetings for @param who.  
	 */
	public String compose(String who) {
		if (who.equals("Smalltalk")) {
			throw new RuntimeException("Never ever!");
		} else {
			return "Hello, dear " + who;
		}
	}
	
	public void say(String s) {
		try {
			System.out.println(this.compose(s));
		} finally {
			System.out.println("I have to go. See you later!");
		}
	}
	
	public void run(String[] args) {		
		try {			
			this.say(args[0]);
		} catch (RuntimeException e) {
			System.out.println("Pity, seems he doesn't like you.");
		}
		
	}
	
	public static void main(String[] args) {
		HelloFinally hello = new HelloFinally();
		hello.run(args);
	}

}
