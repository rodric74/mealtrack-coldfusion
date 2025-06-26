<!DOCTYPE html>
<html>
<head>
    <title>Générateur de Hash</title>
</head>
<body>
    <h1>Génération des hashs pour RESTO</h1>
    
    <cfset salt = "MealTrack2025Resto">
    
    <cfset passwords = [
        {user="admin@resto.com", pass="admin123"},
        {user="manager@resto.com", pass="manager123"},
        {user="roro@resto.com", pass="roro123"}
    ]>
    
    <pre>
    <cfloop array="#passwords#" index="pwd">
User: <cfoutput>#pwd.user#</cfoutput>
Pass: <cfoutput>#pwd.pass#</cfoutput>
Hash: <cfoutput>#hash(pwd.pass & salt, "SHA-256")#</cfoutput>
----------------------------------------
    </cfloop>
    </pre>
</body>
</html>