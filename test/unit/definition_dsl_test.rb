class DefinitionDslTest < ActiveSupport::TestCase

  def definition_dsl
    LiveActivity::DefinitionDSL.new(:new_enquiry)
  end

  def test_initializes_with_name
    assert definition_dsl.attributes[:name] == :new_enquiry
  end

  def test_adds_an_actor_to_the_definition
    dsl = definition_dsl
    dsl.actor(:User)
    assert dsl.attributes[:actor] == :User
  end

  def test_adds_an_act_object_to_the_definition
    dsl = definition_dsl
    dsl.act_object(:Article)
    assert dsl.attributes[:act_object] == :Article
  end

  def test_adds_a_act_target_to_the_definition
    dsl = definition_dsl
    dsl.act_target(:Volume)
    assert dsl.attributes[:act_target] == :Volume
  end

end