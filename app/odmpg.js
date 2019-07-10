// odmpg.js

// Inserts WaterML data (first converted into JSON) into an ODM PG database
const flatten = require('array-flatten')

exports.insertSites =  function(pool,data,update) {
	return new Promise((resolve, reject) => {
		if(!data.sitesResponse) {
			console.log("Error: missing sitesResponse property");
			reject("missing sitesResponse property")
		}
		if(!data.sitesResponse.site) {
			console.log("Error: missing sitesResponse.site property");
			reject("missing sitesResponse.site property")
		}
		if(! Array.isArray(data.sitesResponse.site)) {
			console.log("Error: data.sitesResponse.site must be an Array");
			reject("data.sitesResponse.site must be an Array")
		}
		var insertdata = ""
		data.sitesResponse.site.forEach( function(site) {
			if(! site.siteInfo) {
				console.log("Warning: siteInfo missing from a sites element, skipping")
				return
			}
			if(! site.siteInfo.siteName) {
				console.log("Warning: siteInfo.siteName missing from a sites element, skipping")
				return
			}
			if(! site.siteInfo.siteCode) {
				console.log("Warning: siteInfo.siteCode missing from a sites element, skipping")
				return
			}
			if(Array.isArray(site.siteInfo.siteCode)) {
				site.siteInfo.siteCode = site.siteInfo.siteCode[0]
			}
			if(!site.siteInfo.siteCode.$value) {
				console.log("Warning: siteInfo.siteCode.$value missing from a sites element, skipping")
				return
			}
			if(! site.siteInfo.geoLocation) {
				console.log("Warning: siteInfo.geoLocation missing from a sites element, skipping")
				return
			}
			if(! site.siteInfo.geoLocation.geogLocation) {
				console.log("Warning: siteInfo.geoLocation.geogLocation missing from a sites element, skipping")
				return
			}
			if(! site.siteInfo.geoLocation.geogLocation.latitude) {
				console.log("Warning: siteInfo.geoLocation.geogLocation.latitude missing from a sites element, skipping")
				return
			}
			if(! site.siteInfo.geoLocation.geogLocation.longitude) {
				console.log("Warning: siteInfo.geoLocation.geogLocation.longitude missing from a sites element, skipping")
				return
			}
			insertdata = insertdata + "('" + site.siteInfo.siteName + "','"+site.siteInfo.siteCode.$value+"',st_setsrid(st_point(" + site.siteInfo.geoLocation.geogLocation.longitude + "," + site.siteInfo.geoLocation.geogLocation.latitude + "),4326),"+ site.siteInfo.geoLocation.geogLocation.longitude + "," + site.siteInfo.geoLocation.geogLocation.latitude + "," + ((site.siteInfo.elevation_m) ? site.siteInfo.elevation_m : "null") + ",3),"
		})
		if(insertdata.length <= 0) {
			console.log("Error: no data")
			reject("No data found")
		}
		insertdata = insertdata.slice(0,-1)
		console.log("intentando insert")
		var onconflict = (update) ? 'UPDATE SET "SiteName"=excluded."SiteName", "Geometry"=excluded."Geometry", "Longitude"=excluded."Longitude", "Latitude"=excluded."Latitude", "Elevation_m"=excluded."Elevation_m", "LatLongDatumID"=excluded."LatLongDatumID"' : "NOTHING"
		var stmt = 'INSERT INTO "Sites" ("SiteName", "SiteCode", "Geometry", "Longitude", "Latitude", "Elevation_m","LatLongDatumID") values ' + insertdata + ' ON CONFLICT ("SiteCode") DO ' + onconflict + ' RETURNING *'
		//~ console.log(stmt)
		pool.connect()
			.then(client => {
				client.query(stmt)
					.then(values => {
						client.release()
						console.log("Inserted " + values.rows.length + " rows!")
						resolve({action:"insertSites",result:values.rows.map(item=>{ return item.SiteCode })})
					})
					.catch(e =>{
						client.release()
						console.log(e.stack)
						reject({message: "insert sites error",error:e})
					})
			})
		//~ })
	})
}

