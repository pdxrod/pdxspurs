pdxspurs
========

This is sublimely ironic. I just changed pdxspurs, a branch of https://git-man-page-generator.lokaltog.net, a parody of Git's obtuse error messages, and tried to push it to Github. All I changed was REAME.md. All I changed it to was:

[pdxspurs.com](https://pdxspurs.com) was originally a simple Rails app, then a branch of [a Git man page generator](https://git-man-page-generator.lokaltog.net), and finally a demostration of the Elixir app [article_editor]([article_editor](https://github.com/pdxrod/article_editor)).

When I tried to push this trivial change, it decided I was trying to push to article_editor, not pdxspurs:

git push origin master

From github-pdxrod:pdxrod/article_editor
 + 17578eb...27bb3f6 master     -> origin/master  (forced update)
hint: You have divergent branches and need to specify how to reconcile them.
hint: You can do so by running one of the following commands sometime before
hint: your next pull:
hint: 
hint:   git config pull.rebase false  # merge
hint:   git config pull.rebase true   # rebase
hint:   git config pull.ff only       # fast-forward only
hint: 
hint: You can replace "git config" with "git config --global" to set a default
hint: preference for all repositories. You can also pass --rebase, --no-rebase,
hint: or --ff-only on the command line to override the configured default per
hint: invocation.
fatal: Need to specify how to reconcile divergent branches.
➜  pdxspurs git:(master)  git config pull.ff only
➜  pdxspurs git:(master) status
On branch master
Your branch and 'origin/master' have diverged,
and have 131 and 118 different commits each, respectively.
  (use "git pull" to merge the remote branch into yours)

git pull

git push origin master

To github-pdxrod:pdxrod/article_editor.git
 ! [rejected]        master -> master (fetch first)
error: failed to push some refs to 'github-pdxrod:pdxrod/article_editor.git'
hint: Updates were rejected because the remote contains work that you do
hint: not have locally. This is usually caused by another repository pushing
hint: to the same ref. You may want to first integrate the remote changes
hint: (e.g., 'git pull ...') before pushing again.
hint: See the 'Note about fast-forwards' in 'git push --help' for details.

