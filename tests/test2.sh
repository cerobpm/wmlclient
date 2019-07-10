#~ endpoint="http://giaxe.inmet.gov.br/services/cuahsi_1_1.asmx?WSDL"
endpoint="http://gs-service-production.geodab.eu/gs-service/services/essi/view/plata/cuahsi_1_1.asmx?WSDL"
curl "http://localhost:3000/wmlclient/sites?accion=downloadraw&west=-60.6095&east=-50.6093&north=-20&south=-30&endpoint=$endpoint" > sites1.xml
sitecode="INMET:APIACAS@1554986357"
#~ curl "http://localhost:3000/wmlclient/siteinfo?accion=downloadraw&site=$sitecode&endpoint=http://giaxe.inmet.gov.br/services/cuahsi_1_1.asmx?WSDL" > siteinfo1.xml
variablecode="INMET:Precipitation"
startdate="2018-06-17T00:00:00Z"
enddate="2018-06-18T23:00:00Z"
#~ curl "http://localhost:3000/wmlclient/values?accion=downloadraw&site=$sitecode&variable=$variablecode&startDate=$startdate&endDate=$enddate&endpoint=$endpoint" > values1.xml

