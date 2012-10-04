module PostsHelper
  def no_posts_excuse
    [
      # (I was/I've) probably (been) too busy...
      "watching <a href=\"http://www.youtube.com/watch?v=DpLF8yLlcK4\" rel=\"nofollow\">this cat video</a> on YouTube",
      "trying to <a href=\"http://megaswf.com/serve/102223/\" rel=\"nofollow\">build a better automobile</a>",
      # add your own
    ].sample.html_safe
  end
end
