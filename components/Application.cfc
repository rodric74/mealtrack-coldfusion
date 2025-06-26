<cfcomponent>
    <cfset this.name = "MealTrackApp">
    <cfset this.applicationTimeout = createTimeSpan(1,0,0,0)> <!--- 1 jour --->
    <cfset this.sessionManagement = true>
    <cfset this.sessionTimeout = createTimeSpan(0,0,30,0)> <!--- 30 minutes --->
    <cfset this.setClientCookies = true>
    <cfset this.sessionCookie.httpOnly = true> <!--- Sécurité : cookies non accessibles en JS --->
    <cfset this.sessionCookie.secure = false> <!--- Mettre true en HTTPS --->
    
    <!--- Au démarrage de l'application --->
    <cffunction name="onApplicationStart">
        <cfreturn true>
    </cffunction>
    
    <!--- À chaque requête --->
    <cffunction name="onRequestStart">
        <cfargument name="targetPage" type="string" required="true">
        
        <!--- Vérifier le timeout d'inactivité (15 minutes) --->
        <cfif structKeyExists(session, "user") AND structKeyExists(session.user, "lastActivity")>
            <cfset var inactiveMinutes = dateDiff("n", session.user.lastActivity, now())>
            
            <cfif inactiveMinutes GT 1>
                <!--- Session expirée par inactivité --->
                <cfset structDelete(session, "user")>
                <cfset session.loginError = "Session expirée pour inactivité. Veuillez vous reconnecter.">
                
                <!--- Rediriger vers login sauf si on y est déjà --->
                <cfif NOT findNoCase("login.cfm", arguments.targetPage)>
                    <cflocation url="login.cfm" addtoken="false">
                </cfif>
            <cfelse>
                <!--- Mettre à jour l'activité --->
                <cfset session.user.lastActivity = now()>
            </cfif>
        </cfif>
        
        <cfreturn true>
    </cffunction>
    
    <!--- Gestion des erreurs --->
    <cffunction name="onError">
        <cfargument name="exception" required="true">
        <cfargument name="eventName" type="string" required="true">
        
        <!--- Logger l'erreur (en production) --->
        <cflog file="mealtrack_errors" text="#exception.message# - #exception.detail#">
        
        <!--- Afficher une page d'erreur propre --->
        <cfinclude template="error.cfm">
    </cffunction>
</cfcomponent>