exports.insertSiteInfo =  function(pool,data,update) {
	return new Promise((resolve, reject) => {
		if(!data.sitesResponse) {
			console.log("Error: missing sitesResponse property");
			reject("missing sitesResponse property")
		}
		if(!data.sitesResponse.site) {
			console.log("Error: missing sitesResponse.site property");
			reject("missing sitesResponse.site property")
		}
		if(! Array.isArray(data.sitesResponse.site)) {
			console.log("Error: data.sitesResponse.site must be an Array");
			reject("data.sitesResponse.site must be an Array")
		}
		var promises=[]
		data.sitesResponse.site.forEach( function(site) {
			if(!site.seriesCatalog) {
				console.log("seriesCatalog missing!")
				return
			}
			if(Array.isArray(site.seriesCatalog)) {
				site.seriesCatalog = site.seriesCatalog[0]
			}
			if(! site.seriesCatalog.series) {
				console.log("seriesCatalog.series missing!")
				return
			}
			if(!  Array.isArray(site.seriesCatalog.series)) {
				console.log("seriesCatalog.serie must be an array!")
				return
			}
			site.seriesCatalog.series.forEach( function(series) {
				var vocabulary
				variable: {
					if(!series.variable) {
						console.log("variable missing!")
						break variable
					}
					if(!series.variable.variableCode) {
						console.log("variableCode missing!")
						break variable
					}
					if(Array.isArray(series.variable.variableCode)) {
						series.variable.variableCode = series.variable.variableCode[0]
					}
					var variableCode
					if(series.variable.variableCode.$value) {
						variableCode = series.variable.variableCode.$value
					} else if(series.variable.variableCode.attributes) {
						if(!series.variable.variableCode.attributes.vocabulary) {
							console.log("vocabulary missing!")
							break variable
						}
						vocabulary = series.variable.variableCode.attributes.vocabulary
						if(!series.variable.variableCode.attributes.variableID) {
							console.log("variableID missing!")
							break variable
						}
						variableCode = series.variable.variableCode.attributes.vocabulary + ":" + series.variable.variableCode.attributes.variableID
					} else {
						console.log("variableCode missing!")
						break variable
					}
					if(!series.variable.variableName) {
						console.log("variableName missing!")
						break variable
					}
					console.log("intentando insert de variable")
					var values = "'" + series.variable.variableName + "','" + variableCode + "'," + ((series.variable.speciation) ? (series.variable.speciation != "") ? "'" + series.variable.speciation + "'" : "'Not Applicable'" : "'Not Applicable'" ) + "," + ((series.variable.unit) ? (series.variable.unit.unitCode) ? series.variable.unit.unitCode : 0 : 0 ) + "," + ((series.variable.sampleMedium) ? (series.variable.sampleMedium != "") ? "'" + series.variable.sampleMedium + "'" : "'Unknown'" : "'Unknown'" ) + "," + ((series.variable.valueType) ? (series.variable.valueType != "") ? (series.variable.valueType != "N/A") ? "'" + series.variable.valueType + "'" : "'Unknown'"  : "'Unknown'" : "'Unknown'") + "," + ((series.variable.timeScale) ? (series.variable.timeScale.attributes) ? (series.variable.timeScale.attributes.isRegular) ? series.variable.timeScale.attributes.isRegular : "NULL" : "NULL" : "NULL") + "," + ((series.variable.timeScale) ? (series.variable.timeScale.timeSupport) ? series.variable.timeScale.timeSupport : "DEFAULT" : "DEFAULT") + "," + ((series.variable.timeScale.unit) ? (series.variable.timeScale.unit.unitCode) ? series.variable.timeScale.unit.unitCode : "DEFAULT" : "DEFAULT") + "," + ((series.variable.dataType) ? (series.variable.dataType != "") ? (series.variable.dataType != "N/A") ? "'" + series.variable.dataType + "'" : "'Unknown'" : "'Unknown'" : "'Unknown'") + "," + ((series.variable.generalCategory) ? (series.variable.generalCategory != "") ? "'" + series.variable.generalCategory + "'" : "'Unknown'"  : "'Unknown'") + "," + ((series.variable.noDataValue) ? (series.variable.noDataValue != "") ? series.variable.noDataValue : "0" : "0")
					var onconflict = (update) ? 'UPDATE SET "VariableName"=excluded."VariableName", "VariableCode"=excluded."VariableCode", "Speciation"=excluded."Speciation", "VariableUnitsID"=excluded."VariableUnitsID", "SampleMedium"=excluded."SampleMedium",  "ValueType"=excluded."ValueType", "IsRegular"=excluded."IsRegular", "TimeSupport"=excluded."TimeSupport", "TimeUnitsID"=excluded."TimeUnitsID", "DataType"=excluded."DataType", "GeneralCategory"=excluded."GeneralCategory", "NoDataValue"=excluded."NoDataValue"' : 'NOTHING'
					var stmt = 'INSERT INTO "Variables" ("VariableName", "VariableCode", "Speciation", "VariableUnitsID", "SampleMedium", "ValueType","IsRegular","TimeSupport","TimeUnitsID","DataType", "GeneralCategory","NoDataValue") values (' + values + ') ON CONFLICT ("VariableCode") DO ' + onconflict + ' RETURNING *'
					//~ console.log(stmt)
					promises.push(
						pool.connect()
						    .then(client => {
								return client.query(stmt)
									.then(res => {
										client.release()
										console.log(res.rows)
										return {property:"variable",result:res.rows}
									}).catch(e => {
										client.release()
										console.log(e.stack)
										return {property:"variable",result:[]}
									})
							})
					)
							
					//~ })
				}
				var methodDescription
				method: {
					//~ if(!vocabulary) {
						//~ break method
					//~ }
					if(!series.method) {
						break method
					}
					if(!series.method.attributes) {
						break method
					}
					if(!series.method.attributes.methodID) {
						break method
					}
					if(parseInt(series.method.attributes.methodID) == "NaN") {
						console.log("methodID not an integer")
						break method
					}
					if(!series.method.methodDescription) {
						break method
					}
					console.log("intentando insert de method")
					// NOTE: property methodCode is ignored, new value created as: "methodID"
					//       property MethodID is ignored, new value generated as next value in index
					var values =  "DEFAULT,'" + series.method.methodDescription + "','" + parseInt(series.method.attributes.methodID) + "'," + ((series.method.methodLink) ? "'" + series.method.methodLink + "'" : "NULL" )
					var onconflict = (update) ? 'UPDATE SET  "MethodDescription"=excluded."MethodDescription", "MethodLink"=excluded."MethodLink"' : 'NOTHING'
					var stmt = 'INSERT INTO "Methods" ("MethodID", "MethodDescription", "MethodCode", "MethodLink") VALUES (' + values + ') ON CONFLICT ("MethodCode") DO ' + onconflict + ' RETURNING *'
					//~ console.log(stmt)
					promises.push(
						pool.connect()
							.then(client => {
								return client.query(stmt)
									.then(res => {
										client.release()
										console.log(res.rows[0])
										return {property:"method",result:res.rows}
									}).catch(e => {
										client.release()
										console.log(e.stack)
										return {property:"method",result:[]}
									})
							})
					)
				}
				var organization
				source: {
					//~ if(!vocabulary) {
						//~ break source
					//~ }
					if(!series.source) {
						break source
					}
					if(!series.source.organization) {
						break source
					}
					organization = series.source.organization
					if(!series.source.sourceDescription) {
						break source
					}
					console.log("intentando insert de source")
					// NOTE: property sourceCode is ignored, new value created as: "sourceID"
					//       property SourceID is ignored, new value generated as next value in index
					var values = "DEFAULT,'" + series.source.organization + "','" + series.source.sourceDescription + "'," + ((series.source.sourceLink) ? "'" + series.source.sourceLink + "'" : "NULL") +  "," + ((series.source.contactInformation) ? (series.source.contactInformation.contactName) ? "'" + series.source.contactInformation.contactName + "'" : "DEFAULT"  : "DEFAULT") + "," +  ((series.source.contactInformation) ? (series.source.contactInformation.phone) ? "'" + series.source.contactInformation.phone + "'" : "DEFAULT"  : "DEFAULT") + "," + ((series.source.contactInformation) ? (series.source.contactInformation.email) ? "'" + series.source.contactInformation.email + "'" : "DEFAULT"  : "DEFAULT") + "," + ((series.source.contactInformation) ? (series.source.contactInformation.address) ? "'" + series.source.contactInformation.address + "'" : "DEFAULT"  : "DEFAULT") + "," + ((series.source.contactInformation) ? (series.source.contactInformation.address) ? (series.source.contactInformation.address.city) ? "'" + series.source.contactInformation.address.city + "'" : "DEFAULT"  : "DEFAULT" : "DEFAULT") + "," +  ((series.source.contactInformation) ? (series.source.contactInformation.address) ? (series.source.contactInformation.address.state) ? "'" + series.source.contactInformation.address.state + "'" : "DEFAULT"  : "DEFAULT" : "DEFAULT") + "," + ((series.source.contactInformation) ? (series.source.contactInformation.address) ? (series.source.contactInformation.address.zipCode) ? "'" + series.source.contactInformation.address.zipCode + "'" : "DEFAULT"  : "DEFAULT" : "DEFAULT") + "," + ((series.source.citation) ? "'" + series.source.citation + "'" : "NULL") + "," + ((series.source.metadataID) ? (parseInt(series.source.metadataID) != 'NaN') ? parseInt(series.source.metadataID) : "DEFAULT" : "DEFAULT") + "," + "'" + ((series.source.sourceID) ? parseInt(series.source.sourceID) : "0") + "'"
					var onconflict = (update) ? 'UPDATE SET "Organization"=excluded."Organization", "SourceDescription"=excluded."SourceDescription", "SourceLink"=excluded."SourceLink", "ContactName"=excluded."ContactName", "Phone"=excluded."Phone", "Email"=excluded."Email", "Address"=excluded."Address", "City"=excluded."City", "State"=excluded."State", "ZipCode"=excluded."ZipCode", "Citation"=excluded."Citation", "MetadataID"=excluded."MetadataID"' : 'NOTHING'
					var stmt = 'INSERT INTO "Sources" ("SourceID","Organization","SourceDescription","SourceLink","ContactName","Phone","Email","Address","City","State","ZipCode","Citation","MetadataID","SourceCode") VALUES (' + values + ') ON CONFLICT ("SourceCode") DO ' + onconflict + ' RETURNING *'
					//~ console.log(stmt)
					promises.push(
						pool.connect()
						.then(client => {
							return client.query(stmt)
								.then(res => {
									client.release()
									console.log(res.rows[0])
									return {property:"method",result:res.rows}
								}).catch(e => {
									client.release()
									console.log(e.stack)
									return {property:"method",result:[]}
								})
						})
					)
				}
				SeriesCatalog: {
					console.log(site.siteInfo)
					var siteCode = (site.siteInfo) ? (site.siteInfo.siteCode) ? (Array.isArray(site.siteInfo.siteCode)) ? (typeof site.siteInfo.siteCode[0] === 'string') ? site.siteInfo.siteCode[0] : (site.siteInfo.siteCode[0].$value) ? site.siteInfo.siteCode[0].$value : null : (typeof site.siteInfo.siteCode === 'string') ? site.siteInfo.siteCode : (site.siteInfo.siteCode.$value) ? site.siteInfo.siteCode.$value : null : null : null
					if(! siteCode) {
						console.log("no siteCode!")
						break SeriesCatalog
					}
					if(!variableCode) {
						console.log("no variableCode")
						break SeriesCatalog
					}
					promises.push(
						pool.connect()
						.then(client => {
							var args = [  ((series.variableTimeInterval) ? (series.variableTimeInterval.beginDateTime) ? series.variableTimeInterval.beginDateTime : 'NULL' : 'NULL') , ((series.variableTimeInterval) ? (series.variableTimeInterval.endDateTime) ? series.variableTimeInterval.endDateTime : 'NULL' : 'NULL'),  ((series.variableTimeInterval) ? (series.variableTimeInterval.beginDateTimeUTC) ? series.variableTimeInterval.beginDateTimeUTC : 'NULL' : 'NULL') , ((series.variableTimeInterval) ? (series.variableTimeInterval.endDateTimeUTC) ? series.variableTimeInterval.endDateTimeUTC : 'NULL' : 'NULL'), ((series.valueCount) ? series.valueCount : 'NULL'), siteCode, variableCode, ((methodDescription) ? methodDescription : 'Unknown'), ((organization) ? organization : 'NULL'), ((series.qualityControlLevel) ? (series.qualityControlLevelCode) ? (Array.isArray(series.qualityControlLevelCode)) ? (typeof series.qualityControlLevelCode[0] === 'string') ? series.qualityControlLevelCode[0] : (series.qualityControlLevelCode[0].$value) ? series.qualityControlLevelCode[0].$value : 'Unknown' : (typeof series.qualityControlLevelCode === 'string') ? series.qualityControlLevelCode : (series.qualityControlLevelCode.$value) ? series.qualityControlLevelCode.$value : 'Unknown' : 'Unknown' : 'Unknown' )]
							return client.query("INSERT INTO \"SeriesCatalog\" (\"SiteID\",\"SiteCode\",\"SiteName\",\"SiteType\", \"VariableID\", \"VariableCode\", \"VariableName\", \"Speciation\", \"VariableUnitsID\", \"VariableUnitsName\", \"SampleMedium\", \"ValueType\", \"TimeSupport\", \"TimeUnitsID\", \"TimeUnitsName\", \"DataType\", \"GeneralCategory\", \"MethodID\", \"MethodDescription\", \"SourceID\", \"Organization\", \"SourceDescription\", \"Citation\", \"QualityControlLevelID\", \"QualityControlLevelCode\", \"BeginDateTime\", \"EndDateTime\", \"BeginDateTimeUTC\", \"EndDateTimeUTC\", \"ValueCount\") SELECT \"Sites\".\"SiteID\",\"Sites\".\"SiteCode\", \"Sites\".\"SiteName\",  \"Sites\".\"SiteType\", \"Variables\".\"VariableID\", \"Variables\".\"VariableCode\", \"Variables\".\"VariableName\", \"Variables\".\"Speciation\", \"Variables\".\"VariableUnitsID\", varunits.\"UnitsName\", \"Variables\".\"SampleMedium\", \"Variables\".\"ValueType\", \"Variables\".\"TimeSupport\", \"Variables\".\"TimeUnitsID\", timeunits.\"UnitsName\", \"Variables\".\"DataType\", \"Variables\".\"GeneralCategory\", \"Methods\".\"MethodID\", \"Methods\".\"MethodDescription\", \"Sources\".\"SourceID\", \"Sources\".\"Organization\", \"Sources\".\"SourceDescription\", \"Sources\".\"Citation\", \"QualityControlLevels\".\"QualityControlLevelID\", \"QualityControlLevels\".\"QualityControlLevelCode\",$1, $2, $3, $4, $5 FROM \"Sites\" JOIN \"Variables\" ON (\"SiteCode\"=$6 AND \"VariableCode\"=$7) LEFT JOIN \"Units\" varunits ON (varunits.\"UnitsID\"=\"Variables\".\"VariableUnitsID\") LEFT JOIN \"Units\" timeunits ON (timeunits.\"UnitsID\"=\"Variables\".\"TimeUnitsID\") LEFT JOIN \"Methods\" ON (\"Methods\".\"MethodDescription\" = $8) LEFT JOIN \"Sources\" ON (\"Sources\".\"Organization\" = $9) LEFT JOIN \"QualityControlLevels\" ON (\"QualityControlLevels\".\"QualityControlLevelCode\"=$10) ON CONFLICT (\"SiteID\", \"VariableID\") DO NOTHING RETURNING *",args)
							.then(res => {
								client.release()
								console.log(res.rows[0])
								return {property:"seriesCatalog",result:res.rows}
							}).catch(e => {
								client.release()
								console.log(e.stack)
								return {property:"seriesCatalog",result:[]}
							})
						})
					)
				}
			})
		})
		Promise.all(promises)
			.then(values => {
				console.log("insert siteinfo success")
				console.log(values)
				//~ var variableCodes = values.map(item => {
					//~ return item.rows.map(row => {
						//~ return row.VariableCode
					//~ })
				//~ })
				//~ resolve({action:"insertSiteInfo",result:flatten(variableCodes)})
				var codenames = {source:"Organization", method: "MethodDescription", variable: "VariableCode", seriesCatalog: "SeriesID"}
				var codes = values.map(item => {
					console.log("reading inserted:" + item.property)
					var codename = codenames[item.property]
					return item.result.map(res => {
						return res[codename]
					})
				})
				resolve({action:"insertSiteInfo",result:flatten(codes)})
			})
			.catch(e => {
				console.log("insert siteinfo error")
				console.log(e)
				reject({message: "insert siteinfo error",error:e})
			})
			
	})
}


