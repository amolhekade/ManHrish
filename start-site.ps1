# ManHrish Technologies - minimal static file server (no installs needed)
param([int]$Port = 8092)
$root = $PSScriptRoot
$mime = @{
  '.html'='text/html; charset=utf-8'; '.css'='text/css; charset=utf-8'; '.js'='application/javascript; charset=utf-8'
  '.svg'='image/svg+xml'; '.png'='image/png'; '.jpg'='image/jpeg'; '.jpeg'='image/jpeg'; '.gif'='image/gif'
  '.ico'='image/x-icon'; '.json'='application/json'; '.webp'='image/webp'; '.woff2'='font/woff2'; '.txt'='text/plain'
}
$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add("http://localhost:$Port/")
$listener.Start()
Write-Host "Serving $root at http://localhost:$Port/  (Ctrl+C to stop)"
Start-Process "http://localhost:$Port/"
try {
  while ($listener.IsListening) {
    $ctx = $listener.GetContext()
    $path = [Uri]::UnescapeDataString($ctx.Request.Url.AbsolutePath.TrimStart('/'))
    if ([string]::IsNullOrEmpty($path)) { $path = 'index.html' }
    $file = [IO.Path]::GetFullPath((Join-Path $root $path))
    if ((Test-Path $file -PathType Container)) { $file = Join-Path $file 'index.html' }
    if ($file.StartsWith($root) -and (Test-Path $file -PathType Leaf)) {
      $bytes = [IO.File]::ReadAllBytes($file)
      $ext = [IO.Path]::GetExtension($file).ToLower()
      $ctx.Response.ContentType = $(if ($mime[$ext]) { $mime[$ext] } else { 'application/octet-stream' })
      $ctx.Response.StatusCode = 200
      $ctx.Response.OutputStream.Write($bytes, 0, $bytes.Length)
    } else {
      $ctx.Response.StatusCode = 404
    }
    Write-Host ("{0} {1} {2}" -f $ctx.Request.HttpMethod, $ctx.Request.Url.AbsolutePath, $ctx.Response.StatusCode)
    $ctx.Response.Close()
  }
} finally { $listener.Stop() }
