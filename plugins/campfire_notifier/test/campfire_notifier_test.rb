require 'test_helper'

class CampfireNotifierTest < Test::Unit::TestCase
  def setup
    CruiseControl::Log.stubs(:debug)
  end

  def test_connect_should_login_and_find_room
    campfire = mock()
    campfire.expects(:login).with('username', 'password').returns(true)
    campfire.expects(:find_room_by_name).with('room')
    Tinder::Campfire.expects(:new).returns(campfire)

    notifier = CampfireNotifier.new
    notifier.username = 'username'
    notifier.password = 'password'
    notifier.room = 'room'
    notifier.connect
  end

  def test_should_logout_on_disconnect_if_logged_in
    notifier = CampfireNotifier.new
    notifier.campfire = mock()
    notifier.campfire.expects(:logout)
    notifier.campfire.expects(:logged_in?).returns(true)
    notifier.disconnect
  end

  def test_should_not_logout_on_disconnect_if_not_logged_in
    notifier = CampfireNotifier.new
    notifier.campfire = mock()
    notifier.campfire.expects(:logout).never
    notifier.campfire.expects(:logged_in?).returns(false)
    notifier.disconnect
  end

  def test_should_not_logout_on_disconnect_if_campfire_not_initialized
    notifier = CampfireNotifier.new
    notifier.campfire.expects(:logout).never
    notifier.disconnect
  end

  def test_reconnect_should_disconnect_and_connect
    reconnect = sequence('reconnect')
    notifier = CampfireNotifier.new
    notifier.expects(:disconnect).in_sequence(reconnect)
    notifier.expects(:connect).in_sequence(reconnect)
    notifier.reconnect
  end

  def test_should_not_be_connected_if_campfire_not_initialized
    notifier = CampfireNotifier.new
    assert !notifier.connected?
  end

  def test_should_not_be_connected_if_not_logged_in
    notifier = CampfireNotifier.new
    notifier.campfire = mock()
    notifier.campfire.expects(:logged_in?).returns(false)
    assert !notifier.connected?
  end

  def test_should_be_connected_if_logged_in
    notifier = CampfireNotifier.new
    notifier.campfire = mock()
    notifier.campfire.expects(:logged_in?).returns(true)
    assert notifier.connected?
  end

  def test_should_notify_on_build_fixed
    fixed = mock()
    previous = mock()
    notifier = CampfireNotifier.new
    notifier.expects(:notify).with(fixed)
    notifier.build_fixed(fixed, previous)
  end

  def test_should_notify_on_build_failure
    build = mock()
    build.expects(:failed?).returns(true)
    notifier = CampfireNotifier.new
    notifier.expects(:notify).with(build)
    notifier.build_finished(build)
  end

  def test_should_not_notify_on_build_success
    build = mock()
    build.expects(:failed?).returns(false)
    notifier = CampfireNotifier.new
    notifier.expects(:notify).never
    notifier.build_finished(build)
  end
end
