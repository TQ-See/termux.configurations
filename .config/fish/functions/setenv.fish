function setenv --description "Set secrets Evironment"
    mkdir -p ~/.env
    sops -d "$REPO/.secrets/common.yaml" >~/.env/secrets.env
end
