# Irwi

Irwi is a Ruby on Rails 4 plugin which adds wiki functionality to your
application.

## Status

[<img src="https://secure.travis-ci.org/alno/irwi.png?branch=master" alt="Build Status" />](http://travis-ci.org/alno/irwi)

## Installation

Add to your Gemfile:

    gem 'irwi', :git => 'git://github.com/alno/irwi.git'

Then in your application directory call:

    rails g irwi_wiki

It will generate:
*   WikiPageController to serve wiki pages
*   WikiPage model to represent page
*   Migration to prepare database


Also it will add to your `routes.rb` something like:

    wiki_root '/wiki'

## Wiki syntax (links to other pages)

You can link pages by using

    [[Some page title]]

construction in text. If linked page exists, when it will be replaced with
link to this page, in other case it will be replaced with link to new page
with such path/title.

## Template definition

You may create your own templates for controller actions (`show`, `edit` and
`history`), in other case default built-in templates will be used.

## Helper definition

Following helpers are defined by default and you may replace them with you
own:
*   `wiki_user` - Renders user name or link by given user object. By default
    renders &lt;Unknown&gt; for `nil` and "User#{user.id}" for others.


## Configuration

Configuration options are acessed via `Irwi.config` object. Currently
supported options:
*   `user_class_name` - Name of user model class. By default - 'User'


    Define a method named 'current_user' method on WikiPagesController that returns the object for the current user

*   `formatter` - Formatter instance, which process wiki content before
    output. It should have method `format`, which gets a string and returns it
    formatted. By default instance of `Irwi::Formatters::RedCloth` is used
    (requires RedCloth gem). Other built-in formatter is
    `Irwi::Formatters::BlueCloth` (requires BlueCloth gem). Option accepts
    formatter instance, not class, so correct usage is:

    Irwi.config.formatter = Irwi::Formatters::BlueCloth.new

*   `comparator` - Comparator instance, which builds and renders a set of
    changes between to texts. By default instance of
    `Irwi::Comparators::DiffLcs` is used (requires diff-lcs gem).


## Access control

If you want (and it's good idea) to specify which users can see or edit
certain pages you should simply override following methods in your controller:
*   `show_allowed?` - should return `true` when it's allowed for current user
    to see current page (@page).
*   `history_allowed?` - should return `true` when it's allowed for user to
    see history of current page (@page) and compare it's versions.
*   `edit_allowed?` - should return `true` when it's allowed for current user
    to modify current page (@page).


## Attachments

Irwi allows easy attachment integration in your wiki. There area several
simple steps to add attachments to wiki pages:
*   Call `irwi_wiki_attachments` generator. It will create WikiPageAttachment
    class.
*   Include `config.gem "paperclip"` in your `environment.rb` or, if you
    prefer another library modify generated code for it.
*   Append to initializer (or create a new one) something like
    `Irwi.config.page_attachment_class_name = 'WikiPageAttachment'`.
*   Run `rake db:migrate` and start using attachments in your wiki!


## Contributors

*   Alexey Noskov (http://github.com/alno)
*   Ravi Bhim (http://github.com/ravibhim)
*   Pavel Valodzka (http://github.com/valodzka)
*   Xavier Defrang (http://github.com/xavier)
*   Tomáš Pospíšek (http://github.com/tpo)
*   Evan Arnold (http://github.com/earnold)
*   https://github.com/alno/irwi/contributors


Feel free to add yourself when you add new features.

Copyright (c) 2009 Alexey Noskov, released under the MIT license
