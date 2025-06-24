<!--- Chargement des services --->
<cfset restaurantObj = new components.Restaurant("")>
<cfset incidentService = new components.IncidentService()>

<cfset restaurants = restaurantObj.getAllRestaurants()>
<cfset incidentTypes = incidentService.getIncidentTypes()>
<cfset severityLevels = incidentService.getSeverityLevels()>

<!DOCTYPE html>
<html>
<head>
    <title>Signaler un incident - MealTrack</title>
    <meta charset="UTF-8">
    <style>
        * { box-sizing: border-box; }
        body { 
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Arial, sans-serif; 
            margin: 0;
            padding: 20px;
            background: #f5f5f5;
        }
        .container {
            max-width: 600px;
            margin: 0 auto;
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        h1 { 
            color: #333;
            margin-bottom: 30px;
        }
        .form-group {
            margin-bottom: 20px;
        }
        label {
            display: block;
            margin-bottom: 5px;
            font-weight: 600;
            color: #555;
        }
        input, select, textarea {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 16px;
        }
        textarea {
            resize: vertical;
            min-height: 100px;
        }
        .radio-group {
            display: flex;
            gap: 20px;
            margin-top: 10px;
        }
        .radio-item {
            display: flex;
            align-items: center;
        }
        .radio-item input {
            width: auto;
            margin-right: 5px;
        }
        .btn {
            background: #ff5500;
            color: white;
            padding: 12px 30px;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            cursor: pointer;
            margin-top: 20px;
        }
        .btn:hover {
            background: #e64a00;
        }
        .severity-low { color: #28a745; }
        .severity-medium { color: #ff8800; }
        .severity-high { color: #dc3545; }
    </style>
</head>
<body>
    <div class="container">
        <h1>🚨 Signaler un incident</h1>
        
         <!---Afficher les erreurs --->
         <cfif structKeyExists(session, "errorMessage")>
            <div style="background: #f8d7da; color: #721c24; padding: 15px; border-radius: 5px; margin-bottom: 20px;">
                <cfoutput>#session.errorMessage#</cfoutput>
            </div>
            <cfset structDelete(session, "errorMessage")>
        </cfif>
        
        <form action="process-incident.cfm" method="post">

       
            
            <!--- Restaurant --->
            <div class="form-group">
                <label for="restaurant">Restaurant concerné *</label>
                <select name="restaurant" id="restaurant" required>
                    <option value="">-- Sélectionnez un restaurant --</option>
                    <cfloop array="#restaurants#" index="resto">
                        <option value="<cfoutput>#resto.nom#</cfoutput>">
                            <cfoutput>#resto.nom#</cfoutput>
                        </option>
                    </cfloop>
                </select>
            </div>
            
            <!--- Type d'incident --->
            <div class="form-group">
                <label for="incidentType">Type d'incident *</label>
                <select name="incidentType" id="incidentType" required>
                    <option value="">-- Sélectionnez un type --</option>
                    <cfloop array="#incidentTypes#" index="type">
                        <option value="<cfoutput>#type.id#</cfoutput>">
                            <cfoutput>#type.icon# #type.label#</cfoutput>
                        </option>
                    </cfloop>
                </select>
            </div>
            
            <!--- Sévérité --->
            <div class="form-group">
                <label>Niveau de gravité *</label>
                <div class="radio-group">
                    <cfloop array="#severityLevels#" index="level">
                        <div class="radio-item">
                            <input type="radio" 
                                   name="severity" 
                                   id="severity-<cfoutput>#level.value#</cfoutput>" 
                                   value="<cfoutput>#level.value#</cfoutput>"
                                   required>
                            <label for="severity-<cfoutput>#level.value#</cfoutput>" 
                                   class="severity-<cfoutput>#level.value#</cfoutput>">
                                <cfoutput>#level.label#</cfoutput>
                            </label>
                        </div>
                    </cfloop>
                </div>
            </div>
            
            <!--- Description --->
            <div class="form-group">
                <label for="description">Description détaillée *</label>
                <textarea name="description" id="description" required 
                          placeholder="Décrivez l'incident en détail..."></textarea>
            </div>

             <!--- Nom --->
            <div class="form-group">
                <label for="name">Nom *</label>
                <input type="text" name="name" id="name" required 
                       placeholder="Votre nom">
            </div>

            
            <!--- Email --->
            <div class="form-group">
                <label for="email">Votre email (pour le suivi)</label>
                <input type="email" name="email" id="email" 
                       placeholder="nom@sodexo.com">
            </div>
            
            <button type="submit" class="btn">Envoyer le signalement</button>
            
        </form>
    </div>
</body>
</html>