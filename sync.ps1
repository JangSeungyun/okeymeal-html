# =====================================================================
# OkeyMeal 문서 자동 동기화 스크립트 (sync.ps1)
# =====================================================================
# 원본 문서 폴더에서 필요한 파일만 복사하고, 보안 로직을 유지하며, 
# 깃허브에 자동으로 배포하는 스크립트입니다.
# =====================================================================

$sourceDir = "C:\workspace_personal\1.projects\OkeyMeal\documents"
$destDir = "C:\workspace_personal\1.projects\okeymeal-html"

Write-Host "동기화를 시작합니다..." -ForegroundColor Cyan

# 1. 원본 디렉토리 존재 확인
if (-not (Test-Path $sourceDir)) {
    Write-Host "오류: 원본 폴더($sourceDir)를 찾을 수 없습니다." -ForegroundColor Red
    exit
}

# 2. 파일 복사 (Robocopy 활용)
# /MIR : 원본과 똑같이 맞춤 (원본에 없으면 대상에서도 삭제)
# /XD : 제외할 폴더 (.git 등)
# /XF : 제외할 파일 (로그인 페이지, 이력 파일, README, 스크립트 본인 등 보호해야 할 파일들)
Write-Host "1. 파일을 복사하는 중..." -ForegroundColor Yellow

$robocopyArgs = @(
    $sourceDir, $destDir, "/MIR",
    "/XD", ".git", 
    "/XF", "index.html", "dashboard.html", "sync_history.md", "sync.ps1", "README.md"
)
& robocopy @robocopyArgs | Out-Null

# Robocopy는 성공 시 종료 코드가 1(파일 복사됨) 또는 0(변경없음)입니다.
if ($LASTEXITCODE -gt 7) {
    Write-Host "파일 복사 중 심각한 오류가 발생했습니다." -ForegroundColor Red
    exit
}

# 3. 원본의 index.html을 가져와서 dashboard.html로 변환 (보안 로직 주입)
Write-Host "2. 보안 로직을 주입하여 dashboard.html 생성 중..." -ForegroundColor Yellow

$sourceIndex = Join-Path $sourceDir "index.html"
$destDashboard = Join-Path $destDir "dashboard.html"

if (Test-Path $sourceIndex) {
    $content = Get-Content $sourceIndex -Raw -Encoding UTF8
    
    # 인증 검사 스크립트 블록
    $authScript = @"
<head>
    <!-- Authentication Check -->
    <script>
        const auth = sessionStorage.getItem('okeymeal_auth');
        const validHash = '14b7f0fb0ed3eaea8e8e527d507d2099ff0066bcc51d7ef6d85044f76a82f6ef';
        if (auth !== validHash) {
            window.location.replace('index.html');
        }
    </script>
"@
    
    # <head> 태그 뒤에 스크립트 주입 (대소문자 구분 없이 변경)
    $content = $content -ireplace "<head>", $authScript
    
    # BOM(Byte Order Mark) 없는 UTF-8로 저장
    [System.IO.File]::WriteAllText($destDashboard, $content, [System.Text.Encoding]::UTF8)
} else {
    Write-Host "경고: 원본 index.html을 찾을 수 없습니다." -ForegroundColor Yellow
}

# 4. 동기화 이력 기록 (sync_history.md)
Write-Host "3. 동기화 이력을 기록하는 중..." -ForegroundColor Yellow

# 원본 레포지토리에서 최신 커밋 정보 가져오기
Push-Location $sourceDir
$commitHash = $(git log -1 --format="%h")
$commitMsg = $(git log -1 --format="%s")
$commitDate = $(git log -1 --format="%cd" --date=short)
Pop-Location

$syncDate = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
$historyFile = Join-Path $destDir "sync_history.md"

$logEntry = @"
### Sync: $syncDate
- **Original Repo Commit**: [$commitHash] $commitMsg ($commitDate)

"@

if (-not (Test-Path $historyFile)) {
    $header = "# 동기화 이력 (Sync History)`n`n이 문서는 원본 OkeyMeal 레포지토리에서 문서를 가져온 이력을 자동으로 기록합니다.`n`n"
    [System.IO.File]::WriteAllText($historyFile, $header, [System.Text.Encoding]::UTF8)
}

# 파일 내용 끝에 추가
Add-Content -Path $historyFile -Value $logEntry -Encoding UTF8

# 5. Git 자동 업로드 (선택 사항 - 자동으로 업로드까지 수행)
Write-Host "4. GitHub에 변경 사항을 업로드하는 중..." -ForegroundColor Yellow

Push-Location $destDir
git add .
git commit -m "Auto-sync from OkeyMeal ($commitHash)"
git push
Pop-Location

Write-Host "모든 동기화 및 배포 작업이 성공적으로 완료되었습니다! 🎉" -ForegroundColor Green
Write-Host "아무 키나 누르면 창이 닫힙니다..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
