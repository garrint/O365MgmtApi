# Run the following PowerShell script to retrieve results for Services, Features, Service Health Status and Message Center Posts
# via the O365 Mgmt API

################################################################################################
# -----UPDATE THIS SECTION-----
################################################################################################
#  ClientID is the Application ID of the app registration in your tenant
	$ClientID = "<GUID>" #O365 Mgmt API app in your tenant
#  ClientSecret is the Key value created when setting up an app Key Password in your tenant
	$ClientSecret = "<HASH>" #key password created for the App in your tenant
#  Get the tenant GUID from Azure Active Directory > Properties > Directory ID or (Get-AzureADTenantDetail).ObjectId when connected to AzureAD module
	$TenantGUID = "<GUID>"
#  O365 Tenant Domain (use either <contoso>.onmicrosoft.com or <contoso>.com form for tenant)
	$tenantdomain = "<tenant>.onmicrosoft.com"

################################################################################################
# -----Script to pull data from O365 Mgmt API-----
################################################################################################
# Management API URLs
$loginURL = "https://login.microsoftonline.com/"
$resource = "https://manage.office.com"

# Get access tokens here to pass to Service APIs
$body = @{grant_type="client_credentials";resource=$resource;client_id=$ClientID;client_secret=$ClientSecret}
$oauth = Invoke-RestMethod -Method Post -Uri $loginURL/$tenantdomain/oauth2/token?api-version=1.0 -Body $body
$headerParams = @{'Authorization'="$($oauth.token_type) $($oauth.access_token)"}

################################################################################################
# -----Get Services info 
################################################################################################
# Get Services info 
$MyServices = Invoke-WebRequest -Headers $headerParams -Uri "https://manage.office.com/api/v1.0/$tenantGUID/ServiceComms/Services"
$ServiceData = (Convertfrom-json $MyServices.Content)
$ServiceArray = $ServiceData.value
	$ServiceArray.Features |Select *

################################################################################################
# -----Get Service Health info 
################################################################################################ 
$MyStatus = Invoke-WebRequest -Headers $headerParams -Uri "https://manage.office.com/api/v1.0/$tenantGUID/ServiceComms/CurrentStatus"
$StatusData = (Convertfrom-json $MyStatus.Content)
$StatusArray = $StatusData.value
	# $StatusArray |Select WorkloadDisplayName, StatusDisplayname, Incidentids 
	# $StatusArray | Select WorkloadDisplayName, Incidentids -Expandproperty FeatureStatus | ft
	$StatusArray | Select WorkloadDisplayName, StatusDisplayname, Incidentids -Expandproperty FeatureStatus | ft -GroupBy WorkloadDisplayName
   
################################################################################################
# -----Get Message Center Posts 
################################################################################################
$MyMessages = Invoke-WebRequest -Headers $headerParams -Uri "https://manage.office.com/api/v1.0/$tenantGUID/ServiceComms/Messages"
$MessageData = (Convertfrom-json $MyMessages.Content)
$MessageArray = $MessageData.value
	$MessageArray
	# $MessageArray[0] | select-object messages


