This is my attempt at following the configuration architecture discussed at http://furius.ca/projects/doc/conf.html.

If you want to use this repository, be sure to run `git submodule update --init` after checking it out to get the submodules.

1) Wanting to support multiple platforms (different versions of Ubuntu, OS X, and (if I make poor life choices) Windows (Cygwin)) using common tools. There are certain portions of configurations that are common, and others that are specific to different platforms and different hosts.
2) The need to make changes on one platform and optionally have them impact other platforms.
3) Easy and quick syncing.
4) Version control.

At the moment, I have high-level scripts that I symlink to from ~ in to_symlink, based on host. The rest gets taken care of more or less like the aforementioned article suggests. I don't really have a need for site-specific files. I could see transitioning some of the servers that I have to this scheme. Basically I just want to DRY up my configuration, and this seems like one way to do it. I could use some sort of rsync scripting system, or even polished configuration management systems, but it seems like my requirements are beyond what these can do.

---

Improvement ideas:

 - Change common/bin to have common/bin/vendor and put all scripts that I just randomly downloaded from somewhere there.
 - Improve readme, since it is super old and not really relevant any more. Could include bootstrapping instructions, etc.
 - Add some links to scripts that I use frequently
