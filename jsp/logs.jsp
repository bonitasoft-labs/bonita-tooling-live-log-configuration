<%@page import="java.util.logging.*" %>
<%
String loggerName = request.getParameter("loggerName");
String loggerLevel = request.getParameter("loggerLevel");


loggerName = loggerName != null ? loggerName: "NO_LOGGER_NAME";
loggerLevel = loggerLevel != null ? loggerLevel: "WARNING";

Logger logger = Logger.getLogger(loggerName);
Level originalLogLevel = logger.getLevel();
logger.setLevel(Level.parse(loggerLevel));
Level newLevel = logger.getLevel();

logger.log(newLevel, "ADMIN: new level set");
%>


<!DOCTYPE html>
<html>
<head>
  <title>Bonita Live Logger Level Configuration</title>
</head>

<body>
<h1>Bonita Live Logger Level Configuration</h1>

Requested logger: <b><%= loggerName %></b><br/>
Requested level: <b><%= loggerLevel %></b>
<p/>

Actual logger: <b><%= logger.getName() %></b><br/>
Orig log level: <b><%= originalLogLevel %></b><br/>
New log level: <b><%= newLevel %></b>
</body>

</html>


