netsh interface portproxy add v6tov6 listenport=3390 connectaddress=[::1] connectport=445
netsh interface ipv6 set privacy state=disabled store=active
netsh interface ipv6 set privacy state=disabled store=persistent
netsh interface ipv6 set global randomizeidentifiers=enabled store=active
netsh interface ipv6 set global randomizeidentifiers=enabled store=persistent
@REM netsh interface ipv6 set privacy state=enabled store=active
@REM netsh interface ipv6 set privacy state=enabled store=persistent
@REM netsh interface ipv6 set global randomizeidentifiers=enabled store=active
@REM netsh interface ipv6 set global randomizeidentifiers=enabled store=persistent
pause
