$htmlFiles = Get-ChildItem -Path "d:\Custom Framing  Art Conservation Studio" -Filter *.html

foreach ($file in $htmlFiles) {
    $content = Get-Content $file.FullName -Raw

    # 1. Update font weights for headings (from font-bold to font-semibold)
    # 600 weight is font-semibold in tailwind
    $content = [System.Text.RegularExpressions.Regex]::Replace($content, '(<h[1-6][^>]*?class="[^"]*?)font-bold([^"]*?")', '$1font-semibold$2')

    # Ensure any remaining font-bold on h1/h2/h3 is caught (sometimes attributes are split or single quotes)
    $content = [System.Text.RegularExpressions.Regex]::Replace($content, '(<h[1-6][^>]*?class=''[^'']*?)font-bold([^'']*?'')', '$1font-semibold$2')

    # 2. Standardize sizes (Optional, but let's do the obvious ones)
    # H2 to text-3xl sm:text-5xl (most common)
    $content = [System.Text.RegularExpressions.Regex]::Replace($content, '(<h2[^>]*?class="[^"]*?)(text-2xl sm:text-4xl|text-4xl)([^"]*?")', '$1text-3xl sm:text-5xl$3')

    # H3 to text-2xl sm:text-3xl
    $content = [System.Text.RegularExpressions.Regex]::Replace($content, '(<h3[^>]*?class="[^"]*?)(text-xl|text-lg|text-base|text-3xl)(?! sm:)([^"]*?")', '$1text-2xl sm:text-3xl$3')

    Set-Content -Path $file.FullName -Value $content -Encoding UTF8
}

Write-Output "Typography updated successfully."
