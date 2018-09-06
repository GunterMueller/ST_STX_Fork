package stx.libjava.benchmarks;

import java.io.StringWriter;
import java.io.StringReader;
import net.sf.saxon.*;
import javax.xml.transform.*;
import javax.xml.transform.stream.*;

public class Saxon {
	
	public static void main(String[] args) {
		int n = Integer.parseInt(args[0]);
		runBenchmarkJ(n);
		long time = runBenchmarkJ(n);
		System.out.println("EXECUTION TIME: " + time);
	}
	public static long runBenchmarkJ(int n) {
		long start = System.currentTimeMillis();
		for (int i = 0; i < n; i++) {
			try {
				Configuration config = new Configuration();
				config.setAllNodesUntyped(true);
				TransformerFactoryImpl factory = new TransformerFactoryImpl(config);
				Templates stylesheet = factory.newTemplates(new StreamSource(new StringReader(xsl)));
				Transformer transformer = stylesheet.newTransformer();
				
				StreamSource source = new StreamSource(new StringReader(xml));
				StreamResult result = new StreamResult(new StringWriter());
				
				transformer.transform(source, result);
				
			} catch (TransformerConfigurationException e) {
				e.printStackTrace();
			} catch (TransformerException te) {
				te.printStackTrace();
			}
		}
		long end = System.currentTimeMillis();
		long time = end - start;
		return time;
	}
	
	public static String xsl = "<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?><xsl:stylesheet version=\"1.0\" xmlns:xsl=\"http://www.w3.org/1999/XSL/Transform\"><xsl:template match=\"/\"><html><body><h2>My CD Collection</h2><table border=\"1\"><tr bgcolor=\"#9acd32\"><th>Title</th><th>Artist</th></tr><xsl:for-each select=\"catalog/cd\"><tr><td><xsl:value-of select=\"title\"/></td><td><xsl:value-of select=\"artist\"/></td></tr></xsl:for-each></table></body></html></xsl:template></xsl:stylesheet>";
	public static String xml = "<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?><catalog>        <cd>            <title>Empire Burlesque</title>         <artist>Bob Dylan</artist>              <country>USA</country>          <company>Columbia</company>             <price>10.90</price>            <year>1985</year>       </cd>   <cd>            <title>Hide your heart</title>          <artist>Bonnie Tyler</artist>           <country>UK</country>           <company>CBS Records</company>          <price>9.90</price>             <year>1988</year>       </cd>   <cd>            <title>Greatest Hits</title>            <artist>Dolly Parton</artist>           <country>USA</country>          <company>RCA</company>          <price>9.90</price>             <year>1982</year>       </cd>   <cd>            <title>Still got the blues</title>              <artist>Gary Moore</artist>             <country>UK</country>           <company>Virgin records</company>               <price>10.20</price>            <year>1990</year>       </cd>   <cd>            <title>Eros</title>             <artist>Eros Ramazzotti</artist>                <country>EU</country>           <company>BMG</company>          <price>9.90</price>             <year>1997</year>       </cd>   <cd>            <title>One night only</title>           <artist>Bee Gees</artist>               <country>UK</country>           <company>Polydor</company>              <price>10.90</price>            <year>1998</year>       </cd>   <cd>            <title>Sylvias Mother</title>           <artist>Dr.Hook</artist>                <country>UK</country>           <company>CBS</company>          <price>8.10</price>             <year>1973</year>       </cd>   <cd>            <title>Maggie May</title>               <artist>Rod Stewart</artist>            <country>UK</country>           <company>Pickwick</company>             <price>8.50</price>             <year>1990</year>       </cd>   <cd>            <title>Romanza</title>          <artist>Andrea Bocelli</artist>         <country>EU</country>           <company>Polydor</company>              <price>10.80</price>            <year>1996</year>       </cd>   <cd>            <title>When a man loves a woman</title>         <artist>Percy Sledge</artist>           <country>USA</country>          <company>Atlantic</company>             <price>8.70</price>             <year>1987</year>       </cd>   <cd>            <title>Black angel</title>              <artist>Savage Rose</artist>            <country>EU</country>           <company>Mega</company>         <price>10.90</price>            <year>1995</year>       </cd>   <cd>            <title>1999 Grammy Nominees</title>             <artist>Many</artist>           <country>USA</country>          <company>Grammy</company>               <price>10.20</price>            <year>1999</year>       </cd>   <cd>            <title>For the good times</title>               <artist>Kenny Rogers</artist>           <country>UK</country>           <company>Mucik Master</company>         <price>8.70</price>             <year>1995</year>       </cd>   <cd>            <title>Big Willie style</title>         <artist>Will Smith</artist>             <country>USA</country>          <company>Columbia</company>             <price>9.90</price>             <year>1997</year>       </cd>   <cd>            <title>Tupelo Honey</title>             <artist>Van Morrison</artist>           <country>UK</country>           <company>Polydor</company>              <price>8.20</price>             <year>1971</year>       </cd>   <cd>            <title>Soulsville</title>               <artist>Jorn Hoel</artist>              <country>Norway</country>               <company>WEA</company>          <price>7.90</price>             <year>1996</year>       </cd>   <cd>            <title>The very best of</title>         <artist>Cat Stevens</artist>            <country>UK</country>           <company>Island</company>               <price>8.90</price>             <year>1990</year>       </cd>   <cd>            <title>Stop</title>             <artist>Sam Brown</artist>              <country>UK</country>           <company>A and M</company>              <price>8.90</price>             <year>1988</year>       </cd>   <cd>            <title>Bridge of Spies</title>          <artist>T`Pau</artist>          <country>UK</country>           <company>Siren</company>                <price>7.90</price>             <year>1987</year>       </cd>   <cd>            <title>Private Dancer</title>           <artist>Tina Turner</artist>            <country>UK</country>           <company>Capitol</company>              <price>8.90</price>             <year>1983</year>       </cd>   <cd>            <title>Midt om natten</title>           <artist>Kim Larsen</artist>             <country>EU</country>           <company>Medley</company>               <price>7.80</price>             <year>1983</year>       </cd>   <cd>            <title>Pavarotti Gala Concert</title>           <artist>Luciano Pavarotti</artist>              <country>UK</country>           <company>DECCA</company>                <price>9.90</price>             <year>1991</year>       </cd>   <cd>            <title>The dock of the bay</title>              <artist>Otis Redding</artist>           <country>USA</country>          <company>Atlantic</company>             <price>7.90</price>             <year>1987</year>       </cd>   <cd>            <title>Picture book</title>             <artist>Simply Red</artist>             <country>EU</country>           <company>Elektra</company>              <price>7.20</price>             <year>1985</year>       </cd>   <cd>            <title>Red</title>              <artist>The Communards</artist>         <country>UK</country>           <company>London</company>               <price>7.80</price>             <year>1987</year>       </cd>   <cd>            <title>Unchain my heart</title>         <artist>Joe Cocker</artist>             <country>USA</country>          <company>EMI</company>          <price>8.20</price>             <year>1987</year>       </cd></catalog>";

	
}
