<!--- Incident.cfc --->

<cfcomponent displayname="Incident" hint="Gestion des incidents">
    
    <!--- Propriétés --->
    <cfproperty name="id" type="numeric">
    <cfproperty name="restaurant" type="string">
    <cfproperty name="type" type="numeric">
    <cfproperty name="severity" type="string">
    <cfproperty name="description" type="string">
    <cfproperty name="name" type="string">
    <cfproperty name="email" type="string">
    <cfproperty name="dateReport" type="date">
    <cfproperty name="status" type="string">
    
    <!--- Simuler une base de données en mémoire --->
    <cfset this.incidents = []>
    
    <!--- Constructeur --->
    <cffunction name="init" access="public" returntype="Incident">
        <!--- Utiliser la session pour persister les données --->
        <cfif NOT structKeyExists(session, "incidents")>
            <cfset session.incidents = []>
            <cfset loadSampleData()>
        </cfif>
        <cfset this.incidents = session.incidents>
        <cfreturn this>
    </cffunction>
    
    <!--- Ajouter un incident --->
    <!--- Modifier addIncident pour sauver en session --->
<cffunction name="addIncident" access="public" returntype="numeric">
    <cfargument name="data" type="struct" required="true">
    
    <cfset var newIncident = arguments.data>
    <cfset newIncident.id = arrayLen(this.incidents) + 1>
    <cfset arrayAppend(this.incidents, newIncident)>
    
    <!--- Sauvegarder en session --->
    <cfset session.incidents = this.incidents>
    
    <cfreturn newIncident.id>
</cffunction>
    
    <!--- Obtenir tous les incidents --->
    <cffunction name="getAllIncidents" access="public" returntype="array">
        <cfreturn this.incidents>
    </cffunction>
    
    <!--- Obtenir les stats --->
    <cffunction name="getStats" access="public" returntype="struct">
        <cfset var stats = {
            total = arrayLen(this.incidents),
            high = 0,
            medium = 0,
            low = 0,
            today = 0
        }>
        
        <cfloop array="#this.incidents#" index="inc">
            <cfswitch expression="#inc.severity#">
                <cfcase value="high"><cfset stats.high++></cfcase>
                <cfcase value="medium"><cfset stats.medium++></cfcase>
                <cfcase value="low"><cfset stats.low++></cfcase>
            </cfswitch>
            
            <!--- Incidents du jour --->
            <cfif dateCompare(dateFormat(inc.dateReport, "yyyy-mm-dd"), dateFormat(now(), "yyyy-mm-dd")) EQ 0>
                <cfset stats.today++>
            </cfif>
        </cfloop>
        
        <cfreturn stats>
    </cffunction>

    <!--- Obtenir un incident par ID --->
<cffunction name="getIncidentById" access="public" returntype="struct">
    <cfargument name="id" type="numeric" required="true">
    
    <cfloop array="#this.incidents#" index="inc">
        <cfif inc.id EQ arguments.id>
            <cfreturn inc>
        </cfif>
    </cfloop>
    
    <!--- Si pas trouvé, retourner struct vide --->
    <cfreturn {}>
</cffunction>

<!--- Mettre à jour le statut --->
<cffunction name="updateStatus" access="public" returntype="boolean">
    <cfargument name="id" type="numeric" required="true">
    <cfargument name="newStatus" type="string" required="true">
    
    <cfloop from="1" to="#arrayLen(this.incidents)#" index="i">
        <cfif this.incidents[i].id EQ arguments.id>
            <cfset this.incidents[i].status = arguments.newStatus>
            <!--- Sauvegarder en session --->
            <cfset session.incidents = this.incidents>
            <cfreturn true>
        </cfif>
    </cfloop>
    
    <cfreturn false>
</cffunction>

<!--- Obtenir les stats par restaurant --->
<cffunction name="getStatsByRestaurant" access="public" returntype="array">
    <cfset var stats = {}>
    
    <!--- Compter par restaurant --->
    <cfloop array="#this.incidents#" index="inc">
        <cfif NOT structKeyExists(stats, inc.restaurant)>
            <cfset stats[inc.restaurant] = {
                name = inc.restaurant,
                total = 0,
                high = 0,
                medium = 0,
                low = 0
            }>
        </cfif>
        
        <cfset stats[inc.restaurant].total++>
        
        <cfswitch expression="#inc.severity#">
            <cfcase value="high"><cfset stats[inc.restaurant].high++></cfcase>
            <cfcase value="medium"><cfset stats[inc.restaurant].medium++></cfcase>
            <cfcase value="low"><cfset stats[inc.restaurant].low++></cfcase>
        </cfswitch>
    </cfloop>
    
    <!--- Convertir en array --->
    <cfset var result = []>
    <cfloop collection="#stats#" item="key">
        <cfset arrayAppend(result, stats[key])>
    </cfloop>
    
    <cfreturn result>
</cffunction>
    
    <!--- Données de test --->
    <cffunction name="loadSampleData" access="private">
        <cfset addIncident({
            restaurant = "Restaurant Tour A",
            type = 1,
            severity = "high",
            description = "Présence d'insectes dans la salade. Inacceptable !",
            name = "Marie Dupont",
            email = "m.dupont@sodexo.com",
            dateReport = now(),
            status = "new"
        })>
        
        <cfset addIncident({
            restaurant = "Cantine Centrale",
            type = 3,
            severity = "medium",
            description = "Temps d'attente très long à la caisse, plus de 20 minutes",
            name = "Jean Martin",
            email = "j.martin@sodexo.com",
            dateReport = dateAdd("h", -2, now()),
            status = "new"
        })>
        
        <cfset addIncident({
            restaurant = "Espace Cafétéria B2",
            type = 5,
            severity = "low",
            description = "Plus de desserts disponibles après 13h30",
            name = "Sophie Bernard",
            email = "s.bernard@sodexo.com",
            dateReport = dateAdd("d", -1, now()),
            status = "resolved"
        })>
    </cffunction>
    
</cfcomponent>