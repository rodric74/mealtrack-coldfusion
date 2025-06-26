<!--- Vérifier l'authentification --->
<cfset userObj = new components.User()>
<cfif NOT userObj.isLoggedIn()>
    <cfset session.loginError = "Veuillez vous connecter pour accéder à cette page">
    <cflocation url="login.cfm" addtoken="false">
</cfif>