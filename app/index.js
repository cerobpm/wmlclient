// index.js
'use strict'

const soap = require('soap')
const express = require('express')
const app = express()
const fs = require('fs')
const exphbs = require('express-handlebars')
const bodyParser = require('body-parser')
const Table = require('table-builder')
const request = require('request')
const xml = require('xml')
const { Pool } = require('pg')
//~ const pgp = require('pg-promise')()
//~ const pgpclient = pgp({database: 'odm', user: 'wmlclient', password: 'wmlclient'})
const config = require('config')
const pool = new Pool(config.get('dbsettings'))
//~ const appconfig = config.get('/config/default.json')
const odmpg = require('./odmpg.js')
var insertSites = odmpg.insertSites
var insertSiteInfo = odmpg.insertSiteInfo
var insertValues = odmpg.insertValues

//~ (async () => {
	//~ const client = await pool.connect()
	//~ try {
		//~ const res = await client.query('SELECT NOW() as now')
 	    //~ console.log(res.rows[0])
	//~ } catch(e) {
		//~ console.error('connection error', e.stack)
	//~ }
//~ })().catch(e => console.error(e.stack))

let soap_client_options = { 'request' : request.defaults(config.get('requestdefaults'))}
//~ const { body,validationResult } = require('express-validator/check');
//~ const { sanitizeBody } = require('express-validator/filter');
var gicat_url = config.get('defaultwmlserver.url') // 'http://giaxe.inmet.gov.br/services/cuahsi_1_1.asmx?WSDL';
const port = (config.has('options.port')) ? config.get('options.port') : 3000
app.engine('handlebars', exphbs({defaultLayout: 'main'}));
app.set('view engine', 'handlebars');
app.use(bodyParser.urlencoded({ extended: false }));  
app.use(express.static('public'));

app.get('/wmlclient', (req, res) => {
	res.render('wmlclient', { url: gicat_url})
	console.log('wmlclient form displayed')
	return
})
app.get('/wmlclient/sites', (req, res) => {
	//~ console.log(req.query)
	if(req.query.endpoint && req.query.north && req.query.south && req.query.east && req.query.west) {
		console.log(req.query)
		soap.createClient(req.query.endpoint, soap_client_options, function(err, client) {
			if(err) {
				res.json(err)
				console.log(err)
				return
			}
			client.GetSitesByBoxObject({north: req.query.north, south: req.query.south, east: req.query.east, west: req.query.west}, function(err, result, rawResponse) {
			  if(err) {
				  res.status(500).json({message:"waterML server error",error:err})
				  console.log(err)
				  return 
			  }
			  //~ console.log(client.lastRequest)
			  if(req.query.accion == "insert") {
				  var update = (req.query.update) ? req.query.update : false
				  insertSites(pool,result,update)
					.then(values => {
						console.log(values)
						if(values.result) {
							res.json({message:"insertion success",rows_inserted:values.result.length})
							return
						} else {
						  console.log("empty pg response")
						  res.status("500").send({error:"nothing inserted"})
						}
					})
					.catch(e => {
						console.log("error in insertion")
						res.status("500").send({message:"error in insertion",error:e})
					})
				return
			  } else if(req.query.accion == "download") {
			  //~ DATA DOWNLOAD   
				//~ if(req.query.format) {
					//~ if(req.query.format.toLowerCase() == 'xml') {
						//~ res.set('Content-Type', 'text/xml')
						//~ res.send(xml(result))
					//~ } else {
						//~ res.json(result)
					//~ }
				//~ } else {
				res.setHeader('Content-disposition', 'attachment; filename=sites.json');
				res.send(result)
				//~ }
				return
			  } else if (req.query.accion == "downloadraw") {
				//~ res.setHeader('Content-disposition', 'attachment; filename=sites.xml');
				console.log("download raw")
				res.send(rawResponse)
				return 
			  } 
			  var renderlist = []
			  //~ var ulist = "<
			  if(result.sitesResponse.hasOwnProperty("site")) {
				  result.sitesResponse.site.forEach(function(site) {
					  renderlist.push({siteName: site.siteInfo.siteName,network: site.siteInfo.siteCode[0].attributes.network, siteCode: site.siteInfo.siteCode[0]["$value"], longitude: site.siteInfo.geoLocation.geogLocation.longitude, latitude: site.siteInfo.geoLocation.geogLocation.latitude})
					  
				  })
				  console.log(renderlist)  
				  res.render('sitesresponse', { north: req.query.north, south: req.query.south, east: req.query.east, west: req.query.west, endpoint: req.query.endpoint, results: renderlist}) 
				  console.log('success')
			  } else {
				  res.render('sitesemptyresponse', { north: req.query.north, south: req.query.south, east: req.query.east, west: req.query.west, endpoint: req.query.endpoint})
			  }
		  })
		})
	} else if (req.query.endpoint) {
		res.render('sites', {endpoint: req.query.endpoint})
	} else {
		res.render('sites', {endpoint: gicat_url})
	}
	console.log('sites form displayed')

})

