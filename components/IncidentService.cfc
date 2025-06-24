<cfcomponent displayname="IncidentService" hint="Service de gestion des incidents">
    
    <cffunction name="init" access="public" returntype="IncidentService">
        <cfreturn this>
    </cffunction>
    
    <cffunction name="getIncidentTypes" access="public" returntype="array">
        <cfset var types = [
            {id=1, label="Qualité du repas", icon="🍽️"},
            {id=2, label="Hygiène", icon="🧼"},
            {id=3, label="Service", icon="👥"},
            {id=4, label="Allergène non signalé", icon="⚠️"},
            {id=5, label="Rupture de stock", icon="📦"}
        ]>
        <cfreturn types>
    </cffunction>
    
    <cffunction name="getSeverityLevels" access="public" returntype="array">
        <cfset var levels = [
            {value="low", label="Faible", color="green"},
            {value="medium", label="Moyen", color="orange"},
            {value="high", label="Élevé", color="red"}
        ]>
        <cfreturn levels>
    </cffunction>

    <cffunction name="getServiceHours" access="public" returntype="array">
        <cfset var services = [
            {id=1, label="Petit-déjeuner", horaire="7h00 - 9h30", icon="☕"},
            {id=2, label="Déjeuner", horaire="11h30 - 14h00", icon="🍽️"},
            {id=3, label="Dîner", horaire="18h30 - 20h30", icon="🌙"}
        ]>
        <cfreturn services>
    </cffunction>
    
</cfcomponent>