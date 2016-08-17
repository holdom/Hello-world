
$mr_projects_dir = ""
$mr_readmes_dir = ""

function get-tfs
{
    param([string] $ServerName = "https://tfsrews.am.trimblecorp.net")

    $binpath   = "C:\Program Files (x86)\Microsoft Visual Studio 12.0\Common7\IDE\ReferenceAssemblies\v2.0"
    Add-Type -path "$binpath\Microsoft.TeamFoundation.Client.dll"
    Add-Type -Path "$binpath\Microsoft.TeamFoundation.WorkItemTracking.Client.dll"

    $creds = New-Object Microsoft.TeamFoundation.Client.UICredentialsProvider
    $teamProjectCollection = New-Object Microsoft.TeamFoundation.Client.TfsTeamProjectCollection $ServerName,$creds

    $ws = $teamProjectCollection.GetService([Microsoft.TeamFoundation.WorkItemTracking.Client.WorkItemStore])
    $proj = $ws.Projects["AgileProliance"]

    $ParentWorkItems = $ws.Query("SELECT [System.Id] FROM WorkItems WHERE [System.WorkItemType] = 'Initiative' 
        AND [System.AreaPath] = 'AgileProliance\Proliance Maintenance'  
        AND [System.IterationPath] = 'AgileProliance\Active\Proliance Maintenance - All Versions'
        AND [System.State] <> 'Closed' ")

    foreach ($ini in  $ParentWorkItems)
    {
       $count = 0
       foreach ($link in $ini.WorkItemLinks)
        {
            
            if($link.LinkTypeEnd.Name -eq "Child")
            {
                
                $child= $ws.GetWorkItem($link.TargetId)
                if ($child.Fields["PivotalID"].Value -ne '')
                {
                    $count=$count +1
                    if ($child.State -eq 'For Test')
                    {
                        
                    }
                }
            }
                 
        }
        if ($count -ge 6){write-host $ini.Id}
    }

}
get-tfs