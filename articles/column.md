---
layout: default
title:  Columns
date:   2013-08-26 17:39:22
categories: column
---

## Basic

Define the attributes which are to display. The column names will be automatically fetched using attribute translation.

```ruby
reporter(User.scoped) do
    column :name
	column :age
end
```

## Custom output

Pass a block to the column to output the way you want it to be. You will find the view helper methods available here.

```ruby
reporter(User.scoped) do
	column :name do |user|
		link_to user.name, user
	end
	column :age
end
```

## Show columns only on web

Some of the columns you would only want to show in the web, not in the PDF of CSV. There you can use the 'only_on_web' option.

```ruby
reporter(User.scoped) do
	column :name
    column :action, only_on_web: true do |user|
        render :partial => 'user/user_action', locals: {user: user}
    end
end
```