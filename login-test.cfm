<!DOCTYPE html>
<html>
<head>
    <title>Test Login</title>
</head>
<body>
    <h1>Page de test</h1>
    <p>Si tu vois ça, CF fonctionne !</p>
    
    <cftry>
        <cfset userObj = new components.User()>
        <p>Component User chargé !</p>
        
        <cfset isLogged = userObj.isLoggedIn()>
        <p>Status login : <cfoutput>#isLogged#</cfoutput></p>
        
    <cfcatch>
        <h2>ERREUR :</h2>
        <cfdump var="#cfcatch#">
    </cfcatch>
    </cftry>
</body>
</html>