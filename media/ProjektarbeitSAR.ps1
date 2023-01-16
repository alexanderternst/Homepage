start-transcript $env:USERPROFILE\Transcript.txt
<#
  .SYNOPSIS
  2. Part Hier waehlt man in was fuer ein File man die Informationen exportieren will
  danach wird mit Funktionen erst überprueft ob File schon existiert und danach
  wird das neue File kreiert.
  .PARAMETER <$Auswahl>
  Welche Informationen man haben will
  .DESCRIPTION
  Man kann in Textdatei, CSV, HTML oder direkt-export Exportieren.
  .EXAMPLE
  Man kan alle Informationen mit dieser Funktion aufgerufen und exportiert.
#> 
function ExportAuswahl
{
    
    Clear-Host
    $Menu2 = "true"
    while($Menu2 -eq "true")
    {
        Clear-Host
        $Eingabe = Read-Host -Prompt "
        
    
    
     #####    #    ######  
    #     #  # #   #     # 
    #       #   #  #     # 
    #####  #     # ######  
         # ####### #   #   
    #    # #     # #    #  
    #####  #     # #     # 


        `nBitte auswaehlen...
        `n-----------------------------------------------------------------------------------------
        
        `n1. exportieren als Textdatei
        `n2. exportieren als CSV
        `n3. exportieren als HTML
        `n4. direkt exportieren
        `n5. Zurueck
        
        `n-----------------------------------------------------------------------------------------
        `nNummer bitte auswaehlen "

        switch($Eingabe)
        {
            1
            {
                "Export in ein TXT File"
                $FileName = "txt"
                $FileLocation = "$env:USERPROFILE\$Auswahl.txt"
                DoesFileExist
                ExportFile
                $Menu2 = "false"
            }
            2
            {
                "Export in ein CSV File"
                $FileName = "csv"
                $FileLocation = "$env:USERPROFILE\$Auswahl.csv"
                DoesFileExist
                ExportFile
                $Menu2 = "false"
            }
            3
            {
                "Export in ein HTML File"
                $FileName = "html"
                $FileLocation = "$env:USERPROFILE\$Auswahl.html"
                DoesFileExist
                ExportFile
                $Menu2 = "false"
            }
            4
            {
                "Export Direct"
                $FileName = "direct"
                $FileLocation = "$env:USERPROFILE\$Auswahl.html"
                DoesFileExist
                ExportFile
                $Menu2 = "false"
            }
            5 
            {
            $Menu2 = "false"
            }
            default
            {
            	"Falsche Angabe"
 			Start-Sleep -Seconds 2
            }
        }
    }
}
<#
  .SYNOPSIS
  3. Part Prueft ob file schon existiert und macht abfrage ob man es loeschen/ersetzen will oder ob man zurueck gehen will.
  .PARAMETER <$FileLocation>
  Wo es abgespeichert ist und met der endung welches file
  .EXAMPLE
  Kontrolliert ob File schon existiert.
#>
function DoesFileExist 
{
    $Menu3 = "true"
    while($Menu3 -eq "true")
    {
        Clear-Host
        if (Test-Path -Path $FileLocation -PathType Leaf)
        {
		    "Die Datei exisitiert bereits."
		    Clear-Host
            $Eingabe = Read-Host -Prompt "
            
    
    
     #####    #    ######  
    #     #  # #   #     # 
    #       #   #  #     # 
    #####  #     # ######  
         # ####### #   #   
    #    # #     # #    #  
    #####  #     # #     # 


            `nDie Datei exisitiert bereits...
            `n-----------------------------------------------------------------------------------------
        
            `n1. loeschen und ersetzen
            `n2. zurueck
        
            `n-----------------------------------------------------------------------------------------
            `nNummer bitte auswaehlen "
            switch($Eingabe)
            {
                1
                {
                	Remove-Item -Path $FileLocation
			"Loeschen und ersetzen"
                }
                2
                {
			"Zurueck zu File auswahl"
			ExportAuswahl
                }
                default
                {
			"Falsche Angabe"
			Start-Sleep -Seconds 2
                }
            }
        }
        else
        {
		"Die Datei exisitiert noch nicht."
		Clear-Host
            $Menu3 = "False"
        }
    }   
}
<#
  .SYNOPSIS
   4. Part Exportiert Informationen (je nach vorheriger Auswahl) in CSV, TXT, HTML oder direkt-Export File.
  Der Switch Befehl in dieser Funktion greift entweder auf andere FUnktion zu oder macht export direkt.
  .PARAMETER <$Infos>
  Welche Informationen man haben will
  .PARAMETER <$FileLocation>
  Wo es abgespeichert ist und met der endung welches file
  .DESCRIPTION
  Hier können die Informationen in Textdatei, CSV, HTML oder direkt-export exportiert werden.
  .EXAMPLE
  Alle Informationen und Filetyp Kombinationen werden mit dieser Funktion aufgerufen und exportiert. 
#>
function ExportFile 
{
    if(($Infos -eq "BIOS") -or ($Infos -eq "OS") -and ($FileName -eq "txt"))
    {
        Get-ComputerInfo -Property "$Infos*" |
            Out-File -FilePath $FileLocation
        Invoke-Expression $FileLocation
    }
    elseif(($Infos -eq "BIOS") -or ($Infos -eq "OS") -and ($FileName -eq "csv"))
    {
        Get-ComputerInfo -Property "$Infos*" |
            export-Csv -Path $FileLocation -Delimiter ";"
        Invoke-Expression $FileLocation
    }
    elseif(($Infos -eq "BIOS") -or ($Infos -eq "OS") -and ($FileName -eq "html"))
    {
        Get-ComputerInfo -Property "$Infos*" |
            ConvertTo-Html -Head "<style>td {width:100px; max-width:300px; background-color:lightgrey;}table {width:100%;}th {font-size:14pt;background-color:yellow;}</style>" |
            Set-Content -Path $FileLocation
        Invoke-Expression $FileLocation
    }
    elseif(($Infos -eq "BIOS") -or ($Infos -eq "OS") -and ($FileName -eq "direct"))
    {
        Get-ComputerInfo -Property "$Infos*" |
            Out-GridView
    }
    elseif($Infos -eq "IP")
    {
        ExportIP
    }
    elseif($Infos -eq "HARDDISK")
    {
        ExportHardDisk
    }
    elseif($Infos -eq "Serv")
    {
        ExportServices
    }
    elseif($Infos -eq "INST")
    {
        ExportInstallation
    }
    elseif($Infos -eq "USERS")
    {
        ExportUsers
    }
    elseif($Infos -eq "ERG")
    {
        ExportEreignise
    }
    elseif($Infos -eq "VER")
    {
        ExportVersion
    }
}
 <#
  .SYNOPSIS
  Expotiert Informationen von IP je nach Auswahl ($FileName) in CSV, HTML, TXT oder direkt.
  .DESCRIPTION
  Diese Funktion kann IP-Informationen in Textdatei, CSV, HTML oder direkt-export exportieren.
  .PARAMETER <$FileLocation>
  Wo es abgespeichert ist und met der endung welches file
  .PARAMETER <$Filename>
  Filetyp ist in diesem Parameter gespeichert.
  .EXAMPLE
  IP Informationen werden mit dieser Funktion aufgerufen und exportiert. 
#>
function ExportIP
{
    switch($FileName)
    {
        "txt"
        {
        ipconfig /ALL |
            Out-File -FilePath $FileLocation
        Invoke-Expression $FileLocation
        }
        "csv"
        {
            ipconfig /ALL |
                export-Csv -Path $FileLocation -Delimiter ";"
            Invoke-Expression $FileLocation
        }
        "html"
        {
            ipconfig /ALL |
                ConvertTo-Html -Head "<style>td {width:100px; max-width:300px; background-color:lightgrey;}table {width:100%;}th {font-size:14pt;background-color:yellow;}</style>" |
                Set-Content -Path $FileLocation
            Invoke-Expression $FileLocation
        }
        "direct"
        {
            ipconfig /ALL |
                Out-GridView    
       }
    }
}
 <#
  .SYNOPSIS
  Expotiert PSVersion je nach Auswahl ($FileName) in CSV, HTML, TXT oder direkt.
  .DESCRIPTION
  Diese Funktion kann die PS-Version in Textdatei, CSV, HTML oder direkt-export exportieren.
  .PARAMETER <$FileLocation>
  Wo es abgespeichert ist und met der endung welches file
  .PARAMETER <$Filename>
  Filetyp ist in diesem Parameter gespeichert.
  .EXAMPLE
  PS-Version wird mit dieser Funktion aufgerufen und exportiert.
#>
function ExportVersion
{
    switch($FileName)
    {
        "txt"
        {
            $PSVersionTable |
            Out-File -FilePath $FileLocation
        Invoke-Expression $FileLocation
        }
        "csv"
        {
            $PSVersionTable |
                export-Csv -Path $FileLocation -Delimiter ";"
            Invoke-Expression $FileLocation
        }
        "html"
        {
            $PSVersionTable |
                ConvertTo-Html -Head "<style>td {width:100px; max-width:300px; background-color:lightgrey;}table {width:100%;}th {font-size:14pt;background-color:yellow;}</style>" |
                Set-Content -Path $FileLocation
            Invoke-Expression $FileLocation
        }
        "direct"
        {
            $PSVersionTable |
                Out-GridView    
       }
    }
}
 <#
  .SYNOPSIS
  Expotiert Informationen von HardDisk je nach Auswahl ($FileName) in CSV, HTML, TXT oder direkt.
  .DESCRIPTION
  Diese Funktion kann HardDiskInformationen in Textdatei, CSV, HTML oder direkt-export exportieren.
  .PARAMETER <$FileLocation>
  Wo es abgespeichert ist und met der endung welches file
  .PARAMETER <$Filename>
  Filetyp ist in diesem Parameter gespeichert.
  .EXAMPLE
  HardDisk Informationen werden mit dieser Funktion aufgerufen und exportiert.
#>
function ExportHardDisk
{
   switch($FileName)
    {
        "txt"
        {
            Get-PSDrive |
                Out-File -FilePath $FileLocation
            Invoke-Expression $FileLocation
        }
        "csv"
        {
            Get-PSDrive |
                export-Csv -Path $FileLocation -Delimiter ";"
            Invoke-Expression $FileLocation
        }
        "html"
        {
            Get-PSDrive |
                ConvertTo-Html -Head "<style>td {width:100px; max-width:300px; background-color:lightgrey;}table {width:100%;}th {font-size:14pt;background-color:yellow;}</style>" |
                Set-Content -Path $FileLocation
            Invoke-Expression $FileLocation
        }
        "direct"
        {
            Get-PSDrive |
                Out-GridView
        }
    }
}
 <#
  .SYNOPSIS
  Expotiert Services je nach Auswahl ($FileName) in CSV, HTML, TXT oder direkt.
  .DESCRIPTION
  Diese Funktion kann Services in Textdatei, CSV, HTML oder direkt-export exportieren.
  .PARAMETER <$FileLocation>
  Wo es abgespeichert ist und met der endung welches file
  .PARAMETER <$Filename>
  Filetyp ist in diesem Parameter gespeichert.
  .EXAMPLE
  Services werden mit dieser Funktion aufgerufen und exportiert.
#>
function ExportServices
{
   switch($FileName)
    {
        "txt"
        {
            Get-Service |
                Out-File -FilePath $FileLocation
            Invoke-Expression $FileLocation
        }
        "csv"
        {
            Get-Service |
                export-Csv -Path $FileLocation -Delimiter ";"
            Invoke-Expression $FileLocation
        }
        "html"
        {
            Get-Service |
                ConvertTo-Html -Head "<style>td {width:100px; max-width:300px; background-color:lightgrey;}table {width:100%;}th {font-size:14pt;background-color:yellow;}</style>" |
                Set-Content -Path $FileLocation
            Invoke-Expression $FileLocation
        }
        "direct"
        {
            Get-Service |
                Out-GridView
        }
    }
}
 <#
  .SYNOPSIS
  Expotiert Ereignise je nach Auswahl ($FileName) in CSV, HTML, TXT oder direkt.
  .DESCRIPTION
  Diese Funktion kann Ereignise in Textdatei, CSV, HTML oder direkt-export exportieren.
  .PARAMETER <$FileLocation>
  Wo es abgespeichert ist und met der endung welches file
  .PARAMETER <$Filename>
  Filetyp ist in diesem Parameter gespeichert.
  .EXAMPLE
  Ereignise werden mit dieser Funktion aufgerufen und exportiert.  
#>
function ExportEreignise
{
   switch($FileName)
    {
        "txt"
        {
            Get-EventLog -LogName "Windows PowerShell" |
                Out-File -FilePath $FileLocation
            Invoke-Expression $FileLocation
        }
        "csv"
        {
            Get-EventLog -LogName "Windows PowerShell" |
                export-Csv -Path $FileLocation -Delimiter ";"
            Invoke-Expression $FileLocation
        }
        "html"
        {
            Get-EventLog -LogName "Windows PowerShell" |
                ConvertTo-Html -Head "<style>td {width:100px; max-width:300px; background-color:lightgrey;}table {width:100%;}th {font-size:14pt;background-color:yellow;}</style>" |
                Set-Content -Path $FileLocation
            Invoke-Expression $FileLocation
        }
        "direct"
        {
            Get-EventLog -LogName "Windows PowerShell" |
                Out-GridView
        }
    }
}
 <#
  .SYNOPSIS
  Expotiert Informationen von Usern je nach Auswahl ($FileName) in CSV, HTML, TXT oder direkt.
  .DESCRIPTION
  Diese Funktion kann User-Informationen in Textdatei, CSV, HTML oder direkt-export exportieren.
  .PARAMETER <$FileLocation>
  Wo es abgespeichert ist und met der endung welches file
  .PARAMETER <$Filename>
  Filetyp ist in diesem Parameter gespeichert.
  .EXAMPLE
  User Informationen werden mit dieser Funktion aufgerufen und exportiert. 
#>
function ExportUsers
{
   switch($FileName)
    {
        "txt"
        {
            Get-LocalUser |
                Out-File -FilePath $FileLocation
            Invoke-Expression $FileLocation
        }
        "csv"
        {
            Get-LocalUser |
                export-Csv -Path $FileLocation -Delimiter ";"
            Invoke-Expression $FileLocation
        }
        "html"
        {
            Get-LocalUser |
                ConvertTo-Html -Head "<style>td {width:100px; max-width:300px; background-color:lightgrey;}table {width:100%;}th {font-size:14pt;background-color:yellow;}</style>" |
                Set-Content -Path $FileLocation
            Invoke-Expression $FileLocation
        }
        "direct"
        {
            Get-LocalUser |
                Out-GridView
        }
    }
}
 <#
  .SYNOPSIS
  Exportiert Installations-Informationen je nach Auswahl ($FileName) in CSV, HTML, TXT oder direkt.
  .DESCRIPTION
  Diese Funktion kann Installations-Informationen in Textdatei, CSV, HTML oder direkt-export exportieren.
  .PARAMETER <$FileLocation>
  Wo es abgespeichert ist und met der endung welches file
  .PARAMETER <$Filename>
  Filetyp ist in diesem Parameter gespeichert.
  .EXAMPLE
  Installations-Informationen werden mit dieser Funktion aufgerufen und exportiert. 
#>
function ExportInstallation
{
   switch($FileName)
    {
        "txt"
        {
            $INSTALLED = Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* |
                Select-Object DisplayName, DisplayVersion, Publisher, InstallDate
            $INSTALLED += Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* |
                Select-Object DisplayName, DisplayVersion, Publisher, InstallDate$INSTALLED | 
                ?{ $_.DisplayName -ne $null } |
                sort-object -Property DisplayName -Unique |
                Out-File -FilePath $FileLocation
            Invoke-Expression $FileLocation
        }
        "csv"
        {
            $INSTALLED = Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* |
                Select-Object DisplayName, DisplayVersion, Publisher, InstallDate
            $INSTALLED += Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* |
                Select-Object DisplayName, DisplayVersion, Publisher, InstallDate$INSTALLED | 
                ?{ $_.DisplayName -ne $null } |
                sort-object -Property DisplayName -Unique |
                export-Csv -Path $FileLocation -Delimiter ";"
            Invoke-Expression $FileLocation  
        }
        "html"
        {
            $INSTALLED = Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* |
                Select-Object DisplayName, DisplayVersion, Publisher, InstallDate
            $INSTALLED += Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* |
                Select-Object DisplayName, DisplayVersion, Publisher, InstallDate$INSTALLED | 
                ?{ $_.DisplayName -ne $null } |
                sort-object -Property DisplayName -Unique |
                ConvertTo-Html -Head "<style>td {width:100px; max-width:300px; background-color:lightgrey;}table {width:100%;}th {font-size:14pt;background-color:yellow;}</style>" |
                Set-Content -Path $FileLocation
            Invoke-Expression $FileLocation
        }
        "direct"
        {
            $INSTALLED = Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* |
                Select-Object DisplayName, DisplayVersion, Publisher, InstallDate
            $INSTALLED += Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* |
                Select-Object DisplayName, DisplayVersion, Publisher, InstallDate$INSTALLED | 
                ?{ $_.DisplayName -ne $null } |
                sort-object -Property DisplayName -Unique |
                Out-GridView
        }
    }
}

<#
  .SYNOPSIS
  Hier wird eine kleine Animation abgspielt
  .DESCRIPTION
  Beim Ausloggen aktiviert
#> 
function WaitingDot
{
    $spinner = "."

    for ($num1 = 0; $num1 -le 5; $num1++)
    {
        if($spinner -eq ".")
        {
            clear
            echo $spinner
            $spinner = ".."
            Start-Sleep -Seconds 1
        }
        elseif($spinner -eq "..")
        {
            clear
            echo $spinner
            $spinner = "..."
            Start-Sleep -Seconds 1
        }
        elseif($spinner -eq "...")
        {
            clear
            echo $spinner
            $spinner = "."
            Start-Sleep -Seconds 1
        }
    }
}
<#
  .SYNOPSIS
  1. Part Auswahl was man machen will.
  .DESCRIPTION
  Auswahl welche Infos man exportieren will oder ob man das Programm beenden will.
  .PARAMETER <$infos>
  Welche Infos will ich importieren
  .EXAMPLE
  Man kann auswaehlen welche Informationen man exportiert. Zusatzfunktion die das Programm beendet.
#>
$Menu = "true";
while($Menu -eq "true")
{
"****************"
    Clear-Host
    $EingabeMenu = Read-Host -Prompt "
    
    
     #####    #    ######  
    #     #  # #   #     # 
    #       #   #  #     # 
    #####  #     # ######  
         # ####### #   #   
    #    # #     # #    #  
    #####  #     # #     # 


    `nBitte auswaehlen...
    `n-----------------------------------------------------------------------------------------

    `n1. BIOS Informationen anzeigen
    `n2. Betriebssystem Informationen anzeigen
    `n3. Harddisk Informationen anzeigen
    `n4. Netzwerkkonfigurationen anzeigen
    `n5. Alle laufenden und gestoppten Windows Dienste anzeigen
    `n6. Installierte Programme anzeigen nur C:
    `n7. Windows Benutzeraccounts und Gruppen anzeigen
    `n8. Ereignisprotokoll anzeigen
    `n9. PowerShell Version anzeigen
    `n10. Programm verlassen

    `n-----------------------------------------------------------------------------------------
    `nNummer bitte auswaehlen "                    

    switch($EingabeMenu)
    {
        1
        {
            "Bios Informationen"
            $Auswahl = "BiosInformation"
            $Infos = "BIOS"
            ExportAuswahl
        }
        2
        {
            "OS Informationen"
            $Auswahl = "OSInformation"
            $Infos = "OS"
            ExportAuswahl
        }
        3
        {
            "Harddisk Informationen"
            $Auswahl ="HarddiskInformation"
            $Infos = "HARDDISK"
            ExportAuswahl
        }
        4
        {
            "IP Informationen"
            $Auswahl ="IPInformation"
            $Infos = "IP"
            ExportAuswahl
        }
        5
        {
            "Service Informationen"
            $Auswahl ="ServiceInformation"
            $Infos = "Serv"
            ExportAuswahl
        }
        6
        {
            "Instalation Informationen"
            $Auswahl ="InstalationInformation"
            $Infos = "INST"
            ExportAuswahl
        }
        7
        {
            "Benutzer Informationen"
            $Auswahl ="BenutzeraccountsInformation"
            $Infos = "USERS"
            ExportAuswahl
        }
        8
        {
            "Ereignis Informationen"
            $Auswahl ="EreignisInformation"
            $Infos = "ERG"
            ExportAuswahl
        }
        9
        {
            "Version Informationen"
            $Auswahl ="VersionInformation"
            $Infos = "VER"
            ExportAuswahl
        }
        10
        {
            WaitingDot
            Clear-Host
            $Menu = "false"
            Clear-Host
            Write-Host "`nAuf Wiedersehen" $env:USERNAME "!"
            Start-Sleep -Seconds 2
            stop-transcript 
            Invoke-Expression $env:USERPROFILE\Transcript.txt
            Exit
        }
        default
        {
            Clear-Host
            
            "`nFalsche Eingabe!"
            Start-Sleep -Seconds 2
            Clear-Host
        }
    }
}