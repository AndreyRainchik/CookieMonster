param (
    [Parameter(Mandatory=$true)][string]$site
)

$st = ""
$size = 2048
$params = @'
{
    "id": 1,
     "method": "Network.getAllCookies"
}
'@
$l = @(); $params.ToCharArray() | % {$l += [byte] $_}          
$p = New-Object System.ArraySegment[byte]  -ArgumentList @(,$l)
$l = [byte[]] @(,0) * $size
$receive = New-Object System.ArraySegment[byte]  -ArgumentList @(,$l)
$proc = [System.Diagnostics.Process]::Start("C:\Program Files (x86)\Google\Chrome\Application\chrome.exe","--headless --user-data-dir='$env:LOCALAPPDATA\Google\Chrome\User Data\Default' $site --remote-debugging-port=9222")
$request = Invoke-WebRequest -Uri http://localhost:9222/json | ConvertFrom-Json
$url = $request.webSocketDebuggerUrl[0]
$ws = New-Object System.Net.WebSockets.ClientWebSocket
$ct = New-Object System.Threading.CancellationToken
echo "Connecting to $url"
$conn = $ws.ConnectAsync($url, $ct)
While (!$conn.IsCompleted) { Start-Sleep -Milliseconds 100 }
echo "Connected!"
$conn = $ws.SendAsync($p, [System.Net.WebSockets.WebSocketMessageType]::Text, [System.Boolean]::TrueString, $ct)
While (!$Conn.IsCompleted) { Start-Sleep -Milliseconds 100 }
do {
    $conn = $ws.ReceiveAsync($receive, $ct)
        While (!$Conn.IsCompleted) { Start-Sleep -Milliseconds 100 }
    $receive.Array[0..($conn.Result.Count - 1)] | ForEach { $st += [char]$_ }
} until ($conn.Result.Count -lt $size)
$conn = $ws.CloseAsync([System.Net.WebSockets.WebSocketCloseStatus]::NormalClosure, "NormalClosure", $ct) 
While (!$Conn.IsCompleted) { Start-Sleep -Milliseconds 100 }
echo "Cookies for $site :"
$st
Get-CimInstance Win32_Process -Filter "CommandLine LIKE '%chrome.exe%--headless%'" | %{Stop-Process $_.ProcessId}