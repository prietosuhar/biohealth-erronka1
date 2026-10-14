# BioHealth - VPN proba DMZtik: OpenVPN bezeroaren "remote" WAN IPtik (192.168.123.217) DMZ IPra (192.168.20.254)
# Arrazoia: IsardVDIko Default sareak mahaigainak isolatzen ditu; proba DMZtik egiten da.
# PowerShell ADMINISTRATZAILE gisa exekutatu.
$f = (Get-ChildItem "C:\Program Files\OpenVPN\config\*.ovpn").FullName
(Get-Content $f) -replace "123.217","20.254" | Set-Content $f
Select-String remote $f
