#!/bin/bash
set -e

echo "🛡️ Preparazione backup in .git/backup_files"
mkdir -p .git/backup_files

echo "💾 Backup script e workflow..."
cp auto_merge_and_patch.sh .git/backup_files/
cp .github/workflows/merge-patch.yml .git/backup_files/

echo "🔗 Aggiunta remote upstream..."
git remote add upstream https://github.com/ciccioxm3/ddmfp.git || git remote set-url upstream https://github.com/ciccioxm3/ddmfp.git

echo "🔄 Fetch upstream e reset hard..."
git fetch upstream
git reset --hard upstream/main

echo "♻️ Ripristino script e workflow dal backup..."
cp .git/backup_files/auto_merge_and_patch.sh .
cp .git/backup_files/merge-patch.yml .github/workflows/

echo "🛠 Patch dei file Python con bestemmie..."
for file in 247ita.py fullita.py itaevents.py onlyevents.py; do
    echo "🤬 Modifica di $file..."
    sed -i 's|MFPLINK = ""|MFPLINK = "https://fabianaqq-onda.hf.space"|' "$file"
    sed -i 's|MFPPSW = ""|MFPPSW = "onda"|' "$file"
done

echo "🤬 Modifica di vavoo.py..."
sed -i 's|USREPG = ""|USREPG = "vitouchiha"|' vavoo.py
sed -i 's|BRANCHEPG = ""|BRANCHEPG = "ddmfp"|' vavoo.py
sed -i 's|MFPLINK = ""|MFPLINK = "https://fabianaqq-onda.hf.space"|' vavoo.py
sed -i 's|MFPPSW = ""|MFPPSW = "onda"|' vavoo.py

echo "🤬 Modifica di hat.py..."
sed -i 's|MFPLINK = "LINKMFP"|MFPLINK = "https://fabianaqq-onda.hf.space"|' hat.py
sed -i 's|MFPPSW = "MFPPSW"|MFPPSW = "onda"|' hat.py

echo "👤 Configurazione Git user (prima che bestemmia di nuovo)"
git config user.email "vitouchiha@example.com"
git config user.name "Vitouchiha"

echo "📝 Commit dei .py modificati e dei file ripristinati..."
git add 247ita.py fullita.py itaevents.py onlyevents.py vavoo.py hat.py auto_merge_and_patch.sh .github/workflows/merge-patch.yml
git commit -m "Merge forzato + patch MFPLink/MFPPSW + config personalizzati"
git push origin main --force

echo "🚀 Dispatch downstream workflows (nel mio repo vitouchiha/ddmfp con bestemmie e bestemmioni)..."
curl -X POST \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer $GITHUB_TOKEN" \
  https://api.github.com/repos/vitouchiha/ddmfp/actions/workflows/merge-patch.yml/dispatches \
  -d '{"ref":"main"}'

echo "🔥 PATCH COMPLETATA CON SANTI, MADONNE E IL DIAVOLO!"
