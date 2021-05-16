{ emacs, emacsPackagesNgGen }:
let
  emacsWithPackages = (emacsPackagesNgGen emacs).emacsWithPackages;
  myEmacsPackages = epkgs:
    with epkgs;
    (with elpaPackages; [ ace-window ]) ++ (with melpaStablePackages; [
      auto-complete
      company
      edit-server
      haskell-mode
      json-mode
      markdown-mode
      move-text
      nix-mode
      sudo-edit
      tide
      typescript-mode
      unisonlang-mode
      web-mode
      yaml-mode
    ]) ++ (with melpaPackages; [
      dhall-mode
      flycheck
      psc-ide
      psci
      purescript-mode
      repl-toggle
      rustic
      slime # mode for Lisp
      lsp-mode
    ]) ++ [ ];
  myEmacsWithPackages = emacsWithPackages myEmacsPackages;

  overrides = oldAttrs: {
    name = "emacs-with-packages-and-emacsd";
    # relative path to .emacs.d directory; it is copied to nix/store/...
    home = ./home;
    # make directory $out/home and copy contents from ./home
    # these will be installed (symlinked) in ~/.nix-profile/home
    # intended tobe copied into ~/ of target user installation
    #buildCommand = let
    #  extraCommand = ''
    #    install -dm 755 $out/home
    #    cp -dr --no-preserve=ownership $home/. $out/home/.
    #  '';
    #in oldAttrs.buildCommand + extraCommand;
  };
in myEmacsWithPackages.overrideAttrs overrides
