<!--- DASHBOARD --->

<!--- Protection de la page --->
<cfinclude template="secure.cfm">

<!--- Initialisation --->
<cfset incidentObj = new components.Incident()>
<cfset incidentService = new components.IncidentService()>

<cfset incidents = incidentObj.getAllIncidents()>
<cfset stats = incidentObj.getStats()>
<cfset incidentTypes = incidentService.getIncidentTypes()>

<!--- Gestion du filtre --->
<cfparam name="url.restaurant" default="">
<cfset restaurantObj = new components.Restaurant("")>
<cfset restaurants = restaurantObj.getAllRestaurants()>

<!--- Filtrer les incidents si un restaurant est sélectionné --->
<cfif len(trim(url.restaurant))>
    <cfset filteredIncidents = []>
    <cfloop array="#incidents#" index="inc">
        <cfif inc.restaurant EQ url.restaurant>
            <cfset arrayAppend(filteredIncidents, inc)>
        </cfif>
    </cfloop>
    <cfset incidents = filteredIncidents>
</cfif>

<!--- Recalculer les stats si filtre actif --->
<cfif len(trim(url.restaurant))>
    <cfset stats = incidentObj.getStats()>
    <!--- Recalculer manuellement avec les incidents filtrés --->
    <cfset stats.total = arrayLen(incidents)>
    <cfset stats.high = 0>
    <cfset stats.medium = 0>
    <cfset stats.low = 0>
    <cfset stats.today = 0>
    
    <cfloop array="#incidents#" index="inc">
        <cfswitch expression="#inc.severity#">
            <cfcase value="high"><cfset stats.high++></cfcase>
            <cfcase value="medium"><cfset stats.medium++></cfcase>
            <cfcase value="low"><cfset stats.low++></cfcase>
        </cfswitch>
        <cfif dateCompare(dateFormat(inc.dateReport, "yyyy-mm-dd"), dateFormat(now(), "yyyy-mm-dd")) EQ 0>
            <cfset stats.today++>
        </cfif>
    </cfloop>
</cfif>

