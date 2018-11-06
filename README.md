# O365MgmtApi
Instructions and PS script example for how to interactively pull service health and message center posts from a tenant

Use O365 Mgmt API via PowerShell to get Service Health and Incidents as well as Message Center posts: 
•	Login to AAD Portal with GA account from the tenant where you wish to capture service health and message center updates
  i.	 Select All Services from the blade at the left and find and go into App Registrations
  
    1.	Click + New Application Registration button
      a.	Give it a name like "O365 Mgmt API"
      b.	Leave application type "Web app / API"
      c.	Set a dummy signon url like "https://dummyurl" (this URL not used)
      
    2.	Select the new App you created (mine is “O365 Mgmt API”)
      a.	Copy the Application ID GUID and save in a note for use in a script as your ClientID
      b.	Click the app's Settings button 
        i.	Choose Required Permissions under API Access settings and click +Add
          1. 	Select the "Office 365 Management API" 
          2.	Select "Read service health information for your organization" under Application Permissions and click Save
        ii.	Choose Keys under API Access settings
          1.	Click in the Key field and give it a name like "ClientSecret"
          2.	Select a Duration
          3.	Click Save to create a VALUE which is the ClientSecret password.
          4.	Copy the Value provided for this Key for use in script and safe it in notes as your ClientSecret 
            a.	NOTE: it will not be visible or retrievable after you navigate away from this section
            b.  If you lose it or forget to copy it, you will need to delete it and create a new one
        iii.	Close Keys and Settings
      c.	Click the app's link, created underneath "Managed application in local directory" (has same name as your app)
        i.	Click on Permissions under the Security settings
          1.	Click the Blue Box that says "Grant admin consent for <tenant>.onmicrosoft.com
          2.	Login with a GA or Service Administrator granted user
          3.	Click Accept to allow admin consent
            a.	It will try to open the https://dummyurl you configured for the app once you've accepted the admin consent
            b.  This can be closed and disregarded.

    3.	From the blade at the left, select All Services and find and go into Azure Active Directory 
      a.	Select Properties under the Manage settings
      b.	Copy the Directory ID GUID to save in a note for use in a script as your TenantGUID.
        i.	Alternatively, if you have connected to AzureAD via the AzureAD PowerShell module, you can run:  
          1. (Get-AzureADTenantDetail).ObjectId to get your TenantGUID.
          
    4.	Update the PowerShell example script with your AppID, ClientSecret, and DirectoryID
      a.	Execute the script to retrieve results for Services, Features, Status and Messages from Message Center
      b.  Notice the sections to retrieve data are general, will need to be adapted to what you want to retrieve how you want to see it)
      b.	The script does not require any interactive login because it is using an App Registration with its own:
        i.  Username (AppID) and Password (ClientSecret) to obtain read-only info
