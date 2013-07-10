class ActivityTest < ActiveSupport::TestCase

  def test_truth
    assert true
  end

  def test_register_definition

    @definition = Activity.activity(:test_activity) do
      actor :user, :cache => [:full_name]
      act_object :listing, :cache => [:title, :full_address]
      act_target :listing, :cache => [:title]
    end

    assert @definition.is_a?(LiveActivity::Definition)

  end

  def test_push_activity_to_receivers
    _user    = User.create()
    _user_2  = User.create()
    _article = Article.create()
    _volume  = Volume.create()

    _activity = Activity.publish(:new_enquiry, :actor => _user, :act_object => _article, :act_target => _volume,
                                 :receivers => [_user_2])
    assert _activity.users.size == 1

  end

  def test_publish_new_activity
    _user    = User.create()
    _article = Article.create()
    _volume  = Volume.create()

    _activity = Activity.publish(:new_enquiry, :actor => _user, :act_object => _article, :act_target => _volume)

    assert _activity.persisted?
    #_activity.should be_an_instance_of Activity

  end

  def test_description
    _user    = User.create()
    _article = Article.create()
    _volume  = Volume.create()

    _description = "this is a test"
    _activity = Activity.publish(:test_description, :actor => _user, :act_object => _article, :act_target => _volume,
                                 :description => _description )

    assert _activity.description  == _description

  end

  def test_options
    _user    = User.create()
    _article = Article.create()
    _volume  = Volume.create()

    _country = "denmark"
    _activity = Activity.publish(:test_option, :actor => _user, :act_object => _article, :act_target => _volume,
                                 :country => _country )

    assert _activity.options[:country]  == _country

  end

  def test_bond_type
    _user    = User.create()
    _article = Article.create()
    _volume  = Volume.create()

    _activity = Activity.publish(:test_bond_type, :actor => _user, :act_object => _article, :act_target => _volume)

    assert _activity.bond_type  == 'global'

  end

  def test_reverses_bond_type
    _user    = User.create()
    _article = Article.create()
    _volume  = Volume.create()

    _activity = Activity.publish(:test_reverses_bond_type, :actor => _user, :act_object => _article, :act_target => _volume)

    assert _activity.reverses  == 'test_bond_type'

  end





end