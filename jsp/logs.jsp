<!--
Copyright (C) 2020 Bonitasoft S.A.
Bonitasoft is a trademark of Bonitasoft SA.
This software file is BONITASOFT CONFIDENTIAL. Not For Distribution.
For commercial licensing information, contact:
Bonitasoft, 32 rue Gustave Eiffel – 38000 Grenoble
or Bonitasoft US, 51 Federal Street, Suite 305, San Francisco, CA 94107
-->
<%@page import="java.util.Enumeration" %>
<%@page import="java.util.List" %>
<%@page import="java.util.Locale,java.util.logging.Level" %>
<%@ page import="java.util.logging.Logger" %>
<%@ page import="org.bonitasoft.engine.session.*" %>
<%
	Logger jspLogger = Logger.getLogger("org.bonitasoft.tooling.log.jsp");
	jspLogger.setLevel(Level.INFO); // ensure logs are generated

	// Authorization checks
	APISession apiSession = (APISession) session.getAttribute("apiSession");
	if (apiSession == null) {
		jspLogger.log(Level.WARNING, "Unauthenticated user tried to access to the Logger Level configuration");
		response.sendError(403);
		return;
	}
	String userName = (String) session.getAttribute("username");
	List<String> profiles = apiSession.getProfiles();
	boolean isAdministrator = profiles.contains("Administrator");
	// TODO accept tenant administrator

	if (!isAdministrator) {
		jspLogger.log(Level.WARNING, "Non Administrator '" + userName + "' user tried to access to the Logger Level configuration");
		response.sendError(403);
		return;
	}


// TODO log user id if available in org.bonitasoft.web.rest.model.user.User
//	org.bonitasoft.web.rest.model.user.User

	String loggerName = request.getParameter("loggerName");
	if (loggerName == null) {
		response.sendError(400, "The loggerName parameter is mandatory");
		return;
	}


	String loggerLevel = request.getParameter("loggerLevel");
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

User: <b><%= userName %></b><br/>
<b>isAdministrator</b>: <%= isAdministrator %><br/>
<p>

<% if (isLoggerInfoOnly) {
	jspLogger.log(Level.INFO, "User '" + userName + "' accessed to the Logger Level configuration - Information only");
%>
<b>Providing logger info only</b>
<p/>

Logger: <b><%= loggerName %></b><br/>
Log level: <b><%= originalLogLevel %></b><br/>
<p/>

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
Profiles

<%

out.println("<ul>");
for(String profile: profiles) {
    out.println("<li> " + profile + "</li>");
}
out.println("</ul>");
%>


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