exports.insertValues =  function(pool,data,update) {
	return new Promise((resolve, reject) => {
		if(!data.timeSeriesResponse) {
			console.log("Error: missing timeSeriesResponse property");
			reject("missing timeSeriesResponse property")
		}
		if(!data.timeSeriesResponse.timeSeries) {
			console.log("Error: missing timeSeriesResponse.timeSeries property");
			reject("missing timeSeriesResponse.timeSeries property")
		}
		if(Array.isArray(data.timeSeriesResponse.timeSeries)) {
			data.timeSeriesResponse.timeSeries = data.timeSeriesResponse.timeSeries[0]
		}
		var series = data.timeSeriesResponse.timeSeries
		if(!series.values) {
			console.log("timeSeriesResponse.timeSeries.values property missing")
			reject("timeSeriesResponse.timeSeries.values property missing")
		}
		if(Array.isArray(series.values)) {
			series.values = series.values[0]
		}
		if(!series.values.value) {
			console.log("timeSeriesResponse.timeSeries.values.value property missing")
			reject("timeSeriesResponse.timeSeries.values.value property missing")
		}
		if(! Array.isArray(series.values.value)) {
			console.log("timeSeriesResponse.timeSeries.values.value must be an Array!")
			reject("timeSeriesResponse.timeSeries.values.value must be an Array!")
		}
		var promises = []
		var siteCode
		site: {
			if(!series.sourceInfo) {
				break site
			}
			if(! series.sourceInfo.siteCode) {
				console.log("Warning: siteCode missing")
				break site
			}
			if(Array.isArray(series.sourceInfo.siteCode)) {
				series.sourceInfo.siteCode = series.sourceInfo.siteCode[0]
			}
			if(typeof series.sourceInfo.siteCode === 'string') {
				siteCode = series.sourceInfo.siteCode
			} else {
				if(!series.sourceInfo.siteCode.$value) {
					console.log("Warning: series.sourceInfo.siteCode.$value missing")
					break site
				}
				if(!series.sourceInfo.siteCode.attributes) {
					console.log("Warning: series.sourceInfo.siteCode.attibutes missing")
					break site
				}
				if(!series.sourceInfo.siteCode.attributes.network) {
					console.log("Warning: series.sourceInfo.siteCode.attributes.network missing")
					break site
				}
				siteCode = series.sourceInfo.siteCode.attributes.network + ":" + series.sourceInfo.siteCode.$value
			}
			if(! series.sourceInfo.siteName) {
				console.log("Warning: series.sourceInfo.siteName missing")
				break site
			}
			if(! series.sourceInfo.geoLocation) {
				console.log("Warning: series.sourceInfo.geoLocation missing")
				break site
			}
			if(! series.sourceInfo.geoLocation.geogLocation) {
				console.log("Warning: series.sourceInfo.geoLocation.geogLocation missing")
				break site
			}
			if(! series.sourceInfo.geoLocation.geogLocation.latitude) {
				console.log("Warning: series.sourceInfo.geoLocation.geogLocation.latitude missing")
				break site
			}
			if(! series.sourceInfo.geoLocation.geogLocation.longitude) {
				console.log("Warning: series.sourceInfo.geoLocation.geogLocation.longitude missing")
				break site
			}
			var values = "'" + series.sourceInfo.siteName + "','" + siteCode + "',st_setsrid(st_point(" + series.sourceInfo.geoLocation.geogLocation.longitude + "," + series.sourceInfo.geoLocation.geogLocation.latitude + "),4326),"+ series.sourceInfo.geoLocation.geogLocation.longitude + "," + series.sourceInfo.geoLocation.geogLocation.latitude + "," + ((series.sourceInfo.elevation_m) ? series.sourceInfo.elevation_m : "null") + ",3"
			console.log("intentando insertSites")
			var onconflict = (update) ? 'UPDATE SET "SiteName"=excluded."SiteName", "Geometry"=excluded."Geometry", "Longitude"=excluded."Longitude", "Latitude"=excluded."Latitude", "Elevation_m"=excluded."Elevation_m", "LatLongDatumID"=excluded."LatLongDatumID"' : "NOTHING"
			var stmt = 'INSERT INTO "Sites" ("SiteName", "SiteCode", "Geometry", "Longitude", "Latitude", "Elevation_m","LatLongDatumID") values (' + values + ') ON CONFLICT ("SiteCode") DO ' + onconflict + ' RETURNING *'
			//~ console.log(stmt)
			promises.push(pool.connect()
				.then(client => {
					client.query(stmt)
						.then(res => {
							client.release()
							console.log(res.rows[0])
						})
						.catch(e => {
							client.release()
							console.log(e.stack)
						})
				})
			)
		}
		if(!siteCode) {
			console.log("siteCode missing!")
			reject("siteCode missing!")
			return
		}
		var variableCode
		variable: {
					if(!series.variable) {
						console.log("series.variable missing")
						break variable
					}
					if(!series.variable.variableCode) {
						console.log("series.variable.variableCode missing")
						break variable
					}
					if(Array.isArray(series.variable.variableCode)) {
						series.variable.variableCode = series.variable.variableCode[0]
					}
					if(typeof series.variable.variableCode === 'string') {
						variableCode = series.variable.variableCode
					} else {
						if(!series.variable.variableCode.attributes) {
							console.log("series.variable.variableCode.attributes missing")
							break variable
						}
						if(!series.variable.variableCode.attributes.vocabulary) {
							console.log("series.variable.variableCode.attributes.vocabulary missing")
							break variable
						}
						if(series.variable.variableCode.$value) {
							variableCode = series.variable.variableCode.$value
						} else if(series.variable.variableCode.attributes.variableID) {
							variableCode = series.variable.variableCode.attributes.vocabulary + ":" + series.variable.variableCode.attributes.variableID
						} else {
							console.log("series.variable.variableCode.attributes.variableID missing, variableCode.$value missing")
							break variable
						}
					}
					if(!series.variable.variableName) {
						break variable
					}
					//~ vocabulary = series.variable.variableCode.attributes.vocabulary
					console.log("intentando insert de variable")
					var values = "'" + series.variable.variableName + "','" + variableCode + "'," + ((series.variable.speciation) ? (series.variable.speciation != "") ? "'" + series.variable.speciation + "'" : "'Not Applicable'" : "'Not Applicable'" ) + "," + ((series.variable.unit) ? (series.variable.unit.attributes) ? (series.variable.unit.attributes.unitID) ? series.variable.unit.attributes.unitID : 0 : 0 : 0 ) + "," + ((series.variable.sampleMedium) ? (series.variable.sampleMedium != "") ? "'" + series.variable.sampleMedium + "'" : "'Unknown'" : "'Unknown'" ) + "," + ((series.variable.valueType) ? (series.variable.valueType != "") ? "'" + series.variable.valueType + "'" : "'Unknown'" : "'Unknown'") + "," + ((series.variable.timeScale) ? (series.variable.timeScale.attributes) ? (series.variable.timeScale.attributes.isRegular) ? series.variable.timeScale.attributes.isRegular : "DEFAULT" : "DEFAULT" : "DEFAULT") + "," + ((series.variable.timeScale) ? (series.variable.timeScale.timeSupport) ? series.variable.timeScale.timeSupport : "DEFAULT" : "DEFAULT") + "," + ((series.variable.timeScale) ? (series.variable.timeScale.unit) ? (series.variable.timeScale.unit.unitCode) ? series.variable.timeScale.unit.unitCode : "DEFAULT" : "DEFAULT" : "DEFAULT") + "," + ((series.variable.dataType) ? (series.variable.dataType != "") ? "'" + series.variable.dataType + "'" : "'Unknown'" : "'Unknown'") + "," + ((series.variable.generalCategory) ? (series.variable.generalCategory != "") ? "'" + series.variable.generalCategory + "'" : "'Unknown'"  : "'Unknown'") + "," + ((series.variable.noDataValue) ? (series.variable.noDataValue != "") ? series.variable.noDataValue : "0" : "0")
					var onconflict = (update) ? 'UPDATE SET "VariableName"=excluded."VariableName", "VariableCode"=excluded."VariableCode", "Speciation"=excluded."Speciation", "VariableUnitsID"=excluded."VariableUnitsID", "SampleMedium"=excluded."SampleMedium",  "ValueType"=excluded."ValueType", "IsRegular"=excluded."IsRegular", "TimeSupport"=excluded."TimeSupport", "TimeUnitsID"=excluded."TimeUnitsID", "DataType"=excluded."DataType", "GeneralCategory"=excluded."GeneralCategory", "NoDataValue"=excluded."NoDataValue"' : 'NOTHING'
					var stmt = 'INSERT INTO "Variables" ("VariableName", "VariableCode", "Speciation", "VariableUnitsID", "SampleMedium", "ValueType","IsRegular","TimeSupport","TimeUnitsID","DataType", "GeneralCategory","NoDataValue") values (' + values + ') ON CONFLICT ("VariableCode") DO ' + onconflict + ' RETURNING *'
					//~ console.log(stmt)
					promises.push(pool.connect()
						.then(client => {
							client.query(stmt)
								.then(res => {
									client.release()
									console.log(res.rows[0])
								})
								.catch(e => {
									client.release()
									console.log(e.stack)
								})
						})
					)
		}
		if(!variableCode) {
			console.log("missing variableCode!")
			reject("missing variableCode!")
			return
		}
		Promise.all(promises)
			.then(values => {
				(async () => {
					const client = await pool.connect()
					let datavalues
					try {
						await client.query('BEGIN')
						const v = await client.query('SELECT "SiteID","VariableID" from "Sites","Variables" WHERE "SiteCode"=$1 AND "VariableCode"=$2',[siteCode,variableCode])
					    //~ .then(values => {
						//~ console.log(values)
						if(!v.rows) {
							reject("database error")
							return
						}
						if(v.rows.length <= 0) {
							reject("SiteID + VariableID not found")
							return
						}
						var siteID = v.rows[0].SiteID
						var variableID = v.rows[0].VariableID
						var insertdata = ""
						series.values.value.forEach( function(value) {
							if(!value.$value) {
								console.log(" $value missing!")
								return
							}
							if(parseInt(value.$value == 'NaN')) {
								console.log("$value is NaN!")
								return
							}
							if(!value.attributes) {
								console.log("attributes missing!")
								return
							}
							if(!value.attributes.dateTime) {
								console.log("dateTime missing!")
								return
							}
							var dateTimeUTC = (value.attributes.dateTimeUTC) ? "'" + value.attributes.dateTimeUTC + "'" : (value.attributes.timeOffset) ? "'" + value.attributes.dateTime + "'::timestamp + '" +  value.attributes.timeOffset + "'::interval" : "'" + value.attributes.dateTime + "':timestamp" 
							var methodCode = (value.attributes.MethodID && vocabulary) ? vocabulary + ":" + value.attributes.MethodID : "0"
							var sourceCode = (value.attributes.SourceID && vocabulary) ? vocabulary + ":" + value.attributes.SourceID : "0"
							insertdata = insertdata + '(' + parseInt(value.$value) + "," + ((value.attributes.accuracyStdDev) ? value.attributes.accuracyStdDev : "NULL") + "," + dateTimeUTC + ",'" + value.attributes.dateTime + "'," +  ((value.attributes.UTCOffset) ? value.attributes.UTCOffset : "0") + "," + siteID + "," + variableID + "," + ((value.attributes.offsetValue) ? value.attributes.offsetValue : "NULL") + "," + ((value.attributes.offsetTypeID) ? value.attributes.offsetTypeID : "NULL") + "," + ((value.attributes.censorCode) ? "'" + value.attributes.censorCode + "'" : "'nc'") + ",'" + methodCode + "','" + sourceCode + "'),"
						})
						if(insertdata.length <= 0) {
							reject("No data values")
						}
						insertdata = insertdata.slice(0,-1)
						console.log("intentando insert de values")
						//~ console.log(insertdata)
						//~ (async () => {
					//~ let datavalues
							//~ try {
					    //~ await client.query('BEGIN')
						await client.query('CREATE TEMPORARY TABLE datavalues_tmp ("DataValue" real, "ValueAccuracy" real, "DateTimeUTC" timestamp, "LocalDateTime" timestamp, "UTCOffset" real, "SiteID" int, "VariableID" int, "OffsetValue" real, "OffsetTypeID" int, "CensorCode" varchar(50), "MethodCode" varchar, "SourceCode" varchar) ON COMMIT DROP')
						await client.query('INSERT INTO datavalues_tmp ("DataValue", "ValueAccuracy", "DateTimeUTC", "LocalDateTime", "UTCOffset", "SiteID", "VariableID", "OffsetValue", "OffsetTypeID", "CensorCode", "MethodCode", "SourceCode") values ' + insertdata)
						datavalues = await client.query('INSERT INTO "DataValues" ("DataValue", "ValueAccuracy", "DateTimeUTC", "LocalDateTime", "UTCOffset", "SiteID", "VariableID","OffsetValue", "OffsetTypeID", "CensorCode", "MethodID", "SourceID") SELECT datavalues_tmp."DataValue", datavalues_tmp."ValueAccuracy", datavalues_tmp."DateTimeUTC", datavalues_tmp."LocalDateTime", datavalues_tmp."UTCOffset", datavalues_tmp."SiteID", datavalues_tmp."VariableID", datavalues_tmp."OffsetValue", datavalues_tmp."OffsetTypeID", datavalues_tmp."CensorCode",  "Methods"."MethodID", "Sources"."SourceID" FROM datavalues_tmp LEFT JOIN "Methods" ON (datavalues_tmp."MethodCode"="Methods"."MethodCode") LEFT JOIN "Sources" ON (datavalues_tmp."SourceCode"="Sources"."SourceCode") ON CONFLICT ("SiteID", "VariableID", "SourceID", "DateTimeUTC") DO NOTHING RETURNING *')
						await client.query('COMMIT')
				} catch(e) {
					await client.query('ROLLBACK')
					throw e
				}
				 finally {
					client.release()
				}
				return datavalues
			})()
				.then(values=>{
					console.log("inserted " + values.rows.length + " datavalues")
					resolve({action:"insertValues",result:values.rows})
				})
				.catch(e=>{
					console.log(e.stack)
					reject("Database error")
				})

					//~ })
					//~ .catch(e=>{
						//~ console.log(e.stack)
						//~ reject("Database error")
					//~ })	
			})							
			.catch(e=>{
				console.log(e.stack)
				reject("Database error")
			})
	})
}

