<!--- Vérifier que le formulaire est soumis --->
<cfif NOT structKeyExists(form, "email") OR NOT structKeyExists(form, "password")>
    <cflocation url="login.cfm" addtoken="false">
</cfif>

<!--- Authentifier --->
<cfset userObj = new components.User()>
<cfset isAuthenticated = userObj.authenticate(form.email, form.password)>

<cfif isAuthenticated>
    <!--- Rediriger vers le dashboard --->
    <cflocation url="dashboard.cfm" addtoken="false">
<cfelse>
    <!--- Erreur de connexion --->
    <cfset session.loginError = "Email ou mot de passe incorrect">
    <cflocation url="login.cfm" addtoken="false">
</cfif>