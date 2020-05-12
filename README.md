# adambware does dotfiles with ansible
## dotfiles-playbook
My dotfiles are how I personalize my system. Ansible lets me do some easy testing to make sure things get installed properly along the way.

This is very much a work in progress and is currently only focused on a local macOS installation.

## install

[Ansible must be installed as a prerequisite.](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)

Run this:

```sh
git clone https://github.com/adambware/dotfiles-playbook.git ~/.dotfiles;
cd ~/.dotfiles;
ansible-playbook -K osx.yml
```

This will install and set up zsh, homebrew, ruby, node, python, CLI tools, numerous apps, and even tweaks quite a few OS X settings.

Certain files will be symlinked from .dotfiles into your home directory. Others I found simpler to copy to their respective locations... For now!

## topical

Similar to [holman does dotfiles](https://github.com/holman/dotfiles) everything is built around a topic area. Add a namespaced directory within `roles` for any new area in your forked dotfiles to organize files within each topic. Each role is executed from the `osx.yml` playbook file.

## what is happening

Everything you want in your environment! I have a lot of stuff revolving around web development and making OS X even friendlier for power users. Check everything out in the file browser and see what might work for you. `osx.yml` organizes and runs each role, and each directory in `roles` contains 'tasks' that drive most of the functionality. Check out `osx.yml` and then dig into the tasks within each role - that's a good place to start!
[Fork it](https://github.com/adambware/dotfiles-playbook/fork), remove what you don't need, and build what you do need.

## components

Despite all of the great inspirations I've found for my dotfiles, I'm still tidying up the organization. The topical organization makes most everything self explanatory if you start at `osx.yml` and follow the trail. I'll write more here when it's in a better place!

## bugs

My goal is for this to work for everyone; meaning you can clone it, install, and it will work for an OS X machine (currently). That said, I've only used this on *my* MacBook, so there's a good chance something might break on yours.

If you're new to this and run into any roadblocks, please [open an issue](https://github.com/adambware/dotfiles-playbook/issues) on this repository and I'd love to work through it!

## thanks
I took quite a few ideas from [Zach Holman](https://github.com/holman)'s clever [dotfiles](https://github.com/holman/dotfiles). 
Also found some great work over at [thoughtbot](https://github.com/thoughtbot/) from their [laptop](https://github.com/thoughtbot/laptop) setup script. 
Most OS X tweaks came from the amazing [.osx](https://github.com/mathiasbynens/dotfiles/blob/master/.osx) created by [Mathias Bynens](https://github.com/mathiasbynens).