<!DOCTYPE html>
<html>
<head>
    <title>Tableau de bord - MealTrack</title>
    <meta charset="UTF-8">
    <style>
        * { box-sizing: border-box; }
        body { 
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Arial, sans-serif; 
            margin: 0;
            padding: 20px;
            background: #f5f5f5;
        }
        .header {
            background: white;
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 20px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        .stat-card {
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            text-align: center;
        }
        .stat-number {
            font-size: 36px;
            font-weight: bold;
            margin: 10px 0;
        }
        .stat-label {
            color: #666;
            font-size: 14px;
        }
        .incidents-table {
            background: white;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
        table {
            width: 100%;
            border-collapse: collapse;
        }
        th {
            background: #f8f9fa;
            padding: 15px;
            text-align: left;
            font-weight: 600;
            border-bottom: 2px solid #dee2e6;
        }
        td {
            padding: 15px;
            border-bottom: 1px solid #dee2e6;
        }
        .severity-badge {
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
        }
        .severity-high { background: #f8d7da; color: #721c24; }
        .severity-medium { background: #fff3cd; color: #856404; }
        .severity-low { background: #d4edda; color: #155724; }
        .status-new { color: #ff5500; }
        .status-resolved { color: #28a745; }
    </style>
</head>
<body>
    <div class="header">
        <!--- Info utilisateur et déconnexion --->
    <div style="float: right; text-align: right;">
        <p style="margin: 0; color: #666; font-size: 14px;">
            👤 Connecté : <strong><cfoutput>#session.user.name#</cfoutput></strong>
            <br>
            <span style="font-size: 12px;">(<cfoutput>#session.user.role#</cfoutput>)</span>
        </p>
        <a href="logout.cfm" style="color: #ff5500; font-size: 14px; text-decoration: none;">
            🚪 Déconnexion
        </a>
        <h1>📊 Tableau de bord des incidents</h1>
        <p>Vue d'ensemble des incidents signalés dans les restaurants
            <cfif len(trim(url.restaurant))>
                <br><strong style="color: #ff5500;">🔍 Filtre actif : <cfoutput>#url.restaurant#</cfoutput></strong>
            </cfif>
            </p>
    </div>

    <!--- Filtre --->
<div style="background: white; padding: 20px; border-radius: 10px; margin-bottom: 20px; box-shadow: 0 2px 5px rgba(0,0,0,0.1);">
    <form method="get" action="dashboard.cfm" style="display: flex; align-items: center; gap: 10px;">
        <label for="restaurant" style="font-weight: 600;">Filtrer par restaurant :</label>
        <select name="restaurant" id="restaurant" style="padding: 8px; border: 1px solid #ddd; border-radius: 5px;">
            <option value="">-- Tous les restaurants --</option>
            <cfloop array="#restaurants#" index="resto">
                <option value="<cfoutput>#resto.nom#</cfoutput>" 
                        <cfif url.restaurant EQ resto.nom>selected</cfif>>
                    <cfoutput>#resto.nom#</cfoutput>
                </option>
            </cfloop>
        </select>
        <button type="submit" style="background: #007bff; color: white; padding: 8px 20px; border: none; border-radius: 5px; cursor: pointer;">
            Filtrer
        </button>
        <cfif len(trim(url.restaurant))>
            <a href="dashboard.cfm" style="color: #6c757d; text-decoration: none;">✖ Réinitialiser</a>
        </cfif>
    </form>
</div>
    
    <!--- Statistiques --->
    <div class="stats-grid">
        <div class="stat-card">
            <div class="stat-label">Total incidents</div>
            <div class="stat-number"><cfoutput>#stats.total#</cfoutput></div>
        </div>
        <div class="stat-card" style="border-left: 4px solid #dc3545;">
            <div class="stat-label">Gravité élevée</div>
            <div class="stat-number" style="color: #dc3545;"><cfoutput>#stats.high#</cfoutput></div>
        </div>
        <div class="stat-card" style="border-left: 4px solid #ffc107;">
            <div class="stat-label">Gravité moyenne</div>
            <div class="stat-number" style="color: #ffc107;"><cfoutput>#stats.medium#</cfoutput></div>
        </div>
        <div class="stat-card" style="border-left: 4px solid #28a745;">
            <div class="stat-label">Incidents aujourd'hui</div>
            <div class="stat-number" style="color: #28a745;"><cfoutput>#stats.today#</cfoutput></div>
        </div>
    </div>
    
    <!--- Liste des incidents --->
    <div class="incidents-table">
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Date</th>
                    <th>Restaurant</th>
                    <th>Type</th>
                    <th>Gravité</th>
                    <th>Signalé par</th>
                    <th>Statut</th>
                </tr>
            </thead>
            <tbody>
                <cfloop array="#incidents#" index="incident">
                    <tr>
                        <td>
                            <a href="incident-detail.cfm?id=<cfoutput>#incident.id#</cfoutput>" 
                               style="color: #007bff; text-decoration: none; font-weight: 600;">
                                #<cfoutput>#incident.id#</cfoutput>
                            </a>
                        </td>
                        <td><cfoutput>#dateFormat(incident.dateReport, "dd/mm")# #timeFormat(incident.dateReport, "HH:mm")#</cfoutput></td>
                        <td><cfoutput>#incident.restaurant#</cfoutput></td>
                        <td>
                            <cfset typeInfo = incidentTypes[incident.type]>
                            <cfoutput>#typeInfo.icon# #typeInfo.label#</cfoutput>
                        </td>
                        <td>
                            <span class="severity-badge severity-<cfoutput>#incident.severity#</cfoutput>">
                                <cfoutput>#uCase(incident.severity)#</cfoutput>
                            </span>
                        </td>
                        <td><cfoutput>#incident.name#</cfoutput></td>
                        <td class="status-<cfoutput>#incident.status#</cfoutput>">
                            <cfoutput>#incident.status EQ "new" ? "Nouveau" : "Résolu"#</cfoutput>
                        </td>
                    </tr>
                </cfloop>
            </tbody>
        </table>
    </div>
    
    <div style="margin-top: 20px; text-align: center;">
        <a href="report-incident.cfm" style="background: #ff5500; color: white; padding: 10px 20px; text-decoration: none; border-radius: 5px; margin-right: 10px;">
            🚨 Signaler un incident
        </a>
        <a href="statistics.cfm" style="background: #28a745; color: white; padding: 10px 20px; text-decoration: none; border-radius: 5px; margin-right: 10px;">
            📈 Statistiques
        </a>
        <a href="index.cfm" style="background: #6c757d; color: white; padding: 10px 20px; text-decoration: none; border-radius: 5px;">
            🏠 Accueil
        </a>
    </div>
</body>
</html>