app.get('/wmlclient/siteinfo', (req, res) => {
	if(req.query.endpoint && req.query.site) {
		console.log("siteinfo, got endpoint and site")
		console.log(req.query)
		soap.createClient(req.query.endpoint, soap_client_options, function(err, client) {
			if(err) {
				res.json(err)
				console.log(err)
				return
			}
			client.GetSiteInfoObject({site: req.query.site}, function(err, result, rawResponse) {
			  if(err) {
				  res.json(err)
				  console.log(err)
				  return 
			  }
			  if(req.query.accion == "insert") {
				  var update = (req.query.update) ? req.query.update : false
				  var promises = []
				  promises.push(insertSites(pool,result,update))
				  promises.push(insertSiteInfo(pool,result,update))
				  Promise.all(promises)
					.then(values => {
						//~ console.log(values)
						res.json(values)
					})
					.catch(e => {
						console.log("insert error catched")
						//~ console.log(e)
						res.status(500).json(e)
					})
				  return
			  } else if(req.query.accion == "download") {	
				  res.setHeader('Content-disposition', 'attachment; filename=siteinfo.json');
				  res.json(result)
				  return
			  } else if (req.query.accion == "downloadraw") {
				res.setHeader('Content-disposition', 'attachment; filename=siteinfo.xml');
				res.send(rawResponse)
				return 
			  }
			  var renderlist = []
			  if(result.sitesResponse.hasOwnProperty("site")) {
				  result.sitesResponse.site.forEach(function(site) {
					  var siteinfo = {siteName: site.siteInfo.siteName,network: site.siteInfo.siteCode[0].attributes.network, siteCode: site.siteInfo.siteCode[0]["$value"], longitude: site.siteInfo.geoLocation.geogLocation.longitude, latitude: site.siteInfo.geoLocation.geogLocation.latitude}
					  if(site.seriesCatalog.length > 0) {
						  if(site.seriesCatalog[0].series.length > 0) {
							site.seriesCatalog[0].series.forEach(function(item) {
								renderlist.push({
											...siteinfo, 
											variableCode: (item.variable.variableCode[0].$value) ? item.variable.variableCode[0].$value : item.variable.variableCode[0].attributes.vocabulary + ":" + item.variable.variableCode[0].attributes.variableID, 
									         variableName: item.variable.variableName,
									         valueType: item.variable.valueType,
									         dataType: item.variable.dataType,
									         generalCategory: item.variable.generalCategory,
									         sampleMedium: item.variable.sampleMedium,
									         unitName: item.variable.unit.unitName,
									         unitType: item.variable.unit.unitType,
									         unitAbbreviation: item.variable.unit.unitAbbreviation,
									         unitCode: item.variable.unit.unitCode,
									         noDataValue: item.variable.noDataValue,
									         timeScaleIsRegular: item.variable.timeScale.attributes.isRegular,
									         timeScaleUnitName: (item.variable.timeScale.unit) ? item.variable.timeScale.unit.unitName : null,
									         timeScaleUnitType: (item.variable.timeScale.unit) ? item.variable.timeScale.unit.unitType : null,
									         timeScaleUnitAbbreviation: (item.variable.timeScale.unit) ? item.variable.timeScale.unit.unitAbbreviation : null,
									         timeScaleUnitCode: (item.variable.timeScale.unit) ? item.variable.timeScale.unit.unitCode : null,
									         timeScaleTimeSupport: (item.variable.timeScale.timeSupport) ? item.variable.timeScale.timeSupport : null,
									         speciation: item.variable.speciation,
									         valueCount: item.valueCount,
									         beginDateTime: item.variableTimeInterval.beginDateTime,
									         endDateTime: item.variableTimeInterval.endDateTime,
									         beginDateTimeUTC: item.variableTimeInterval.beginDateTimeUTC,
									         endDateTimeUTC: item.variableTimeInterval.endDateTimeUTC,
									         methodId: (item.method) ? item.method.attributes.methodID : null,
									         methodCode: (item.method) ? item.method.methodCode: null,
									         methodDescription: (item.method) ? item.method.methodDescription : null,
									         methodLink: (item.method) ? item.method.methodLink : null,
									         sourceID: item.source.attributes.sourceID,
									         organization: item.source.organization,
									         citation: item.source.citation,
									         qualityControlLevelID: (item.qualityControlLevel) ? item.qualityControlLevel.attributes.qualityControlLevelID : null,
									         qualityControlLevelCode: (item.qualityControlLevel) ? item.qualityControlLevel.qualityControlLevelCode : null,
									         qualityControlLevelDefinition: (item.qualityControlLevel) ? item.qualityControlLevel.definition : null})
							})
						}
					}
							  
				  })
				  console.log(renderlist)  
				  res.render('siteinforesponse', { site: req.query.site, endpoint: req.query.endpoint, results: renderlist}) 
				  console.log('success')
			  } else {
				  res.render('sitesemptyresponse', { site: req.query.site, endpoint: req.query.endpoint, results: renderlist}) 
			  } 
			})
		})
	} else if (req.query.endpoint) {
		console.log("siteinfo, got endpoint")
		res.render('siteinfo', {endpoint: req.query.endpoint})
	} else {
		console.log("siteinfo: no args")
		res.render('siteinfo', {endpoint: gicat_url})
	}
})

