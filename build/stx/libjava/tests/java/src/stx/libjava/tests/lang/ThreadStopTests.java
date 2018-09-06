package stx.libjava.tests.lang;

import static org.junit.Assert.*;

import org.junit.Test;

@stx.libjava.annotation.Package("stx:libjava/tests")
public class ThreadStopTests {
    
    protected void giveUp() {
        try {
            Thread.sleep(100);
        } catch (InterruptedException ie) {
            // Lovely, really. Very Javaish.  
        }
    }
    
    @Test
    public void test_kill_02() {
        Worker worker = new Worker();
        Thread workerT = new Thread(worker);
        
        workerT.start();
        try {
            Thread.sleep(100);
        } catch (InterruptedException ie) {
            // Do nothing. I love this Java idiom! 
        }
        workerT.interrupt();
        workerT.stop();
        giveUp();
                
        assertTrue(worker.started);
        assertTrue(worker.killed);
        assertFalse(worker.aborted);
        assertFalse(worker.finished);
    }

    @Test
    public void test_kill_01() {
        Worker worker = new Worker();
        Thread workerT = new Thread(worker);
        
        workerT.start();
        try {
            Thread.sleep(100);
        } catch (InterruptedException ie) {
            // Do nothing. I love this Java idiom! 
        }
        workerT.stop();
        giveUp();
                
        assertTrue(worker.started);
        assertTrue(worker.killed);
        assertFalse(worker.aborted);
        assertFalse(worker.finished);
    }
    
    @Test
    public void test_abort_02() {
        Worker worker = new Worker();
        Thread workerT = new Thread(worker);
        
        workerT.start();
        try {
            Thread.sleep(100);
        } catch (InterruptedException ie) {
            // Do nothing. I love this Java idiom! 
        }
        workerT.interrupt();
        workerT.stop(new AbortSignal());
        giveUp();
                
        assertTrue(worker.started);
        assertFalse(worker.killed);
        assertTrue(worker.aborted);
        assertFalse(worker.finished);
    }

    @Test
    public void test_abort_01() {
        Worker worker = new Worker();
        Thread workerT = new Thread(worker);
        
        workerT.start();
        try {
            Thread.sleep(100);
        } catch (InterruptedException ie) {
            // Do nothing. I love this Java idiom! 
        }
        workerT.stop(new AbortSignal());
        giveUp();
                
        assertTrue(worker.started);
        assertFalse(worker.killed);
        assertTrue(worker.aborted);
        assertFalse(worker.finished);
    }
    
    
    class AbortSignal extends Error {
    }
    
    class Worker implements Runnable {
        public boolean started = false;
        public boolean killed = false;
        public boolean aborted = false;
        public boolean finished = false;

        @Override
        public void run() {
            started = true;
            try {
                work();
                finished = true;
                return;
            } catch (AbortSignal ae) {
                aborted = true;
                return;
            } catch (ThreadDeath td) {
                killed = true;
                throw td;
            }           
        }
        
        public void work() {
            // Just to keep thread busy for some time
            for (int i = 1; i < 3; i++) {
                try {
                    Thread.sleep(1000);
                } catch (InterruptedException ie) {
                    // Simulate a bad guy
                    i--;
                } catch (Exception e) {
                    // Simulate a really bad guy
                    i--;
                }
            }
        }
    }

}
