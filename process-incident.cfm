<!--- Vérification que le formulaire a été soumis --->
<cfif NOT structKeyExists(form, "restaurant")>
    <cflocation url="report-incident.cfm" addtoken="false">
</cfif>


<!--- Validation de la description --->
<cfif len(trim(form.description)) LT 10>
    <cfset session.errorMessage = "La description doit contenir au moins 10 caractères.">
    <cflocation url="report-incident.cfm" addtoken="false">
</cfif>

<!--- Récupération et validation des données --->
<cfset incident = {
    restaurant = form.restaurant,
    type = form.incidentType,
    severity = form.severity,
    description = form.description,
    email = form.email ?: "Non fourni",
    dateReport = now(),
    status = "new",
    name = form.name
}>

<!--- Créer l'objet Incident    --->

<cfset incidentObj = new components.Incident()>
<cfset newIncidentId = incidentObj.addIncident(incident)>

<!DOCTYPE html>
<html>
<head>
    <title>Incident enregistré - MealTrack</title>
    <meta charset="UTF-8">
    <style>
        body { 
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Arial, sans-serif; 
            margin: 0;
            padding: 20px;
            background: #f5f5f5;
        }
        .success-container {
            max-width: 600px;
            margin: 50px auto;
            background: white;
            padding: 40px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            text-align: center;
        }
        .success-icon {
            font-size: 64px;
            color: #28a745;
            margin-bottom: 20px;
        }
        h1 { color: #333; }
        .details {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 5px;
            margin: 20px 0;
            text-align: left;
        }
        .btn {
            display: inline-block;
            background: #ff5500;
            color: white;
            padding: 10px 20px;
            text-decoration: none;
            border-radius: 5px;
            margin-top: 20px;
        }
    </style>
</head>
<body>
    <div class="success-container">
        <div class="success-icon">✅</div>
        <h1>Incident enregistré avec succès</h1>
        <p>Merci pour votre signalement. Notre équipe va traiter votre demande rapidement.</p>
        
        <div class="details">
            <h3>Récapitulatif :</h3>
            <p><strong>Restaurant :</strong> <cfoutput>#incident.restaurant#</cfoutput></p>
            <p><strong>Date :</strong> <cfoutput>#dateFormat(incident.dateReport, "dd/mm/yyyy")# à #timeFormat(incident.dateReport, "HH:mm")#</cfoutput></p>
            <p><strong>Niveau :</strong> <cfoutput>#incident.severity#</cfoutput></p>
            <p><strong>Email de suivi :</strong> <cfoutput>#incident.email#</cfoutput></p>
        </div>
        
        <a href="report-incident.cfm" class="btn">Signaler un autre incident</a>
        <a href="index.cfm" class="btn" style="background: #6c757d;">Retour à l'accueil</a>
    </div>
</body>
</html>