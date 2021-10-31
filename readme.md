This is the site for the CSUS sustainable teaching award.

This readme will show how to build the site on your computer and how to add to it.

# Getting started

### installing stack

Firstly, be sure to install stack. This is the tool used to build the site.

[Haskell Tool Stack](https://docs.haskellstack.org/en/stable/install_and_upgrade/) recommends running

`curl -sSL https://get.haskellstack.org/ | sh`

on any Unix OS (inclu. Mac). Windows, idk google it.

### building and veiwing the site

With stack installed, `cd` into the directory that is a clone of this repo and run `stack run build`. 

`build` will build the website, and `run` will run the build, making it ready for viewing :)

To view the website, you can point your browser to the `index.html` file of the site by going to 
`file:///{...}/award-site/_site/index.html`. There is the website, in all its glory! 

Alterntively, you can go into the `_site` dir in the project file, and run `python -m http.server`. This will run a python module that will host the contents of the `_site` dir on localhost:8000. To view the site, go to localhost:8000 in your browser.

Be sure to rebuild the site using `stack run rebuild` to see the changes in the browser!

# Editing the site/general structure

### Adding a reading summary

All reading summaries go in  `/readings`. Create a new file in that dir, ending with `.md`. 

Its important that each new reading start with this metadata syntax:
```
--- 
title: My awesome reading title
tags: environment, tag2, tag3
---
```
The `title` will be the title of the paper shown to users of the site. the `tags` metadata will direct which topic tag this reading falls under. Comma separate multiple tags.

## Tags

Tags are currently associated with each reading. You can see the list of tags in `Resources`. Navigating to `{...}/tags/{tag}` will display all readings with that tag and the associated "tag blurb" which is the little meta-blurb about the topic.

### Tag blurbs

You can edit what the tag-blurb says in `tag-blurb`. 

## Pages

If you want to add a new page to the website, like a contact page, simply create the file in `/pages`. You can add a `title` field in the meta data, i think that is what will show up in the browser tab for that page. 

## Nav bar and template

`templates/default.html` is the default template applied to each page. Edit default.html if you want to change the nav bar or footer or anything else that is applied to each page. If you add a new page, you'll probably want to add a link to it in the nav bar. 

# Other things

There is no CSS right now -- it looks awful lol
