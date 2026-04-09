try {
    $output = query user 2>$null
    if ($output) {
        # Parse the first active session
        $user = ($output -split "`n" | Select-Object -Skip 1 |
                 ForEach-Object { ($_ -split '\s+')[0] } |
                 Where-Object { $_ -and $_ -ne '>' })[0]
        if ($user) {
            Write-Output "Logged-in user: $user"
        }
        else {
            Write-Output "No active user found."
        }
    }
    else {
        Write-Output "No session data available."
    }
}
catch {
    Write-Error "Failed to query user: $_"
}