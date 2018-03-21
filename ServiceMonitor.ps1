$computername = (Get-WmiObject -Class Win32_ComputerSystem -Property Name).Name
$StatusLogFileName = $computername + '_ServiceStatus.log'
$StatusLogFileLocation = "";
$ServiceName = ''
$arrService = Get-Service -Name $ServiceName
$DateTime = get-date
$StartingStatement = 'The specified service found to be stopped starting Service Now for:' + $computername
$RunningStatement = 'The service is now running:' + $computername

while ($arrService.Status -ne 'Running')
{

    Start-Service $ServiceName
    $emailFrom = ""
    $smtpServer = ""
    $smtp = new-object Net.Mail.SmtpClient($smtpServer)
    $to = ""
    $messageParameters = @{ 
              Subject = ""
              Body = "***Custom Message*** -" + $computername
              From = $emailFrom
              To = $to
              SmtpServer = $smtpServer
              BodyAsHtml=$true 
              Priority="high"
              }
    Send-MailMessage @messageParameters
    Out-File $StatusLogFileLocation -InputObject "$DateTime - $StartingStatement" -Append
    Start-Sleep -seconds 60
    $arrService.Refresh()
    if ($arrService.Status -eq 'Running')
    {
        (Out-File $StatusLogFileLocation -InputObject "$DateTime - $RunningStatement" -Append)
    }

}
