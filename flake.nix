{
  description = "Quarto, Python, R, & Julia Development Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils-plus.url = "github:gytis-ivaskevicius/flake-utils-plus/master";
  };

  outputs =
    {
      nixpkgs,
      flake-utils-plus,
      ...
    }:
    flake-utils-plus.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };
        python = (
          pkgs.python3.withPackages (python-pkgs: [
            python-pkgs.ipython
            python-pkgs.numpy
            python-pkgs.pandas
            python-pkgs.radian
            python-pkgs.scipy
            python-pkgs.plotly
            python-pkgs.jupyter
          ])
        );
        julia = (
          pkgs.julia-bin.withPackages [
            "LanguageServer"
            "DataFrames"
            "DataFramesMeta"
          ]
        );
        R_packages = with pkgs.rPackages; [
          dplyr
          egg
          furrr
          ggplot2
          gt
          kableExtra
          knitr
          languageserver
          magrittr
          quarto
          renv
          stringr
          tibble
          tidyr
          tidyselect
        ];
        my_R = pkgs.rWrapper.override {
          packages = R_packages;
        };
        my_quarto = pkgs.quarto.override {
          extraRPackages = R_packages;
        };
        auto-multiple-choice = pkgs.auto-multiple-choice;
        tex = (
          pkgs.texlive.combine {
            inherit (pkgs.texlive) scheme-full;
            inherit auto-multiple-choice;
          }
        );
        nativeBuildInputs = with pkgs; [
          bashInteractive
          # python
          # julia
          # jupyter-all # For jupyter kernel rendering in Quarto
          flake-checker
          mermaid-cli
          my_R
          my_quarto
          pandoc
          tex
        ];
      in
      {
        devShells.default = pkgs.mkShell {

          inherit nativeBuildInputs;

          shellHook =
            # bash
            ''
              echo " "
              echo -e "\e[32m----- Initialized Nix Flake Development Environment -----\e[0m"
              echo " "

              out=$(git --no-pager fetch --dry-run 2>&1)
              if [ -n "$out" ]
              then    
              echo -e "\e[31m----- Local git repo is behind Github remote or unreachable, Consider git pulling before further work ----- <<--\e[0m"
              echo " "
              while true; do
              read -p "----- Do you want to git pull? (y/n) ----- " yn
              case $yn in 
                [yY] ) 
                  echo " ";
                  git pull;
                  break;;
                [nN] ) 
                  echo " ";
                  echo -e "\e[31m----- WARNING: Editing repo without git pulling ----- <<--\e[0m";
                  exit;;
                * ) echo invalid response;;
              esac
              done
              else
              echo -e "\e[32m----- Local git repo is up to date with Github remote -----\e[0m"
              fi

              echo -e " "
              echo -e "\e[32m----- Setting git root directory and Rprofile location -----\e[0m"
              export GIT_ROOT_DIR=$(git rev-parse --show-toplevel)
              export R_PROFILE_USER="$(echo $GIT_ROOT_DIR)/.Rprofile" 

              if [[ -f $R_PROFILE_USER  &&  -d $GIT_ROOT_DIR/renv ]]; 
              then
                echo -e " "
                echo -e "\e[32m----- .Rprofile and renv directory found -----\e[0m"
              else
                echo -e " "
                echo -e "\e[31m----- Missing .Rprofile and/or renv directory ----- <<--\e[0m"
              fi

              echo -e " "
              out="$($(flake-checker --no-telemetry --fail-mode > ./flake_check_results) echo $?)"
              if [ "$out" = 1 ]
              then
              echo -e "\e[31m----- Flake check gives warnings: ----- <<--\e[0m"
              echo -e " "
              cat ./flake_check_results
              rm -rf ./flake_check_results
              else
              echo -e "\e[32m----- Flake check gives good status -----\e[0m"
              rm -rf ./flake_check_results
              fi

              echo -e " "
              echo -e "\e[32m----- Finished Nix Flake Development Environment Init Process -----\e[0m"
              echo -e " "
            '';
        };
      }
    );
}
