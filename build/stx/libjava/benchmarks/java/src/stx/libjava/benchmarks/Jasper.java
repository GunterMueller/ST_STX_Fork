package stx.libjava.benchmarks;

import net.sf.jasperreports.engine.JasperCompileManager;
import net.sf.jasperreports.engine.JasperExportManager;
import net.sf.jasperreports.engine.JasperFillManager;
import net.sf.jasperreports.engine.JasperPrint;
import net.sf.jasperreports.engine.JasperReport;
import net.sf.jasperreports.engine.xml.JRXmlLoader;
import net.sf.jasperreports.engine.design.JasperDesign;

import java.io.OutputStream;
import java.io.ByteArrayOutputStream;
import java.util.Map;
import java.util.HashMap;

public class Jasper {

	public static void main(String[] args) throws Exception {
		int n = Integer.parseInt(args[0]);
		runBenchmarkJ(n);
		long time = runBenchmarkJ(n);
		System.out.println("EXECUTION TIME: " + time);
	}

	public static long runBenchmarkJ(int n) throws Exception {		
		OutputStream out = new ByteArrayOutputStream();
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("name", "Dr. Foo");
		map.put("address", "Foo Boulevard 42");
		map.put("city", "Fooville");
		map.put("sender", "Mr. Bar Baz");

		long start = System.currentTimeMillis();
		for (int i = 0; i < n; i++) {
			JasperDesign jasperDesign = JRXmlLoader.load(REPORT_PATH);			
			JasperReport report = JasperCompileManager.compileReport(jasperDesign);
			JasperPrint print = JasperFillManager.fillReport(report, map);
			JasperExportManager.exportReportToPdfStream(print, out);
		}
		long end = System.currentTimeMillis();
		long time = end - start;
		return time;
	}
	
	private static final String REPORT_PATH = "java/postcard.jrxml";
}