app.get('/wmlclient/values', (req, res) => {
	if(req.query.endpoint && req.query.site && req.query.variable && req.query.startDate && req.query.endDate) {
		console.log("values, got endpoint, site, variable, startDate y endDate")
		console.log(req.query)
		soap.createClient(req.query.endpoint, soap_client_options, function(err, client) {
			if(err) {
				res.json(err)
				console.log(err)
				return
			}
			client.GetValuesObject({location: req.query.site, variable: req.query.variable, startDate: req.query.startDate, endDate: req.query.endDate}, function(err, result, rawResponse) {
			  if(err) {
				  //~ res.json(err)
				  console.log(err.stack)
				  switch(req.query.accion) {
					  case "download":
						res.status(500).json({message:"download error",error:err})
						break
					  case "downloadraw":
					    res.set('Content-Type', 'text/xml')
                        res.status(500).send(xml(err))
                        break
                      case "insert":
                        res.status(500).json({message:"download error",error:err})
						break
					  default:
						  res.render('valuesemptyresponse', { endpoint: req.query.endpoint, site: req.query.site, variable: req.query.variable, startDate: req.query.startDate, endDate:req.query. endDate, results: renderlist, metadata: timeSeriesInfo } )
						  console.log(err.stack)
						  break
				  }
				  return 
			  }
			  //~ console.log(JSON.stringify(result,null,2))
			   if(req.query.accion == "insert") {
				  var update = (req.query.update) ? req.query.update : false
				  var promises = []
				  //~ promises.push(insertSites(pool,result,update))
				  //~ promises.push(insertSiteInfo(pool,result,update))
				  promises.push(insertValues(pool,result,update))
				  Promise.all(promises)
					.then(values => {
						//~ console.log(values)
						res.json(values)
					})
					.catch(e => {
						console.log("insert error catched")
						console.log(e.stack)
						res.status(500).json(e)
					})
				  return
			  } else if(req.query.accion == "download") {	
				  res.setHeader('Content-disposition', 'attachment; filename=values.json');
				  res.json(result)
				  return
			  } else if (req.query.accion == "downloadraw") {
				res.setHeader('Content-disposition', 'attachment; filename=values.xml');
				res.send(rawResponse)
				return 
			  }
			  var renderlist = []
			  var timeSeriesInfo = {}
			  if(result.timeSeriesResponse.hasOwnProperty("timeSeries")) {
				  if(Array.isArray(result.timeSeriesResponse.timeSeries)) {
					  console.log("timeSeries es array!")
					  result.timeSeriesResponse.timeSeries = result.timeSeriesResponse.timeSeries[0]
				  }
				  //~ console.log(result.timeSeriesResponse.timeSeries.variable)
				  timeSeriesInfo = {
						siteName: result.timeSeriesResponse.timeSeries.sourceInfo.siteName,
						siteCode: (result.timeSeriesResponse.timeSeries.sourceInfo.siteCode[0].attributes) ? result.timeSeriesResponse.timeSeries.sourceInfo.siteCode[0].attributes.network + ":" + result.timeSeriesResponse.timeSeries.sourceInfo.siteCode[0].$value : result.timeSeriesResponse.timeSeries.sourceInfo.siteCode[0].$value,
						longitude: (result.timeSeriesResponse.timeSeries.sourceInfo.geoLocation) ? result.timeSeriesResponse.timeSeries.sourceInfo.geoLocation.geogLocation.longitude : null,
						latitude: (result.timeSeriesResponse.timeSeries.sourceInfo.geoLocation) ? result.timeSeriesResponse.timeSeries.sourceInfo.geoLocation.geogLocation.latitude: null,
						variableCode: (Array.isArray(result.timeSeriesResponse.timeSeries.variable.variableCode)) ? result.timeSeriesResponse.timeSeries.variable.variableCode[0].$value : result.timeSeriesResponse.timeSeries.variable.variableCode.$value,
						variableName: result.timeSeriesResponse.timeSeries.variable.variableName,
						valueType: result.timeSeriesResponse.timeSeries.variable.valueType,
						generalCategory: result.timeSeriesResponse.timeSeries.variable.generalCategory,
						sampleMedium: result.timeSeriesResponse.timeSeries.variable.sampleMedium,
						unitName: result.timeSeriesResponse.timeSeries.variable.unit.unitName,
						unitAbbreviation: result.timeSeriesResponse.timeSeries.variable.unit.unitAbbreviation,
						unitCode: result.timeSeriesResponse.timeSeries.variable.unit.unitCode,
						NoDataValue: result.timeSeriesResponse.timeSeries.variable.NoDataValue,
						timeScale: result.timeSeriesResponse.timeSeries.variable.timeScale}

				  if(result.timeSeriesResponse.timeSeries.values) { 
					 if(Array.isArray(result.timeSeriesResponse.timeSeries.values)) {
						  console.log("values is array!")
					  	  if(result.timeSeriesResponse.timeSeries.values.length<=0) {
						      console.log("No Data Values")
						      res.render('valuesemptyresponse',  { endpoint: req.query.endpoint, site: req.query.site, variable: req.query.variable, startDate: req.query.startDate, endDate:req.query. endDate, results: renderlist, metadata: timeSeriesInfo })
						      return
						  }
						  result.timeSeriesResponse.timeSeries.values = result.timeSeriesResponse.timeSeries.values[0]
					 }
					 if(!result.timeSeriesResponse.timeSeries.values) {
						  console.log("No Data Values")
						  res.render('valuesemptyresponse',  { endpoint: req.query.endpoint, site: req.query.site, variable: req.query.variable, startDate: req.query.startDate, endDate:req.query. endDate, results: renderlist, metadata: timeSeriesInfo })
						  return
					 }
					 if(! result.timeSeriesResponse.timeSeries.values.hasOwnProperty("value")) {
						 console.log("no value property found");
						 res.render('valuesemptyresponse',  { endpoint: req.query.endpoint, site: req.query.site, variable: req.query.variable, startDate: req.query.startDate, endDate:req.query. endDate, results: renderlist, metadata: timeSeriesInfo })
						 return
					 }
					 if(! Array.isArray(result.timeSeriesResponse.timeSeries.values.value)) {
						 console.log("value propery is not an array!")
						 res.render('valuesemptyresponse',  { endpoint: req.query.endpoint, site: req.query.site, variable: req.query.variable, startDate: req.query.startDate, endDate:req.query. endDate, results: renderlist, metadata: timeSeriesInfo })
						 return
					 }
					 if(result.timeSeriesResponse.timeSeries.values.value.length <= 0) {
						 console.log("value property is of length 0")
						 res.render('valuesemptyresponse',  { endpoint: req.query.endpoint, site: req.query.site, variable: req.query.variable, startDate: req.query.startDate, endDate:req.query. endDate, results: renderlist, metadata: timeSeriesInfo })
						 return
					 }
					 result.timeSeriesResponse.timeSeries.values.value.forEach(function(value) {
					      renderlist.push({
							  censorCode: value.attributes.censorCode,
							  dateTime: value.attributes.dateTime,
							  qualityControlLevel: value.attributes.qualityControlLevel,
							  methodID: value.attributes.methodID,
							  sourceID: value.attributes.sourceID,
							  sampleID: value.attributes.sampleID,
							  value: value.$value})
					})
				  }
				  //~ console.log(renderlist)  
				  res.render('valuesresponse', { endpoint: req.query.endpoint, site: req.query.site, variable: req.query.variable, startDate: req.query.startDate, endDate:req.query. endDate, results: renderlist, metadata: timeSeriesInfo }) 
				  console.log('success')
			  } else {
				  res.render('valuesemptyresponse', { endpoint: req.query.endpoint, site: req.query.site, variable: req.query.variable, startDate: req.query.startDate, endDate:req.query. endDate, results: renderlist, metadata: timeSeriesInfo }) 
			  } 
			})
		})
	} else if (req.query.endpoint && req.query.site && req.query.variable) {
		console.log("values, got endpoint, site y variable")
		console.log(req.query)
		res.render('values', {endpoint: req.query.endpoint, site: req.query.site, variable: req.query.variable})
	} else if (req.query.endpoint) {
		console.log("values, got endpoint")
		res.render('values', {endpoint: req.query.endpoint})
	} else {
		console.log("values: no args")
		res.render('values', {endpoint: gicat_url})
	}
})
		//~ const cldes = client.describe()
		//~ fs.writeFile('describe.txt',JSON.stringify(cldes,null,4))
		//~ client.GetValuesForASiteObject(args, function(err,result) {
		
		//~ client.GetVariableInfoObject({ variable: "INA:2"}, function(err,result) {
			//~ fs.writeFile('variableinfo.json',JSON.stringify(result, null, 4))
		//~ })
		//~ client.GetSiteInfoObject({site: "ANA:73600600@1613412505"},  function(err, result) {
			//~ fs.writeFile('siteinfo.txt',JSON.stringify(result, null, 4))
		//~ })
		//~ client.GetValuesObject({location: "ANA:73600600@1613412505", variable: "ODM:Chuva", startDate: "2019-01-14T00:00:00", endDate: "2019-01-15T00:00:00"},  function(err, result) {
			//~ var tvp = []
			//~ for(var i=0;i <result.timeSeriesResponse.timeSeries.values[0].value.length;i++) {
				//~ tvp[i] = [result.timeSeriesResponse.timeSeries.values[0].value[i].attributes.dateTime, result.timeSeriesResponse.timeSeries.values[0].value[i].$value]
			//~ }
			//~ fs.writeFile('values_tvp.txt',JSON.stringify(tvp))
	  //~ })
	  
	//~ })
	//~ .request( (xml,eid) => {
		  //~ console.log('envelope:'+xml)
//~ })
//~ })
//~ app.get('/variables', (req, res) => {
	//~ soap.createClient(url, function(err, client) {
	  //~ client.GetVariables([], function(err, result) {
		  //~ console.log(result.site)
		  //~ res.xml(result.site)
	  //~ })
	//~ })
 //~ soap.createClientAsync(url).then((client) => {
    //~ return client.GetVariables([]);
  //~ }).then((result) => {
    //~ console.log(result);
  //~ });
//~ })

app.listen(port, (err) => {
	if (err) {
		return console.log('rrr',err)
	}
	console.log(`server listening on port ${port}`)
});

