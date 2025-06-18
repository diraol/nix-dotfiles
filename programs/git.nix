{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;
    userName = "Diego Rabatone Oliveira";
    userEmail = "diraol@diraol.eng.br";
    
    extraConfig = {
      # GitHub and GitLab users
      github.user = "diraol";
      gitlab.user = "diraol";
      
      # Branch settings
      branch = {
        autosetuprebase = "always";
        sort = "-committerdate";
      };
      
      # Color settings
      color = {
        ui = "auto";
        branch = "auto";
        diff = "auto";
        interactive = "auto";
        status = "auto";
      };
      
      # Column settings
      column.ui = "auto";
      
      # Commit settings
      commit.verbose = true;
      
      # Core settings
      core = {
        whitespace = "indent-with-non-tab";
        excludesfile = "~/.gitignore";
        editor = "vim";
      };
      
      # Diff settings
      diff = {
        algorithm = "histogram";
        colorMoved = "plain";
        mnemonicPrefix = true;
        renames = true;
      };
      
      # Fetch settings
      fetch = {
        prune = true;
        pruneTags = true;
        all = true;
      };
      
      # Help settings
      help.autocorrect = "prompt";
      
      # Init settings
      init.defaultBranch = "main";
      
      # Merge settings
      merge.conflictstyle = "zdiff3";
      
      # Pull settings
      pull.rebase = true;
      
      # Push settings
      push = {
        default = "simple";
        autoSetupRemote = true;
        followTags = true;
      };
      
      # Rebase settings
      rebase = {
        autoStash = true;
        updateRefs = true;
      };
      
      # Receive settings
      receive.denyNonFastForwards = true;
      
      # Remote settings
      remote.pushdefault = "origin";
      
      # Rerere settings
      rerere = {
        enabled = true;
        autoupdate = true;
      };
      
      # Status settings
      status.submoduleSummary = true;
      
      # Tag settings
      tag.sort = "version:refname";
      
      # URL rewrites
      url."git@github.com:".insteadOf = "https://github.com/";
      
      # Credentials
      credential = {
        helper = "cache";
        "https://github.com".helper = "!/usr/bin/gh auth git-credential";
        "https://gist.github.com".helper = "!/usr/bin/gh auth git-credential";
      };
      
      # LFS filter
      filter.lfs = {
        clean = "git-lfs clean -- %f";
        smudge = "git-lfs smudge --skip %f";
        process = "git-lfs filter-process --skip";
        required = true;
      };
    };
    
    # Include conditional configs
    includes = [
      {
        condition = "gitdir:~/.vim/";
        path = ".diraol/gitconfig";
      }
      {
        condition = "gitdir:~/dev/personal/";
        path = ".diraol/gitconfig";
      }
      {
        condition = "gitdir:~/dev/floss/";
        path = ".diraol/gitconfig";
      }
    ];
  };
} 