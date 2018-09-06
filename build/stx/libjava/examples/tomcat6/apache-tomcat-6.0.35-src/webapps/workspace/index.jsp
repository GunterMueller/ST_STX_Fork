<%-- 
Document   : index
Created on : Aug 21, 2012, 9:03:18 PM
Author     : Marcel Hlopko
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
	<head>
		<c:set var="contextPath" value="${pageContext.request.contextPath}"/>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>Smalltalk Workspace</title>
		<script src="${contextPath}/static/jquery-1.8.0.min.js"></script>        
		<link rel="stylesheet" href="${contextPath}/static/bootstrap/css/bootstrap.min.css"/>
		<link rel="stylesheet" href="${contextPath}/static/workspace.css"/>
		<script src="${contextPath}/static/bootstrap/js/bootstrap.min.js"></script>
		<script type="text/javascript">
			$.fn.isBound = function(type, fn) {
				if (this.data('events') === undefined) {
					return false;
				}
				var data = this.data('events')[type];

				if (data === undefined || data.length === 0) {
					return false;
				}   
				return (-1 !== $.inArray(fn, data.map(function(o) {
								return o.handler
								})));
			};

			$.fn.bindIfNotBound = function(eventName, handler) {
				this.each(function() {
					if (!$(this).isBound(eventName, handler)) {        
						$(this).bind(eventName, handler);
					}
				});    
			};

			$(document).ready(function() {            
				$("#submit-button").click(function(e) {
					e.preventDefault();
					submitData();                                         
				});			

				$("#browse-EvaluatorServlet").click(function(e) {
					e.preventDefault();
					browse('JAVA stx libjava stworkspace EvaluatorServlet');
				});			

				$("#browse-Evaluator").click(function(e) {
					e.preventDefault();
					browse('JAVA stx libjava stworkspace Evaluator');
				});			



				$("#input").focus();
			});

			function paste(source) {
				$("#input").val(source);
			}

			function evaluate(source, language) {
				var lang = language;
				if (lang == undefined) {
					lang = 'smalltalk';
				}
				$.ajax({
					type: "POST",
					url: "evaluator",
					data: lang + ";" + source,
					contentType: 'application/json;charset=utf-8',
					success: success,
					error: error
				});				
			} 

			function submitData() {
				evaluate($("#input").val(), $("#lang-select").val())

			}

			function prependNewOutputElement(text, element) {
				outputElement = '' +
					'<div class="span8 well remove-output">' +
					'    <button class="close">&times;</button>' +
					'    <p>' + text + '</p>' +
					'</div>';
				$(outputElement).hide().prependTo(element).fadeIn('slow');
				$(".remove-output").bindIfNotBound("click", function(e) {
					e.preventDefault();
					$(this).fadeOut('slow', function() {$(this).remove();});                    
				});
			}

			

			/* a helper function to open browser on given class */
			function browse(classname) {
				evaluate("Tools::NewSystemBrowser new open; switchToClass: " + classname);
			}

			function success(result) {
				prependNewOutputElement(result, $("#output")); 
				//$("#input").val('');
				$("#input").focus();
			}    

			function error() {
				prependNewOutputElement("Could not talk to the evaluator :(",$("#output"));
			}
		</script>
	</head>    
	<body>  
		<div class="container">
			<div class="row" style="margin-top: 30px;">
				<div class="offset2 span8">
					<div class="span5" style="margin-left: 0px;">
						<h1>Workspace</h1>
					</div>            
					<div class="offset1 span2">                    
						<a id="logo" href="https://swing.fit.cvut.cz/projects/stx-libjava">
							<img src="${contextPath}/static/javax_web_270x70.png" alt="STX:LIBJAVA"/>
						</a>
					</div>
				</div>
			</div>
			<!-- 
			<div class="row">			
				<div class="span8 offset2">
					<p class="lead" style="text-align: justify">
					Hello! I'm Smalltalk Workspace. Write some Smalltalk code 
					and I will print the result. By the way, I am running as a Java web application
					deployed on Tomcat. And this Tomcat is running on
					<a href="https://swing.fit.cvut.cz/projects/stx-libjava/">STX:LIBJAVA</a>.
					Pretty cool, huh? :)
					</p>
					<p style="text-align: justify">
					STX:LIBJAVA is a tiny Java implementation allowing Java programs to run 
					directly under 
					<a href="http://www.exept.de/en/products/smalltalkx">Smalltalk/X VM</a>.                    
					</p>
				</div> 
			</div>
			-->
			<div class="row">
				<div class="span2">	
					<div class="row">
						<h4>Examples</h4>
					</div>				
                    <div class="row template">                    	
                        <span onclick="paste('3+4')" class="span2 template">3+4</span>
                    </div>    

                    <div class="row template">                    	
                        <span onclick="paste('Transcript showCR:\'Hello World\'')" class="span2 template">Transcript showCR: ...</span>
                    </div>    
                    
                    <div class="row template">                    	
                    	<span onclick="paste('Object zork')" class="span2 template">Object zork</span>
                    </div>

                    
					<div class="row" style="padding-top: 2em">
						<h4>Sources</h4>						
					</div>				

                    <div class="row">                    	
                    	<a id="browse-EvaluatorServlet" style="margin-left: 0px;" class="span2">EvaluatorServlet.java</span>
                    </div>

                    <div class="row">                    	
                    	<a id="browse-Evaluator" style="margin-left: 0px;" class="span2">Evaluator.groovy</span>
                    </div>

                    
                	





                </div>
				<div class="span8">
					<div class="row"> 
						<div class="span8">
							<select id="lang-select" class="span8">
								<option value="smalltalk">Smalltalk</option>
								<option value="javascript">Javascript</option>
								<option value="groovy">Groovy</option>
							</select>
						</div>
						<div class="span8">
							<textarea class="span8" rows="10" style="/*resize: none*/" id="input">3+4</textarea>
						</div>
						<div class="span8" >
							<input type="submit" id="submit-button" class="span8 btn btn-primary" value="Evaluate!" />
						</div>                            
					</div>            
					<div id="output" class="row" style="margin-top: 50px;">                    
					</div>
				</div>            
			</div>
		</div>
	</body>
</html>
