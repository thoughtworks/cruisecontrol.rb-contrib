require 'test_helper'

class CampfireNotifierTest < Test::Unit::TestCase
  def setup
    CruiseControl::Log.stubs(:debug)
    CruiseControl::Log.stubs(:warn)
  end

  def test_connect_should_true_for_valid_login_and_room
    campfire = mock()
    campfire.expects(:login).with('username', 'password').returns(true)
    campfire.expects(:find_room_by_name).with('room').returns(mock())
    Tinder::Campfire.expects(:new).returns(campfire)

    notifier = CampfireNotifier.new
    notifier.username = 'username'
    notifier.password = 'password'
    notifier.room = 'room'
    assert notifier.connect
  end

  def test_connect_should_return_false_for_invalid_login
    campfire = mock()
    campfire.expects(:login).raises(Tinder::Error.new)
    Tinder::Campfire.expects(:new).returns(campfire)

    notifier = CampfireNotifier.new
    assert !notifier.connect
  end

  def test_connect_should_return_false_for_invalid_room
    campfire = mock()
    campfire.expects(:login).returns(true)
    campfire.expects(:find_room_by_name).returns(nil)
    Tinder::Campfire.expects(:new).returns(campfire)

    notifier = CampfireNotifier.new
    notifier.username = 'username'
    notifier.password = 'password'
    notifier.room = 'room'
    assert !notifier.connect
  end

  def test_should_warn_if_login_fails
    campfire = mock()
    campfire.expects(:login).raises(Tinder::Error.new)
    Tinder::Campfire.expects(:new).returns(campfire)
    CruiseControl::Log.expects(:warn).with { |value| value =~ /login failed/ }

    CampfireNotifier.new.connect
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
