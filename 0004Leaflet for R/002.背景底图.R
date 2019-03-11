# OpenStreetMap.Mapnik
# OpenStreetMap.BlackAndWhite
# OpenStreetMap.DE
# OpenStreetMap.France
# OpenStreetMap.HOT
# OpenTopoMap
# Thunderforest.OpenCycleMap
# Thunderforest.Transport
# Thunderforest.TransportDark
# Thunderforest.SpinalMap
# Thunderforest.Landscape
# Thunderforest.Outdoors
# Thunderforest.Pioneer
# OpenMapSurfer.Roads
# OpenMapSurfer.Grayscale
# Hydda.Full
# Stamen.Toner
# Stamen.TonerBackground
# Stamen.TonerLite
# Stamen.Watercolor
# Stamen.Terrain
# Stamen.TerrainBackground
# Stamen.TopOSMRelief
# Esri.WorldStreetMap
# Esri.DeLorme
# Esri.WorldTopoMap
# Esri.WorldImagery
# Esri.WorldTerrain
# Esri.WorldShadedRelief
# Esri.WorldPhysical
# Esri.OceanBasemap
# Esri.NatGeoWorldMap
# Esri.WorldGrayCanvas
# MtbMap
# CartoDB.Positron
# CartoDB.PositronNoLabels
# CartoDB.PositronOnlyLabels
# CartoDB.DarkMatter
# CartoDB.DarkMatterNoLabels
# CartoDB.DarkMatterOnlyLabels
# HikeBike.HikeBike
# HikeBike.HillShading
# NASAGIBS.ModisTerraTrueColorCR
# NASAGIBS.ModisTerraBands367CR
# NASAGIBS.ViirsEarthAtNight2012
# NASAGIBS.ModisTerraLSTDay
# NASAGIBS.ModisTerraSnowCover
# NASAGIBS.ModisTerraAOD
# NASAGIBS.ModisTerraChlorophyll

library(leaflet)

leaflet()%>%setView(lng=116.38,lat=39.9,zoom=3)%>%
  addTiles()%>%addProviderTiles("Stamen.Toner")

leaflet()%>%setView(lng=116.38,lat=39.9,zoom=3)%>%
  addTiles()%>%addProviderTiles("Esri.WorldImagery")


leaflet()%>%setView(lng=116.38,lat=39.9,zoom=3)%>%
  addTiles()%>%addProviderTiles("CartoDB.DarkMatter")


leaflet()%>%setView(lng=116.38,lat=39.9,zoom=2)%>%
  addTiles()%>%addProviderTiles("NASAGIBS.ViirsEarthAtNight2012")


leaflet() %>% 
  setView(lng = 110, lat = 30, zoom = 2) %>%
  addTiles() %>% 
  addProviderTiles("NASAGIBS.ModisTerraTrueColorCR",
                   options = providerTileOptions(
                     time = "2015-01-15", opacity = 1))


leaflet() %>% addTiles() %>% setView(-93.65, 42.0285, zoom = 4) %>%
  addWMSTiles(
    "http://mesonet.agron.iastate.edu/cgi-bin/wms/nexrad/n0r.cgi",
    layers = "nexrad-n0r-900913",
    options = WMSTileOptions(format = "image/png", transparent = TRUE),
    attribution = "Weather data © 2012 IEM Nexrad"
  )
