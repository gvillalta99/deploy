#!/usr/bin/env bash

REPOS=( \
  git@github.com:eucglobaldemo/vmwcloud-be-encrypter.git \
  git@github.com:eucglobaldemo/vmwcloud-be-third-party-synchronizer.git \
  git@github.com:eucglobaldemo/vmwcloud-be-form-handler.git \
  git@github.com:eucglobaldemo/vmwcloud-be-provider.git \
  git@github.com:eucglobaldemo/vmwcloud-be-synchronizer.git \
  git@github.com:eucglobaldemo/vmwcloud-fe.git \
)

BRANCHES=( \
  release \
  integration \
)

# bash, ksh and zsh only
versionInput="${@: -1}"
VERSION="$(echo $versionInput | grep "^v" && echo "$versionInput" || echo "v$versionInput")"

echo "Propagating changes from $VERSION to ${BRANCHES[@]}"

function folderName() {
  # git@github.com:eucglobaldemo/vmwcloud-be-encrypter.git will be converted to:
  # vmwcloud-be-encrypter
  local _repoName="$1"
  echo "$_repoName" | rev | cut -d"/" -f1 | rev | cut -d"." -f1
}

function propagateChanges() {
  local _repoFolder="$1"

  cd "$_repoFolder"
  echo "Propagating to $_repoFolder"
  if [[ $(git status -s | wc -c) -ne 0 ]]; then
    git add . &> /dev/null
    git stash &> /dev/null
    echo "$_repoFolder was stashed"
  fi

  git fetch -a &> /dev/null

  for branch in "${BRANCHES[@]}"; do
    git checkout "$branch" &> /dev/null
    git merge --no-ff "$VERSION" &> /dev/null
    echo "Updating $_repoFolder : $branch"
    git push origin "$branch"
  done

  echo "All set in $_repoFolder"
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
