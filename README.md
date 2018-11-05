# CookieMonster
Inspired by a post from [the hacker known as "Alex"](https://mango.pdf.zone/stealing-chrome-cookies-without-a-password "Link for inspiration"), I set out to write a PowerShell script that will display all the local cookies stored in Google Chrome for a given website. It does so by using Chrome's Remote Debugging Protocol to start Chrome in headless mode and grab cookies without needing to authenticate. 

Running it with `cookies.ps1 -site https://www.google.com` results in 
```
Connecting to ws://localhost:9222/devtools/page/1579337FB241D91C388CFB8945F37DB9
Connected!
Cookies for https://www.google.com :
{"id":1,"result":{"cookies":[{"name":"NID","value":"XXX","domain":".google.com","pat
h":"/","expires":1557207301.706976,"size":178,"httpOnly":true,"secure":false,"session":false},{"name":"OGPC","value":"XXX","domain":".google.com","path":"/","expires":1546580102,"size":15,"httpOnly":false,"secure":false,"session":false},{"name":"1P
_JAR","value":"XXX","domain":".google.com","path":"/","expires":1543988102,"size":17,"httpOnly":false,"secure":false,"se
ssion":false}]}}
```

As this is my first PowerShell script, I'm betting that I made some stylistic or functional errors, but that's all part of the learning. One improvement that could be made is in the cleanup, as while it does kill the spawned Chrome process, it often spits out errors too.
