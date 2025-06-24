<cfcomponent displayname="Restaurant" hint="Gestion des restaurants SODEXO">
    
    <!--- Propriétés --->
    <cfproperty name="id" type="numeric">
    <cfproperty name="nom" type="string">
    <cfproperty name="adresse" type="string">
    <cfproperty name="capacite" type="numeric">
    <cfproperty name="email" type="string">
    
    <!--- Constructeur --->
    <cffunction name="init" access="public" returntype="Restaurant">
        <cfargument name="nom" type="string" required="true">
        <cfargument name="adresse" type="string" required="false" default="">
        <cfargument name="capacite" type="numeric" required="false" default="0">
        <cfargument name="email" type="string" required="false" default="">
        
        <cfset this.id = 0>
        <cfset this.nom = arguments.nom>
        <cfset this.email = arguments.email>
        <cfset this.adresse = arguments.adresse>
        <cfset this.capacite = arguments.capacite>
        
        <cfreturn this>
    </cffunction>
    
    <!--- Méthode pour obtenir tous les restaurants --->
    <cffunction name="getAllRestaurants" access="public" returntype="array">
        <!--- Pour l'instant, on simule une base de données --->
        <cfset var restaurants = []>
        
        <cfset arrayAppend(restaurants, new Restaurant("Restaurant Tour A", "Tour A - 2ème étage", 150))>
        <cfset arrayAppend(restaurants, new Restaurant("Cantine Centrale", "Bâtiment Principal", 300))>
        <cfset arrayAppend(restaurants, new Restaurant("Espace Cafétéria B2", "Tour B - RDC", 80))>
        <cfset arrayAppend(restaurants, new Restaurant("Espace Cafétéria C2", "Tour C - RDC", 80))>
        
        
        <cfreturn restaurants>
    </cffunction>
    
</cfcomponent>