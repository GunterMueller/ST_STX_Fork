package stx.libjava.examples;

/**
 * A classical 'Hello World' program in Java. Nothing
 * special, but imagine the feeling when you first
 * run such a program on your own Java virtual machine
 * implementation :-)
 * 
 * @author Jan Vrany
 *
 */

@stx.libjava.annotation.Package("stx:libjava/examples")
public class HelloWorld {
	public void sayHello(String name) {
		System.out.println("Hello " + name);
   }
  
	public static void main(String[] args) { 
		new HelloWorld().sayHello(args[0]);
	}
}
