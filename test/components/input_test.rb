require 'test_helper'

class InputTest < ActionView::TestCase

  setup do
    SimpleForm::Components::Input.reset_i18n_cache :boolean_collection
  end

  def with_input_for(attribute, type, options={})
    simple_form_for @user do |f|
      input = SimpleForm::Components::Input.new(f, attribute, type, options)
      concat(input.generate)
      yield input if block_given?
    end
  end

  test 'input should map text field to string attribute' do
    with_input_for(:name, :string)
    assert_select 'input[name=\'user[name]\'][id=user_name][value=New in Simple Form!]'
  end

  test 'input should generate css class based on default input type' do
    with_input_for(:name, :string)
    assert_select 'input.string'
    with_input_for(:description, :text)
    assert_select 'textarea.text'
    with_input_for(:age, :numeric)
    assert_select 'input.numeric'
    with_input_for(:born_at, :date)
    assert_select 'select.date'
    with_input_for(:created_at, :datetime)
    assert_select 'select.datetime'
  end

  test 'input should allow passing options to text field' do
    with_input_for :name, :string, :html => { :class => 'my_input', :id => 'my_input' }
    assert_select 'input#my_input.my_input'
  end

  test 'input should generate a text area for text attributes' do
    with_input_for :description, :text
    assert_select 'textarea.text#user_description'
  end

  test 'input should generate a numeric text field for numeric attributes ' do
    with_input_for :age, :numeric
    assert_select 'input.numeric#user_age'
  end

  test 'input should generate a checkbox by default for boolean attributes' do
    with_input_for :active, :boolean
    assert_select 'input[type=checkbox].boolean#user_active'
  end

  test 'input should generate a password field for password attributes' do
    with_input_for :password, :password
    assert_select 'input[type=password].password#user_password'
  end

  test 'input should generate a hidden field' do
    with_input_for :name, :hidden
    assert_no_select 'input[type=text]'
    assert_select 'input#user_name[type=hidden]'
  end

  test 'input should generate a datetime select by default for datetime attributes' do
    with_input_for :created_at, :datetime
    1.upto(5) do |i|
      assert_select "form select.datetime#user_created_at_#{i}i"
    end
  end

  test 'input should be able to pass options to datetime select' do
    with_input_for :created_at, :datetime, :options => {
      :disabled => true, :prompt => { :year => 'ano', :month => 'mês', :day => 'dia' }
    }
    assert_select 'select.datetime[disabled=disabled]'
    assert_select 'select.datetime option', 'ano'
    assert_select 'select.datetime option', 'mês'
    assert_select 'select.datetime option', 'dia'
  end

  test 'input should generate a date select for date attributes' do
    with_input_for :born_at, :date
    assert_select 'select.date#user_born_at_1i'
    assert_select 'select.date#user_born_at_2i'
    assert_select 'select.date#user_born_at_3i'
    assert_no_select 'select.date#user_born_at_4i'
  end

  test 'input should be able to pass options to date select' do
    with_input_for :born_at, :date, :options => {
      :disabled => true, :prompt => { :year => 'ano', :month => 'mês', :day => 'dia' }
    }
    assert_select 'select.date[disabled=disabled]'
    assert_select 'select.date option', 'ano'
    assert_select 'select.date option', 'mês'
    assert_select 'select.date option', 'dia'
  end

  test 'input should generate a time select for time attributes' do
    with_input_for :delivery_time, :time
    assert_select 'input[type=hidden]#user_delivery_time_1i'
    assert_select 'input[type=hidden]#user_delivery_time_2i'
    assert_select 'input[type=hidden]#user_delivery_time_3i'
    assert_select 'select.time#user_delivery_time_4i'
    assert_select 'select.time#user_delivery_time_5i'
  end

  test 'input should be able to pass options to time select' do
    with_input_for :delivery_time, :time, :options => {
      :disabled => true, :prompt => { :hour => 'hora', :minute => 'minuto' }
    }
    assert_select 'select.time[disabled=disabled]'
    assert_select 'select.time option', 'hora'
    assert_select 'select.time option', 'minuto'
  end

  test 'input should generate boolean radio buttons by default for radio types' do
    with_input_for :active, :radio
    assert_select 'input[type=radio][value=true].radio#user_active_true'
    assert_select 'input[type=radio][value=false].radio#user_active_false'
  end

  test 'input as radio should generate internal labels by default' do
    with_input_for :active, :radio
    assert_select 'label.radio[for=user_active_true]', 'Yes'
    assert_select 'label.radio[for=user_active_false]', 'No'
  end

  test 'input as radio should use i18n to translate internal labels' do
    store_translations(:en, :simple_form => { :true => 'Sim', :false => 'Não' }) do
      with_input_for :active, :radio
      assert_select 'label.radio[for=user_active_true]', 'Sim'
      assert_select 'label.radio[for=user_active_false]', 'Não'
    end
  end

  test 'input should generate a boolean select with options by default for select types' do
    with_input_for :active, :select
    assert_select 'select.select#user_active'
    assert_select 'select option[value=true]', 'Yes'
    assert_select 'select option[value=false]', 'No'
  end

  test 'input as select should use i18n to translate select boolean options' do
    store_translations(:en, :simple_form => { :true => 'Sim', :false => 'Não' }) do
      with_input_for :active, :select
      assert_select 'select option[value=true]', 'Sim'
      assert_select 'select option[value=false]', 'Não'
    end
  end

  test 'input should allow overriding collection for select types' do
    with_input_for :name, :select, :collection => ['Jose', 'Carlos']
    assert_select 'select.select#user_name'
    assert_select 'select option', 'Jose'
    assert_select 'select option', 'Carlos'
  end

  test 'inputs should allow overriding collection for radio types' do
    with_input_for :name, :radio, :collection => ['Jose', 'Carlos']
    assert_select 'input[type=radio][value=Jose]'
    assert_select 'input[type=radio][value=Carlos]'
    assert_select 'label.radio', 'Jose'
    assert_select 'label.radio', 'Carlos'
  end

  test 'input should allow using a collection with text/value arrays' do
    with_input_for :name, :radio, :collection => [['Jose', 'jose'], ['Carlos', 'carlos']]
    assert_select 'input[type=radio][value=jose]'
    assert_select 'input[type=radio][value=carlos]'
    assert_select 'label.radio', 'Jose'
    assert_select 'label.radio', 'Carlos'
  end

  test 'input should allow overriding label and value method for collections' do
    with_input_for :name, :radio,
                          :collection => ['Jose' , 'Carlos'],
                          :label_method => :upcase,
                          :value_method => :downcase
    assert_select 'input[type=radio][value=jose]'
    assert_select 'input[type=radio][value=carlos]'
    assert_select 'label.radio', 'JOSE'
    assert_select 'label.radio', 'CARLOS'
  end


  test 'input should be required by default' do
    with_input_for :name, :string
    assert_select 'input.required#user_name'
  end

  test 'input should allow disabling required' do
    with_input_for :name, :string, :required => false
    assert_no_select 'input.required'
  end
end