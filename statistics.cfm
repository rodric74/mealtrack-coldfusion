<!--- Chargement des données --->
<cfset incidentObj = new components.Incident()>
<cfset incidents = incidentObj.getAllIncidents()>
<cfset stats = incidentObj.getStats()>
<cfset statsByRestaurant = incidentObj.getStatsByRestaurant()>

<!DOCTYPE html>
<html>
<head>
    <title>Statistiques - MealTrack</title>
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
        .charts-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(400px, 1fr));
            gap: 20px;
            margin-bottom: 20px;
        }
        .chart-card {
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
        .chart-container {
            position: relative;
            height: 300px;
            margin-top: 20px;
        }
        .bar {
            fill: #ff5500;
            transition: fill 0.3s;
        }
        .bar:hover {
            fill: #e64a00;
        }
        .severity-chart {
            display: flex;
            justify-content: center;
            align-items: center;
            height: 300px;
        }
        .donut-chart {
            position: relative;
            width: 200px;
            height: 200px;
        }
        .chart-legend {
            display: flex;
            justify-content: center;
            gap: 20px;
            margin-top: 20px;
            flex-wrap: wrap;
        }
        .legend-item {
            display: flex;
            align-items: center;
            gap: 5px;
        }
        .legend-color {
            width: 16px;
            height: 16px;
            border-radius: 3px;
        }
        .stats-table {
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
        .text-center { text-align: center; }
        .text-high { color: #dc3545; font-weight: 600; }
        .text-medium { color: #ffc107; font-weight: 600; }
        .text-low { color: #28a745; font-weight: 600; }
    </style>
</head>
<body>
    <div class="header">
        <h1>📈 Statistiques des incidents</h1>
        <p>Analyse détaillée des incidents par restaurant et par gravité</p>
    </div>
    
    <!--- Graphique en barres par restaurant --->
    <div class="charts-grid">
        <div class="chart-card">
            <h3>Incidents par restaurant</h3>
            <div class="chart-container">
                <canvas id="barChart" width="400" height="300"></canvas>
            </div>
        </div>
        
        <!--- Graphique donut par gravité --->
        <div class="chart-card">
            <h3>Répartition par gravité</h3>
            <div class="severity-chart">
                <div class="donut-chart">
                    <canvas id="donutChart" width="200" height="200"></canvas>
                </div>
            </div>
            <div class="chart-legend">
                <div class="legend-item">
                    <div class="legend-color" style="background: #dc3545;"></div>
                    <span>Élevée (<cfoutput>#stats.high#</cfoutput>)</span>
                </div>
                <div class="legend-item">
                    <div class="legend-color" style="background: #ffc107;"></div>
                    <span>Moyenne (<cfoutput>#stats.medium#</cfoutput>)</span>
                </div>
                <div class="legend-item">
                    <div class="legend-color" style="background: #28a745;"></div>
                    <span>Faible (<cfoutput>#stats.low#</cfoutput>)</span>
                </div>
            </div>
        </div>
    </div>
    
    <!--- Tableau détaillé --->
    <div class="stats-table">
        <table>
            <thead>
                <tr>
                    <th>Restaurant</th>
                    <th class="text-center">Total</th>
                    <th class="text-center">Gravité élevée</th>
                    <th class="text-center">Gravité moyenne</th>
                    <th class="text-center">Gravité faible</th>
                    <th class="text-center">% du total</th>
                </tr>
            </thead>
            <tbody>
                <cfloop array="#statsByRestaurant#" index="resto">
                    <tr>
                        <td><cfoutput>#resto.name#</cfoutput></td>
                        <td class="text-center"><strong><cfoutput>#resto.total#</cfoutput></strong></td>
                        <td class="text-center text-high"><cfoutput>#resto.high#</cfoutput></td>
                        <td class="text-center text-medium"><cfoutput>#resto.medium#</cfoutput></td>
                        <td class="text-center text-low"><cfoutput>#resto.low#</cfoutput></td>
                        <td class="text-center">
                            <cfoutput>#numberFormat((resto.total / stats.total) * 100, "0.0")#%</cfoutput>
                        </td>
                    </tr>
                </cfloop>
            </tbody>
            <tfoot>
                <tr style="background: #f8f9fa; font-weight: 600;">
                    <td>TOTAL</td>
                    <td class="text-center"><cfoutput>#stats.total#</cfoutput></td>
                    <td class="text-center text-high"><cfoutput>#stats.high#</cfoutput></td>
                    <td class="text-center text-medium"><cfoutput>#stats.medium#</cfoutput></td>
                    <td class="text-center text-low"><cfoutput>#stats.low#</cfoutput></td>
                    <td class="text-center">100%</td>
                </tr>
            </tfoot>
        </table>
    </div>
    
    <div style="margin-top: 20px; text-align: center;">
        <a href="dashboard.cfm" style="background: #007bff; color: white; padding: 10px 20px; text-decoration: none; border-radius: 5px; margin-right: 10px;">
            📊 Tableau de bord
        </a>
        <a href="index.cfm" style="background: #6c757d; color: white; padding: 10px 20px; text-decoration: none; border-radius: 5px;">
            🏠 Accueil
        </a>
    </div>

    <script>
        // Données pour les graphiques
        const restaurantData = [
            <cfloop array="#statsByRestaurant#" index="resto">
                { name: '<cfoutput>#JSStringFormat(resto.name)#</cfoutput>', count: <cfoutput>#resto.total#</cfoutput> },
            </cfloop>
        ];
        
        const severityData = {
            high: <cfoutput>#stats.high#</cfoutput>,
            medium: <cfoutput>#stats.medium#</cfoutput>,
            low: <cfoutput>#stats.low#</cfoutput>
        };
        
        // Graphique en barres
        const barCanvas = document.getElementById('barChart');
        const barCtx = barCanvas.getContext('2d');
        
        // Calculer les dimensions
        const barWidth = 60;
        const barSpacing = 20;
        const maxCount = Math.max(...restaurantData.map(d => d.count));
        const chartHeight = 250;
        const chartPadding = 20;
        
        // Dessiner les barres
        restaurantData.forEach((data, index) => {
            const x = chartPadding + index * (barWidth + barSpacing);
            const barHeight = (data.count / maxCount) * (chartHeight - 40);
            const y = chartHeight - barHeight;
            
            // Barre
            barCtx.fillStyle = '#ff5500';
            barCtx.fillRect(x, y, barWidth, barHeight);
            
            // Valeur au-dessus
            barCtx.fillStyle = '#333';
            barCtx.font = '14px Arial';
            barCtx.textAlign = 'center';
            barCtx.fillText(data.count, x + barWidth/2, y - 5);
            
            // Nom du restaurant (tronqué si trop long)
            barCtx.save();
            barCtx.translate(x + barWidth/2, chartHeight + 10);
            barCtx.rotate(-Math.PI/4);
            barCtx.font = '12px Arial';
            barCtx.textAlign = 'right';
            const name = data.name.length > 15 ? data.name.substring(0, 12) + '...' : data.name;
            barCtx.fillText(name, 0, 0);
            barCtx.restore();
        });
        
        // Graphique donut
        const donutCanvas = document.getElementById('donutChart');
        const donutCtx = donutCanvas.getContext('2d');
        const centerX = 100;
        const centerY = 100;
        const radius = 80;
        const innerRadius = 40;
        
        const total = severityData.high + severityData.medium + severityData.low;
        const colors = {
            high: '#dc3545',
            medium: '#ffc107',
            low: '#28a745'
        };
        
        let currentAngle = -Math.PI / 2;
        
        ['high', 'medium', 'low'].forEach(severity => {
            const value = severityData[severity];
            const angle = (value / total) * 2 * Math.PI;
            
            // Dessiner le segment
            donutCtx.beginPath();
            donutCtx.arc(centerX, centerY, radius, currentAngle, currentAngle + angle);
            donutCtx.arc(centerX, centerY, innerRadius, currentAngle + angle, currentAngle, true);
            donutCtx.fillStyle = colors[severity];
            donutCtx.fill();
            
            currentAngle += angle;
        });
        
        // Centre blanc
        donutCtx.beginPath();
        donutCtx.arc(centerX, centerY, innerRadius - 2, 0, 2 * Math.PI);
        donutCtx.fillStyle = 'white';
        donutCtx.fill();
        
        // Texte au centre
        donutCtx.fillStyle = '#333';
        donutCtx.font = 'bold 24px Arial';
        donutCtx.textAlign = 'center';
        donutCtx.textBaseline = 'middle';
        donutCtx.fillText(total, centerX, centerY);
        donutCtx.font = '12px Arial';
        donutCtx.fillText('incidents', centerX, centerY + 20);
    </script>
</body>
</html>