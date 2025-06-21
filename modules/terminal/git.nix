{pkgs, ...}: {
  programs.git = {
    enable = true;
    package = pkgs.gitAndTools.gitFull;
    userName = "Diego Rabatone Oliveira";
    userEmail = "diraol@diraol.eng.br";
    ignores = [
      # TODO: Update
      ".env"
      ".mise.toml"
      ".venv"
    ];
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
      {
        condition = "hasconfig:remote.*.url:ssh://*@*.*.github.com:nubank/**";
        contents = {
          user = {
            email = "diego.rabatone@nubank.com.br";
          };
        };
      }
    ];
    # aliases = {
    #   # List available aliases
    #   aliases = "!git config --get-regexp alias | sed -re 's/alias\\.(\\S*)\\s(.*)$/\\1 = \\2/g'";
    #   # Command shortcuts
    #   ci = "commit";
    #   co = "checkout";
    #   st = "status";
    #   # Display tree-like log, default log is not ideal
    #   lg = "log --graph --date=relative --pretty=tformat:'%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%an %ad)%Creset'";
    #   # Useful when you have to update your last commit
    #   # with staged files without editing the commit message.
    #   oops = "commit --amend --no-edit";
    #   # Ensure that force-pushing won't lose someone else's work (only your own).
    #   push-with-lease = "push --force-with-lease";
    #   # List local commits that were not pushed to remote repository
    #   review-local = "!git lg @{push}..";
    #   # Edit last commit message
    #   reword = "commit --amend";
    #   # Undo last commit but keep changed files in stage
    #   uncommit = "reset --soft HEAD~1";
    #   # Remove file(s) from Git but not from disk
    #   untrack = "rm --cache --";
    # };
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
      # credential = {
      #   helper = "cache";
      #   "https://github.com".helper = "!/usr/bin/gh auth git-credential";
      #   "https://gist.github.com".helper = "!/usr/bin/gh auth git-credential";
      # };
      
      # LFS filter
      filter.lfs = {
        clean = "git-lfs clean -- %f";
        smudge = "git-lfs smudge --skip %f";
        process = "git-lfs filter-process --skip";
        required = true;
      };
    };
  };

  programs.gh = {
    enable = true;
    gitCredentialHelper.enable = true;
  };
}
