<!DOCTYPE html>
<html>
<head>
    <title>Test Hash</title>
</head>
<body>
    <h1>Générateur de hash pour les mots de passe</h1>
    
    <cfset salt = "MealTrack2025Sodexo">
    
    <cfset passwords = [
        {user="admin@sodexo.com", pass="admin123"},
        {user="manager@sodexo.com", pass="manager123"},
        {user="roro@sodexo.com", pass="roro123"}
    ]>
    
    <cfloop array="#passwords#" index="pwd">
        <p>
            <strong><cfoutput>#pwd.user#</cfoutput></strong><br>
            Password: <cfoutput>#pwd.pass#</cfoutput><br>
            Hash: <cfoutput>#hash(pwd.pass & salt, "SHA-256")#</cfoutput>
        </p>
        <hr>
    </cfloop>
</body>
</html>