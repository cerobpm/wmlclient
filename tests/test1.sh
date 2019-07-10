#curl "http://localhost:3000/wmlclient/sites?accion=downloadraw&west=-60.6095&east=-60.6093&north=-3.3105&south=-3.3107&endpoint=http://gs-service-production.geodab.eu/gs-service/services/essi/view/plata/cuahsi_1_1.asmx?WSDL" > sites.xml
sitecode="d1df0ee8-b82e-3e12-ba07-bc80c394be3d"
#~ curl "http://localhost:3000/wmlclient/siteinfo?accion=downloadraw&site=$sitecode&endpoint=http://gs-service-production.geodab.eu/gs-service/services/essi/view/plata/cuahsi_1_1.asmx?WSDL" > siteinfo.xml
variablecode="519bb3b1-5780-3d02-92b7-d673aebb013c"
startdate="2019-05-23T00:00:00Z"
enddate="2019-05-24T13:05:26Z"
curl "http://localhost:3000/wmlclient/values?accion=downloadraw&site=$sitecode&variable=$variablecode&startDate=$startdate&endDate=$enddate&endpoint=http://gs-service-production.geodab.eu/gs-service/services/essi/view/plata/cuahsi_1_1.asmx?WSDL" > values.xml

