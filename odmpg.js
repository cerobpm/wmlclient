// odmpg.js

// Inserts WaterML data (first converted into JSON) into an ODM PG database

exports.insert =  function(client,data) {
		if(!data.sitesResponse) {
			console.log("Error: missing sitesResponse property");
			return;
		}
		if(!data.sitesResponse.site) {
			console.log("Error: missing sitesResponse.site property");
			return;
		}
		if(! Array.isArray(data.siteResponse.site)) {
			console.log("Error: data.siteResponse.site must be an Array");
			return;
		}
		var insertdata = ""
		data.siteResponse.site.forEach( function(site) {
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
			insertdata = insertdata + "('" + site.siteInfo.siteName + "','"+site.siteInfo.siteCode+"',st_setsrid(st_point(" + site.siteInfo.geoLocation.geogLocation.longitude + "," + site.siteInfo.geoLocation.geogLocation.latitude + "),4326),"+ geoLocation.geogLocation.longitude + "," + geoLocation.geogLocation.latitude + "," + ((site.siteInfo.elevation_m) ? site.siteInfo.elevation_m : "null") + "),"
		})
		if(insertdata.length <= 0) {
			console.log("Error: no data")
			return;
		}
		insertdata.chop()
		console.log("intentando insert")
		client.query('INSERT INTO "Sites" ("SiteName", "SiteCode", "Geometry", "Longitude", "Latitude", "elevation_m") values ' + insertdata + ' ON CONFLICT ("SiteCode") DO UPDATE SET "SiteName"=excluded."SiteName" RETURNING *;', (err, res) => {
		  if (err) {
			console.log(err.stack)
			return
		  } else {
			console.log("Inserted " + res.rows.length + " rows!")
			return res
		  }
		})
	}

