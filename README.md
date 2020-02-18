# bonita-tooling-live-log-configuration

Configure Bonita logger level in live environment

# The jsp (uggly) way

Not recommended but this is the fastest way. Tested with Bonita 7.8.4 Enterprise (but should work with 7.7+ and
Community edition)

**IMPORTANT**: be aware that the jsp is not secured, which means that anybody knowning the path to the page can update
the log levels of your Bonita Runtime.

## Installation

In your `BONITA_INSTALLATION_DIRECTORY/server/webapps/bonita` create a folder which a random name (this is a poor way to
obfuscate the place where the admin page is located)

For instance `lCsjYSTZAEdhnQ7GCl3/QMmRhhkDp8USR5f0fzf` (DO NOT this path, create your own)

Copy the [logs.jsp](jsp/logs.jsp) file in the newly created folder.

## Usage

Do a HTTP GET on the `logs.jsp` page  with parameters
- `loggerName`: full name of the logger whose you want to update the level
- `loggerLevel`: level of the logger to be updated

For instance, using the path provided as example in the installation section: http://localhost:8080/bonita/lCsjYSTZAEdhnQ7GCl3/QMmRhhkDp8USR5f0fzf/logs.jsp?loggerName=com.bonitasoft.message.MyLogger&loggerLevel=FINE

In the bonita.log, you will see something like
```
2020-02-18 15:26:16.602 +0100 FINE: com.bonitasoft.message.MyLogger ADMIN: new level set
```
