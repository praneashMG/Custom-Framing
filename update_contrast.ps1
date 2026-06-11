$htmlFiles = Get-ChildItem -Path "d:\Custom Framing  Art Conservation Studio" -Filter *.html

foreach ($file in $htmlFiles) {
    $content = Get-Content $file.FullName -Raw

    # Update .btn-primary and .btn-accent text colors to adapt to themes properly
    # Replace hardcoded 'color: white;' with 'color: var(--color-background);' in these button definitions
    
    # We can do this safely using regex
    $content = $content -replace '(\.btn-primary\s*{[^}]*)color:\s*white;', '$1color: var(--color-background);'
    $content = $content -replace '(\.btn-primary:hover\s*{[^}]*)color:\s*white;', '$1color: var(--color-background);'
    $content = $content -replace '(\.btn-accent\s*{[^}]*)color:\s*white;', '$1color: var(--color-background);'

    # Additionally, let's check for any text-white classes that could be problematic in dark mode
    # Sometimes text-white is used inside cards or overlays. If it's over an image (project-overlay), white is fine.
    # We will just stick to fixing the button contrast which is the most critical interactive element.

    Set-Content -Path $file.FullName -Value $content -Encoding UTF8
}

Write-Output "Contrast updated successfully."
