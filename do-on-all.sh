#!/usr/bin/env bash

REPOS=( \
  git@github.com:eucglobaldemo/vmwcloud-be-encrypter.git \
  git@github.com:eucglobaldemo/vmwcloud-be-third-party-synchronizer.git \
  git@github.com:eucglobaldemo/vmwcloud-be-form-handler.git \
  git@github.com:eucglobaldemo/vmwcloud-be-provider.git \
  git@github.com:eucglobaldemo/vmwcloud-be-synchronizer.git \
  git@github.com:eucglobaldemo/vmwcloud-fe.git \
)

function folderName() {
  # git@github.com:eucglobaldemo/vmwcloud-be-encrypter.git will be converted to:
  # vmwcloud-be-encrypter
  local _repoName="$1"
  echo "$_repoName" | rev | cut -d"/" -f1 | rev | cut -d"." -f1
}

function propagateChanges() {
  local _repoFolder="$1"

  cd "$_repoFolder"
  git tag | tail -1
  cd ".."
}

for repo in "${REPOS[@]}"; do
  repoFolder="$(folderName "$repo")"
  if [ ! -d  "./$repoFolder" ]; then
    echo "$repo is not in folder $repoFolder"
    continue
  fi

  propagateChanges "$repoFolder"
done
