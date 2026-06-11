$files = Get-ChildItem -Path ".\*.html"
foreach ($file in $files) {
    $content = Get-Content $file.FullName -Raw
    
    $pattern = '(?i)<img[^>]*src="assets/[^"]*"[^>]*>'
    $evaluator = [System.Text.RegularExpressions.MatchEvaluator] {
        param($m)
        $imgTag = $m.Value
        $lowerTag = $imgTag.ToLower()
        
        $newSrc = "assets/Custom Framing.jpg" # Default
        
        if ($lowerTag -match "canvas stretching") {
            $newSrc = "assets/Canvas Stretching & Mounting.jpg"
        } elseif ($lowerTag -match "fine art conservation|preservation") {
            $newSrc = "assets/Fine Art Conservation.jpg"
        } elseif ($lowerTag -match "stain|foxing|paper|document|manuscript|parchment") {
            $newSrc = "assets/Stain & Foxing Removal.jpg"
        } elseif ($lowerTag -match "18th century|clean|chemical") {
            $newSrc = "assets/18th Century Oil Painting Cleaning.jpg"
        } elseif ($lowerTag -match "antique oil|fine art restoration|art restoration|oil preservation|oil") {
            $newSrc = "assets/Antique Oil Painting.jpg"
        } elseif ($lowerTag -match "repair & gild|gild|burnish") {
            $newSrc = "assets/Antique Frame Repair & Gilding.webp"
        } elseif ($lowerTag -match "ornate gold leaf") {
            $newSrc = "assets/Ornate Gold Leaf Frame.jpg"
        } elseif ($lowerTag -match "gold leaf|gold") {
            $newSrc = "assets/Gold Leaf Frame.jpg"
        } elseif ($lowerTag -match "3d object|shadowbox|box frame") {
            $newSrc = "assets/3D Object Shadowbox.jpg"
        } elseif ($lowerTag -match "custom framing|matting|moulding|corner|bevel|join") {
            $newSrc = "assets/Custom Framing.jpg"
        } elseif ($lowerTag -match "gallery|wall|exhibition") {
            $newSrc = "assets/Fine Art Conservation.jpg" # Fallback
        } elseif ($lowerTag -match "studio|consultation|desk|workshop|laboratory|lab|microscope") {
            $newSrc = "assets/Fine Art Conservation.jpg" # Fallback
        }
        
        $newImgTag = [System.Text.RegularExpressions.Regex]::Replace($imgTag, 'src="assets/[^"]*"', "src=`"$newSrc`"")
        return $newImgTag
    }
    
    $content = [System.Text.RegularExpressions.Regex]::Replace($content, $pattern, $evaluator)
    
    # Also background images
    $content = [System.Text.RegularExpressions.Regex]::Replace($content, 'url\(''assets/[^'']+''\)', "url('assets/Custom Framing.jpg')")
    
    Set-Content -Path $file.FullName -Value $content
}
