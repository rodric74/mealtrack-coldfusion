<!--- Déconnexion --->
<cfset userObj = new components.User()>
<cfset userObj.logout()>


<cfset structClear(session)>


<cflocation url="login.cfm?logout=success" addtoken="false">