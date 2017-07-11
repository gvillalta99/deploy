#!/usr/bin/env bash

REPOS=( \
  git@github.com:eucglobaldemo/vmwcloud-be-encrypter.git \
  git@github.com:eucglobaldemo/vmwcloud-be-third-party-synchronizer.git \
  git@github.com:eucglobaldemo/vmwcloud-be-form-handler.git \
  git@github.com:eucglobaldemo/vmwcloud-be-provider.git \
  git@github.com:eucglobaldemo/vmwcloud-be-synchronizer.git \
  git@github.com:eucglobaldemo/vmwcloud-fe.git \
)

# bash, ksh and zsh only
versionInput="${@: -1}"
VERSION="$(echo $versionInput | grep "^v" && echo "$versionInput" || echo "v$versionInput")"

echo "Bumping REPOS to version $VERSION"

function folderName() {
  # git@github.com:eucglobaldemo/vmwcloud-be-encrypter.git will be converted to:
  # vmwcloud-be-encrypter
  local _repoName="$1"
  echo "$_repoName" | rev | cut -d"/" -f1 | rev | cut -d"." -f1
}

function tagRepo() {
  local _repoFolder="$1"

  cd "$_repoFolder"
  if [[ $(git status -s | wc -c) -ne 0 ]]; then
    git add . &> /dev/null
    git stash &> /dev/null
    echo "$_repoFolder was stashed"
  fi
  git checkout develop &> /dev/null
  git pull origin develop &> /dev/null
  git tag -a "$VERSION" -m "Bumping version $VERSION"
  git push origin --tags
  cd ".."
}

for repo in "${REPOS[@]}"; do
  repoFolder="$(folderName "$repo")"
  if [ ! -d  "./$repoFolder" ]; then
    echo "Clonning $repo to $repoFolder"
    git clone $repo $repoFolder
    echo "Clonned $repo to $repoFolder"
  fi
done

for repo in "${REPOS[@]}"; do
  repoFolder="$(folderName "$repo")"
  if [ ! -d "./$repoFolder" ]; then
    echo "Failed to bump version for '$repo' at '$repoFolder'"
    exit 1
  fi

  tagRepo "$repoFolder"
done

echo "$VERSION"
