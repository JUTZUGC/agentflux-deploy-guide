# AgentFlux 一键部署脚本（第三方指南）——按官方文档封装
# 官方文档：https://github.com/davemessew/AgentFlux/blob/main/docs/installation.md
# 更新日期：2026-11-02
# 类型：docker
$ErrorActionPreference = 'Stop'
Set-Location -Path $PSScriptRoot

foreach ($cmd in @('git', 'docker')) {
  if (-not (Get-Command $cmd -ErrorAction SilentlyContinue)) { throw "需要先安装 $cmd" }
}
docker compose version | Out-Null
if ($LASTEXITCODE -ne 0) { throw '需要 Docker Compose v2（docker compose 子命令）' }

New-Item -ItemType Directory -Force -Path .download | Out-Null
Set-Location -Path .download

New-Item -ItemType Directory -Force agentflux | Out-Null; Set-Location agentflux
curl.exe -fL -o agentflux-0.3.0-linux-amd64.tar.gz https://github.com/davemessew/AgentFlux/releases/download/v0.3.0/agentflux-0.3.0-linux-amd64.tar.gz
curl.exe -fL -o compose.yaml https://github.com/davemessew/AgentFlux/releases/download/v0.3.0/compose.yaml
$h=(Get-FileHash .\agentflux-0.3.0-linux-amd64.tar.gz -Algorithm SHA256).Hash.ToLower()
if ($h -ne "c722c914000d6d86355e5c54c6efbfcfa7c712bf1adf41acd69ac1f8b7bfc883") { throw "SHA256 校验失败" }
docker load -i agentflux-0.3.0-linux-amd64.tar.gz
docker compose up -d --wait
Write-Host "已启动：默认端口 4310，两个服务都 healthy 后再打开"

Write-Host ''
$url = 'http://localhost:4310'
Write-Host "等待服务启动：$url"
$ready = $false
for ($i = 0; $i -lt 30; $i++) {
  try {
    Invoke-WebRequest -UseBasicParsing -Uri $url -TimeoutSec 3 | Out-Null
    $ready = $true
    break
  } catch {
    Start-Sleep -Seconds 2
  }
}
if (-not $ready) { throw "60 秒内未探测到 $url，请手动打开确认或查看日志" }
Write-Host '服务已就绪'
Write-Host '部署完成，浏览器访问 http://localhost:4310'
Write-Host '若结果异常或需要改配置，请参考官方文档：https://github.com/davemessew/AgentFlux/blob/main/docs/installation.md'
