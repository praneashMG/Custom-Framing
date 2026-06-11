$files = Get-ChildItem -Path ".\*.html"
foreach ($file in $files) {
    $content = Get-Content $file.FullName -Raw
    
    # Process all img tags
    $pattern = '(?i)<img[^>]*src="assets/[^"]*"[^>]*>'
    $evaluator = [System.Text.RegularExpressions.MatchEvaluator] {
        param($m)
        $imgTag = $m.Value
        $lowerTag = $imgTag.ToLower()
        
        $newSrc = $null
        
        # Mapping logic
        if ($lowerTag -match "canvas stretching") {
            $newSrc = "assets/Canvas Stretching & Mounting.jpg"
        } elseif ($lowerTag -match "fine art conservation|preservation") {
            $newSrc = "assets/Fine Art Conservation.jpg"
        } elseif ($lowerTag -match "stain|foxing|paper|document|manuscript|parchment") {
            $newSrc = "assets/Stain & Foxing Removal.jpg"
        } elseif ($lowerTag -match "18th century|clean|oil canvas chemical") {
            $newSrc = "assets/18th Century Oil Painting Cleaning.jpg"
        } elseif ($lowerTag -match "antique oil|fine art restoration|art restoration|oil preservation") {
            $newSrc = "assets/Antique Oil Painting.jpg"
        } elseif ($lowerTag -match "repair & gild|gilding|burnishing") {
            $newSrc = "assets/Antique Frame Repair & Gilding.webp"
        } elseif ($lowerTag -match "ornate gold leaf") {
            $newSrc = "assets/Ornate Gold Leaf Frame.jpg"
        } elseif ($lowerTag -match "gold leaf") {
            $newSrc = "assets/Gold Leaf Frame.jpg"
        } elseif ($lowerTag -match "3d object|shadowbox|box frame") {
            $newSrc = "assets/3D Object Shadowbox.jpg"
        } elseif ($lowerTag -match "custom framing|matting") {
            $newSrc = "assets/Custom Framing.jpg"
        }
        
        if ($newSrc) {
            # Replace the src attribute with the new image
            $newImgTag = [System.Text.RegularExpressions.Regex]::Replace($imgTag, 'src="assets/[^"]*"', "src=`"$newSrc`"")
            return $newImgTag
        }
        
        return $imgTag
    }
    
    $content = [System.Text.RegularExpressions.Regex]::Replace($content, $pattern, $evaluator)
    Set-Content -Path $file.FullName -Value $content
}
