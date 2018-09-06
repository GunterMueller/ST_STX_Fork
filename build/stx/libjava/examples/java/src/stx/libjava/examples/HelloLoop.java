package stx.libjava.examples;

@stx.libjava.annotation.Package("stx:libjava/examples")
public class HelloLoop implements Runnable {
        protected int i;
	protected boolean stop;
	
	public void start() {
		stop = false;
                i = 0;
		Thread t = new Thread(this);
		t.start();
	}
	
	public void stop() {
		stop = true;
	}
	
	public void run() {
		while ( ! stop ) {
			try {
				hello();
				Thread.sleep(2000);
			} catch (InterruptedException e) {
			}
		}
	}
	
	protected void hello() {
		hello("XXXX");
	}
	
	protected void hello(String s) {
		System.out.println(s);		
	}
	
	public static void main(String[] args) {
		HelloLoop loop = new HelloLoop();
		loop.start();
		try {
			Thread.sleep(20000);
		} catch (InterruptedException e) {
		}
		loop.stop();
	}
	
	
}
