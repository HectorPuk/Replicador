add-type @"
    using System.Net;
    using System.Security.Cryptography.X509Certificates;
    public class TrustAllCertsPolicy : ICertificatePolicy {
        public bool CheckValidationResult(
            ServicePoint srvPoint, X509Certificate certificate,
            WebRequest request, int certificateProblem) {
            return true;
        }
    }
"@
[System.Net.ServicePointManager]::CertificatePolicy = New-Object TrustAllCertsPolicy

#$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
#$headers.Add("Content-Type", "text/plain")
#$headers.Add("Cookie", "B1SESSION=5fc3be92-cadd-11eb-8000-000c29966740; CompanyDB=TESTBACKUP; ROUTEID=.node1")

$body = "{`"CompanyDB`": `"TESTBACKUP`", `"UserName`": `"manager`", `"Password`": `"1234`", `"Language`": `"23`"}"

$StartTime = $(get-date)

$response = Invoke-RestMethod 'https://192.168.1.233:50000/b1s/v1/Login' -Method 'POST' -Body $body
$response | ConvertTo-Json

Write-Output ("{0}" -f ($(get-date)-$StartTime))
