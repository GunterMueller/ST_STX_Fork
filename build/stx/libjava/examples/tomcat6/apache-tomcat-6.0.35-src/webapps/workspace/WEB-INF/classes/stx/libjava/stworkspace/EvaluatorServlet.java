package stx.libjava.stworkspace;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import stx.libjava.stworkspace.Evaluator;

/**
 *
 * @author Marcel Hlopko
 */
public class EvaluatorServlet extends HttpServlet {
	
	protected Evaluator evaluator;
	
	public EvaluatorServlet() {		
		try {
			evaluator = new Evaluator();		
		} catch (Throwable t) {
			t.printStackTrace();
			evaluator = null;
		}		
	}

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {        
		if (evaluator == null) {
        	resp.getWriter().println("No evaluator - failed to initialize?");
        	return;
        }
        
        String line;
        String data = "";
        BufferedReader reader = req.getReader();
        while ((line = reader.readLine()) != null) {
            data += line;
        }

        String language = data.substring(0, data.indexOf(';'));
        String code = data.substring(data.indexOf(';') + 1);
		int syntax;
        if ("smalltalk".equals(language) && evaluator.hasSmalltalkLanguageSupport()) {
            syntax = Evaluator.SYNTAX_SMALLTALK;
        } else if ("javascript".equals(language) && evaluator.hasJavaScriptLanguageSupport()) {
            syntax = Evaluator.SYNTAX_JAVASCRIPT;
        } else if ("groovy".equals(language) && evaluator.hasGroovyLanguageSupport()) {
            syntax = Evaluator.SYNTAX_GROOVY;
        } else {
			resp.getWriter().println(String.format("Hmmmm I have never heard of %s, give us a while, we will implement it on St/X soon :)", language));
			return;
		}
        try {
        	resp.getWriter().println(evaluator.evaluate(code, syntax));        	
        } catch (Throwable e) {
        	resp.getWriter().println(e.getMessage());
        	e.printStackTrace(resp.getWriter());
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws IOException, ServletException {
		response.setContentType("text/html");
		PrintWriter out = response.getWriter();

		out.println("<html>");
		out.println("<head>");
		out.println("<title>ERROR: POST only</title>");
		out.println("</head>");
		out.println("<body bgcolor=\"white\">");
		out.println("<div>ERROR: POST only!</div>");
		out.println("</body>");
		out.println("</html>");
	}
}
