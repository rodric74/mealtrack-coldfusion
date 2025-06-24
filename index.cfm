<!--- Initialisation des services --->
<cfset restaurantObj = new components.Restaurant("")>
<cfset incidentService = new components.IncidentService()>

<cfset listeRestaurants = restaurantObj.getAllRestaurants()>
<cfset typesIncidents = incidentService.getIncidentTypes()>

<!DOCTYPE html>
<html>
<head>
    <title>MealTrack - SODEXO</title>
    <meta charset="UTF-8">
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        .restaurant-card { 
            border: 1px solid #ddd; 
            padding: 15px; 
            margin: 10px 0;
            border-radius: 5px;
        }
        .incident-type {
            display: inline-block;
            margin: 5px;
            padding: 8px 15px;
            background: #f0f0f0;
            border-radius: 20px;
        }
    </style>
</head>
<body>
    <h1>🍽️ MealTrack - Système de suivi qualité</h1>
    
    <cfset username = "Roro">
    <p>Bonjour <strong><cfoutput>#username#</cfoutput></strong> ! 
    Nous sommes le <cfoutput>#dateFormat(now(), "dd/mm/yyyy")# à #timeFormat(now(), "HH:mm")#</cfoutput></p>
    
    <h2>Nos restaurants :</h2>
    <cfloop array="#listeRestaurants#" index="resto">
        <div class="restaurant-card">
            <h3><cfoutput>#resto.nom#</cfoutput></h3>
            <p>📍 <cfoutput>#resto.adresse#</cfoutput></p>
            <p>👥 Capacité : <cfoutput>#resto.capacite#</cfoutput> places</p>
        </div>
    </cfloop>
    
    <h2>Types d'incidents gérés :</h2>
    <cfloop array="#typesIncidents#" index="type">
        <span class="incident-type">
            <cfoutput>#type.icon# #type.label#</cfoutput>
        </span>
    </cfloop>

    <h2>Horaires de service :</h2>
<cfset serviceHours = incidentService.getServiceHours()>
<cfloop array="#serviceHours#" index="service">
    <div style="margin: 10px 0;">
        <cfoutput>
            <strong>#service.icon# #service.label#</strong> : #service.horaire#
        </cfoutput>
    </div>
</cfloop>
    
</body>
</html>