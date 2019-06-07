# Script envio de mensagem pelo Telegram usando o Powershell - Créditos Gabriel Luiz - www.gabrielluiz.com ##

$BotKey = "6933339977:AAE4Kn_u9kuoi2ZBBliD-6o9LDjuUkiXhCo" # Coloque aqui o código token API gerado. Exemplo: 6933339977:AAE4Kn_u9kuoi2ZBBliD-6o9LDjuUkiXhCo
$GetChatID = Invoke-WebRequest -Uri "https://api.telegram.org/bot$BotKey/getUpdates"
(ConvertFrom-Json $GetChatID.Content).result.message.chat.id

function Send-TeleMessage([string] $BotKey , [array] $ChatIDs , [string] $Message)
{
    $sendMsgLink = "https://api.telegram.org/bot$BotKey/sendMessage"
    foreach ($ID in $ChatIDs)
    {        
        try
        {
            
            $ExecuteInvokeWeb = Invoke-WebRequest -Uri "$sendMsgLink" -Method Post -ContentType "application/json;charset=utf-8" -Body (ConvertTo-Json -Compress -InputObject @{chat_id=$ID; text="$Message"}) -ErrorAction SilentlyContinue
            $Status = (ConvertFrom-Json -InputObject $ExecuteInvokeWeb.Content)
            if($Status.ok){Write-Host "Message successfully sent to Chat ID : $ID (Type : $($Status.result.chat.type))" -ForegroundColor Green}
        }
        catch [Exception]
        {
            $exception = $_.Exception.ToString().Split(".")[2]
            Write-Host "Message failed to send at Chat ID : $ID ($exception)" -ForegroundColor Red
        }
    }
}

Send-TeleMessage -BotKey "6933339977:AAE4Kn_u9kuoi2ZBBliD-6o9LDjuUkiXhCo" -ChatIDs "267966999" -Message "Alerta Evento 29292 - Crítico! Servidor HY2 parou de fazer a réplicação, favor verificar. " # No campo -BotKey repita o código token gerado pela API. Já o campo -ChatIDs copie o código gerado no Chat ID, exemplo: 795591150. # Já o campo -Message escreve a mensagem de alerta.