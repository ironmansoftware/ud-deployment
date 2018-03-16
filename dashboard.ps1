Import-Module UniversalDashboard

$ImportModule = "Import-Module $PSScriptRoot\controls.psm1"
Import-Module $PSScriptRoot\controls.psm1

$Dashboard = New-UDDashboard -Title "PowerShell Deployment" -Content {
    New-UDRow -Columns {
        New-UDColumn -Size 4 -Content {}
        New-UDColumn -Size 4 -Content {
            New-UDElement -Tag "div" -Id "parent" -Content {

                # Creates the input box and adds some fields to it
                New-UDInput -Title "Universal Dashboard - Deploy" -Content {
                    New-UDInputField -Name "txtVMIP" -Type "textbox" -Placeholder "VM IP Address"
                    New-UDInputField -Name "txtAdminUserId" -Type "textbox" -Placeholder "Admin User ID"
                    New-UDInputField -Name "txtAdminPassword" -Type "password" -Placeholder "Admin Password"

                #Creates an endpoint that accepts the values of the fields
                } -Endpoint {
                    param($txtVMIP, $txtAdminUserId, $txtAmdinPassword)
                     
                    #Creates a new control to display in the input box
                    $Element = New-DeploymentCard -IP $txtVMIP -UserId $txtAdminUserId -UserPass $txtAmdinPassword 
                    New-UDInputAction -Content $Element
                } -SubmitText "Login"
            }
        }

    }
} -EndpointInitializationScript ([ScriptBlock]::Create($ImportModule))

Start-UDDashboard -Dashboard $Dashboard -Port 10001