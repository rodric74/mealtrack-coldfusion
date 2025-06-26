<!--- Vérifier qu'on a les données --->
<cfif NOT structKeyExists(form, "id") OR NOT structKeyExists(form, "status")>
    <cflocation url="dashboard.cfm" addtoken="false">
</cfif>

<!--- Mettre à jour le statut --->
<cfset incidentObj = new components.Incident()>
<cfset success = incidentObj.updateStatus(form.id, form.status)>

<!--- Rediriger vers le détail avec un message --->
<cfif success>
    <cfset session.successMessage = "Le statut a été mis à jour avec succès !">
<cfelse>
    <cfset session.errorMessage = "Erreur lors de la mise à jour du statut.">
</cfif>

<cflocation url="incident-detail.cfm?id=#form.id#" addtoken="false">