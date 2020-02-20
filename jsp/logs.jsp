<!--
Copyright (C) 2020 Bonitasoft S.A.
Bonitasoft is a trademark of Bonitasoft SA.
This software file is BONITASOFT CONFIDENTIAL. Not For Distribution.
For commercial licensing information, contact:
Bonitasoft, 32 rue Gustave Eiffel – 38000 Grenoble
or Bonitasoft US, 51 Federal Street, Suite 305, San Francisco, CA 94107
-->
<%@page import="java.util.logging.*" %>
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


</body>

</html>
