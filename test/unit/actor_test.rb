class ActorTest < ActiveSupport::TestCase


  def test_publish_activity

    _user = User.create()
    _article = Article.create()
    _volume  = Volume.create()

    activity = _user.publish_activity(:new_enquiry, :act_object => _article, :act_target => _volume)

    assert activity.persisted?

  end

  def test_pushes_to_a_defined_stream
    _user    = User.create()
    _user_2  = User.create()
    _article = Article.create()
    _volume  = Volume.create()

    _activity = _user.publish_activity(:new_enquiry, :act_object => _article, :act_target => _volume,
                                       :receivers => [_user_2])
    assert _activity.users.size == 1

  end

  def test_retrieves_the_stream_for_an_actor
    _user    = User.create()
    _article = Article.create()
    _volume  = Volume.create()

    _user.publish_activity(:new_enquiry, :act_object => _article, :act_target => _volume, :receivers => [_user])
    _user.publish_activity(:new_enquiry, :act_object => _article, :act_target => _volume, :receivers => [_user])

    assert _user.activity_stream.size == 2

  end


  def test_retrieves_the_stream_for_a_particular_activity_type
    _user = User.create()
    _article = Article.create()
    _volume  = Volume.create()

    _user.publish_activity(:new_enquiry, :act_object => _article, :act_target => _volume, :receivers => [_user])
    _user.publish_activity(:new_enquiry, :act_object => _article, :act_target => _volume, :receivers => [_user])
    _user.publish_activity(:test_bond_type, :act_object => _article, :act_target => _volume, :receivers => [_user])

    assert _user.activity_stream(:verb      => 'new_enquiry').size == 2
    assert _user.activity_stream(:bond_type => 'global').size == 1

  end




end