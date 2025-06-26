<!--- <cfsetting showdebugoutput="true" enablecfoutputonly="false"> --->


<!--- Si déjà connecté, rediriger --->
<cfset userObj = new components.User()>
<cfif userObj.isLoggedIn()>
    <cflocation url="dashboard.cfm" addtoken="false">
</cfif>

<!DOCTYPE html>
<html>
<head>
    <title>Connexion - MealTrack</title>
    <meta charset="UTF-8">
    <style>
        * { box-sizing: border-box; }
        body { 
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Arial, sans-serif; 
            margin: 0;
            padding: 0;
            background: linear-gradient(135deg, #ff5500 0%, #ff8800 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .login-container {
            background: white;
            padding: 40px;
            border-radius: 20px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.1);
            width: 100%;
            max-width: 400px;
        }
        .logo {
            text-align: center;
            margin-bottom: 30px;
        }
        .logo h1 {
            margin: 0;
            color: #333;
            font-size: 32px;
        }
        .logo p {
            margin: 5px 0;
            color: #666;
            font-size: 14px;
        }
        .form-group {
            margin-bottom: 20px;
        }
        label {
            display: block;
            margin-bottom: 5px;
            font-weight: 600;
            color: #555;
            font-size: 14px;
        }
        input {
            width: 100%;
            padding: 12px;
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            font-size: 16px;
            transition: border-color 0.3s;
        }
        input:focus {
            outline: none;
            border-color: #ff5500;
        }
        .btn {
            width: 100%;
            background: #ff5500;
            color: white;
            padding: 14px;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: background 0.3s;
        }
        .btn:hover {
            background: #e64a00;
        }
        .error-message {
            background: #f8d7da;
            color: #721c24;
            padding: 12px;
            border-radius: 8px;
            margin-bottom: 20px;
            font-size: 14px;
        }
        .demo-info {
            background: #d1ecf1;
            color: #0c5460;
            padding: 15px;
            border-radius: 8px;
            margin-top: 20px;
            font-size: 13px;
        }
        .demo-info h4 {
            margin: 0 0 10px 0;
            font-size: 14px;
        }
        .demo-info ul {
            margin: 5px 0;
            padding-left: 20px;
        }
        .demo-info li {
            margin: 3px 0;
        }
        .demo-info code {
            background: #bee5eb;
            padding: 2px 5px;
            border-radius: 3px;
            font-family: monospace;
        }
    </style>
</head>
<body>
    <div class="login-container">
        <div class="logo">
            <h1>🍽️ MealTrack</h1>
            <p>Système de gestion qualité RESTO</p>
        </div>
        
       <!--- Messages --->
<cfif structKeyExists(session, "loginError")>
    <div class="error-message">
        <cfoutput>#session.loginError#</cfoutput>
    </div>
    <cfset structDelete(session, "loginError")>
</cfif>

<cfif structKeyExists(url, "logout") AND url.logout EQ "success">
    <div style="background: #d4edda; color: #155724; padding: 12px; border-radius: 8px; margin-bottom: 20px; font-size: 14px;">
        ✅ Vous avez été déconnecté avec succès
    </div>
</cfif>
        
        <form action="process-login.cfm" method="post">
            <div class="form-group">
                <label for="email">Email</label>
                <input type="email" 
                       name="email" 
                       id="email" 
                       placeholder="votre.email@resto.com"
                       required 
                       autofocus>
            </div>
            
            <div class="form-group">
                <label for="password">Mot de passe</label>
                <input type="password" 
                       name="password" 
                       id="password" 
                       placeholder="••••••••"
                       required>
            </div>
            
            <button type="submit" class="btn">Se connecter</button>
        </form>
        
        <div class="demo-info">
            <h4>🔐 Comptes de démonstration :</h4>
            <ul>
                <li>Admin : <code>admin@resto.com</code> / <code>admin123</code></li>
                <li>Manager : <code>manager@resto.com</code> / <code>manager123</code></li>
                <li>Utilisateur : <code>roro@resto.com</code> / <code>roro123</code></li>
            </ul>
        </div>
    </div>
</body>
</html>