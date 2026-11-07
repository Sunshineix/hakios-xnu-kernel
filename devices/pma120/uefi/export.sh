#!/bin/bash
# Save the pma120 platform from Mu-Silicium/ into files/ here (uefi/export.sh runs this; HakiOS's own changes are uefi/'s).
set -e
cd "$(dirname "$(readlink -f "$0")")"
MU=${MU:-../../../Mu-Silicium}
rm -rf files
mkdir -p files/Resources/Configs files/Resources/DTBs files/Platforms/OPPO files/Binaries
cp -r $MU/Platforms/OPPO/pma120Pkg files/Platforms/OPPO/
cp $MU/Resources/Configs/pma120.toml files/Resources/Configs/
cp $MU/Resources/DTBs/pma120.dtb files/Resources/DTBs/
cp -r $MU/Binaries/pma120 files/Binaries/
find files -name __pycache__ -prune -exec rm -rf {} +
echo "devices/pma120/uefi/export.sh: $(find files -type f | wc -l) files"
