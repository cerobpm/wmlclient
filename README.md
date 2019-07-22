# wmlclient

Lite client for CUAHSI/WaterML 1.1 Web Service with PostgreSQL database interface

## Configuration

file config/default.json

	defaultwmlserver.url: Default endpoint of CUAHSI/WaterML Server (default: 'http://giaxe.inmet.gov.br/services/cuahsi_1_1.asmx?WSDL')
	
	requestdefaults.proxy: 		HTTP proxy for SOAP client (define if required)
	requestdefault.timeout: 	HTTP SOAP request timeout (milliseconds, default 20000)
	requestdefaut.connection: 	HTTP SOAP connection type (default 'keep-alive')

	options.port: 				nodejs server port (default 3000)
	
	dbsettings.database: 		PostgreSQL database name (default 'odm')
	dbsettings.host:			PostgreSQL database host (default 'localhost')
	dbsettings.user:			PostgreSQL database user name (default 'wmlclient')
	dbsettings.password:		PostgreSQL database password (default 'wmlclient')

## Setup

run sudo apt install postgresql nodejs: will install PostgreSQL and node.js

run psql -f sql/odm.sql: will create user wmlclient and database odm

edit config/default.json or create config/local.json

##Initialize

nodejs index.js

Server will start listening  on  localhost:3000 (or the specified port) 

##Usage

###Using the graphical interface

	- Browse to localhost:3000/wmlclient/sites
	- Set CUAHSI/WaterML endpoint url (or leave default) and optionally set bounding box in geographical coordinates
	- Click on "Enviar consulta". You'll see the search results in a list.
	- Click on the desired site on the list. You'll be redirected to localhost:3000/wmlclient/siteinfo
	- Available variables for the selected site will be automatically shown on a list. Click on the desired variable. You'll be redirected to localhost:3000/values
	- Choose a time period for the desired time series and click on submit button.
	- You can download any result list in native format (WML) or in JSON

###Using HTTP/GET
```
	- /sites
		*request parameters:
			- endpoint		url
			- north			real
			- south			real
			- east			real
			- west			real
			- accion		"downloadraw"|"download"|"insert"    (download WML, download JSON o insert into database, if omitted returns HTML page)
	- /siteinfo
		*request parameters:
			- endpoint 		url
			- site			string (site code)
			- accion			"downloadraw"|"download"|"insert"    (download WML, download JSON o insert into database, if omitted returns HTML page)
	- /values
		*request parameters:
			- endpoint 		url
			- site			string (site code)
			- variable		string (variable code)
			- accion		"downloadraw"|"download"|"insert"    (download WML, download JSON o insert into database, if omitted returns HTML page)

```
Done!
   
