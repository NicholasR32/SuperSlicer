if (-Not(Test-Path -Path "3dzips")) {
    New-Item -Name "3dzips" -ItemType Directory
}

if (-Not(Test-Path -Path "unzipped")) {
    New-Item -Name "unzipped" -ItemType Directory
}

$src = "."
$dst_move = "3dzips"
$dst_unzip = "unzipped"
$items = Get-ChildItem -Path $src
$num_folders_moved = 0

# echo "Emptying destination folder..."
# Remove-Item -Path "unzipped/*" -Recurse

$confirmation = Read-Host "Move zip folders? [y/n]"

if ($confirmation -eq 'y')
{
    foreach ($zip in $items) {
        if ($zip.Extension -eq ".zip") {
            try
            {
                echo "Moving $($zip.BaseName) to $dst_move..."
                Move-Item -Path $zip -Destination $dst_move
                $num_folders_moved = $num_folders_moved + 1
            }
            # doesn't work but oh well
            catch
            {
                echo "Error: $zip has already been moved"
            }
        }
    }
}

$confirmation = Read-Host "$num_folders_moved zips moved to ./unzipped. Unzip? [y/n]"

if ($confirmation -eq "n")
{
    echo "Exiting..."
    exit
}

$items = Get-ChildItem -Path $dst_move
foreach ($zip in $items)
{
    echo "Unzipping $zip to $dst_unzip"

    # Create directory with name of zip file
    New-Item -Path $dst_unzip -Name $zip.BaseName -ItemType Directory
    $temp = $zip.BaseName

    # Extract files to new directory
    Expand-Archive -Path "$dst_move/$zip" -DestinationPath "$dst_unzip/$temp"

    # echo "Deleting $zip"
    # Remove-Item -Path "$src/$zip"
}

$confirmation = Read-Host "Done. Press any key to exit..."