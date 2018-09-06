package stx.libjava.examples;

/**
 * A simple program to exercise semantics of exception
 * handling in Java. 
 * 
 * @author Jan Vrany
 *
 */

@stx.libjava.annotation.Package("stx:libjava/examples")
public class HelloExceptions {
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
	
	public void run(String[] args) {
		String hello;
		try {
			hello = this.compose(args[0]);
			System.out.println(hello);
		} catch (RuntimeException e) {
			System.out.println("Pity, seems he doesn't like you.");
		}
		
	}
		
	public static void main(String[] args) {
		HelloExceptions hello = new HelloExceptions();
		hello.run(args);
	}
}
