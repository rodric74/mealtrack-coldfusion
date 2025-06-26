<cfcomponent displayname="User" hint="Gestion des utilisateurs">
    
    <!--- Liste des utilisateurs (en production : base de données) --->
    <cffunction name="init" access="public" returntype="User">
        <cfreturn this>
    </cffunction>
    
    <!--- Authentifier un utilisateur --->
    <cffunction name="authenticate" access="public" returntype="boolean">
        <cfargument name="email" type="string" required="true">
        <cfargument name="password" type="string" required="true">
        
        <!--- Liste d'utilisateurs de test --->
        <cfset var users = [
            {email="admin@sodexo.com", password="admin123", name="Administrateur", role="admin"},
            {email="manager@sodexo.com", password="manager123", name="Manager Restaurant", role="manager"},
            {email="roro@sodexo.com", password="roro123", name="Roro", role="user"}
        ]>
        
        <!--- Vérifier les credentials --->
        <cfloop array="#users#" index="user">
            <cfif user.email EQ arguments.email AND user.password EQ arguments.password>
                <!--- Stocker en session --->
                <cfset session.user = {
                    email = user.email,
                    name = user.name,
                    role = user.role,
                    isLoggedIn = true
                }>
                <cfreturn true>
            </cfif>
        </cfloop>
        
        <cfreturn false>
    </cffunction>
    
    <!--- Déconnecter --->
    <cffunction name="logout" access="public" returntype="void">
        <cfset structDelete(session, "user")>
    </cffunction>
    
    <!--- Vérifier si connecté --->
    <cffunction name="isLoggedIn" access="public" returntype="boolean">
        <cfreturn structKeyExists(session, "user") AND session.user.isLoggedIn>
    </cffunction>
    
</cfcomponent>