$files = Get-ChildItem -Path ".\*.html"
foreach ($file in $files) {
    $content = Get-Content $file.FullName -Raw
    
    # Replace all unsplash links in <link rel="icon" ...>
    $content = [System.Text.RegularExpressions.Regex]::Replace($content, 'href="https://images\.unsplash\.com/[^"]*"', 'href="assets/favicon.png"')
    $content = $content -replace 'assets/vf\.jpg', 'assets/favicon.png'
    
    # Process all img tags
    $pattern = '(?i)<img[^>]*src="https://images\.unsplash\.com/[^"]*"[^>]*>'
    $evaluator = [System.Text.RegularExpressions.MatchEvaluator] {
        param($m)
        $imgTag = $m.Value
        $lowerTag = $imgTag.ToLower()
        
        $newSrc = "assets/custom_framing.png"
        if ($lowerTag -match "restor|oil|clean|canvas|paint|stabiliz") {
            $newSrc = "assets/art_restoration.png"
        } elseif ($lowerTag -match "paper|document|map|textile|manuscript|parchment") {
            $newSrc = "assets/paper_conservation.png"
        } elseif ($lowerTag -match "gild|gold") {
            $newSrc = "assets/gilding.png"
        } elseif ($lowerTag -match "consult|laborat|micro|measur|desk|workshop") {
            $newSrc = "assets/studio_consultation.png"
        } elseif ($lowerTag -match "galler|exhibit|wall|display|portfolio") {
            $newSrc = "assets/gallery_wall.png"
        }
        
        return [System.Text.RegularExpressions.Regex]::Replace($imgTag, 'src="https://images\.unsplash\.com/[^"]*"', "src=`"$newSrc`"")
    }
    $content = [System.Text.RegularExpressions.Regex]::Replace($content, $pattern, $evaluator)
    
    # Background images 
    $content = [System.Text.RegularExpressions.Regex]::Replace($content, 'url\(''https://images\.unsplash\.com/[^'']*''\)', "url('assets/studio_consultation.png')")
    $content = [System.Text.RegularExpressions.Regex]::Replace($content, 'url\("https://images\.unsplash\.com/[^"]*"\)', "url('assets/studio_consultation.png')")
    
    Set-Content -Path $file.FullName -Value $content
}
