<cfcomponent displayname="User" hint="Gestion des utilisateurs">
    
    <!--- Liste des utilisateurs (en production : base de données) --->
    <cffunction name="init" access="public" returntype="User">
        <cfreturn this>
    </cffunction>
    
    <!--- Hasher un mot de passe --->
    <cffunction name="hashPassword" access="private" returntype="string">
        <cfargument name="password" type="string" required="true">
        <cfset var salt = "MealTrack2025Resto"> <!--- Salt modifié --->
        <cfreturn hash(arguments.password & salt, "SHA-256")>
    </cffunction>
    
    <!--- Authentifier un utilisateur --->

<cffunction name="authenticate" access="public" returntype="boolean">
    <cfargument name="email" type="string" required="true">
    <cfargument name="password" type="string" required="true">
    
    <!--- Liste d'utilisateurs avec mots de passe hashés --->
    <cfset var users = [
        {
            email="admin@resto.com", 
            passwordHash="CD770066C480DB643E8B6581B186883726E3F176DD03ABB96DD6AC55112B6FA5", 
            name="Administrateur", 
            role="admin"
        },
        {
            email="manager@resto.com", 
            passwordHash="B7B924E0DE1DB56814B4ABC7928E223E3903BF9D936D12ABBC3FB5FC5B0D9D35", 
            name="Manager Restaurant", 
            role="manager"
        },
        {
            email="roro@resto.com", 
            passwordHash="17A9BAD16F6215C191E2A357FCFE9A478A2A9D321F3AAB28CAFCDADC36D1F742", 
            name="Roro", 
            role="user"
        }
    ]>
    
    <!--- Hasher le mot de passe fourni --->
    <cfset var hashedPassword = hashPassword(arguments.password)>
    
    <!--- Vérifier les credentials avec hash --->
    <cfloop array="#users#" index="user">
        <cfif user.email EQ arguments.email AND user.passwordHash EQ hashedPassword>
            <!--- Stocker en session --->
            <cfset session.user = {
                email = user.email,
                name = user.name,
                role = user.role,
                isLoggedIn = true,
                lastActivity = now()
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