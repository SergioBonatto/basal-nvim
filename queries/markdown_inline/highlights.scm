;; Highlights for Basal tags and links

((inline) @basal_tag
  (#match? @basal_tag "#\\w+"))

((inline) @basal_link
  (#match? @basal_link "\\[\\[.*\\]\\]"))
