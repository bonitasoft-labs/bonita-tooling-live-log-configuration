<!--
Copyright (C) 2020 Bonitasoft S.A.
Bonitasoft is a trademark of Bonitasoft SA.
This software file is BONITASOFT CONFIDENTIAL. Not For Distribution.
For commercial licensing information, contact:
Bonitasoft, 32 rue Gustave Eiffel – 38000 Grenoble
or Bonitasoft US, 51 Federal Street, Suite 305, San Francisco, CA 94107
-->
<%@page import="java.util.List" %>
<%@page import="java.util.logging.Level" %>
<%@page import="java.util.logging.Logger" %>
<%@page import="org.bonitasoft.engine.session.*" %>
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
	String actualLoggerName = logger.getName();
    jspLogger.log(Level.INFO, "User '" + userName + "' set the log level of logger " + actualLoggerName + " from " + originalLogLevel + " to " + newLogLevel);
%>

<b>Logger Level change</b>
<p/>

Requested logger: <b><%= loggerName %></b><br/>
Requested level: <b><%= loggerLevel %></b>
<p/>

Actual logger: <b><%= actualLoggerName %></b><br/>
Orig log level: <b><%= originalLogLevel %></b><br/>
New log level: <b><%= newLogLevel %></b>
<% } %>

</body>

</html>
