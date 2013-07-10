class DefinitionTest < ActiveSupport::TestCase

  def definition_dsl
    dsl = LiveActivity::DefinitionDSL.new(:new_enquiry)
    dsl.actor(:User)
    dsl.act_object(:Article)
    dsl.act_target(:Volume)
    dsl
  end

  def test_initialization
    _definition_dsl = definition_dsl
    _definition     = LiveActivity::Definition.new(_definition_dsl)

    assert _definition.actor      == :User
    assert _definition.act_object == :Article
    assert _definition.act_target == :Volume

  end

  def test_register_definition_and_return_new_definition

    assert LiveActivity::Definition.register(definition_dsl).is_a?(LiveActivity::Definition)

  end

  def test_register_invalid_definition

    assert LiveActivity::Definition.register(false)  == false

  end

  def test_return_registered_definitions

    LiveActivity::Definition.register(definition_dsl)
    assert LiveActivity::Definition.registered.size > 0

  end

  def test_return_definition_by_name
    assert LiveActivity::Definition.find(:new_enquiry).name == :new_enquiry

  end

  def test_raise_exception_if_invalid_activity

    assert_raises(LiveActivity::InvalidActivity){ LiveActivity::Definition.find(:unknown_activity) }

  end

end