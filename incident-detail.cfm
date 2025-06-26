<!--- Protection de la page --->
<cfinclude template="secure.cfm">

<!--- Vérifier qu'on a un ID --->
<cfif NOT structKeyExists(url, "id") OR NOT isNumeric(url.id)>
    <cflocation url="dashboard.cfm" addtoken="false">
</cfif>

<!--- Charger l'incident --->
<cfset incidentObj = new components.Incident()>
<cfset incidentService = new components.IncidentService()>
<cfset incident = incidentObj.getIncidentById(url.id)>

<!--- Si incident non trouvé --->
<cfif structIsEmpty(incident)>
    <cflocation url="dashboard.cfm" addtoken="false">
</cfif>

<!--- Récupérer les infos du type --->
<cfset incidentTypes = incidentService.getIncidentTypes()>
<cfset typeInfo = incidentTypes[incident.type]>

<!DOCTYPE html>
<html>
<head>
    <title>Incident #<cfoutput>#incident.id#</cfoutput> - MealTrack</title>
    <meta charset="UTF-8">
    <style>
        * { box-sizing: border-box; }
        body { 
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Arial, sans-serif; 
            margin: 0;
            padding: 20px;
            background: #f5f5f5;
        }
        .detail-container {
            max-width: 800px;
            margin: 0 auto;
        }
        .detail-card {
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            margin-bottom: 20px;
        }
        .incident-header {
            display: flex;
            justify-content: space-between;
            align-items: start;
            margin-bottom: 30px;
        }
        .incident-title {
            flex: 1;
        }
        .incident-id {
            color: #666;
            font-size: 14px;
        }
        .info-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 20px;
            margin-bottom: 30px;
        }
        .info-item {
            padding: 15px;
            background: #f8f9fa;
            border-radius: 5px;
        }
        .info-label {
            font-size: 12px;
            color: #666;
            text-transform: uppercase;
            margin-bottom: 5px;
        }
        .info-value {
            font-size: 16px;
            font-weight: 600;
        }
        .description-box {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 5px;
            margin-bottom: 30px;
        }
        .severity-badge {
            padding: 6px 16px;
            border-radius: 20px;
            font-size: 14px;
            font-weight: 600;
            display: inline-block;
        }
        .severity-high { background: #f8d7da; color: #721c24; }
        .severity-medium { background: #fff3cd; color: #856404; }
        .severity-low { background: #d4edda; color: #155724; }
        .status-badge {
            padding: 6px 16px;
            border-radius: 20px;
            font-size: 14px;
            font-weight: 600;
        }
        .status-new { background: #fff3cd; color: #856404; }
        .status-in-progress { background: #cce5ff; color: #004085; }
        .status-resolved { background: #d4edda; color: #155724; }
        .action-buttons {
            display: flex;
            gap: 10px;
        }
        .btn {
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            text-decoration: none;
            font-size: 16px;
        }
        .btn-primary { background: #007bff; color: white; }
        .btn-success { background: #28a745; color: white; }
        .btn-secondary { background: #6c757d; color: white; }
    </style>
</head>
<body>
    <div class="detail-container">
        <div class="detail-card">
            <div class="incident-header">
                <div class="incident-title">
                    <div class="incident-id">INCIDENT #<cfoutput>#incident.id#</cfoutput></div>
                    <h1 style="margin: 5px 0;">
                        <cfoutput>#typeInfo.icon# #typeInfo.label#</cfoutput>
                    </h1>
                    <p style="color: #666; margin: 0;">
                        <cfoutput>#incident.restaurant#</cfoutput>
                    </p>
                </div>
                <div>
                    <span class="severity-badge severity-<cfoutput>#incident.severity#</cfoutput>">
                        <cfoutput>#uCase(incident.severity)#</cfoutput>
                    </span>
                </div>
            </div>
            
            <div class="info-grid">
                <div class="info-item">
                    <div class="info-label">Signalé par</div>
                    <div class="info-value"><cfoutput>#incident.name#</cfoutput></div>
                </div>
                <div class="info-item">
                    <div class="info-label">Contact</div>
                    <div class="info-value"><cfoutput>#incident.email#</cfoutput></div>
                </div>
                <div class="info-item">
                    <div class="info-label">Date de signalement</div>
                    <div class="info-value">
                        <cfoutput>#dateFormat(incident.dateReport, "dd/mm/yyyy")# à #timeFormat(incident.dateReport, "HH:mm")#</cfoutput>
                    </div>
                </div>
                <div class="info-item">
                    <div class="info-label">Statut actuel</div>
                    <div class="info-value">
                        <span class="status-badge status-<cfoutput>#incident.status#</cfoutput>">
                            <cfif incident.status EQ "new">
                                ⏳ Nouveau
                            <cfelseif incident.status EQ "in-progress">
                                🔄 En cours
                            <cfelse>
                                ✅ Résolu
                            </cfif>
                        </span>
                    </div>
                </div>
            </div>
            
            <h3>Description de l'incident</h3>
            <div class="description-box">
                <cfoutput>#incident.description#</cfoutput>
            </div>
            
            <div class="action-buttons">
                <cfif incident.status NEQ "resolved">
                    <form action="update-incident.cfm" method="post" style="display: inline;">
                        <input type="hidden" name="id" value="<cfoutput>#incident.id#</cfoutput>">
                        <input type="hidden" name="status" value="resolved">
                        <button type="submit" class="btn btn-success">
                            ✅ Marquer comme résolu
                        </button>
                    </form>
                </cfif>
                
                <a href="dashboard.cfm" class="btn btn-secondary">
                    ← Retour au tableau de bord
                </a>
            </div>
        </div>
    </div>
</body>
</html>