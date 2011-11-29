require 'test/unit'
require 'mocha'

class BuilderPlugin; end
class Configuration; end
module CruiseControl; class Log; end; end
$LOAD_PATH.unshift File.dirname(__FILE__) + '/../lib'
require 'campfire_notifier'


class CampfireNotifierTest < Test::Unit::TestCase
  def setup
    CruiseControl::Log.stubs(:debug)
    CruiseControl::Log.stubs(:warn)
    CruiseControl::Log.stubs(:fatal)
    @notifier = CampfireNotifier.new
    @notifier.subdomain = 'sub'
  end

  def test_connect_should_true_for_valid_room
    campfire = mock
    campfire.expects(:logged_in?).returns(true)
    campfire.expects(:find_room_by_name).with('room').returns(mock)
    Tinder::Campfire.expects(:new).returns(campfire)

    @notifier.ssl = true
    @notifier.token = 'token'
    @notifier.room = 'room'
    assert @notifier.connect
  end

  def test_connect_should_return_false_for_invalid_room
    campfire = mock
    campfire.expects(:find_room_by_name).returns(nil)
    campfire.expects(:logged_in?).returns(false)
    Tinder::Campfire.expects(:new).returns(campfire)

    @notifier.room = 'room'
    assert !@notifier.connect
  end

  def test_should_logout_on_disconnect_if_logged_in
    @notifier.campfire = mock
    @notifier.campfire.expects(:logout)
    @notifier.campfire.expects(:logged_in?).returns(true)
    @notifier.disconnect
  end

  def test_should_not_logout_on_disconnect_if_not_logged_in
    @notifier.campfire = mock
    @notifier.campfire.expects(:logout).never
    @notifier.campfire.expects(:logged_in?).returns(false)
    @notifier.disconnect
  end

  def test_should_not_logout_on_disconnect_if_campfire_not_initialized
    @notifier.campfire.expects(:logout).never
    @notifier.disconnect
  end

  def test_reconnect_should_disconnect_and_connect
    reconnect = sequence('reconnect')
    @notifier.expects(:disconnect).in_sequence(reconnect)
    @notifier.expects(:connect).in_sequence(reconnect)
    @notifier.reconnect
  end

  def test_should_not_be_connected_if_campfire_not_initialized
    assert !@notifier.connected?
  end

  def test_should_not_be_connected_if_not_logged_in
    @notifier.campfire = mock
    @notifier.campfire.expects(:logged_in?).returns(false)
    assert !@notifier.connected?
  end

  def test_should_be_connected_if_logged_in
    @notifier.campfire = mock
    @notifier.campfire.expects(:logged_in?).returns(true)
    assert @notifier.connected?
  end

  def test_should_notify_on_build_fixed
    fixed = mock
    previous = mock
    @notifier.expects(:notify).with(fixed)
    @notifier.build_fixed(fixed, previous)
  end

  def test_should_notify_on_build_failure
    build = mock
    build.expects(:failed?).returns(true)
    @notifier.expects(:notify).with(build)
    @notifier.build_finished(build)
  end

  def test_should_not_notify_on_build_success
    build = mock
    build.expects(:failed?).returns(false)
    @notifier.expects(:notify).never
    @notifier.build_finished(build)
  end

  def test_notification_message_formatting
    build = mock
    build.expects(:failed?).returns(true)
    project = mock
    build.expects(:project).returns(project)
    project.expects(:name).returns('projectname')
    Configuration.expects(:dashboard_url).returns(true)
    build.expects(:url).returns('http://dashboard_url/build')
    assert_equal @notifier.notification_message(build), 'CI build projectname BROKEN: http://dashboard_url/build'
  end
end
