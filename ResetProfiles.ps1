Add-Type -Assembly 'System.IO.Compression.FileSystem'

$dataDirectory = "$env:SystemDrive\SunliteSuite2\_DataLight"

foreach ($file in Get-ChildItem -Path $PSScriptRoot -File -Filter '*.shw') {
	$extractDirectory = "$dataDirectory\$($file.BaseName)"
	if (Test-Path $extractDirectory) {
		Remove-Item -Force "$dataDirectory\$($file.BaseName)" -Recurse
	}
	
	[System.IO.Compression.ZipFile]::ExtractToDirectory($file.FullName, $extractDirectory)
}

Get-ChildItem -Path $dataDirectory -File | Remove-Item -Force
Copy-Item -Path "$PSScriptRoot\_global.xml" -Destination $dataDirectory -Force