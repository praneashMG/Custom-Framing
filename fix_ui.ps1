$files = Get-ChildItem -Path "d:\Custom Framing  Art Conservation Studio\*.html"
foreach ($file in $files) {
    $content = Get-Content $file.FullName -Raw
    
    # Fix favicon
    $content = $content -replace '<link rel="icon".*?>\s*<link rel="icon".*?>', '<link rel="icon" href="assets/favicon.png" type="image/png">'
    
    # Actually wait, some files might have it in different forms. Let's do a more robust replace for favicon
    $content = $content -replace '(?s)<link rel="icon"[^>]*>(\s*<link rel="icon"[^>]*>)*', '<link rel="icon" href="assets/favicon.png" type="image/png">'

    # Fix oversized cards (h-80, h-72, h-[300px]) to h-64 or just remove fixed height and let it be responsive
    # Or replace h-80, h-72 with h-64 or h-auto aspect-square
    $content = $content -replace '\bh-80\b', 'h-64'
    $content = $content -replace '\bh-72\b', 'h-64'
    $content = $content -replace '\bh-\[300px\]\b', 'h-64'
    $content = $content -replace '\bh-\[400px\]\b', 'h-64'
    
    # Fix container width. Let's standardize to max-w-6xl
    $content = $content -replace 'max-w-4xl', 'max-w-6xl'
    $content = $content -replace 'max-w-5xl', 'max-w-6xl'
    $content = $content -replace 'max-w-7xl', 'max-w-6xl'
    $content = $content -replace 'max-w-\[1400px\]', 'max-w-6xl'
    
    # Fix py- padding consistency (py-12, py-16, py-20, etc.) -> make sections py-20
    # Just be careful not to override small py-ings. Let's look at <section class="... py-...">
    $content = $content -replace '(?<=<section[^>]*class="[^"]*?\b)py-12\b', 'py-16'
    $content = $content -replace '(?<=<section[^>]*class="[^"]*?\b)py-20\b', 'py-16'

    Set-Content -Path $file.FullName -Value $content -NoNewline
}
