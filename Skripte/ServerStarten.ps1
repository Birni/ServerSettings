#------------------------------------[Server]---------------------------------------
$ServerNameForLog = "Salty Bay Aberration" 
$PathNameOfExe= "Ark_ServerX10\\Aberration"
$arksurvivalFolder ="C:\SERVER\Ark_ServerX10\Aberration"
$arkSurvivalStartArgument="Aberration_P?QueryPort=27017?MultiHome=185.38.149.15?RCONEnabled=true?RCONPort=27022?MaxPlayers=120?TribeLogDestroyedEnemyStructures=true?Port=7781?PreventOfflinePvP=true?PreventOfflinePvPInterval=2700?UseOptimizedHarvestingHealth=trues?listen -ClusterDirOverride=C:\SERVER\Ark_ServerX10\clusters -NoTransferFromFiltering -clusterid=2017ARK -automanagedmods -UseBattlEye -nosteamclient -AutoDestroyStructures -game -server -ForceRespawnDinos -log"
$ServerIP="185.38.149.15"
$serveraffinity=3
$priority ="High"
#--------------------------
#------------------------------------[mcrconInformation]------------------------------------------
#Folder for mcrcon
$mcrconExec="C:\server\mcrcon\mcrcon.exe"
#RCON Port
$rconPort=27022
#RCON Password
$rconPassword=[secret]
#------------------------------------[SteamInformation]-------------------------------------------
#Folder where SteamCMD is:
$steamcmdFolder="C:\SERVER\steamcmd"
#The ID of the App Your Updating
$steamAppID="376030"
#------------------------------------[ScriptInformation]---------------------------------------------
$clearCache=1
$steamcmdExec = $steamcmdFolder+"\steamcmd.exe"
$steamcmdCache = $steamcmdFolder+"\appcache"

#------------------------------------[ServerBroadcastMessages]---------------------------------------


$60minWarning ="broadcast server restart. server will shutdown in 60 minutes"
$45minWarning ="broadcast server restart. server will shutdown in 45 minutes"
$30minWarning ="broadcast server restart. server will shutdown in 30 minutes"
$15minWarning ="broadcast server restart. server will shutdown in 15 minutes"
$10minWarning ="broadcast server restart. server will shutdown in 10 minutes"
$5minWarning ="broadcast server restart. server will shutdown in 5 minutes"
$1minWarning ="broadcast server restart. server will shutdown in 1 minutes"
$WorldSaveMsg = "broadcast World Saved"



#------------------------------------[whatsmatelogin]---------------------------------------
 $groupAdmin = "+491786289770" # TODO: Specify the WhatsApp number of the group creator, including the country code
 $groupName = "SaltyBayStatus"   # TODO: Specify the name of the group
 $message = "Daily Restarting!" # TODO: Specify the content of your message

 $instanceId = "11"  # TODO: Replace it with your gateway instance ID here
 $clientId = "Matthias-Birnthaler@hotmail.de"  # TODO: Replace it with your Forever Green client ID here
 $clientSecret = "d73fc7a6e67d41eb918ee65fd36aeda4"  # TODO: Replace it with your Forever Green client secret here


function sendWhatsApp([string] $_message)
{
 $jsonObj = @{'group_admin'=$groupAdmin;
              'group_name'=$groupName;
              'message'=$_message;}

	Try {
		$res = Invoke-WebRequest -Uri "http://api.whatsmate.net/v3/whatsapp/group/text/message/$instanceId" `
                          -Method Post   `
                          -Headers @{"X-WM-CLIENT-ID"=$clientId; "X-WM-CLIENT-SECRET"=$clientSecret;} `
                          -Body (ConvertTo-Json $jsonObj)

	Write-host "Status Code: "  $res.StatusCode
	Write-host $res.Content
	}
	Catch {
	$result = $_.Exception.Response.GetResponseStream()
	$reader = New-Object System.IO.StreamReader($result)
	$reader.BaseStream.Position = 0
	$reader.DiscardBufferedData()
	$responseBody = $reader.ReadToEnd();

	Write-host "Status Code: " $_.Exception.Response.StatusCode
	Write-host $responseBody
}
}  
#------------------------------------[Main Function]--------------------------------------------------------
Clear-Host

        
        
        
        #Server Message 60 minute warning
		& $mcrconExec -c -H $ServerIP -P $rconPort -p $rconPassword $60minWarning
        $time =	Get-Date	
        Write-Host $time 60 min warning given 
		sendWhatsApp($ServerNameForLog +"server restart in 60 min")
		Start-Sleep -s 900

		#Server Message 45 minute warning
		& $mcrconExec -c -H $ServerIP -P $rconPort -p $rconPassword $45minWarning
		$time =	Get-Date
        Write-Host $time 45 min warning given
		#sendWhatsApp($ServerNameForLog +"server restart in 45 min")
		Start-Sleep -s 900
		
		#Server Message 30 minute warning
		& $mcrconExec -c -H $ServerIP -P $rconPort -p $rconPassword $30minWarning	
		$time =	Get-Date
        Write-Host $time 30 min warning given 
		#sendWhatsApp($ServerNameForLog +"server restart in 30 min")
		Start-Sleep -s 900
		
		#Server Message 15 minute warning
		& $mcrconExec -c -H $ServerIP -P $rconPort -p $rconPassword $15minWarning
		$time = Get-Date
		Write-Host $time 15 min warning
		#sendWhatsApp($ServerNameForLog +"server restart in 15 min")
		Start-Sleep -s 300	

		#Server Message 10 minute warning	
		& $mcrconExec -c -H $ServerIP -P $rconPort -p $rconPassword $10minWarning
		$time =	Get-Date
        Write-Host $time 10 min warning given 
		#sendWhatsApp($ServerNameForLog +"server restart in 10 min")
		Start-Sleep -s 300

		#Server Message 5 minute warning			
		& $mcrconExec -c -H $ServerIP -P $rconPort -p $rconPassword $5minWarning	
		$time =	Get-Date
        Write-Host $time 5 min warning given
		#sendWhatsApp($ServerNameForLog +"server restart in 5 min") 
		Start-Sleep -s 240
		
		#Server Message 1 minute warning
		& $mcrconExec -c -H $ServerIP -P $rconPort -p $rconPassword $1minWarning			
		$time =	Get-Date
        Write-Host $time 1 min warning given 
		sendWhatsApp($ServerNameForLog +"server restart in 1 min")
		$ramdom = Get-Random -Minimum -15 -Maximum 15
		$sleeptime = 60 + $ramdom
		Start-Sleep -s $sleeptime 

		& $mcrconExec -c -H $ServerIP -P $rconPort -p $rconPassword "saveworld"
		$time =	Get-Date
        Write-Host $time world saving Server
		Start-Sleep -s 2


 $Process = Get-Process ShooterGameServer  | Where-Object {$_.Path -match $PathNameOfExe} 

 $Process | foreach {$_.kill()}

 #Start Server Illand
 Write-Host Update Script Initialising
 & $steamcmdExec +login anonymous +force_install_dir $arksurvivalFolder +app_update 376030 +exit
 #restart server



& $arksurvivalFolder"\ShooterGame\Binaries\Win64\ShooterGameServer.exe" $arkSurvivalStartArgument
$time = Get-Date
Write-Host $time Restarting Server with long orp!
sendWhatsApp($ServerNameForLog +"server restarted")

Start-Sleep -s 10
 
$Process = Get-Process ShooterGameServer  | Where-Object {$_.Path -match $PathNameOfExe} 

#$Process.processoraffinity = $serveraffinity
$Process.priorityclass = $priority
 
 
 
