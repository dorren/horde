class String
  # actorize("comment")  # --> commenter
  # actorize("vote")     # --> voter
  def actorize
    self =~ /e$/ ? self + "r" : self + "er"
  end

  # past_tense("comment")  # --> commented
  # past_tense("vote")     # --> voted
  def past_tense
    self =~ /e$/ ? self + "d" : self + "ed"
  end
end
