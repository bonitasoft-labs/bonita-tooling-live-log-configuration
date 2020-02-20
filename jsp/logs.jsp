<!--
Copyright (C) 2020 Bonitasoft S.A.
Bonitasoft is a trademark of Bonitasoft SA.
This software file is BONITASOFT CONFIDENTIAL. Not For Distribution.
For commercial licensing information, contact:
Bonitasoft, 32 rue Gustave Eiffel – 38000 Grenoble
or Bonitasoft US, 51 Federal Street, Suite 305, San Francisco, CA 94107
-->
<%@page import="java.util.logging.*" %>
<%@page import="java.io.*,java.util.*" %>
<%
String loggerName = request.getParameter("loggerName");
String loggerLevel = request.getParameter("loggerLevel");

// TODO mandatory field
loggerName = loggerName != null ? loggerName: "NO_LOGGER_NAME";


Logger logger = Logger.getLogger(loggerName);
Level originalLogLevel = logger.getLevel();

boolean isLoggerInfoOnly = loggerLevel == null;
%>


<!DOCTYPE html>
<html>
<head>
  <title>Bonita Live Logger Level Configuration</title>
</head>

<body>
<h1>Bonita Live Logger Level Configuration</h1>

<% if (isLoggerInfoOnly) { %>
Providing logger info only<p>

Logger: <b><%= loggerName %></b><br/>
Log level: <b><%= originalLogLevel %></b><br/>
Loggable levels:
<ul>
    <li><%= Level.SEVERE %>: <%= logger.isLoggable(Level.SEVERE) %>
    <li><%= Level.WARNING %>: <%= logger.isLoggable(Level.WARNING) %>
    <li><%= Level.INFO %>: <%= logger.isLoggable(Level.INFO) %>
    <li><%= Level.CONFIG %>: <%= logger.isLoggable(Level.CONFIG) %>
    <li><%= Level.FINE %>: <%= logger.isLoggable(Level.FINE) %>
    <li><%= Level.FINER %>: <%= logger.isLoggable(Level.FINER) %>
    <li><%= Level.FINEST %>: <%= logger.isLoggable(Level.FINEST) %>
</ul>

<% } else {
    logger.setLevel(Level.parse(loggerLevel));
    Level newLogLevel = logger.getLevel();

    logger.log(newLogLevel, "{BONITA TOOLING LOGGER JSP} log level set from " + originalLogLevel + " to " + newLogLevel);
%>
Requested logger: <b><%= loggerName %></b><br/>
Requested level: <b><%= loggerLevel %></b>
<p/>

Actual logger: <b><%= logger.getName() %></b><br/>
Orig log level: <b><%= originalLogLevel %></b><br/>
New log level: <b><%= newLogLevel %></b>
<% } %>


<h1>Session info</h1>

<h2>Session</h2>

<table border="1">
<tr>
<th>Name</th><th>Value(s)</th>
</tr>
<%
	Enumeration attributeNames = session.getAttributeNames();
    while(attributeNames.hasMoreElements()) {
        String attributeName = (String) attributeNames.nextElement();
        out.print ("<tr><td>" + attributeName + "</td>" );

        Object attributeValue = session.getAttribute(attributeName);
        // String paramValue = "";
        out.println("<td> " + attributeValue + "</td></tr>");
    }
%>
</table>

<p>
apiSession
permissions
api_token
user
username
<p>




<h2>Request</h2>

<table border="1">
<tr>
<th>Name</th><th>Value(s)</th>
</tr>
<%
	HttpSession gurusession = request.getSession();
	out.print("<tr><td>Session Name is </td><td>" +gurusession+ "</td.></tr>");
	Locale gurulocale = request.getLocale ();
	out.print("<tr><td>Locale Name is</td><td>" +gurulocale + "</td></tr>");
	String path = request.getPathInfo();
	out.print("<tr><td>Path Name is</td><td>" +path+ "</td></tr>");
	//String lpath = request.get();
	//out.print("<tr><td>Context path is</td><td>" +lpath + "</td></tr>");
	String servername = request.getServerName();
	out.print("<tr><td>Server Name is </td><td>" +servername+ "</td></tr>");
	int portname = request.getServerPort();
	out.print("<tr><td>Server Port is </td><td>" +portname+ "</td></tr>");
	Enumeration hnames = request.getHeaderNames();
	while(hnames.hasMoreElements()) {
		String paramName = (String)hnames.nextElement();
		out.print ("<tr><td>" + paramName + "</td>" );

		String paramValue = request.getHeader(paramName);
		out.println("<td> " + paramValue + "</td></tr>");
	}
%>
</table>

</body>

</html>
