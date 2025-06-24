<!DOCTYPE html>
<html>
<head>
    <title>MealTrack - SODEXO</title>
    <meta charset="UTF-8">
</head>
<body>
    <h1>Bienvenue sur MealTrack</h1>
    
    <cfset heure = now()>
    <cfset jour =  day(heure)>
    cfset username = "Roro">
    <p>Il est actuellement : <cfoutput>#timeFormat(heure, "HH:mm:ss")#</cfoutput></p>
    <p>Nous sommes le : <cfoutput>#jour#</cfoutput></p>
    <p>Bonjour <cfoutput>#username#</cfoutput></p>
    
    <cfset restaurants = ["Restaurant A1", "Restaurant B2", "Cantine Centrale","Restaurant C3"]>
    
    <h2>Nos restaurants :</h2>
    <ul>
        <cfloop array="#restaurants#" index="resto">
            <li><cfoutput>#resto#</cfoutput></li>
        </cfloop>
    </ul>
</body>
</html>
