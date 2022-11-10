import requests
import folium
from folium.features import DivIcon

m = folium.Map(location=[40.84, -38], zoom_start=3) #create our map
locations = ['posteInsa', 'lesArcs', 'paris1'] #list of all the data collected
colors = ['blue', 'red', 'black'] #a few colours to draw the lines

allPoints = [] #list of all the points on the map WITHOUT duplicates

for i in range(0, len(locations)):
    with open("./data/"+ locations[i] +".txt", 'r') as f:
        #content = f.readlines()
        pointsOfThisRoute = [] #list of all the points of one route
        noDupPointsOfThisRoute = [] #list of all the points of one route WITHOUT duplicates (if several ip for one location => count 1)
        idCoor = 0
        print(i)
        #Check every line of the traceroute
        for line in f.readlines():
            #if we got an ip address (and not *), extract it
            if "(" in line and ")" in line:
                ip = line[line.find("(")+1:line.find(")")]
                idStr = line[0:3] #number of hop found at the beginning of the line
                if idStr!= '   ':
                    idInt = int(idStr) #if it's not empty (meaning that there wasn't any hop), turn it to an int
                
                response = (requests.get("http://ip-api.com/json/" + ip)).json() #api request to get the location of the ip address
                print(response.get('status'))

                if response.get('status')=='success':
                    #get latitude and longitude
                    currentLat = response.get('lat') 
                    currentLon = response.get('lon')

                    #offset for the tags on the map depending on the number of times one location is used in different routes (a)
                    #and how many ip correspond to that location in one specific route (b)
                    a = allPoints.count((currentLat, currentLon))
                    b = pointsOfThisRoute.count((currentLat, currentLon))

                    #fill the two lists with the new location
                    pointsOfThisRoute.append((currentLat, currentLon))
                    if not (currentLat, currentLon) in noDupPointsOfThisRoute:
                        noDupPointsOfThisRoute.append((currentLat,currentLon))
    
                    #create the point on the map
                    folium.Marker(
                        location = [currentLat, currentLon],
                        popup = ip,
                        icon=DivIcon(
                            icon_size=(100,20),
                            icon_anchor=(-a*110,-b*20),
                            html='<div style="font-size: 6pt; background-color:' + colors[i] + '; border-radius:2px; text-align: center; color: white">' + str(idInt) + " - " +ip + '</div>',
                            )
                    ).add_to(m)

    allPoints = allPoints + noDupPointsOfThisRoute

    #add the routes
    folium.PolyLine(pointsOfThisRoute, color=colors[i], weight=2.5, opacity=1).add_to(m)

m.save("map.html")
