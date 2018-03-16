#These controls will be part of the next minor version (v1.6.0) of UD

function New-UDTextbox {
    param($Id, $Placeholder, [Switch]$Password)

    $type = "text"
    if ($Password) {
        $type = "password"
    }

    New-UDElement -Tag "div" -Attributes @{
        className = "input-field"
    } -Content {
        New-UDElement -Tag "input" -Attributes @{
            type = $type
            placeholder = $Placeholder
        } -Id $Id
    }
}

function New-UDButton {
    param($Text, $onClick) 

    New-UDElement -Tag "a" -Attributes @{
        className = "btn"
        onClick = $onClick
    } -Content { $Text }
}

function New-UDProgress {
    param($Percent, $Id) 

    New-UDElement -Tag "div" -Attributes @{ className = "progress"} -Content {
        New-UDElement -Tag "div" -Attributes @{ className = "determinate"; style = @{ width = "$Percent%"}} -Id $Id
    }
}
# Updates the status of a particular computer
function Set-UDStatus {
    param($Computer, $Percent, $Message, [Switch]$Failed)

    $Color = "green"
    if ($Failed) {
        $Color = "red"
    }

    Set-UDElement -Id "status_$Computer" -Content {$Message}
    Set-UDElement -Id "progress_$Computer" -Attributes @{
        className = "determinate";
        style = @{
            width = "$Percent%"
            backgroundColor = $Color
        }
    }
}

function New-DeploymentCard {
    param(
        $IP,
        $UserId,
        $UserPass
    )
        
    New-UDElement -Id "DeploymentCard" -Tag "div" -Attributes @{ className = "card" } -Content {

        #$UserPass = $UserPass | ConvertTo-SecureString
        #$cred = new-object -typename System.Management.Automation.PSCredential -argumentlist $UserId, $password
        #$Computers = Get-ADComputer -Server $IP -Credential $cred

        $Computers = @("2008r2dc", "node1", "node2")

        New-UDElement -Tag "div" -Attributes @{ className = "card-content" } -Content {
            New-UDElement -Tag "span" -Attributes @{ className = "card-title "} -Content { "Universal Dashboard - Deploy" }

            foreach($computer in $computers) {
                New-UDElement -Tag "i" -id "icon_$computer" -Content {  } 
                New-UDElement -Tag "span" -Content { "    $computer" } 
                New-UDElement -Tag "p" -Content { "" } -Id "status_$computer"
                New-UDProgress -Percent 0 -Id "progress_$computer"
            }

            New-UDButton -Text "Deploy" -onClick {
                foreach($computer in $computers) {

                    Start-RSJob {
                        $DashboardHub = $Using:DashboardHub
                        $ConnectionId = $Using:ConnectionId
                        #$Cred = $Using:Cred
                        $Computer = $Using:Computer

                        Set-UDElement -Id "icon_$computer" -Attributes @{ className = "fa fa-play green-text"}

                        Set-UDStatus -Computer $Computer -Message "Copying deployment files" -Percent 15
                        Start-Sleep -Seconds (Get-Random -Minimum 5 -Maximum 10)
    
                        #Copy-Item \\asset-computer\assets\* -Destination "\\$Computer\C$" -Credential $Cred
    
                        Set-UDStatus -Computer $Computer -Message "Installing .NET 4.6.2" -Percent 25
                        Start-Sleep -Seconds (Get-Random -Minimum 5 -Maximum 10)
    
                        #$process = get-wmiobject -query "SELECT * FROM Meta_Class WHERE __Class = 'Win32_Process'" -namespace "root\cimv2" -computername $Computer -credential $cred
                        #$results = $process.Create( "C:\mu_.net_fx_4_6_2_for_win_7sp1_8dot1_10_win_server_2008sp2_2008r2sp1_2012_2012r2_x86_x64_9058211.exe /q" )

                        Set-UDStatus -Computer $Computer -Message "Restarting Computer" -Percent 45
                        Start-Sleep -Seconds (Get-Random -Minimum 5 -Maximum 10)
    
                        #Restart-Computer -ComputerName $Computer -Credential $Cred -Wait 

                        Set-UDStatus -Computer $Computer -Message "Installing WMF 5.1" -Percent 75
                        Start-Sleep -Seconds (Get-Random -Minimum 5 -Maximum 10)

                        #$process = get-wmiobject -query "SELECT * FROM Meta_Class WHERE __Class = 'Win32_Process'" -namespace "root\cimv2" -computername $Computer -credential $cred
                        #$results = $process.Create( "powershell -File C:\InstallWMF5.1.ps1" )

                        Set-UDStatus -Computer $Computer -Message "Checking PowerShell Version" -Percent 85
                        Start-Sleep -Seconds (Get-Random -Minimum 5 -Maximum 10)

                        $Random = Get-Random -Minimum 0 -Maximum 100

                        # Check that WMF 5.1 succeeded

                        if ($Random -gt 60) {
                            Set-UDStatus -Computer $Computer -Message "WMF 5.1 Failed to Install" -Percent 100 -Failed
                            Set-UDElement -Id "icon_$computer" -Attributes @{ className = "fa fa-times red-text"}
                        } else {
                            Set-UDStatus -Computer $Computer -Message "WMF 5.1 Installed" -Percent 100
                            Set-UDElement -Id "icon_$computer" -Attributes @{ className = "fa fa-check green-text"}
                        }
                    } -ModulesToImport (Get-Module controls).Path
                }
            }
        }
    }
}
