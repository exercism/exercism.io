require 'pry'
require_relative '../acceptance_helper'

class NotificationsTest < AcceptanceTestCase

  def setup
    super
    Language.instance_variable_set(:"@by_track_id", {"ruby" => "Ruby"})
    # Hacked my way toward creating this integration spec
    # Please note: even if submission is not liked, or comment not created.
    # A notification is created.
    @alice = User.create!({github_id: 121, username: 'Alice'})
    bob = User.create!({github_id: 123, username: 'Bob'})
    submission = Submission.create(language: 'ruby', slug: 'one', user: @alice)
    # submission.comments.create(user: bob, body: "Test nit")
    # submission.like!(bob)
    Notification.on(submission, to: @alice, regarding: 'nitpick', creator: bob)
    Notification.on(submission, to: @alice, regarding: 'like', creator: bob)
  end

  def test_notifications_page
    with_login(@alice) do
      visit "/notifications"
      assert_content "Bob commented on your One in Ruby "
      assert_content "Bob liked your submission of One in Ruby"
    end
  end

  def test_dashboard_page
    with_login(@alice) do
      visit "/dashboard"
      assert page.has_css?('span.fa.fa-comment-o')
      assert page.has_css?('span.fa.fa-thumbs-o-up')
      assert_content "Bob One (Ruby)"
    end
  end

  def teardown
    super
    Language.instance_variable_set(:"@by_track_id", nil)
  end

end
