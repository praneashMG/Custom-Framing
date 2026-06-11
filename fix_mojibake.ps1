$htmlFiles = Get-ChildItem -Path "d:\Custom Framing  Art Conservation Studio" -Filter *.html

foreach ($file in $htmlFiles) {
    # Read as UTF8 to correctly catch the garbage strings
    $content = Get-Content $file.FullName -Raw -Encoding UTF8

    # Replace the corrupted encodings with normal characters
    $content = $content -replace 'Ã¢â‚¬â€œ', '-'
    $content = $content -replace 'Ã¢â‚¬â€ ', '-'
    $content = $content -replace 'â€”', '-'
    $content = $content -replace 'â€“', '-'
    $content = $content -replace 'â€¢', '•'

    Set-Content -Path $file.FullName -Value $content -Encoding UTF8
}

Write-Output "Mojibake cleaned up successfully."
