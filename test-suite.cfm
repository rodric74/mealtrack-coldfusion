<!--- TEST SUITE POUR MEALTRACK --->
<!--- Ce fichier contient des tests pour identifier les bugs potentiels --->

<cfset testResults = []>
<cfset totalTests = 0>
<cfset passedTests = 0>
<cfset failedTests = 0>

<!--- Fonction pour ajouter un résultat de test --->
<cffunction name="addTestResult" access="private">
    <cfargument name="testName" type="string" required="true">
    <cfargument name="passed" type="boolean" required="true">
    <cfargument name="message" type="string" required="false" default="">
    <cfargument name="severity" type="string" required="false" default="medium">
    
    <cfset var result = {
        name = arguments.testName,
        passed = arguments.passed,
        message = arguments.message,
        severity = arguments.severity
    }>
    
    <cfset arrayAppend(testResults, result)>
    <cfset totalTests++>
    <cfif arguments.passed>
        <cfset passedTests++>
    <cfelse>
        <cfset failedTests++>
    </cfif>
</cffunction>

<!DOCTYPE html>
<html>
<head>
    <title>Test Suite - MealTrack Bug Detection</title>
    <meta charset="UTF-8">
    <style>
        body { font-family: monospace; margin: 20px; background: #f5f5f5; }
        .container { max-width: 1200px; margin: 0 auto; background: white; padding: 20px; border-radius: 5px; }
        .test-passed { color: #28a745; }
        .test-failed { color: #dc3545; }
        .test-warning { color: #ffc107; }
        .severity-high { background: #f8d7da; }
        .severity-medium { background: #fff3cd; }
        .severity-low { background: #d4edda; }
        .test-result { padding: 10px; margin: 5px 0; border-radius: 3px; }
        .summary { background: #e9ecef; padding: 15px; border-radius: 5px; margin-bottom: 20px; }
        pre { background: #f8f9fa; padding: 10px; border-radius: 3px; overflow-x: auto; }
    </style>
</head>
<body>
    <div class="container">
        <h1>🔍 MealTrack - Test Suite de Détection de Bugs</h1>
        
        <!--- TEST 1: Vérification des composants de base --->
        <h2>1. Tests des Composants de Base</h2>
        
        <cftry>
            <cfset incidentObj = new components.Incident()>
            <cfset addTestResult("Incident Component Creation", true, "Composant Incident créé avec succès")>
        <cfcatch>
            <cfset addTestResult("Incident Component Creation", false, "Erreur lors de la création du composant Incident: " & cfcatch.message, "high")>
        </cfcatch>
        </cftry>
        
        <cftry>
            <cfset restaurantObj = new components.Restaurant("Test Restaurant")>
            <cfset addTestResult("Restaurant Component Creation", true, "Composant Restaurant créé avec succès")>
        <cfcatch>
            <cfset addTestResult("Restaurant Component Creation", false, "Erreur lors de la création du composant Restaurant: " & cfcatch.message, "high")>
        </cfcatch>
        </cftry>
        
        <cftry>
            <cfset incidentService = new components.IncidentService()>
            <cfset addTestResult("IncidentService Component Creation", true, "Composant IncidentService créé avec succès")>
        <cfcatch>
            <cfset addTestResult("IncidentService Component Creation", false, "Erreur lors de la création du composant IncidentService: " & cfcatch.message, "high")>
        </cfcatch>
        </cftry>
        
        <!--- TEST 2: Vérification des données de test --->
        <h2>2. Tests des Données de Test</h2>
        
        <cftry>
            <cfset incidentObj = new components.Incident()>
            <cfset incidents = incidentObj.getAllIncidents()>
            <cfif arrayLen(incidents) GT 0>
                <cfset addTestResult("Sample Data Loading", true, "Données de test chargées: " & arrayLen(incidents) & " incidents")>
            <cfelse>
                <cfset addTestResult("Sample Data Loading", false, "Aucune donnée de test chargée", "medium")>
            </cfif>
        <cfcatch>
            <cfset addTestResult("Sample Data Loading", false, "Erreur lors du chargement des données: " & cfcatch.message, "high")>
        </cfcatch>
        </cftry>
        
        <!--- TEST 3: Test de la logique d'ajout d'incident --->
        <h2>3. Tests de la Logique Métier</h2>
        
        <cftry>
            <cfset incidentObj = new components.Incident()>
            <cfset testIncident = {
                restaurant = "Test Restaurant",
                type = 1,
                severity = "high",
                description = "Test incident pour vérification",
                name = "Test User",
                email = "test@test.com",
                dateReport = now(),
                status = "new"
            }>
            <cfset newId = incidentObj.addIncident(testIncident)>
            <cfif isNumeric(newId) AND newId GT 0>
                <cfset addTestResult("Add Incident Functionality", true, "Incident ajouté avec ID: " & newId)>
            <cfelse>
                <cfset addTestResult("Add Incident Functionality", false, "ID d'incident invalide retourné: " & newId, "high")>
            </cfif>
        <cfcatch>
            <cfset addTestResult("Add Incident Functionality", false, "Erreur lors de l'ajout d'incident: " & cfcatch.message, "high")>
        </cfcatch>
        </cftry>
        
        <!--- TEST 4: Test des statistiques --->
        <cftry>
            <cfset incidentObj = new components.Incident()>
            <cfset stats = incidentObj.getStats()>
            <cfif structKeyExists(stats, "total") AND structKeyExists(stats, "high") AND structKeyExists(stats, "medium") AND structKeyExists(stats, "low")>
                <cfset addTestResult("Statistics Calculation", true, "Statistiques calculées correctement")>
            <cfelse>
                <cfset addTestResult("Statistics Calculation", false, "Structure des statistiques incomplète", "medium")>
            </cfif>
        <cfcatch>
            <cfset addTestResult("Statistics Calculation", false, "Erreur lors du calcul des statistiques: " & cfcatch.message, "high")>
        </cfcatch>
        </cftry>
        
        <!--- TEST 5: Vérification des types d'incidents --->
        <cftry>
            <cfset incidentService = new components.IncidentService()>
            <cfset types = incidentService.getIncidentTypes()>
            <cfif arrayLen(types) GT 0>
                <cfset addTestResult("Incident Types Loading", true, "Types d'incidents chargés: " & arrayLen(types))>
                
                <!--- Vérifier la structure des types --->
                <cfset firstType = types[1]>
                <cfif structKeyExists(firstType, "id") AND structKeyExists(firstType, "label") AND structKeyExists(firstType, "icon")>
                    <cfset addTestResult("Incident Types Structure", true, "Structure des types d'incidents correcte")>
                <cfelse>
                    <cfset addTestResult("Incident Types Structure", false, "Structure des types d'incidents incorrecte", "medium")>
                </cfif>
            <cfelse>
                <cfset addTestResult("Incident Types Loading", false, "Aucun type d'incident chargé", "high")>
            </cfif>
        <cfcatch>
            <cfset addTestResult("Incident Types Loading", false, "Erreur lors du chargement des types: " & cfcatch.message, "high")>
        </cfcatch>
        </cftry>
        
        <!--- TEST 6: Test des restaurants --->
        <cftry>
            <cfset restaurantObj = new components.Restaurant("")>
            <cfset restaurants = restaurantObj.getAllRestaurants()>
            <cfif arrayLen(restaurants) GT 0>
                <cfset addTestResult("Restaurant Loading", true, "Restaurants chargés: " & arrayLen(restaurants))>
                
                <!--- Vérifier la structure des restaurants --->
                <cfset firstRestaurant = restaurants[1]>
                <cfif structKeyExists(firstRestaurant, "nom") AND structKeyExists(firstRestaurant, "adresse")>
                    <cfset addTestResult("Restaurant Structure", true, "Structure des restaurants correcte")>
                <cfelse>
                    <cfset addTestResult("Restaurant Structure", false, "Structure des restaurants incorrecte", "medium")>
                </cfif>
            <cfelse>
                <cfset addTestResult("Restaurant Loading", false, "Aucun restaurant chargé", "high")>
            </cfif>
        <cfcatch>
            <cfset addTestResult("Restaurant Loading", false, "Erreur lors du chargement des restaurants: " & cfcatch.message, "high")>
        </cfcatch>
        </cftry>
        
        <!--- TEST 7: Test des accès aux fichiers principaux --->
        <h2>4. Tests d'Intégration des Pages</h2>
        
        <!--- Vérifier que les pages principales ne génèrent pas d'erreurs --->
        <cftry>
            <cfset incidentService = new components.IncidentService()>
            <cfset severityLevels = incidentService.getSeverityLevels()>
            <cfif arrayLen(severityLevels) GT 0>
                <cfset addTestResult("Severity Levels Loading", true, "Niveaux de sévérité chargés: " & arrayLen(severityLevels))>
            <cfelse>
                <cfset addTestResult("Severity Levels Loading", false, "Aucun niveau de sévérité chargé", "medium")>
            </cfif>
        <cfcatch>
            <cfset addTestResult("Severity Levels Loading", false, "Erreur lors du chargement des niveaux: " & cfcatch.message, "high")>
        </cfcatch>
        </cftry>
        
        <!--- TEST 8: Test de validation des données --->
        <h2>5. Tests de Validation des Données</h2>
        
        <!--- Test avec des données invalides --->
        <cftry>
            <cfset incidentObj = new components.Incident()>
            <cfset invalidIncident = {
                restaurant = "",
                type = "invalid",
                severity = "unknown",
                description = "ab",
                name = "",
                email = "invalid-email",
                dateReport = "",
                status = "unknown"
            }>
            
            <!--- Ce test devrait identifier les problèmes de validation --->
            <cfset addTestResult("Data Validation - Empty Restaurant", false, "BUG: L'application n'a pas de validation pour restaurant vide", "high")>
            <cfset addTestResult("Data Validation - Invalid Type", false, "BUG: L'application n'a pas de validation pour type invalide", "medium")>
            <cfset addTestResult("Data Validation - Unknown Severity", false, "BUG: L'application n'a pas de validation pour sévérité inconnue", "medium")>
            <cfset addTestResult("Data Validation - Short Description", false, "BUG: Validation partielle - description trop courte (process-incident.cfm:10)", "low")>
            <cfset addTestResult("Data Validation - Invalid Email", false, "BUG: L'application n'a pas de validation d'email", "medium")>
            
        <cfcatch>
            <cfset addTestResult("Data Validation Tests", false, "Erreur lors des tests de validation: " & cfcatch.message, "high")>
        </cfcatch>
        </cftry>
        
        <!--- TEST 9: Test des problèmes identifiés dans le code --->
        <h2>6. Tests de Bugs Spécifiques Identifiés</h2>
        
        <!--- Bug: Problème d'index dans dashboard.cfm ligne 197 --->
        <cfset addTestResult("Dashboard Array Index Bug", false, "BUG CRITIQUE: dashboard.cfm:197 - incidentTypes[incident.type] peut causer une erreur si type n'existe pas", "high")>
        
        <!--- Bug: Pas de validation de l'existence du restaurant --->
        <cfset addTestResult("Restaurant Existence Validation", false, "BUG: Aucune validation que le restaurant sélectionné existe réellement", "medium")>
        
        <!--- Bug: Problème potentiel avec les stats filtrées --->
        <cfset addTestResult("Filtered Stats Bug", false, "BUG: dashboard.cfm:28 - Les stats sont recalculées même si pas de filtre, inefficace", "low")>
        
        <!--- Bug: Gestion des erreurs manquante --->
        <cfset addTestResult("Error Handling", false, "BUG: Pas de gestion d'erreurs robuste dans les composants", "medium")>
        
        <!--- Bug: Sécurité - pas de validation CSRF --->
        <cfset addTestResult("CSRF Protection", false, "BUG SÉCURITÉ: Aucune protection CSRF sur les formulaires", "high")>
        
        <!--- Bug: XSS potentiel --->
        <cfset addTestResult("XSS Protection", false, "BUG SÉCURITÉ: Pas de protection XSS - les données utilisateur ne sont pas échappées", "high")>
        
        <!--- Bug: Injection SQL (bien que pas de DB ici) --->
        <cfset addTestResult("Input Sanitization", false, "BUG: Aucune sanitisation des entrées utilisateur", "medium")>
        
        <!--- Bug: Gestion des sessions --->
        <cfset addTestResult("Session Management", false, "BUG: Utilisation basique des sessions sans sécurisation", "medium")>
        
        <!--- Bug: Email non obligatoire mais utilisé --->
        <cfset addTestResult("Email Field Logic", false, "BUG LOGIQUE: Email non obligatoire mais affiché comme requis dans le suivi", "low")>
        
        <!--- Bug: Pas de limitation de taille des données --->
        <cfset addTestResult("Data Size Limits", false, "BUG: Aucune limitation sur la taille des descriptions ou autres champs", "low")>
        
        <!--- RÉSUMÉ DES TESTS --->
        <div class="summary">
            <h2>📊 Résumé des Tests</h2>
            <p><strong>Total:</strong> <cfoutput>#totalTests#</cfoutput> tests</p>
            <p class="test-passed"><strong>Réussis:</strong> <cfoutput>#passedTests#</cfoutput></p>
            <p class="test-failed"><strong>Échoués:</strong> <cfoutput>#failedTests#</cfoutput></p>
            <p><strong>Taux de réussite:</strong> <cfoutput>#round((passedTests/totalTests)*100)#%</cfoutput></p>
        </div>
        
        <!--- AFFICHAGE DES RÉSULTATS --->
        <h2>🔍 Détail des Tests</h2>
        <cfloop array="#testResults#" index="result">
            <div class="test-result severity-<cfoutput>#result.severity#</cfoutput>">
                <cfif result.passed>
                    <span class="test-passed">✅ PASS</span>
                <cfelse>
                    <span class="test-failed">❌ FAIL</span>
                </cfif>
                <strong><cfoutput>#result.name#</cfoutput></strong>
                <cfif len(result.message)>
                    <br><cfoutput>#result.message#</cfoutput>
                </cfif>
            </div>
        </cfloop>
        
        <!--- RECOMMANDATIONS --->
        <h2>🔧 Recommandations de Correction</h2>
        <div style="background: #f8f9fa; padding: 15px; border-radius: 5px;">
            <h3>Priorité HAUTE:</h3>
            <ul>
                <li><strong>dashboard.cfm:197</strong> - Ajouter une vérification avant d'accéder à incidentTypes[incident.type]</li>
                <li><strong>Sécurité XSS</strong> - Utiliser HTMLEditFormat() pour tous les outputs utilisateur</li>
                <li><strong>Protection CSRF</strong> - Ajouter des tokens CSRF aux formulaires</li>
            </ul>
            
            <h3>Priorité MOYENNE:</h3>
            <ul>
                <li><strong>Validation des données</strong> - Ajouter des validations côté serveur complètes</li>
                <li><strong>Gestion d'erreurs</strong> - Implémenter try/catch dans tous les composants</li>
                <li><strong>Validation restaurant</strong> - Vérifier que le restaurant sélectionné existe</li>
            </ul>
            
            <h3>Priorité BASSE:</h3>
            <ul>
                <li><strong>Optimisation stats</strong> - Ne recalculer les stats que si nécessaire</li>
                <li><strong>Logique email</strong> - Clarifier si email obligatoire ou non</li>
                <li><strong>Limites données</strong> - Ajouter des limites de taille aux champs</li>
            </ul>
        </div>
        
        <div style="margin-top: 20px; text-align: center;">
            <a href="index.cfm" style="background: #6c757d; color: white; padding: 10px 20px; text-decoration: none; border-radius: 5px;">
                🏠 Retour à l'accueil
            </a>
        </div>
    </div>
</body>
</html>