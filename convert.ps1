param (
    [switch]$initTool
)

$enableDebug = $false

enum LogLevel {
    Info = 0
    Verbose = 1
    Warning = 2
    Error = 3
}

function Log() {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$msg,
        [Parameter(Mandatory)]
        [LogLevel]$lvl
    )

    $prefix = '[SHC]'
    $suffix = ''

    if($lvl -eq [LogLevel]::Info) {
        Write-Host ($prefix + ' [INFO] ' + $msg + $suffix) -ForegroundColor Green
    } elseif($lvl -eq [LogLevel]::Warning) {
        Write-Host ($prefix + ' [WARN] ' + $msg + $suffix) -ForegroundColor Yellow
    } elseif($lvl -eq [LogLevel]::Error) {
        Write-Host ($prefix + ' [ERROR] ' + $msg + $suffix) -ForegroundColor Red
    } elseif($lvl -eq [LogLevel]::Verbose -and $enableDebug) {
        Write-Host ($prefix + ' [VERBOSE] ' + $msg + $suffix) -ForegroundColor DarkBlue
    }
}

function ConvertTo-CustomerReadyDoc() {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [Object]$content
    )
    # init doc in array
    $cxReadyDoc = @()
    $intReadyDoc = @()

    # helper vars to determine when we write excluded text and when not.
    $headingLevel = 0
    $headingLevelEx = 0
    $isExcluded = $false

    # step through line by line
    foreach($line in $content) {
        if($line -like '#*') {
            Log -msg 'Discovered heading' -lvl ([LogLevel]::Verbose)

            # set header level. used to check if we are up a level or down a level for exclusions
            $headingLevel = ($line.split('#').length - 1)
            Log -msg ('setting headinglevel: ' + $headingLevel) -lvl ([LogLevel]::Verbose)
            
            if($isExcluded) {
                # we are in a excluded block. we need to understand if we want to remove the isExcluded flag
                Log -msg ('headinglevel: ' + $headingLevel) -lvl ([LogLevel]::Verbose)   
                Log -msg ('headinglevelex: ' + $headingLevel) -lvl ([LogLevel]::Verbose)   
                if($headingLevel -le $headingLevelEx) {
                    # we are going up a level. when we are setting the level on 3 we need at least 3 or less to lift the exclude condition.
                    Log -msg 'Lifting exclusion' -lvl ([LogLevel]::Verbose)      
                    $isExcluded = $false
                    $headingLevelEx = 0
                }
            }

            Log -msg ('line: ' + $line.toLower()) -lvl ([LogLevel]::Verbose)
            if($line.toLower() -like '* !exclude') {
                # we are reaching a excluded line!
                Log -msg 'Found excluded line' -lvl ([LogLevel]::Verbose)
                $isExcluded = $true
                $headingLevelEx = $headingLevel
                Log -msg ('setting headinglevelEx: ' + $headingLevelEx) -lvl ([LogLevel]::Verbose)  
            }
        }

        if($isExcluded -eq $false) {
            $cxReadyDoc += $line
        }

        # remove any markings of the line to have a nicely formatted internal doc
        $intReadyDoc += $line.replace('!EXCLUDE','')
    }

    # return array with cxReady and interal doc
    return @($cxReadyDoc,$intReadyDoc)
}

function Reconcile-Startup() {
    Log -msg 'Reconciling startup' -lvl ([LogLevel]::Info)

    if($initTool) {
        Log -msg 'Preparing module for first use' -lvl ([LogLevel]::Info)
        New-Item -Path $PSScriptRoot -Name 'article' -Type Directory -ErrorAction SilentlyContinue | Out-Null
        New-Item -Path $PSScriptRoot -Name 'out' -Type Directory -ErrorAction SilentlyContinue  | Out-Null
        
        return $false
    } elseif( (Test-Path -Path ($PSScriptRoot + '\article') ) -and (Test-Path -Path ($PSScriptRoot + '\out')) ) {
        Log -msg 'Verifiying folders' -lvl ([LogLevel]::Info)
        return $true
    } 

    Log -msg 'We are unable to detect the folders \article\ and \out\. Run the tool with the -initTool flag to create these folders' -lvl ([LogLevel]::Error)
    return $false
}

Log -msg 'Starting up module' -lvl ([LogLevel]::Info)
if(Reconcile-Startup) {
    Log -msg 'Discovering articles to convert.' -lvl ([LogLevel]::Info)
    $pathArticle = Get-ChildItem -Path ($PSScriptRoot + '\article') -Filter '*.md'
    
    if($pathArticle.Length -gt 0) {
    
        foreach($article in $pathArticle) {
            Log -msg ('Converting article ' + $article.BaseName) -lvl ([LogLevel]::Info)
            $articleContent = Get-Content -Path $article.FullName
            $fileName = ($article.BaseName + '_cxReady.md')
            $fileNameInt = ($article.BaseName + '_internal.md')
    
            $docs = ConvertTo-CustomerReadyDoc -content $articleContent
    
            Out-File -InputObject $docs[0] -FilePath ($PSScriptRoot + '\out\' + $fileName) -Encoding utf8 -Force
            Out-File -InputObject $docs[1] -FilePath ($PSScriptRoot + '\out\' + $fileNameInt) -Encoding utf8 -Force
    
            Log -msg ('Finished converting ' + $article.BaseName) -lvl ([LogLevel]::Info)
        }
    
    } else {
        Log -msg 'No articles found' -lvl ([LogLevel]::Warning)
    }
}
